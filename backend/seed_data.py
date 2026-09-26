import uuid
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.models import Mine, Profile, UserMineAssignment, UserRole
from geoalchemy2.elements import WKTElement

def seed_database():
    db: Session = SessionLocal()
    try:
        print("Seeding WCL Mines...")
        
        # 3 Mandatory WCL Mines data
        mines_data = [
            {
                "id": str(uuid.uuid4()),
                "name": "WCL Umrer",
                "mine_code": "WCL_UMRER",
                "company": "WCL",
                "district": "Nagpur",
                "state": "Maharashtra",
                "latitude": 20.8545,
                "longitude": 79.3242,
                "status": "active"
            },
            {
                "id": str(uuid.uuid4()),
                "name": "WCL Majri",
                "mine_code": "WCL_MAJRI",
                "company": "WCL",
                "district": "Chandrapur",
                "state": "Maharashtra",
                "latitude": 20.1415,
                "longitude": 79.0305,
                "status": "active"
            },
            {
                "id": str(uuid.uuid4()),
                "name": "WCL Ballarpur",
                "mine_code": "WCL_BALLARPUR",
                "company": "WCL",
                "district": "Chandrapur",
                "state": "Maharashtra",
                "latitude": 19.8451,
                "longitude": 79.3496,
                "status": "active"
            }
        ]

        inserted_mines = {}
        for mine_info in mines_data:
            existing_mine = db.query(Mine).filter(Mine.mine_code == mine_info["mine_code"]).first()
            if not existing_mine:
                # Use WKTElement for PostGIS location Point(longitude, latitude)
                loc_wkt = f"POINT({mine_info['longitude']} {mine_info['latitude']})"
                mine_obj = Mine(
                    id=mine_info["id"],
                    name=mine_info["name"],
                    mine_code=mine_info["mine_code"],
                    company=mine_info["company"],
                    district=mine_info["district"],
                    state=mine_info["state"],
                    latitude=mine_info["latitude"],
                    longitude=mine_info["longitude"],
                    location=WKTElement(loc_wkt, srid=4326),
                    status=mine_info["status"]
                )
                db.add(mine_obj)
                inserted_mines[mine_info["mine_code"]] = mine_obj
                print(f"Added mine: {mine_info['name']}")
            else:
                inserted_mines[mine_info["mine_code"]] = existing_mine
                print(f"Mine already exists: {mine_info['name']}")

        db.commit()

        print("Seeding Demo Users...")
        # Demo Users
        users_data = [
            {
                "id": "demo-admin-id-111",
                "email": "admin@coalnexus.com",
                "full_name": "System Administrator",
                "role": UserRole.ADMIN.value,
                "is_active": True,
                "assigned_mines": []
            },
            {
                "id": "demo-officer-id-222",
                "email": "officer@coalnexus.com",
                "full_name": "Mine Safety Officer",
                "role": UserRole.OFFICER.value,
                "is_active": True,
                "assigned_mines": ["WCL_UMRER", "WCL_MAJRI"]
            },
            {
                "id": "demo-inspector-id-333",
                "email": "inspector@coalnexus.com",
                "full_name": "Safety Inspector",
                "role": UserRole.INSPECTOR.value,
                "is_active": True,
                "assigned_mines": ["WCL_UMRER", "WCL_BALLARPUR"]
            }
        ]

        for user_info in users_data:
            existing_profile = db.query(Profile).filter(Profile.id == user_info["id"]).first()
            if not existing_profile:
                profile_obj = Profile(
                    id=user_info["id"],
                    email=user_info["email"],
                    full_name=user_info["full_name"],
                    role=user_info["role"],
                    is_active=user_info["is_active"]
                )
                db.add(profile_obj)
                db.flush() # populate ID and session info

                # Assign user to mines
                for code in user_info["assigned_mines"]:
                    mine_obj = inserted_mines.get(code)
                    if mine_obj:
                        assignment = UserMineAssignment(
                            profile_id=profile_obj.id,
                            mine_id=mine_obj.id
                        )
                        db.add(assignment)
                print(f"Added profile: {user_info['full_name']} ({user_info['role']})")
            else:
                print(f"Profile already exists: {user_info['full_name']}")

        db.commit()
        print("Database seeding completed successfully.")

    except Exception as e:
        db.rollback()
        print(f"Error seeding database: {e}")
        raise e
    finally:
        db.close()

if __name__ == "__main__":
    import sys
    import os
    # Add parent directory to python path if needed
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    seed_database()
