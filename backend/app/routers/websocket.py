from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from typing import List
import json

router = APIRouter()

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            try:
                await connection.send_text(message)
            except Exception:
                # Handle stale connections
                pass

manager = ConnectionManager()

@router.websocket("/ws/telemetry")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # Keep connection alive and handle incoming entity updates
            message = await websocket.receive_text()
            try:
                payload = json.loads(message)
                # If it's an entity update event, broadcast it
                if payload.get("event") == "entity.updated" or "entity_type" in payload:
                    await manager.broadcast(message)
            except Exception:
                pass
    except WebSocketDisconnect:
        manager.disconnect(websocket)

# Helper for other routers/services
async def notify_telemetry_update(data: dict):
    await manager.broadcast(json.dumps({"event": "telemetry.updated", "data": data}))

async def notify_entity_update(entity_type: str, action: str, data: dict):
    payload = {
        "event": "entity.updated",
        "entity_type": entity_type,
        "action": action,
        "data": data
    }
    await manager.broadcast(json.dumps(payload))
