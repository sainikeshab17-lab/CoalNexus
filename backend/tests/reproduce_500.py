import json
from fastapi.testclient import TestClient
from app.main import app
from app.database import SessionLocal, Base, engine
from app.models.models import Violation, Mine, Inspection, Profile
from sqlalchemy import text
from datetime import datetime

client = TestClient(app)

def setup_db():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    
    # Clean up
    db.query(Violation).delete()
    db.query(Inspection).delete()
    db.execute(text("DELETE FROM user_mine_assignments"))
    db.query(Mine).delete()
    db.query(Profile).delete()
    
    # Create required entities
    profile = Profile(id="test-user", email="test@example.com", role="INSPECTOR")
    db.add(profile)
    
    mine = Mine(
        id="204", 
        name="Test Mine", 
        mine_code="M204", 
        latitude=0.0, 
        longitude=0.0, 
        status="active",
        local_id="local-mine-204"
    )
    db.add(mine)
    
    inspection = Inspection(
        id="556", 
        mine_id="204", 
        inspector_id="test-user", 
        status="inProgress",
        local_id="local-insp-556"
    )
    db.add(inspection)
    
    violation = Violation(
        id="server-viol-id",
        local_id="200dcd66-1eeb-48e1-9f3b-62bdd4b1e658",
        mine_id="204",
        inspection_id="556",
        finding_id="1",
        title="Original PPE violation",
        description="Original description",
        severity="medium",
        status="open",
        detected_at=datetime.now(),
        local_version=1
    )
    db.add(violation)
    db.commit()
    db.close()

def test_reproduce_update_violation_500():
    setup_db()
    
    payload = {
        "local_id": "200dcd66-1eeb-48e1-9f3b-62bdd4b1e658",
        "server_id": None,
        "inspection_id": "556",
        "finding_id": "1",
        "mine_id": "204",
        "title": "PPE violation",
        "description": "no helmet wore by worker",
        "severity": "high",
        "status": "open",
        "assigned_to": "Inspector",
        "due_date": "2026-10-05T00:00:00.000",
        "detected_at": "2026-09-28T23:57:22.000",
        "created_at": "2026-09-28T23:57:22.000",
        "updated_at": "2026-09-28T23:58:03.487689",
        "local_version": 2
    }
    
    from app.routers.routers import get_current_user_profile
    from app.models.models import Profile
    
    app.dependency_overrides[get_current_user_profile] = lambda: Profile(id="test-user", email="test@example.com", role="INSPECTOR")
    
    print("\n[REPRODUCTION] Sending PUT /api/violations/200dcd66-1eeb-48e1-9f3b-62bdd4b1e658")
    response = client.put("/api/violations/200dcd66-1eeb-48e1-9f3b-62bdd4b1e658", json=payload)
    
    print(f"[REPRODUCTION] Status Code: {response.status_code}")
    if response.status_code == 500 or response.status_code == 422:
        print(f"[REPRODUCTION] Error: {response.text}")
    else:
        print(f"[REPRODUCTION] Success or other error: {response.status_code}")
        print(response.json())

if __name__ == "__main__":
    test_reproduce_update_violation_500()
