import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from typing import Optional, List
from ..database import get_db
from ..models.models import Profile, UserMineAssignment, UserRole
from .config import settings

security = HTTPBearer()

def get_current_user_profile(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> Profile:
    token = credentials.credentials
    try:
        secret = settings.SUPABASE_SECRET_KEY or settings.SECRET_KEY
        if not secret and settings.ENVIRONMENT == "production":
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Security configuration error: SECRET_KEY not set",
            )
            
        payload = jwt.decode(token, secret, algorithms=["HS256"], options={"verify_aud": False})
        
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials (missing sub claim)",
            )
    except jwt.PyJWTError:
        # Fallback for easier testing/development or token simulation with basic strings or demo profiles
        # In production, we MUST fail here.
        if settings.ENVIRONMENT == "production":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token",
            )
        user_id = token
        
    profile = db.query(Profile).filter(Profile.id == user_id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User profile not found in database",
        )
    if not profile.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User profile is inactive",
        )
    return profile

class RoleChecker:
    def __init__(self, allowed_roles: List[str]):
        self.allowed_roles = allowed_roles

    def __call__(self, current_user: Profile = Depends(get_current_user_profile)) -> Profile:
        if current_user.role not in self.allowed_roles and current_user.role != UserRole.ADMIN.value:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Operation not permitted for this user role",
            )
        return current_user

class MineAccessChecker:
    def __init__(self, allowed_roles: Optional[List[str]] = None):
        self.allowed_roles = allowed_roles or [UserRole.ADMIN.value, UserRole.OFFICER.value, UserRole.INSPECTOR.value]

    def check_mine_access(self, db: Session, user: Profile, mine_id: str):
        # Admins have access to everything
        if user.role == UserRole.ADMIN.value:
            return True
            
        # Check mine assignment
        assignment = db.query(UserMineAssignment).filter(
            UserMineAssignment.profile_id == user.id,
            UserMineAssignment.mine_id == mine_id
        ).first()
        
        if not assignment:
            # Also try checking if mine_id is a local_id or mine_code
            from ..repositories.repositories import mine_repo
            mine_obj = mine_repo.get_by_id(db, mine_id) or mine_repo.get_by_local_id(db, mine_id) or db.query(Mine).filter(Mine.mine_code == mine_id).first()
            if mine_obj:
                assignment = db.query(UserMineAssignment).filter(
                    UserMineAssignment.profile_id == user.id,
                    UserMineAssignment.mine_id == mine_obj.id
                ).first()
                
        if not assignment:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Access denied to this specific mine data",
            )
        return True
