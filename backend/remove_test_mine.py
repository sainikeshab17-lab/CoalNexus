import sys
import os

# Add the current directory to sys.path so 'app' can be imported
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from app.database import SessionLocal
from app.models.models import Mine

def remove_test_mine():
    db = SessionLocal()
    try:
        # Looking for 'Test Mine' or code 'M204'
        test_mine = db.query(Mine).filter((Mine.name == 'Test Mine') | (Mine.mine_code == 'M204')).first()
        if test_mine:
            print(f"Found test mine: {test_mine.name} ({test_mine.mine_code}). ID: {test_mine.id}")
            db.delete(test_mine)
            db.commit()
            print("Test mine deleted successfully.")
        else:
            print("Test mine not found.")
            
        final_count = db.query(Mine).count()
        print(f"Final mine count in database: {final_count}")
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    remove_test_mine()
