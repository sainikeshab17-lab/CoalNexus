from typing import Dict, List, Set, Type, Any
from fastapi import HTTPException, status
from ..schemas.models import InspectionStatus, ViolationStatus

# Define statuses as strings to match DB and schema enums
CORRECTIVE_ACTION_STATUSES = {
    "assigned",
    "inProgress",
    "submitted",
    "verification",
    "verified",
    "rejected",
    "closed"
}

INSPECTION_STATUSES = {
    "draft",
    "inProgress",
    "completed",
    "findingsGenerated",
    "submitted"
}

VIOLATION_STATUSES = {
    "open",
    "inProgress",
    "resolved",
    "closed"
}

class WorkflowService:
    @staticmethod
    def validate_inspection_transition(current: str, target: str):
        transitions = {
            "draft": {"inProgress"},
            "inProgress": {"completed", "draft"},
            "completed": {"findingsGenerated"},
            "findingsGenerated": {"submitted"},
            "submitted": set()
        }
        if target not in transitions.get(current, set()):
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=f"Invalid inspection transition from {current} to {target}"
            )

    @staticmethod
    def validate_violation_transition(current: str, target: str):
        transitions = {
            "open": {"inProgress", "resolved", "closed"},
            "inProgress": {"resolved", "closed"},
            "resolved": {"closed", "inProgress"},
            "closed": set()
        }
        if target not in transitions.get(current, set()):
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=f"Invalid violation transition from {current} to {target}"
            )

    @staticmethod
    def validate_corrective_action_transition(current: str, target: str):
        transitions = {
            "assigned": {"inProgress"},
            "inProgress": {"submitted"},
            "submitted": {"verification"},
            "verification": {"verified", "rejected"},
            "verified": {"closed"},
            "rejected": {"inProgress"},
            "closed": set()
        }
        if target not in transitions.get(current, set()):
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=f"Invalid corrective action transition from {current} to {target}"
            )

workflow_service = WorkflowService()
