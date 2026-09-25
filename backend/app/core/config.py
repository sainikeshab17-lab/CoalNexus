from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "CoalNexus API"
    API_V1_STR: str = "/api"
    
    # Database
    DATABASE_URL: str = "sqlite:///./coalnexus.db"
    
    # Authentication (Placeholder)
    SECRET_KEY: str = "SECRET_TOKEN_FOR_PROTOTYPE"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8
    
    class Config:
        case_sensitive = True

settings = Settings()
