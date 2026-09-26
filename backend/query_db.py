from app.database import SessionLocal
from app.models.models import Profile, UserMineAssignment, Mine

db = SessionLocal()
try:
    profiles = db.query(Profile).all()
    print("--- PROFILES ---")
    for p in profiles:
        print(f"ID: {p.id}, Email: {p.email}, Role: {p.role}")
    
    assignments = db.query(UserMineAssignment).all()
    print("--- ASSIGNMENTS ---")
    for a in assignments:
        print(f"User: {a.profile_id} -> Mine: {a.mine_id}")
        
    mines = db.query(Mine).all()
    print("--- MINES ---")
    for m in mines:
        print(f"ID: {m.id}, Code: {m.mine_code}")
finally:
    db.close()
