from app.database import SessionLocal
from app.models.models import Mine, Inspection, Violation, Alert

db = SessionLocal()
try:
    mines = db.query(Mine).all()
    print(f"Total mines: {len(mines)}")
    for m in mines:
        is_demo = m.mine_code in ["WCL_UMRER", "WCL_MAJRI", "WCL_BALLARPUR"]
        
        inspections = db.query(Inspection).filter(Inspection.mine_id == m.id).count()
        violations = db.query(Violation).filter(Violation.mine_id == m.id).count()
        alerts = db.query(Alert).filter(Alert.mine_id == m.id).count()
        
        if is_demo or inspections > 0 or violations > 0 or alerts > 0:
            print(f"Mine: {m.name} ({m.mine_code})")
            print(f"  ID: {m.id}")
            print(f"  Status: {m.status}")
            print(f"  Is Demo Code: {is_demo}")
            print(f"  Inspections: {inspections}")
            print(f"  Violations: {violations}")
            print(f"  Alerts: {alerts}")
            print("-" * 20)
finally:
    db.close()
