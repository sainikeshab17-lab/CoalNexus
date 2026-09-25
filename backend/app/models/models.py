from sqlalchemy import Column, String, DateTime, Integer, Boolean, Float, ForeignKey, text
from sqlalchemy.orm import relationship
from ..database import Base
from .base import SyncableModel
from .telemetry import Telemetry

class Mine(SyncableModel):
    __tablename__ = "mines"
    
    name = Column(String, nullable=False)
    mine_code = Column(String, unique=True, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    status = Column(String, nullable=False) # active, inactive, etc.

    inspections = relationship("Inspection", back_populates="mine")
    violations = relationship("Violation", back_populates="mine")
    alerts = relationship("Alert", back_populates="mine")

class Inspection(SyncableModel):
    __tablename__ = "inspections"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    inspector_id = Column(String, nullable=False)
    status = Column(String, nullable=False)
    category = Column(String, nullable=False, server_default="other")

    mine = relationship("Mine", back_populates="inspections")
    findings = relationship("InspectionFinding", back_populates="inspection")
    violations = relationship("Violation", back_populates="inspection")

class InspectionFinding(SyncableModel):
    __tablename__ = "inspection_findings"
    
    inspection_id = Column(String, ForeignKey("inspections.id"), nullable=False)
    requirement_id = Column(String, nullable=False)
    description = Column(String, nullable=False)
    status = Column(String, nullable=False)
    severity = Column(String, nullable=False, server_default="medium")

    inspection = relationship("Inspection", back_populates="findings")

class Violation(SyncableModel):
    __tablename__ = "violations"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    inspection_id = Column(String, ForeignKey("inspections.id"), nullable=False)
    finding_id = Column(String, nullable=False)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    severity = Column(String, nullable=False) # low, medium, high, critical
    status = Column(String, nullable=False) # open, resolved, etc.
    assigned_to = Column(String, nullable=True)
    due_date = Column(DateTime, nullable=True)
    detected_at = Column(DateTime, nullable=False)

    mine = relationship("Mine", back_populates="violations")
    inspection = relationship("Inspection", back_populates="violations")
    corrective_actions = relationship("CorrectiveAction", back_populates="violation")

class Alert(SyncableModel):
    __tablename__ = "alerts"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    title = Column(String, nullable=False)
    message = Column(String, nullable=False)
    severity = Column(String, nullable=False) # LOW, MEDIUM, HIGH, CRITICAL
    is_read = Column(Boolean, default=False)

    mine = relationship("Mine", back_populates="alerts")

class CorrectiveAction(SyncableModel):
    __tablename__ = "corrective_actions"
    
    violation_id = Column(String, ForeignKey("violations.id"), nullable=False)
    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    assigned_to = Column(String, nullable=False)
    priority = Column(String, nullable=False)
    due_date = Column(DateTime, nullable=False)
    status = Column(String, nullable=False)
    submitted_at = Column(DateTime, nullable=True)
    verified_at = Column(DateTime, nullable=True)
    evidence = Column(String, nullable=True)

    violation = relationship("Violation", back_populates="corrective_actions")

class AuditTrail(SyncableModel):
    __tablename__ = "audit_trails"
    
    entity_type = Column(String, nullable=False)
    entity_id = Column(String, nullable=False)
    action = Column(String, nullable=False)
    previous_state = Column(String, nullable=True)
    new_state = Column(String, nullable=False)
    actor_id = Column(String, nullable=False)
    timestamp = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
    comment = Column(String, nullable=True)

class ProcessedOperation(Base):
    __tablename__ = "processed_operations"
    
    operation_id = Column(String, primary_key=True, index=True)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
