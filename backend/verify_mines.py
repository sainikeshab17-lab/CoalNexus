from fastapi.testclient import TestClient
from app.main import app
import json

client = TestClient(app)

def verify():
    # Public endpoint - should NOT require auth
    print("Testing GET /api/public/mines?limit=500")
    response = client.get("/api/public/mines?limit=500")
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"Total mines returned: {len(data)}")
        if len(data) > 0:
            print(f"First mine: {data[0].get('name')} (Code: {data[0].get('mine_code')})")
    else:
        print(f"Error: {response.text}")

if __name__ == "__main__":
    verify()
