from app.database import SessionLocal
from app.models.models import Mine

db = SessionLocal()
try:
    total_mines = db.query(Mine).count()
    active_mines = db.query(Mine).filter(Mine.status != "inactive").count()
    inactive_mines = db.query(Mine).filter(Mine.status == "inactive").count()
    
    print(f"Total rows in Mine table: {total_mines}")
    print(f"Active mines count: {active_mines}")
    print(f"Inactive mines count: {inactive_mines}")
finally:
    db.close()
