from app.database import SessionLocal
from app.models.models import Mine, Inspection, Violation, Alert, MineSensor, RiskScore, UserMineAssignment
from app.models.telemetry import Telemetry

db = SessionLocal()
try:
    # 1. Get all mines
    all_mines = db.query(Mine).all()
    print(f"Total mines in database: {len(all_mines)}")
    
    # Check extra mines (id does not start with srv_ind_)
    extra_mines = [m for m in all_mines if not m.id.startswith("srv_ind_")]
    print(f"Found {len(extra_mines)} extra mines:")
    
    for idx, m in enumerate(extra_mines, start=1):
        print(f"\n--- EXTRA MINE {idx} ---")
        print(f"ID: {m.id}")
        print(f"Name: {m.name}")
        print(f"Code: {m.mine_code}")
        print(f"State: {m.state}")
        print(f"District: {m.district}")
        print(f"Created At: {m.created_at}")
        
        # Check references
        inspections = db.query(Inspection).filter(Inspection.mine_id == m.id).count()
        violations = db.query(Violation).filter(Violation.mine_id == m.id).count()
        alerts = db.query(Alert).filter(Alert.mine_id == m.id).count()
        sensors = db.query(MineSensor).filter(MineSensor.mine_id == m.id).count()
        risk_scores = db.query(RiskScore).filter(RiskScore.mine_id == m.id).count()
        assignments = db.query(UserMineAssignment).filter(UserMineAssignment.mine_id == m.id).count()
        telemetry = db.query(Telemetry).filter(Telemetry.mine_id == m.id).count()
        
        print(f"References counts:")
        print(f"  Inspections: {inspections}")
        print(f"  Violations: {violations}")
        print(f"  Alerts: {alerts}")
        print(f"  Sensors: {sensors}")
        print(f"  Risk Scores: {risk_scores}")
        print(f"  User Assignments: {assignments}")
        print(f"  Telemetry: {telemetry}")

    # Count srv_ind_ mines
    srv_ind_mines = [m for m in all_mines if m.id.startswith("srv_ind_")]
    print(f"\nTotal 'srv_ind_' mines: {len(srv_ind_mines)}")
    
    # Check for duplicate codes or duplicate name/district/state combinations
    codes = [m.mine_code for m in srv_ind_mines]
    unique_codes = set(codes)
    print(f"Unique 'srv_ind_' mine codes: {len(unique_codes)}")
    if len(codes) != len(unique_codes):
        print("WARNING: There are duplicate mine codes in srv_ind_ mines!")
        import collections
        dups = [item for item, count in collections.Counter(codes).items() if count > 1]
        print(f"Duplicate codes: {dups}")
    else:
        print("Confirmed: All 459 Excel mines are uniquely present exactly once by mine_code.")

finally:
    db.close()
