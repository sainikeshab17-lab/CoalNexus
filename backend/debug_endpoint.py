from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)
response = client.get("/api/mines", headers={"Authorization": "Bearer demo-admin-id-111"})
print("Status Code:", response.status_code)
print("Response text:", response.text)
