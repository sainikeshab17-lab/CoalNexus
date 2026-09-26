from sqlalchemy import Column, String, DateTime, Integer, Boolean, Float, ForeignKey, text, Enum, Table
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
from ..database import Base
from .base import SyncableModel
from .telemetry import Telemetry
import enum

# --- RBAC ---

class UserRole(str, enum.Enum):
    ADMIN = "ADMIN"
    OFFICER = "OFFICER"
    INSPECTOR = "INSPECTOR"

class UserPermission(str, enum.Enum):
    VIEW_DASHBOARD = "viewDashboard"
    VIEW_MINE = "viewMine"
    CREATE_INSPECTION = "createInspection"
    EDIT_INSPECTION = "editInspection"
    SUBMIT_INSPECTION = "submitInspection"
    VIEW_VIOLATION = "viewViolation"
    CREATE_VIOLATION = "createViolation"
    ASSIGN_CORRECTIVE_ACTION = "assignCorrectiveAction"
    VERIFY_CORRECTIVE_ACTION = "verifyCorrectiveAction"
    VIEW_RISK = "viewRisk"
    VIEW_AUDIT_LOG = "viewAuditLog"
    MANAGE_USERS = "manageUsers"
    MANAGE_MINES = "manageMines"

class Profile(Base):
    __tablename__ = "profiles"
    
    id = Column(String, primary_key=True, index=True) # Matches Supabase Auth User ID
    email = Column(String, unique=True, index=True, nullable=False)
    full_name = Column(String)
    role = Column(String, nullable=False, server_default="INSPECTOR")
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
    updated_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'), onupdate=text('CURRENT_TIMESTAMP'))

    mine_assignments = relationship("UserMineAssignment", back_populates="profile")

class UserMineAssignment(Base):
    __tablename__ = "user_mine_assignments"
    
    profile_id = Column(String, ForeignKey("profiles.id"), primary_key=True)
    mine_id = Column(String, ForeignKey("mines.id"), primary_key=True)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))

    profile = relationship("Profile", back_populates="mine_assignments")
    mine = relationship("Mine", back_populates="user_assignments")

# --- CORE ---

class Mine(SyncableModel):
    __tablename__ = "mines"
    
    name = Column(String, nullable=False)
    mine_code = Column(String, unique=True, nullable=False)
    company = Column(String, nullable=True, server_default="WCL")
    district = Column(String, nullable=True)
    state = Column(String, nullable=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    # PostGIS location
    location = Column(Geometry(geometry_type='POINT', srid=4326))
    status = Column(String, nullable=False) # active, inactive, etc.

    inspections = relationship("Inspection", back_populates="mine")
    violations = relationship("Violation", back_populates="mine")
    alerts = relationship("Alert", back_populates="mine")
    sensors = relationship("MineSensor", back_populates="mine")
    risk_scores = relationship("RiskScore", back_populates="mine")
    user_assignments = relationship("UserMineAssignment", back_populates="mine")

class MineSensor(SyncableModel):
    __tablename__ = "mine_sensors"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    sensor_code = Column(String, unique=True, nullable=False)
    sensor_type = Column(String, nullable=False) # methane, co, temperature, etc.
    unit = Column(String, nullable=False)
    min_threshold = Column(Float, nullable=True)
    max_threshold = Column(Float, nullable=True)
    status = Column(String, nullable=False, server_default="active")

    mine = relationship("Mine", back_populates="sensors")

class RiskScore(SyncableModel):
    __tablename__ = "risk_scores"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    score = Column(Float, nullable=False)
    level = Column(String, nullable=False) # low, medium, high, critical
    contributing_factors = Column(String, nullable=True) # JSON string or text
    timestamp = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))

    mine = relationship("Mine", back_populates="risk_scores")

class Inspection(SyncableModel):
    __tablename__ = "inspections"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    inspector_id = Column(String, nullable=False)
    status = Column(String, nullable=False)
    category = Column(String, nullable=False, server_default="other")

    mine = relationship("Mine", back_populates="inspections")
    findings = relationship("InspectionFinding", back_populates="inspection")
    violations = relationship("Violation", back_populates="inspection")
    evidence = relationship("Evidence", primaryjoin="and_(Evidence.entity_type=='Inspection', Evidence.entity_id==Inspection.id)", foreign_keys="[Evidence.entity_id]")

class InspectionFinding(SyncableModel):
    __tablename__ = "inspection_findings"
    
    inspection_id = Column(String, ForeignKey("inspections.id"), nullable=False)
    requirement_id = Column(String, nullable=False)
    description = Column(String, nullable=False)
    status = Column(String, nullable=False)
    severity = Column(String, nullable=False, server_default="medium")

    inspection = relationship("Inspection", back_populates="findings")
    evidence = relationship("Evidence", primaryjoin="and_(Evidence.entity_type=='Finding', Evidence.entity_id==InspectionFinding.id)", foreign_keys="[Evidence.entity_id]")

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
    evidence = relationship("Evidence", primaryjoin="and_(Evidence.entity_type=='Violation', Evidence.entity_id==Violation.id)", foreign_keys="[Evidence.entity_id]")

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
    # The existing 'evidence' field was a string, keeping for compat but will use Evidence table too
    evidence_deprecated = Column(String, nullable=True, name="evidence")

    violation = relationship("Violation", back_populates="corrective_actions")
    verification_records = relationship("VerificationRecord", back_populates="corrective_action")
    evidence = relationship("Evidence", primaryjoin="and_(Evidence.entity_type=='CorrectiveAction', Evidence.entity_id==CorrectiveAction.id)", foreign_keys="[Evidence.entity_id]")

class VerificationRecord(SyncableModel):
    __tablename__ = "verification_records"
    
    corrective_action_id = Column(String, ForeignKey("corrective_actions.id"), nullable=False)
    verifier_id = Column(String, nullable=False)
    status = Column(String, nullable=False) # verified, rejected
    comment = Column(String, nullable=True)
    verified_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))

    corrective_action = relationship("CorrectiveAction", back_populates="verification_records")
    evidence = relationship("Evidence", primaryjoin="and_(Evidence.entity_type=='Verification', Evidence.entity_id==VerificationRecord.id)", foreign_keys="[Evidence.entity_id]")

class Evidence(SyncableModel):
    __tablename__ = "evidence"
    
    entity_type = Column(String, nullable=False) # Inspection, Finding, Violation, CorrectiveAction, Verification
    entity_id = Column(String, nullable=False)
    evidence_type = Column(String, nullable=False) # image, document, signature
    file_path = Column(String, nullable=False)
    description = Column(String, nullable=True)
    uploaded_by = Column(String, nullable=False)

class Alert(SyncableModel):
    __tablename__ = "alerts"
    
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    title = Column(String, nullable=False)
    message = Column(String, nullable=False)
    severity = Column(String, nullable=False) # LOW, MEDIUM, HIGH, CRITICAL
    is_read = Column(Boolean, default=False)
    alert_type = Column(String, nullable=True)
    acknowledged_at = Column(DateTime, nullable=True)
    resolved_at = Column(DateTime, nullable=True)

    mine = relationship("Mine", back_populates="alerts")

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
    metadata_json = Column(String, nullable=True) # JSON string for extra audit info

class ProcessedOperation(Base):
    __tablename__ = "processed_operations"
    
    operation_id = Column(String, primary_key=True, index=True)
    created_at = Column(DateTime, server_default=text('CURRENT_TIMESTAMP'))
