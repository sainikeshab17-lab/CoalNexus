import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.main import app
from app.database import Base, get_db
from app.models.models import UserRole, Profile, UserMineAssignment, Mine
from geoalchemy2 import Geometry
import geoalchemy2.admin.dialects.sqlite

# Bypass GeoAlchemy2 initialization for SQLite testing
setattr(geoalchemy2.admin.dialects.sqlite, 'after_create', lambda *a, **kw: None)
setattr(geoalchemy2.admin.dialects.sqlite, 'before_create', lambda *a, **kw: None)
setattr(geoalchemy2.admin.dialects.sqlite, 'before_drop', lambda *a, **kw: None)
setattr(geoalchemy2.admin.dialects.sqlite, 'after_drop', lambda *a, **kw: None)

# Also remove the index and geometry columns from the metadata for SQLite to avoid creation errors
for table in Base.metadata.tables.values():
    table.indexes = {idx for idx in table.indexes if not any(isinstance(c.type, Geometry) for c in idx.columns)}
    for column in table.columns:
        if isinstance(column.type, Geometry):
            # Change Geometry to a simple type for SQLite
            from sqlalchemy import Text
            column.type = Text()

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

@pytest.fixture(autouse=True)
def run_around_tests():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    
    # Seed a demo admin profile for auth tests
    db = TestingSessionLocal()
    admin = Profile(
        id="demo-admin-id-111",
        email="admin@coalnexus.com",
        full_name="Admin User",
        role=UserRole.ADMIN.value,
        is_active=True
    )
    db.add(admin)
    
    inspector = Profile(
        id="demo-inspector-id-333",
        email="inspector@coalnexus.com",
        full_name="Inspector User",
        role=UserRole.INSPECTOR.value,
        is_active=True
    )
    db.add(inspector)
    db.commit()
    db.close()

    yield
    Base.metadata.drop_all(bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

def test_health_check():
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "version": "1.0.0"}

def test_create_mine():
    mine_data = {
        "local_id": "loc_123",
        "name": "Test Mine",
        "mine_code": "TM001",
        "latitude": 12.34,
        "longitude": 56.78,
        "status": "active",
        "operation_id": "op_123"
    }
    response = client.post("/api/mines", json=mine_data, headers={"Authorization": "Bearer demo-admin-id-111"})
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Test Mine"
    assert data["local_id"] == "loc_123"
    assert data["id"].startswith("srv_")

def test_idempotency():
    mine_data = {
        "local_id": "loc_456",
        "name": "Idempotent Mine",
        "mine_code": "IM001",
        "latitude": 12.34,
        "longitude": 56.78,
        "status": "active",
        "operation_id": "op_456"
    }
    response1 = client.post("/api/mines", json=mine_data, headers={"Authorization": "Bearer demo-admin-id-111"})
    assert response1.status_code == 200
    id1 = response1.json()["id"]

    response2 = client.post("/api/mines", json=mine_data, headers={"Authorization": "Bearer demo-admin-id-111"})
    assert response2.status_code == 200
    id2 = response2.json()["id"]
    
    assert id1 == id2

def test_telemetry_ingestion():
    telemetry_data = {
        "mine_id": "loc_123",
        "device_id": "sensor_001",
        "timestamp": "2023-10-27T10:00:00Z",
        "readings": {
            "methane": 0.5,
            "co": 10.0,
            "temperature": 25.5,
            "humidity": 60.0,
            "oxygen": 20.9,
            "dust": 0.02,
            "vibration": 0.1
        }
    }
    # First ensure the mine exists
    client.post("/api/mines", json={
        "local_id": "loc_123",
        "name": "Test Mine",
        "mine_code": "TM001",
        "latitude": 0,
        "longitude": 0,
        "status": "active",
        "operation_id": "op_tel_1"
    }, headers={"Authorization": "Bearer demo-admin-id-111"})
    
    response = client.post("/api/telemetry", json=telemetry_data)
    assert response.status_code == 200
    data = response.json()
    assert data["device_id"] == "sensor_001"
    assert data["readings"]["methane"] == 0.5

def test_workflow_validation_inspection():
    # Create an inspection
    insp_data = {
        "local_id": "insp_1",
        "mine_id": "loc_123",
        "inspector_id": "user_1",
        "status": "draft",
        "category": "safety",
        "local_version": 1,
        "operation_id": "op_insp_1"
    }
    client.post("/api/inspections", json=insp_data)
    
    # Try invalid transition: draft -> completed (skipping inProgress)
    update_data = insp_data.copy()
    update_data["status"] = "completed"
    update_data["local_version"] = 2
    update_data["operation_id"] = "op_insp_2"
    
    response = client.put("/api/inspections/insp_1", json=update_data)
    assert response.status_code == 422
    assert "Invalid inspection transition" in response.json()["detail"]

    # Try valid transition: draft -> inProgress
    update_data["status"] = "inProgress"
    response = client.put("/api/inspections/insp_1", json=update_data)
    assert response.status_code == 200
    assert response.json()["status"] == "inProgress"

def test_corrective_action_workflow():
    # 1. Create Mine
    client.post("/api/mines", json={
        "local_id": "m1", "name": "M1", "mine_code": "M1", "latitude": 0, "longitude": 0, "status": "active", "operation_id": "op1"
    }, headers={"Authorization": "Bearer demo-admin-id-111"})
    # 2. Create Inspection
    client.post("/api/inspections", json={
        "local_id": "i1", "mine_id": "m1", "inspector_id": "u1", "status": "draft", "category": "safety", "operation_id": "op2"
    })
    # 3. Create Violation
    client.post("/api/violations", json={
        "local_id": "v1", "mine_id": "m1", "inspection_id": "i1", "finding_id": "f1", "title": "V1", "description": "D1",
        "severity": "high", "status": "open", "detected_at": "2023-10-27T10:00:00Z", "operation_id": "op3"
    })
    # 4. Create Corrective Action
    ca_data = {
        "local_id": "ca1",
        "violation_id": "v1",
        "title": "Fix it",
        "description": "Do something",
        "assigned_to": "worker1",
        "priority": "high",
        "due_date": "2023-11-27T10:00:00Z",
        "status": "assigned",
        "operation_id": "op4"
    }
    response = client.post("/api/corrective-actions", json=ca_data)
    assert response.status_code == 200
    
    # 5. Transition: assigned -> inProgress (Valid)
    ca_data["status"] = "inProgress"
    ca_data["operation_id"] = "op5"
    response = client.put("/api/corrective-actions/ca1", json=ca_data)
    assert response.status_code == 200
    
    # 6. Transition: inProgress -> verified (Invalid, must be submitted first)
    ca_data["status"] = "verified"
    ca_data["operation_id"] = "op6"
    response = client.put("/api/corrective-actions/ca1", json=ca_data)
    assert response.status_code == 422
    assert "Invalid corrective action transition" in response.json()["detail"]
