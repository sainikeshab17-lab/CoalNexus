from sqlalchemy import Column, String, DateTime, Integer, Boolean, Float, text
from ..database import Base

class SyncableModel(Base):
    __abstract__ = True
    
    id = Column(String, primary_key=True, index=True) # Server ID
    local_id = Column(String, unique=True, index=True)
    local_version = Column(Integer, default=1)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
    updated_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'), onupdate=text('CURRENT_TIMESTAMP'))
    operation_id = Column(String, unique=True, nullable=True) # For idempotency
