from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import Mine, Inspection, InspectionFinding, Violation, Alert, ProcessedOperation
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
operation_repo = OperationRepository()
