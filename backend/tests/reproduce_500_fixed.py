import sys
import os
from datetime import datetime

# Add the C:\coalnexus\backend directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

import json
from fastapi.testclient import TestClient
from app.main import app
from app.database import SessionLocal, Base, engine
from app.models.models import Mine, Inspection, Profile, Violation
from sqlalchemy import text

client = TestClient(app)

def setup_db():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    
    # Clean up
    db.execute(text("DELETE FROM violations"))
    db.execute(text("DELETE FROM inspections"))
    db.execute(text("DELETE FROM user_mine_assignments"))
    db.execute(text("DELETE FROM mines"))
    db.execute(text("DELETE FROM profiles"))
    
    # Create required entities
    profile = Profile(id="test-user", email="test@example.com", role="INSPECTOR")
    db.add(profile)
    
    mine = Mine(
        id="srv_mine_123", 
        name="Test Mine", 
        mine_code="M204", 
        latitude=0.0, 
        longitude=0.0, 
        status="active",
        local_id="local_mine_123"
    )
    db.add(mine)
    
    inspection = Inspection(
        id="srv_insp_456", 
        mine_id="srv_mine_123", 
        inspector_id="test-user", 
        status="inProgress",
        local_id="local_insp_456"
    )
    db.add(inspection)
    db.commit()
    db.close()

def test_reproduce_create_violation_failure():
    setup_db()
    
    # Case 1: Valid resolution
    payload = {
        "local_id": "viol_local_1",
        "inspection_id": "local_insp_456",
        "finding_id": "finding_1",
        "mine_id": "local_mine_123",
        "title": "PPE violation",
        "description": "no helmet wore by worker",
        "severity": "high",
        "status": "open",
        "assigned_to": "Inspector",
        "due_date": "2026-10-05T00:00:00.000",
        "detected_at": "2026-09-28T23:57:22.000",
        "local_version": 1
    }
    
    from app.routers.routers import get_current_user_profile
    from app.models.models import Profile
    
    app.dependency_overrides[get_current_user_profile] = lambda: Profile(id="test-user", email="test@example.com", role="INSPECTOR")
    
    print("\n[REPRODUCTION] Case 1: Valid resolution")
    response = client.post("/api/violations", json=payload)
    print(f"Status Code: {response.status_code}")
    
    # Case 2: Unresolvable mine_id -> Should expect 500 (current behavior) or 400/404 (desired)
    payload_bad_mine = payload.copy()
    payload_bad_mine["local_id"] = "viol_local_2"
    payload_bad_mine["mine_id"] = "non-existent-mine"
    
    print("\n[REPRODUCTION] Case 2: Unresolvable mine_id")
    response = client.post("/api/violations", json=payload_bad_mine)
    print(f"Status Code: {response.status_code}")
    if response.status_code == 500:
        print("CONFIRMED: Got 500 for unresolvable mine_id")
    else:
        print(f"Got {response.status_code}: {response.text}")

    # Case 3: Unresolvable inspection_id
    payload_bad_insp = payload.copy()
    payload_bad_insp["local_id"] = "viol_local_3"
    payload_bad_insp["inspection_id"] = "non-existent-insp"
    
    print("\n[REPRODUCTION] Case 3: Unresolvable inspection_id")
    response = client.post("/api/violations", json=payload_bad_insp)
    print(f"Status Code: {response.status_code}")
    if response.status_code == 500:
        print("CONFIRMED: Got 500 for unresolvable inspection_id")
    else:
        print(f"Got {response.status_code}: {response.text}")

if __name__ == "__main__":
    test_reproduce_create_violation_failure()
