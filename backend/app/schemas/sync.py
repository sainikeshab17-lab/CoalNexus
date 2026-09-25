from pydantic import BaseModel, Field
from typing import Optional, Generic, TypeVar, List
from datetime import datetime

T = TypeVar("T")

class SyncResponse(BaseModel, Generic[T]):
    id: str
    local_id: str
    data: T
    status: str = "synced"

class HealthResponse(BaseModel):
    status: str = "ok"
    version: str = "1.0.0"
