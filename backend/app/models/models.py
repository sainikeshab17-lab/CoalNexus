from sqlalchemy import Column, String, DateTime, Integer, Boolean, Float, ForeignKey, text
from sqlalchemy.orm import relationship
from ..database import Base
from .base import SyncableModel

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
    status = Column(String, nullable=False) # submitted, completed, etc.

    mine = relationship("Mine", back_populates="inspections")
    findings = relationship("InspectionFinding", back_populates="inspection")
    violations = relationship("Violation", back_populates="inspection")

class InspectionFinding(SyncableModel):
    __tablename__ = "inspection_findings"
    
    inspection_id = Column(String, ForeignKey("inspections.id"), nullable=False)
    requirement_id = Column(String, nullable=False)
    description = Column(String, nullable=False)
    status = Column(String, nullable=False) # compliant, non_compliant

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

class Alert(SyncableModel):
    __tablename__ = "alerts"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    title = Column(String, nullable=False)
    message = Column(String, nullable=False)
    severity = Column(String, nullable=False) # LOW, MEDIUM, HIGH, CRITICAL
    is_read = Column(Boolean, default=False)

    mine = relationship("Mine", back_populates="alerts")

class ProcessedOperation(Base):
    __tablename__ = "processed_operations"
    
    operation_id = Column(String, primary_key=True, index=True)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
