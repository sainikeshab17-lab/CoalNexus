from typing import Generic, TypeVar, List, Optional, Type
from sqlalchemy.orm import Session
from ..models.base import SyncableModel

T = TypeVar("T", bound=SyncableModel)

class BaseRepository(Generic[T]):
    def __init__(self, model: Type[T]):
        self.model = model

    def get_by_id(self, db: Session, id: str) -> Optional[T]:
        return db.query(self.model).filter(self.model.id == id).first()

    def get_by_local_id(self, db: Session, local_id: str) -> Optional[T]:
        return db.query(self.model).filter(self.model.local_id == local_id).first()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100) -> List[T]:
        return db.query(self.model).offset(skip).limit(limit).all()

    def create(self, db: Session, obj_in: T) -> T:
        db.add(obj_in)
        db.commit()
        db.refresh(obj_in)
        return obj_in

    def update(self, db: Session, db_obj: T, obj_in: dict) -> T:
        for field in obj_in:
            if hasattr(db_obj, field):
                setattr(db_obj, field, obj_in[field])
        db.add(db_obj)
        db.commit()
        db.refresh(db_obj)
        return db_obj
