from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

headers = {
    "Authorization": "Bearer demo-inspector-id-333",
    "Content-Type": "application/json"
}
payload = {
    "mine_id": "651e6ee2-bee1-43f8-8fe9-6b6dd01c526c",
    "inspector_id": "demo-inspector-id-333",
    "category": "safety",
    "local_id": "loc_insp_12345",
    "status": "findingsGenerated",
    "local_version": 1,
    "operation_id": "op_conflict_trigger_test"
}

try:
    response = client.put("/api/inspections/srv_3e940770", headers=headers, json=payload)
    print(f"Status Code: {response.status_code}")
    print("Response:")
    print(response.text)
except Exception as e:
    import traceback
    traceback.print_exc()
