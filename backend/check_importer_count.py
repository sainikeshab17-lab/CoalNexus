from app.database import SessionLocal
from app.models.models import Mine

db = SessionLocal()
try:
    all_mines = db.query(Mine).all()
    srv_ind_mines = [m for m in all_mines if m.id.startswith("srv_ind_")]
    print(f"Number of srv_ind_ mines before any action: {len(srv_ind_mines)}")
finally:
    db.close()
