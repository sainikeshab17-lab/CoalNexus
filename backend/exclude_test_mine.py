import sys
import os

# Add the current directory to sys.path so 'app' can be imported
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from app.database import SessionLocal
from app.models.models import Mine

def exclude_test_mine():
    db = SessionLocal()
    try:
        # Looking for 'Test Mine' or code 'M204'
        test_mine = db.query(Mine).filter((Mine.name == 'Test Mine') | (Mine.mine_code == 'M204')).first()
        if test_mine:
            print(f"Found test mine: {test_mine.name} ({test_mine.mine_code}). Current Status: {test_mine.status}")
            test_mine.status = 'test'
            db.commit()
            print("Test mine status updated to 'test'.")
        else:
            print("Test mine not found.")
            
        # Verify active count
        active_count = db.query(Mine).filter(Mine.status == 'active').count()
        print(f"Active mine count in database: {active_count}")
        
        total_count = db.query(Mine).count()
        print(f"Total mine count in database: {total_count}")
        
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    exclude_test_mine()
