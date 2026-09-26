import httpx
import json

def test_conflict():
    url = "http://127.0.0.1:8000/api/inspections/srv_3e940770"
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
        response = httpx.put(url, headers=headers, json=payload, timeout=10)
        print(f"Status Code: {response.status_code}")
        print("Response Body:")
        try:
            print(json.dumps(response.json(), indent=2))
        except:
            print(response.text)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_conflict()
