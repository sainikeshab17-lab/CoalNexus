import uuid
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.models import Mine, Profile, UserMineAssignment, UserRole
from geoalchemy2.elements import WKTElement

def seed_database():
    db: Session = SessionLocal()
    try:
        print("Seeding Initial Authentic Mines...")
        
        # We use a few authentic mine codes for demo user assignments.
        # These mines should already exist from the Excel import.
        
        inserted_mines = {}
        mine_codes = ["IND_BCCL_108", "IND_BCCL_109"]
        for code in mine_codes:
            existing_mine = db.query(Mine).filter(Mine.mine_code == code).first()
            if existing_mine:
                inserted_mines[code] = existing_mine
                print(f"Found authentic mine for seeding: {existing_mine.name}")
            else:
                print(f"WARNING: Authentic mine {code} not found in DB. Run import first.")

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
                "assigned_mines": ["IND_BCCL_108", "IND_BCCL_109"]
            },
            {
                "id": "demo-inspector-id-333",
                "email": "inspector@coalnexus.com",
                "full_name": "Safety Inspector",
                "role": UserRole.INSPECTOR.value,
                "is_active": True,
                "assigned_mines": ["IND_BCCL_108", "IND_BCCL_109"]
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
