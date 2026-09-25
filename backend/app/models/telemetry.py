from sqlalchemy import Column, String, DateTime, Float, ForeignKey, JSON
from ..database import Base
import uuid

class Telemetry(Base):
    __tablename__ = "telemetry"
    
    id = Column(String, primary_key=True, index=True, default=lambda: "tel_" + str(uuid.uuid4())[:8])
    mine_id = Column(String, ForeignKey("mines.id"), nullable=False)
    device_id = Column(String, nullable=False)
    timestamp = Column(DateTime, nullable=False)
    readings = Column(JSON, nullable=False)
