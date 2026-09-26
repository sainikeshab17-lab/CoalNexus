from pydantic_settings import BaseSettings
from typing import Optional
import os
from dotenv import load_dotenv

load_dotenv()

class Settings(BaseSettings):
    PROJECT_NAME: str = "CoalNexus API"
    API_V1_STR: str = "/api"
    
    # CORS
    ALLOWED_ORIGINS: str = os.getenv("ALLOWED_ORIGINS", "")
    
    # Database
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./coalnexus.db")
    
    # Supabase
    SUPABASE_URL: Optional[str] = os.getenv("SUPABASE_URL")
    SUPABASE_PUBLISHABLE_KEY: Optional[str] = os.getenv("SUPABASE_PUBLISHABLE_KEY")
    SUPABASE_SECRET_KEY: Optional[str] = os.getenv("SUPABASE_SECRET_KEY")
    
    # Authentication
    SECRET_KEY: str = os.getenv("SECRET_KEY", "DEVELOPMENT_SECRET_DO_NOT_USE_IN_PROD")
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "development")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8
    
    class Config:
        case_sensitive = True

settings = Settings()
