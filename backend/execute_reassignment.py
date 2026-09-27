from app.database import SessionLocal
from app.models.models import Mine, Inspection, UserMineAssignment, Violation, Alert, MineSensor, RiskScore
from app.models.telemetry import Telemetry
import sys

db = SessionLocal()
try:
    print("Starting transactional legacy mine reassignment and cleanup...")
    
    # Target Legacy Mine IDs
    umrer_legacy_id = "651e6ee2-bee1-43f8-8fe9-6b6dd01c526c"
    majri_legacy_id = "db7bc236-3abc-40d2-bc6b-6cb6aa9d74be"
    ballarpur_legacy_id = "d57ea097-4a06-47af-b41a-ac2b0bf54ad3"
    
    # Target Authentic Master Mine IDs
    umrer_authentic_id = "srv_ind_239"
    majri_authentic_id = "srv_ind_210"
    ballarpur_authentic_id = "srv_ind_199"
    
    # Verify the authentic mines exist
    for aid in [umrer_authentic_id, majri_authentic_id, ballarpur_authentic_id]:
        m = db.query(Mine).filter(Mine.id == aid).first()
        if not m:
            print(f"ERROR: Authentic mine {aid} not found in database!")
            sys.exit(1)
            
    # Step 1: Reassign WCL Umrer (651e6ee2...) -> srv_ind_239
    print("\n--- Processing WCL Umrer Reassignment ---")
    inspections_umrer = db.query(Inspection).filter(Inspection.mine_id == umrer_legacy_id).all()
    for ins in inspections_umrer:
        print(f"Reassigning Inspection ID: {ins.id} from {umrer_legacy_id} to {umrer_authentic_id}")
        ins.mine_id = umrer_authentic_id
        
    assignments_umrer = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == umrer_legacy_id).all()
    for ass in assignments_umrer:
        exists = db.query(UserMineAssignment).filter(
            UserMineAssignment.profile_id == ass.profile_id,
            UserMineAssignment.mine_id == umrer_authentic_id
        ).first()
        if exists:
            print(f"Assignment for user {ass.profile_id} to {umrer_authentic_id} already exists. Removing legacy assignment row.")
            db.delete(ass)
        else:
            print(f"Reassigning User Assignment for {ass.profile_id} to {umrer_authentic_id}")
            new_ass = UserMineAssignment(profile_id=ass.profile_id, mine_id=umrer_authentic_id, created_at=ass.created_at)
            db.delete(ass)
            db.add(new_ass)

    # Step 2: Reassign WCL Majri (db7bc236...) -> srv_ind_210
    print("\n--- Processing WCL Majri Reassignment ---")
    assignments_majri = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == majri_legacy_id).all()
    for ass in assignments_majri:
        exists = db.query(UserMineAssignment).filter(
            UserMineAssignment.profile_id == ass.profile_id,
            UserMineAssignment.mine_id == majri_authentic_id
        ).first()
        if exists:
            print(f"Assignment for user {ass.profile_id} to {majri_authentic_id} already exists. Removing legacy assignment row.")
            db.delete(ass)
        else:
            print(f"Reassigning User Assignment for {ass.profile_id} to {majri_authentic_id}")
            new_ass = UserMineAssignment(profile_id=ass.profile_id, mine_id=majri_authentic_id, created_at=ass.created_at)
            db.delete(ass)
            db.add(new_ass)

    # Step 3: Reassign WCL Ballarpur (d57ea097...) -> srv_ind_199
    print("\n--- Processing WCL Ballarpur Reassignment ---")
    assignments_ballarpur = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == ballarpur_legacy_id).all()
    for ass in assignments_ballarpur:
        exists = db.query(UserMineAssignment).filter(
            UserMineAssignment.profile_id == ass.profile_id,
            UserMineAssignment.mine_id == ballarpur_authentic_id
        ).first()
        if exists:
            print(f"Assignment for user {ass.profile_id} to {ballarpur_authentic_id} already exists. Removing legacy assignment row.")
            db.delete(ass)
        else:
            print(f"Reassigning User Assignment for {ass.profile_id} to {ballarpur_authentic_id}")
            new_ass = UserMineAssignment(profile_id=ass.profile_id, mine_id=ballarpur_authentic_id, created_at=ass.created_at)
            db.delete(ass)
            db.add(new_ass)

    # Flush session to sync deletions and additions with database before querying counts
    db.flush()

    # Step 4: Verify there are absolutely zero references left to any of the 3 legacy mine IDs
    print("\n--- Verifying Zero Remaining Foreign-Key References ---")
    for lid in [umrer_legacy_id, majri_legacy_id, ballarpur_legacy_id]:
        c_ins = db.query(Inspection).filter(Inspection.mine_id == lid).count()
        c_viol = db.query(Violation).filter(Violation.mine_id == lid).count()
        c_alr = db.query(Alert).filter(Alert.mine_id == lid).count()
        c_sens = db.query(MineSensor).filter(MineSensor.mine_id == lid).count()
        c_risk = db.query(RiskScore).filter(RiskScore.mine_id == lid).count()
        c_ass = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == lid).count()
        c_tel = db.query(Telemetry).filter(Telemetry.mine_id == lid).count()
        
        print(f"LID {lid} counts -> ins: {c_ins}, viol: {c_viol}, alr: {c_alr}, sens: {c_sens}, risk: {c_risk}, ass: {c_ass}, tel: {c_tel}")
        
        total_refs = c_ins + c_viol + c_alr + c_sens + c_risk + c_ass + c_tel
        if total_refs > 0:
            print(f"ERROR: Legacy mine {lid} still has {total_refs} active references! Rolling back transaction.")
            db.rollback()
            sys.exit(1)
        else:
            print(f"Legacy mine {lid} has 0 remaining references.")

    # Step 5: Handle Legacy Mine records via existing schema 'status' column
    print("\n--- Deprecating Legacy Mine Records via status field ---")
    for lid in [umrer_legacy_id, majri_legacy_id, ballarpur_legacy_id]:
        m = db.query(Mine).filter(Mine.id == lid).first()
        if m:
            print(f"Setting status of {m.name} ({lid}) to 'inactive'")
            m.status = "inactive"

    db.commit()
    print("\nTransaction committed successfully! All verified foreign-key records reassigned safely.")
    
except Exception as e:
    db.rollback()
    print(f"\nFATAL EXCEPTION DURING TRANSACTION: {e}. Rolled back completely.")
    raise e
finally:
    db.close()
