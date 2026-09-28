import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
import jwt
from fastapi import HTTPException
from app.core.security import get_current_user_profile
from app.core.config import settings
from app.models.models import Profile, UserRole
from sqlalchemy.orm import Session
from unittest.mock import MagicMock

def test_production_rejection_of_unverified_token(monkeypatch):
    # Force production environment
    monkeypatch.setattr(settings, "ENVIRONMENT", "production")
    monkeypatch.setattr(settings, "SECRET_KEY", "super-secret")
    
    # Create a token signed with a DIFFERENT secret
    tampered_token = jwt.encode({"sub": "user123"}, "wrong-secret", algorithm="HS256")
    
    db = MagicMock(spec=Session)
    credentials = MagicMock()
    credentials.credentials = tampered_token
    
    # Should raise 401 Unauthorized in production
    with pytest.raises(HTTPException) as excinfo:
        get_current_user_profile(credentials=credentials, db=db)
    
    assert excinfo.value.status_code == 401
    assert "Invalid token" in excinfo.value.detail

def test_development_fallback_allowed(monkeypatch):
    # Force development environment
    monkeypatch.setattr(settings, "ENVIRONMENT", "development")
    
    # Create an unverified token (or just a string that looks like a token)
    # Even if signature fails, it should fallback
    token = jwt.encode({"sub": "dev-user"}, "any-secret", algorithm="HS256")
    
    db = MagicMock(spec=Session)
    profile = Profile(id="dev-user", role=UserRole.INSPECTOR.value, is_active=True)
    db.query.return_value.filter.return_value.first.return_value = profile
    
    credentials = MagicMock()
    credentials.credentials = token
    
    # In development, it should succeed via fallback even if signature is "wrong" 
    # (because settings.SECRET_KEY won't match "any-secret" if not set)
    result = get_current_user_profile(credentials=credentials, db=db)
    assert result.id == "dev-user"

def test_inactive_user_rejection():
    # Setup token
    secret = "test-secret"
    settings.SECRET_KEY = secret
    token = jwt.encode({"sub": "inactive-user"}, secret, algorithm="HS256")
    
    db = MagicMock(spec=Session)
    profile = Profile(id="inactive-user", role=UserRole.INSPECTOR.value, is_active=False)
    db.query.return_value.filter.return_value.first.return_value = profile
    
    credentials = MagicMock()
    credentials.credentials = token
    
    with pytest.raises(HTTPException) as excinfo:
        get_current_user_profile(credentials=credentials, db=db)
    
    assert excinfo.value.status_code == 403
    assert "inactive" in excinfo.value.detail.lower()
