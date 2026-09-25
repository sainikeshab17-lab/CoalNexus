import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.main import app
from app.database import Base, get_db

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

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
    response = client.post("/api/mines", json=mine_data)
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
    response1 = client.post("/api/mines", json=mine_data)
    assert response1.status_code == 200
    id1 = response1.json()["id"]

    response2 = client.post("/api/mines", json=mine_data)
    assert response2.status_code == 200
    id2 = response2.json()["id"]
    
    assert id1 == id2
