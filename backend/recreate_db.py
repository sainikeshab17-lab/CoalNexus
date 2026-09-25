import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.database import engine, Base
# Import all models to ensure they are registered with Base.metadata
from app.models import models
from app.models import telemetry
from sqlalchemy import text

def recreate():
    print("Connecting to database...")
    with engine.connect() as conn:
        print("Dropping all tables...")
        conn.execute(text("PRAGMA foreign_keys = OFF;"))
        # Get all tables
        result = conn.execute(text("SELECT name FROM sqlite_master WHERE type='table';"))
        tables = [row[0] for row in result if row[0] not in ('sqlite_sequence',)]
        for table in tables:
            print(f"Dropping {table}...")
            conn.execute(text(f"DROP TABLE IF EXISTS \"{table}\""))
        conn.commit()
    
    print("Creating all tables from scratch...")
    Base.metadata.create_all(bind=engine)
    print("Database schema successfully recreated.")
    
    # Verify tables
    with engine.connect() as conn:
        result = conn.execute(text("SELECT name FROM sqlite_master WHERE type='table';"))
        tables = [row[0] for row in result]
        print(f"Current tables: {tables}")

if __name__ == "__main__":
    recreate()
