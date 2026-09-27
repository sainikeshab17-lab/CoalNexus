from app.database import SessionLocal
from app.models.models import Mine, Inspection, UserMineAssignment, Profile

db = SessionLocal()
try:
    print("--- 1. CANDIDATE AUTHENTIC MINES FOR LEGACY MINES ---")
    all_mines = db.query(Mine).all()
    
    legacy_mines = [m for m in all_mines if not m.id.startswith("srv_ind_")]
    authentic_mines = [m for m in all_mines if m.id.startswith("srv_ind_")]
    
    for lm in legacy_mines:
        print(f"\nLegacy Mine: ID={lm.id}, Name={lm.name}, Code={lm.mine_code}, State={lm.state}, District={lm.district}, Type={lm.mine_type}, Owner={lm.owner_name}, Lat={lm.latitude}, Lon={lm.longitude}")
        print("Candidates from Authentic Mines:")
        search_term = lm.name.replace("WCL ", "").lower()
        candidates = []
        for am in authentic_mines:
            if search_term in am.name.lower():
                candidates.append(am)
        for c in candidates:
            print(f"  -> Authentic Mine: ID={c.id}, Name={c.name}, Code={c.mine_code}, State={c.state}, District={c.district}, Type={c.mine_type}, Owner={c.owner_name}, Lat={c.latitude}, Lon={c.longitude}")

    print("\n--- 2. DETAILED REFERENCES FOR LEGACY MINES ---")
    for lm in legacy_mines:
        print(f"\nReferences for Legacy Mine: {lm.name} ({lm.id})")
        
        # Inspections
        inspections = db.query(Inspection).filter(Inspection.mine_id == lm.id).all()
        print(f"  Inspections count: {len(inspections)}")
        for insp in inspections:
            print(f"    - Inspection ID: {insp.id}, Status: {insp.status}, Category: {insp.category}, Created At: {insp.created_at}")
            
        # User Mine Assignments
        assignments = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == lm.id).all()
        print(f"  User Assignments count: {len(assignments)}")
        for ass in assignments:
            prof = db.query(Profile).filter(Profile.id == ass.profile_id).first()
            role = prof.role if prof else "Unknown"
            email = prof.email if prof else "Unknown"
            print(f"    - User ID: {ass.profile_id}, Email: {email}, Role: {role}, Assigned At: {ass.created_at}")

finally:
    db.close()
