from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from typing import List
import uuid

from ..database import get_db
from ..schemas import models as schemas
from ..schemas import sync as sync_schemas
from ..models import models as db_models
from ..repositories.repositories import mine_repo, inspection_repo, violation_repo, alert_repo, operation_repo, finding_repo, corrective_action_repo, audit_trail_repo, telemetry_repo
from ..services.workflow import workflow_service
from ..schemas import telemetry as tel_schemas
from ..core.security import get_current_user_profile, RoleChecker, MineAccessChecker
from ..models.models import UserRole, Profile

router = APIRouter()

mine_access_checker = MineAccessChecker()

@router.get("/health", response_model=sync_schemas.HealthResponse)
def health_check():
    return sync_schemas.HealthResponse()

def check_idempotency(db: Session, operation_id: str or None):
    if operation_id and operation_repo.is_processed(db, operation_id):
        return True
    return False

# --- MINES ---
@router.get("/mines", response_model=List[schemas.Mine])
def get_mines(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), current_user: Profile = Depends(get_current_user_profile)):
    # If admin, return all mines. Otherwise return only assigned ones.
    if current_user.role == UserRole.ADMIN.value:
        return mine_repo.get_all(db, skip=skip, limit=limit)
    
    assigned_mine_ids = [assignment.mine_id for assignment in current_user.mine_assignments]
    all_mines = mine_repo.get_all(db, skip=skip, limit=limit)
    return [m for m in all_mines if m.id in assigned_mine_ids]

@router.get("/mines/{mine_id}", response_model=schemas.Mine)
def get_mine(mine_id: str, db: Session = Depends(get_db), current_user: Profile = Depends(get_current_user_profile)):
    db_obj = mine_repo.get_by_id(db, mine_id) or mine_repo.get_by_local_id(db, mine_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Mine not found")
    mine_access_checker.check_mine_access(db, current_user, db_obj.id)
    return db_obj

@router.post("/mines", response_model=schemas.Mine)
def create_mine(mine_in: schemas.MineCreate, db: Session = Depends(get_db), current_user: Profile = Depends(RoleChecker([UserRole.ADMIN.value]))):
    if mine_in.operation_id and check_idempotency(db, mine_in.operation_id):
        existing = mine_repo.get_by_local_id(db, mine_in.local_id)
        if existing:
            return existing
    
    existing_local = mine_repo.get_by_local_id(db, mine_in.local_id)
    if existing_local:
        return existing_local

    db_obj = db_models.Mine(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=mine_in.local_id,
        name=mine_in.name,
        mine_code=mine_in.mine_code,
        latitude=mine_in.latitude,
        longitude=mine_in.longitude,
        status=mine_in.status.value,
        local_version=mine_in.local_version,
        operation_id=mine_in.operation_id
    )
    mine_repo.create(db, db_obj)
    if mine_in.operation_id:
        operation_repo.mark_processed(db, mine_in.operation_id)
    return db_obj

@router.put("/mines/{mine_id}", response_model=schemas.Mine)
def update_mine(mine_id: str, mine_in: schemas.MineUpdate, db: Session = Depends(get_db), current_user: Profile = Depends(RoleChecker([UserRole.ADMIN.value]))):
    db_obj = mine_repo.get_by_id(db, mine_id) or mine_repo.get_by_local_id(db, mine_in.local_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Mine not found")
    
    if mine_in.operation_id and check_idempotency(db, mine_in.operation_id):
        return db_obj

    # Simple conflict strategy: newer version wins
    if mine_in.local_version < db_obj.local_version:
        # Server version is newer, return 409 Conflict with current server object
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=jsonable_encoder({
                "message": "Conflict detected: server version is newer",
                "server_version": db_obj.local_version,
                "current_server_obj": schemas.Mine.from_orm(db_obj).dict()
            })
        )

    update_data = {
        "name": mine_in.name,
        "mine_code": mine_in.mine_code,
        "latitude": mine_in.latitude,
        "longitude": mine_in.longitude,
        "status": mine_in.status.value,
        "local_version": mine_in.local_version,
        "operation_id": mine_in.operation_id
    }
    updated = mine_repo.update(db, db_obj, update_data)
    if mine_in.operation_id:
        operation_repo.mark_processed(db, mine_in.operation_id)
    return updated

# --- INSPECTIONS ---
@router.get("/inspections", response_model=List[schemas.Inspection])
def get_inspections(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return inspection_repo.get_all(db, skip=skip, limit=limit)

@router.post("/inspections", response_model=schemas.Inspection)
def create_inspection(insp_in: schemas.InspectionCreate, db: Session = Depends(get_db)):
    if insp_in.operation_id and check_idempotency(db, insp_in.operation_id):
        existing = inspection_repo.get_by_local_id(db, insp_in.local_id)
        if existing:
            return existing

    existing_local = inspection_repo.get_by_local_id(db, insp_in.local_id)
    if existing_local:
        return existing_local

    # Resolve mine_id if it's local_id
    mine_obj = mine_repo.get_by_id(db, insp_in.mine_id) or mine_repo.get_by_local_id(db, insp_in.mine_id)
    mine_id = mine_obj.id if mine_obj else insp_in.mine_id

    db_obj = db_models.Inspection(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=insp_in.local_id,
        mine_id=mine_id,
        inspector_id=insp_in.inspector_id,
        status=insp_in.status.value,
        category=insp_in.category,
        local_version=insp_in.local_version,
        operation_id=insp_in.operation_id
    )
    inspection_repo.create(db, db_obj)
    if insp_in.operation_id:
        operation_repo.mark_processed(db, insp_in.operation_id)
    return db_obj

@router.put("/inspections/{insp_id}", response_model=schemas.Inspection)
def update_inspection(insp_id: str, insp_in: schemas.InspectionCreate, db: Session = Depends(get_db)):
    db_obj = inspection_repo.get_by_id(db, insp_id) or inspection_repo.get_by_local_id(db, insp_in.local_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Inspection not found")
    
    if insp_in.operation_id and check_idempotency(db, insp_in.operation_id):
        return db_obj

    if insp_in.local_version < db_obj.local_version:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=jsonable_encoder({
                "message": "Conflict detected: server version is newer",
                "server_version": db_obj.local_version,
                "current_server_obj": schemas.Inspection.from_orm(db_obj).dict()
            })
        )

    if insp_in.status.value != db_obj.status:
        workflow_service.validate_inspection_transition(db_obj.status, insp_in.status.value)

    mine_obj = mine_repo.get_by_id(db, insp_in.mine_id) or mine_repo.get_by_local_id(db, insp_in.mine_id)
    mine_id = mine_obj.id if mine_obj else insp_in.mine_id

    update_data = {
        "mine_id": mine_id,
        "inspector_id": insp_in.inspector_id,
        "status": insp_in.status.value,
        "category": insp_in.category,
        "local_version": insp_in.local_version,
        "operation_id": insp_in.operation_id
    }
    updated = inspection_repo.update(db, db_obj, update_data)
    if insp_in.operation_id:
        operation_repo.mark_processed(db, insp_in.operation_id)
    return updated

# --- VIOLATIONS ---
@router.get("/violations", response_model=List[schemas.Violation])
def get_violations(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return violation_repo.get_all(db, skip=skip, limit=limit)

@router.post("/violations", response_model=schemas.Violation)
def create_violation(viol_in: schemas.ViolationCreate, db: Session = Depends(get_db)):
    if viol_in.operation_id and check_idempotency(db, viol_in.operation_id):
        existing = violation_repo.get_by_local_id(db, viol_in.local_id)
        if existing:
            return existing

    existing_local = violation_repo.get_by_local_id(db, viol_in.local_id)
    if existing_local:
        return existing_local

    mine_obj = mine_repo.get_by_id(db, viol_in.mine_id) or mine_repo.get_by_local_id(db, viol_in.mine_id)
    mine_id = mine_obj.id if mine_obj else viol_in.mine_id

    insp_obj = inspection_repo.get_by_id(db, viol_in.inspection_id) or inspection_repo.get_by_local_id(db, viol_in.inspection_id)
    inspection_id = insp_obj.id if insp_obj else viol_in.inspection_id

    db_obj = db_models.Violation(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=viol_in.local_id,
        mine_id=mine_id,
        inspection_id=inspection_id,
        finding_id=viol_in.finding_id,
        title=viol_in.title,
        description=viol_in.description,
        severity=viol_in.severity.value,
        status=viol_in.status.value,
        assigned_to=viol_in.assigned_to,
        due_date=viol_in.due_date,
        detected_at=viol_in.detected_at,
        local_version=viol_in.local_version,
        operation_id=viol_in.operation_id
    )
    violation_repo.create(db, db_obj)
    if viol_in.operation_id:
        operation_repo.mark_processed(db, viol_in.operation_id)
    return db_obj

@router.put("/violations/{viol_id}", response_model=schemas.Violation)
def update_violation(viol_id: str, viol_in: schemas.ViolationCreate, db: Session = Depends(get_db)):
    db_obj = violation_repo.get_by_id(db, viol_id) or violation_repo.get_by_local_id(db, viol_in.local_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Violation not found")

    if viol_in.operation_id and check_idempotency(db, viol_in.operation_id):
        return db_obj

    if viol_in.local_version < db_obj.local_version:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=jsonable_encoder({
                "message": "Conflict detected: server version is newer",
                "server_version": db_obj.local_version,
                "current_server_obj": schemas.Violation.from_orm(db_obj).dict()
            })
        )

    if viol_in.status.value != db_obj.status:
        workflow_service.validate_violation_transition(db_obj.status, viol_in.status.value)

    mine_obj = mine_repo.get_by_id(db, viol_in.mine_id) or mine_repo.get_by_local_id(db, viol_in.mine_id)
    mine_id = mine_obj.id if mine_obj else viol_in.mine_id

    insp_obj = inspection_repo.get_by_id(db, viol_in.inspection_id) or inspection_repo.get_by_local_id(db, viol_in.inspection_id)
    inspection_id = insp_obj.id if insp_obj else viol_in.inspection_id

    update_data = {
        "mine_id": mine_id,
        "inspection_id": inspection_id,
        "finding_id": viol_in.finding_id,
        "title": viol_in.title,
        "description": viol_in.description,
        "severity": viol_in.severity.value,
        "status": viol_in.status.value,
        "assigned_to": viol_in.assigned_to,
        "due_date": viol_in.due_date,
        "detected_at": viol_in.detected_at,
        "local_version": viol_in.local_version,
        "operation_id": viol_in.operation_id
    }
    updated = violation_repo.update(db, db_obj, update_data)
    if viol_in.operation_id:
        operation_repo.mark_processed(db, viol_in.operation_id)
    return updated

# --- FINDINGS ---
@router.get("/findings", response_model=List[schemas.Finding])
def get_findings(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return finding_repo.get_all(db, skip=skip, limit=limit)

@router.post("/findings", response_model=schemas.Finding)
def create_finding(finding_in: schemas.FindingCreate, db: Session = Depends(get_db)):
    if finding_in.operation_id and check_idempotency(db, finding_in.operation_id):
        existing = finding_repo.get_by_local_id(db, finding_in.local_id)
        if existing:
            return existing

    existing_local = finding_repo.get_by_local_id(db, finding_in.local_id)
    if existing_local:
        return existing_local

    insp_obj = inspection_repo.get_by_id(db, finding_in.inspection_id) or inspection_repo.get_by_local_id(db, finding_in.inspection_id)
    inspection_id = insp_obj.id if insp_obj else finding_in.inspection_id

    db_obj = db_models.InspectionFinding(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=finding_in.local_id,
        inspection_id=inspection_id,
        requirement_id=finding_in.requirement_id,
        description=finding_in.description,
        status=finding_in.status.value,
        severity=finding_in.severity,
        local_version=finding_in.local_version,
        operation_id=finding_in.operation_id
    )
    finding_repo.create(db, db_obj)
    if finding_in.operation_id:
        operation_repo.mark_processed(db, finding_in.operation_id)
    return db_obj

@router.put("/findings/{finding_id}", response_model=schemas.Finding)
def update_finding(finding_id: str, finding_in: schemas.FindingCreate, db: Session = Depends(get_db)):
    db_obj = finding_repo.get_by_id(db, finding_id) or finding_repo.get_by_local_id(db, finding_in.local_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Finding not found")
    
    if finding_in.operation_id and check_idempotency(db, finding_in.operation_id):
        return db_obj

    if finding_in.local_version < db_obj.local_version:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=jsonable_encoder({
                "message": "Conflict detected: server version is newer",
                "server_version": db_obj.local_version,
                "current_server_obj": schemas.Finding.from_orm(db_obj).dict()
            })
        )

    insp_obj = inspection_repo.get_by_id(db, finding_in.inspection_id) or inspection_repo.get_by_local_id(db, finding_in.inspection_id)
    inspection_id = insp_obj.id if insp_obj else finding_in.inspection_id

    update_data = {
        "inspection_id": inspection_id,
        "requirement_id": finding_in.requirement_id,
        "description": finding_in.description,
        "status": finding_in.status.value,
        "severity": finding_in.severity,
        "local_version": finding_in.local_version,
        "operation_id": finding_in.operation_id
    }
    updated = finding_repo.update(db, db_obj, update_data)
    if finding_in.operation_id:
        operation_repo.mark_processed(db, finding_in.operation_id)
    return updated

# --- ALERTS ---
@router.get("/alerts", response_model=List[schemas.Alert])
def get_alerts(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return alert_repo.get_all(db, skip=skip, limit=limit)

@router.post("/alerts", response_model=schemas.Alert)
def create_alert(alert_in: schemas.AlertCreate, db: Session = Depends(get_db)):
    if alert_in.operation_id and check_idempotency(db, alert_in.operation_id):
        existing = alert_repo.get_by_local_id(db, alert_in.local_id)
        if existing:
            return existing

    existing_local = alert_repo.get_by_local_id(db, alert_in.local_id)
    if existing_local:
        return existing_local

    mine_obj = mine_repo.get_by_id(db, alert_in.mine_id) or mine_repo.get_by_local_id(db, alert_in.mine_id)
    mine_id = mine_obj.id if mine_obj else alert_in.mine_id

    db_obj = db_models.Alert(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=alert_in.local_id,
        mine_id=mine_id,
        title=alert_in.title,
        message=alert_in.message,
        severity=alert_in.severity,
        is_read=alert_in.is_read,
        operation_id=alert_in.operation_id
    )
    alert_repo.create(db, db_obj)
    if alert_in.operation_id:
        operation_repo.mark_processed(db, alert_in.operation_id)
    return db_obj

# --- CORRECTIVE ACTIONS ---
@router.get("/corrective-actions", response_model=List[schemas.CorrectiveAction])
def get_corrective_actions(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return corrective_action_repo.get_all(db, skip=skip, limit=limit)

@router.post("/corrective-actions", response_model=schemas.CorrectiveAction)
def create_corrective_action(ca_in: schemas.CorrectiveActionCreate, db: Session = Depends(get_db)):
    if ca_in.operation_id and check_idempotency(db, ca_in.operation_id):
        existing = corrective_action_repo.get_by_local_id(db, ca_in.local_id)
        if existing:
            return existing

    existing_local = corrective_action_repo.get_by_local_id(db, ca_in.local_id)
    if existing_local:
        return existing_local

    viol_obj = violation_repo.get_by_id(db, ca_in.violation_id) or violation_repo.get_by_local_id(db, ca_in.violation_id)
    violation_id = viol_obj.id if viol_obj else ca_in.violation_id

    db_obj = db_models.CorrectiveAction(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=ca_in.local_id,
        violation_id=violation_id,
        title=ca_in.title,
        description=ca_in.description,
        assigned_to=ca_in.assigned_to,
        priority=ca_in.priority,
        due_date=ca_in.due_date,
        status=ca_in.status,
        submitted_at=ca_in.submitted_at,
        verified_at=ca_in.verified_at,
        evidence=ca_in.evidence,
        local_version=ca_in.local_version,
        operation_id=ca_in.operation_id
    )
    corrective_action_repo.create(db, db_obj)
    if ca_in.operation_id:
        operation_repo.mark_processed(db, ca_in.operation_id)
    return db_obj

@router.put("/corrective-actions/{ca_id}", response_model=schemas.CorrectiveAction)
def update_corrective_action(ca_id: str, ca_in: schemas.CorrectiveActionCreate, db: Session = Depends(get_db)):
    db_obj = corrective_action_repo.get_by_id(db, ca_id) or corrective_action_repo.get_by_local_id(db, ca_in.local_id)
    if not db_obj:
        raise HTTPException(status_code=404, detail="Corrective action not found")

    if ca_in.operation_id and check_idempotency(db, ca_in.operation_id):
        return db_obj

    if ca_in.local_version < db_obj.local_version:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=jsonable_encoder({
                "message": "Conflict detected: server version is newer",
                "server_version": db_obj.local_version,
                "current_server_obj": schemas.CorrectiveAction.from_orm(db_obj).dict()
            })
        )

    if ca_in.status != db_obj.status:
        workflow_service.validate_corrective_action_transition(db_obj.status, ca_in.status)

    viol_obj = violation_repo.get_by_id(db, ca_in.violation_id) or violation_repo.get_by_local_id(db, ca_in.violation_id)
    violation_id = viol_obj.id if viol_obj else ca_in.violation_id

    update_data = {
        "violation_id": violation_id,
        "title": ca_in.title,
        "description": ca_in.description,
        "assigned_to": ca_in.assigned_to,
        "priority": ca_in.priority,
        "due_date": ca_in.due_date,
        "status": ca_in.status,
        "submitted_at": ca_in.submitted_at,
        "verified_at": ca_in.verified_at,
        "evidence": ca_in.evidence,
        "local_version": ca_in.local_version,
        "operation_id": ca_in.operation_id
    }
    updated = corrective_action_repo.update(db, db_obj, update_data)
    if ca_in.operation_id:
        operation_repo.mark_processed(db, ca_in.operation_id)
    return updated

# --- AUDIT TRAIL ---
@router.get("/audit-trail", response_model=List[schemas.AuditTrail])
def get_audit_trail(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return audit_trail_repo.get_all(db, skip=skip, limit=limit)

@router.post("/audit-trail", response_model=schemas.AuditTrail)
def create_audit_trail(audit_in: schemas.AuditTrailCreate, db: Session = Depends(get_db)):
    if audit_in.operation_id and check_idempotency(db, audit_in.operation_id):
        existing = audit_trail_repo.get_by_local_id(db, audit_in.local_id)
        if existing:
            return existing

    existing_local = audit_trail_repo.get_by_local_id(db, audit_in.local_id)
    if existing_local:
        return existing_local

    db_obj = db_models.AuditTrail(
        id="srv_" + str(uuid.uuid4())[:8],
        local_id=audit_in.local_id,
        entity_type=audit_in.entity_type,
        entity_id=audit_in.entity_id,
        action=audit_in.action,
        previous_state=audit_in.previous_state,
        new_state=audit_in.new_state,
        actor_id=audit_in.actor_id,
        timestamp=audit_in.timestamp,
        comment=audit_in.comment,
        operation_id=audit_in.operation_id
    )
    audit_trail_repo.create(db, db_obj)
    if audit_in.operation_id:
        operation_repo.mark_processed(db, audit_in.operation_id)
    return db_obj

# --- TELEMETRY ---
@router.post("/telemetry", response_model=tel_schemas.Telemetry)
def create_telemetry(tel_in: tel_schemas.TelemetryCreate, db: Session = Depends(get_db)):
    mine_obj = mine_repo.get_by_id(db, tel_in.mine_id) or mine_repo.get_by_local_id(db, tel_in.mine_id)
    if not mine_obj:
        raise HTTPException(status_code=404, detail="Mine not found")
    
    db_obj = db_models.Telemetry(
        mine_id=mine_obj.id,
        device_id=tel_in.device_id,
        timestamp=tel_in.timestamp,
        readings=tel_in.readings.dict()
    )
    return telemetry_repo.create(db, db_obj)

@router.get("/telemetry", response_model=List[tel_schemas.Telemetry])
def get_telemetry(limit: int = 100, db: Session = Depends(get_db)):
    return telemetry_repo.get_all(db, limit=limit)

@router.get("/telemetry/{mine_id}", response_model=List[tel_schemas.Telemetry])
def get_mine_telemetry(mine_id: str, limit: int = 100, db: Session = Depends(get_db)):
    mine_obj = mine_repo.get_by_id(db, mine_id) or mine_repo.get_by_local_id(db, mine_id)
    if not mine_obj:
        raise HTTPException(status_code=404, detail="Mine not found")
    return telemetry_repo.get_by_mine(db, mine_obj.id, limit=limit)
