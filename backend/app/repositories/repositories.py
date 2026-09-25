from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import Mine, Inspection, InspectionFinding, Violation, Alert, ProcessedOperation, CorrectiveAction, AuditTrail
from ..models.telemetry import Telemetry as TelemetryModel
from .base import BaseRepository

class MineRepository(BaseRepository[Mine]):
    def __init__(self):
        super().__init__(Mine)

    def get_by_code(self, db: Session, mine_code: str) -> Optional[Mine]:
        return db.query(Mine).filter(Mine.mine_code == mine_code).first()

class InspectionRepository(BaseRepository[Inspection]):
    def __init__(self):
        super().__init__(Inspection)

    def get_by_mine(self, db: Session, mine_id: str) -> List[Inspection]:
        return db.query(Inspection).filter(Inspection.mine_id == mine_id).all()

class FindingRepository(BaseRepository[InspectionFinding]):
    def __init__(self):
        super().__init__(InspectionFinding)

    def get_by_inspection(self, db: Session, inspection_id: str) -> List[InspectionFinding]:
        return db.query(InspectionFinding).filter(InspectionFinding.inspection_id == inspection_id).all()

class ViolationRepository(BaseRepository[Violation]):
    def __init__(self):
        super().__init__(Violation)

    def get_by_mine(self, db: Session, mine_id: str) -> List[Violation]:
        return db.query(Violation).filter(Violation.mine_id == mine_id).all()

class AlertRepository(BaseRepository[Alert]):
    def __init__(self):
        super().__init__(Alert)

    def get_by_mine(self, db: Session, mine_id: str) -> List[Alert]:
        return db.query(Alert).filter(Alert.mine_id == mine_id).all()

class CorrectiveActionRepository(BaseRepository[CorrectiveAction]):
    def __init__(self):
        super().__init__(CorrectiveAction)

    def get_by_violation(self, db: Session, violation_id: str) -> List[CorrectiveAction]:
        return db.query(CorrectiveAction).filter(CorrectiveAction.violation_id == violation_id).all()

class AuditTrailRepository(BaseRepository[AuditTrail]):
    def __init__(self):
        super().__init__(AuditTrail)

    def get_by_entity(self, db: Session, entity_id: str) -> List[AuditTrail]:
        return db.query(AuditTrail).filter(AuditTrail.entity_id == entity_id).all()

class TelemetryRepository:
    def create(self, db: Session, obj: TelemetryModel) -> TelemetryModel:
        db.add(obj)
        db.commit()
        db.refresh(obj)
        return obj

    def get_by_mine(self, db: Session, mine_id: str, limit: int = 100) -> List[TelemetryModel]:
        return db.query(TelemetryModel).filter(TelemetryModel.mine_id == mine_id).order_by(TelemetryModel.timestamp.desc()).limit(limit).all()

    def get_all(self, db: Session, limit: int = 100) -> List[TelemetryModel]:
        return db.query(TelemetryModel).order_by(TelemetryModel.timestamp.desc()).limit(limit).all()

class OperationRepository:
    def is_processed(self, db: Session, operation_id: str) -> bool:
        return db.query(ProcessedOperation).filter(ProcessedOperation.operation_id == operation_id).first() is not None

    def mark_processed(self, db: Session, operation_id: str):
        op = ProcessedOperation(operation_id=operation_id)
        db.add(op)
        db.commit()

mine_repo = MineRepository()
inspection_repo = InspectionRepository()
finding_repo = FindingRepository()
violation_repo = ViolationRepository()
alert_repo = AlertRepository()
corrective_action_repo = CorrectiveActionRepository()
audit_trail_repo = AuditTrailRepository()
telemetry_repo = TelemetryRepository()
operation_repo = OperationRepository()
