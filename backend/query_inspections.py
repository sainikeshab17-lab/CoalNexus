from app.database import SessionLocal
from app.models.models import Inspection

db = SessionLocal()
try:
    inspections = db.query(Inspection).all()
    print("--- INSPECTIONS ---")
    for i in inspections:
        print(f"ID: {i.id}, Mine ID: {i.mine_id}, Inspector ID: {i.inspector_id}, Status: {i.status}, Local ID: {i.local_id}")
finally:
    db.close()
