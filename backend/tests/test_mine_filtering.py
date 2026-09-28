import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.database import Base, get_db
from app.models.models import Mine, Profile, UserRole, UserMineAssignment

from geoalchemy2 import Geometry
import geoalchemy2.admin.dialects.sqlite


# Bypass GeoAlchemy2 for SQLite
setattr(
    geoalchemy2.admin.dialects.sqlite,
    "after_create",
    lambda *a, **kw: None,
)
setattr(
    geoalchemy2.admin.dialects.sqlite,
    "before_create",
    lambda *a, **kw: None,
)


# ---------------------------------------------------------
# Test Database
# ---------------------------------------------------------

SQLALCHEMY_DATABASE_URL = "sqlite:///./test_filtering.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
)

TestingSessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)


def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


# ---------------------------------------------------------
# Database Setup
# ---------------------------------------------------------

@pytest.fixture(scope="module", autouse=True)
def setup_db():

    # Set this module's database override only when
    # this test module is active.
    app.dependency_overrides[get_db] = override_get_db

    # Patch GeoAlchemy geometry for SQLite
    for table in Base.metadata.tables.values():

        table.indexes = {
            idx
            for idx in table.indexes
            if not any(
                isinstance(column.type, Geometry)
                for column in idx.columns
            )
        }

        for column in table.columns:
            if isinstance(column.type, Geometry):
                from sqlalchemy import Text
                column.type = Text()

    # Create all tables
    Base.metadata.create_all(bind=engine)

    db = TestingSessionLocal()

    # -----------------------------------------------------
    # Seed test mines
    # -----------------------------------------------------

    mines = [
        Mine(
            id="m1",
            local_id="L1",
            name="ENA Colliery",
            mine_code="C1",
            latitude=0,
            longitude=0,
            status="active",
            state="Jharkhand",
            district="Dhanbad",
            owner_code="BCCL",
            company="BCCL",
            mine_type="OC",
            ownership_type="Govt",
            commodity="Coal",
        ),
        Mine(
            id="m2",
            local_id="L2",
            name="Moonidih",
            mine_code="C2",
            latitude=0,
            longitude=0,
            status="active",
            state="Jharkhand",
            district="Dhanbad",
            owner_code="BCCL",
            company="BCCL",
            mine_type="UG",
            ownership_type="Govt",
            commodity="Coal",
        ),
        Mine(
            id="m3",
            local_id="L3",
            name="Singrauli Mine",
            mine_code="C3",
            latitude=0,
            longitude=0,
            status="active",
            state="Madhya Pradesh",
            district="Singrauli",
            owner_code="NCL",
            company="NCL",
            mine_type="OC",
            ownership_type="Govt",
            commodity="Coal",
        ),
        Mine(
            id="m4",
            local_id="L4",
            name="Inactive Mine",
            mine_code="C4",
            latitude=0,
            longitude=0,
            status="inactive",
            state="Bihar",
            district="Gaya",
            owner_code="PVT",
            company="Private Ltd",
            mine_type="OC",
            ownership_type="Private",
            commodity="Coal",
        ),
    ]

    db.add_all(mines)

    # -----------------------------------------------------
    # Seed profiles
    # -----------------------------------------------------

    admin = Profile(
        id="admin-id",
        email="admin@test.com",
        role=UserRole.ADMIN.value,
    )

    officer = Profile(
        id="officer-id",
        email="officer@test.com",
        role=UserRole.OFFICER.value,
    )

    db.add_all([admin, officer])

    # Assign m1 to officer
    db.add(
        UserMineAssignment(
            profile_id="officer-id",
            mine_id="m1",
        )
    )

    db.commit()
    db.close()

    yield

    # -----------------------------------------------------
    # Cleanup
    # -----------------------------------------------------

    Base.metadata.drop_all(bind=engine)

    # Remove this module's database override
    app.dependency_overrides.pop(get_db, None)


# ---------------------------------------------------------
# Test Client
# ---------------------------------------------------------

client = TestClient(app)


# ---------------------------------------------------------
# Public Mine Tests
# ---------------------------------------------------------

def test_public_mines_default():
    response = client.get("/api/public/mines")

    assert response.status_code == 200

    data = response.json()

    # Should only return active mines: m1, m2, m3
    assert len(data) == 3
    assert all(m["status"] == "active" for m in data)


def test_public_mines_state_filter():
    response = client.get(
        "/api/public/mines?state=Jharkhand"
    )

    assert response.status_code == 200

    data = response.json()

    assert len(data) == 2
    assert all(
        m["state"] == "Jharkhand"
        for m in data
    )


def test_public_mines_district_filter():
    response = client.get(
        "/api/public/mines?district=Singrauli"
    )

    assert response.status_code == 200

    data = response.json()

    assert len(data) == 1
    assert data[0]["name"] == "Singrauli Mine"


def test_public_mines_search():
    # Case-insensitive search
    response = client.get(
        "/api/public/mines?search=ena"
    )

    assert response.status_code == 200

    data = response.json()

    assert len(data) == 1
    assert data[0]["name"] == "ENA Colliery"


def test_public_mines_combined_filter():
    response = client.get(
        "/api/public/mines?state=Jharkhand&mine_type=UG"
    )

    assert response.status_code == 200

    data = response.json()

    assert len(data) == 1
    assert data[0]["name"] == "Moonidih"


def test_public_mines_pagination():
    response = client.get(
        "/api/public/mines?skip=0&limit=2"
    )

    assert response.status_code == 200

    data = response.json()

    assert len(data) == 2

    response2 = client.get(
        "/api/public/mines?skip=2&limit=2"
    )

    assert response2.status_code == 200

    data2 = response2.json()

    assert len(data2) == 1

    assert data2[0]["id"] not in [
        m["id"] for m in data
    ]


def test_public_mines_limit_clamping():
    # limit > 500 should be rejected
    # by FastAPI Query validation
    response = client.get(
        "/api/public/mines?limit=501"
    )

    assert response.status_code == 422


def test_public_mines_sorting():

    response = client.get(
        "/api/public/mines?sort_by=name&sort_order=asc"
    )

    assert response.status_code == 200

    names = [
        m["name"]
        for m in response.json()
    ]

    assert names == sorted(names)

    response = client.get(
        "/api/public/mines?sort_by=name&sort_order=desc"
    )

    assert response.status_code == 200

    names = [
        m["name"]
        for m in response.json()
    ]

    assert names == sorted(
        names,
        reverse=True,
    )


# ---------------------------------------------------------
# Authenticated Mine Tests
# ---------------------------------------------------------

def test_authenticated_mines_admin():

    from app.core.security import get_current_user_profile

    db = TestingSessionLocal()

    try:
        admin = (
            db.query(Profile)
            .filter(Profile.id == "admin-id")
            .first()
        )

        app.dependency_overrides[
            get_current_user_profile
        ] = lambda: admin

        response = client.get("/api/mines")

        assert response.status_code == 200

        # All active mines
        assert len(response.json()) == 3

    finally:
        app.dependency_overrides.pop(
            get_current_user_profile,
            None,
        )
        db.close()


def test_authenticated_mines_officer():

    from app.core.security import get_current_user_profile

    db = TestingSessionLocal()

    try:
        officer = (
            db.query(Profile)
            .filter(Profile.id == "officer-id")
            .first()
        )

        app.dependency_overrides[
            get_current_user_profile
        ] = lambda: officer

        response = client.get("/api/mines")

        assert response.status_code == 200

        data = response.json()

        assert len(data) == 1
        assert data[0]["id"] == "m1"

    finally:
        app.dependency_overrides.pop(
            get_current_user_profile,
            None,
        )
        db.close()
