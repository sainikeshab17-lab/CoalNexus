import sys
import os
from fastapi.testclient import TestClient

# Add the current directory to sys.path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from app.main import app

client = TestClient(app)

def verify_public_mines():
    # Public endpoint does not require auth
    response = client.get("/api/public/mines?limit=500")
    if response.status_code == 200:
        mines = response.json()
        print(f"Public Mines Count: {len(mines)}")
        test_mines = [m for m in mines if 'test' in m['name'].lower() or m['mine_code'] == 'M204']
        if test_mines:
            print(f"WARNING: Found {len(test_mines)} test mines in public endpoint!")
            for m in test_mines:
                print(f" - {m['name']} ({m['mine_code']})")
        else:
            print("Verified: No test mines in public endpoint.")
    else:
        print(f"Error: {response.status_code}")
        print(response.text)

if __name__ == "__main__":
    verify_public_mines()
