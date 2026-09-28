from app.database import SessionLocal
from app.models.models import Mine

db = SessionLocal()
mines = db.query(Mine).all()
print(f"Total mines in DB: {len(mines)}")
test_mines = [m for m in mines if 'test' in m.name.lower() or 'test' in m.mine_code.lower() or m.mine_code == 'M204']
for m in test_mines:
    print(f"ID: {m.id}, LocalID: {m.local_id}, Name: {m.name}, Code: {m.mine_code}, Status: {m.status}")
db.close()
