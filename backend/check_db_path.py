from app.core.config import settings
from app.database import engine
print("DATABASE_URL:", settings.DATABASE_URL)
print("Engine URL:", engine.url)
