from app.database import SessionLocal
from app.models.models import Mine

db = SessionLocal()
try:
    mines = db.query(Mine).all()
    print("--- MINES DETAILS ---")
    for m in mines:
        print(f"ID: {m.id}, Name: {m.name}, Code: {m.mine_code}, Lat: {m.latitude}, Lon: {m.longitude}, Local ID: {m.local_id}, Local Version: {m.local_version}, Created: {m.created_at}")
finally:
    db.close()
