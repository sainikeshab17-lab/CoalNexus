from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime
from enum import Enum

class MineStatus(str, Enum):
    active = "active"
    inactive = "inactive"
    suspended = "suspended"
    underMaintenance = "underMaintenance"

class SyncBase(BaseModel):
    local_id: Optional[str] = None
    local_version: int = 1
    operation_id: Optional[str] = None

class MineBase(BaseModel):
    name: str
    mine_code: str
    latitude: float
    longitude: float
    status: MineStatus

class MineCreate(MineBase, SyncBase):
    pass

class MineUpdate(MineBase, SyncBase):
    pass

class Mine(MineBase):
    id: str
    local_id: Optional[str] = None
    local_version: int
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class InspectionStatus(str, Enum):
    draft = "draft"
    inProgress = "inProgress"
    completed = "completed"
    findingsGenerated = "findingsGenerated"
    submitted = "submitted"

class InspectionBase(BaseModel):
    mine_id: str
    inspector_id: str
    status: InspectionStatus
    category: str = "other"

class InspectionCreate(InspectionBase, SyncBase):
    pass

class Inspection(InspectionBase):
    id: str
    local_id: Optional[str] = None
    local_version: int
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class FindingStatus(str, Enum):
    open = "open"
    acknowledged = "acknowledged"
    resolved = "resolved"
    compliant = "compliant"
    nonCompliant = "nonCompliant"
    notApplicable = "notApplicable"

class FindingBase(BaseModel):
    inspection_id: str
    requirement_id: str
    description: str
    status: FindingStatus
    severity: str = "medium"

class FindingCreate(FindingBase, SyncBase):
    pass

class Finding(FindingBase):
    id: str
    local_id: Optional[str] = None
    local_version: int
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class ViolationSeverity(str, Enum):
    low = "low"
    medium = "medium"
    high = "high"
    critical = "critical"

class ViolationStatus(str, Enum):
    open = "open"
    resolved = "resolved"
    inProgress = "inProgress"
    closed = "closed"

class ViolationBase(BaseModel):
    mine_id: str
    inspection_id: str
    finding_id: str
    title: str
    description: str
    severity: ViolationSeverity
    status: ViolationStatus
    assigned_to: Optional[str] = None
    due_date: Optional[datetime] = None
    detected_at: datetime

class ViolationCreate(ViolationBase, SyncBase):
    pass

class Violation(ViolationBase):
    id: str
    local_id: Optional[str] = None
    local_version: int
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class AlertBase(BaseModel):
    mine_id: str
    title: str
    message: str
    severity: str
    is_read: bool = False

class AlertCreate(AlertBase, SyncBase):
    pass

class Alert(AlertBase):
    id: str
    local_id: Optional[str] = None
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class CorrectiveActionBase(BaseModel):
    violation_id: str
    title: str
    description: str
    assigned_to: str
    priority: str
    due_date: datetime
    status: str
    submitted_at: Optional[datetime] = None
    verified_at: Optional[datetime] = None
    evidence: Optional[str] = None

class CorrectiveActionCreate(CorrectiveActionBase, SyncBase):
    pass

class CorrectiveAction(CorrectiveActionBase):
    id: str
    local_id: Optional[str] = None
    local_version: int
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)

class AuditTrailBase(BaseModel):
    entity_type: str
    entity_id: str
    action: str
    previous_state: Optional[str] = None
    new_state: str
    actor_id: str
    timestamp: datetime
    comment: Optional[str] = None

class AuditTrailCreate(AuditTrailBase, SyncBase):
    pass

class AuditTrail(AuditTrailBase):
    id: str
    local_id: Optional[str] = None
    created_at: datetime
    
    model_config = ConfigDict(from_attributes=True)
