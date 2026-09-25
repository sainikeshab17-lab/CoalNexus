from pydantic import BaseModel
from typing import Dict, Optional
from datetime import datetime

class TelemetryReadings(BaseModel):
    methane: float
    co: float
    temperature: float
    humidity: float
    oxygen: float
    dust: float
    vibration: float

class TelemetryCreate(BaseModel):
    mine_id: str
    device_id: str
    timestamp: datetime
    readings: TelemetryReadings

class Telemetry(BaseModel):
    id: str
    mine_id: str
    device_id: str
    timestamp: datetime
    readings: TelemetryReadings
    
    class Config:
        from_attributes = True
