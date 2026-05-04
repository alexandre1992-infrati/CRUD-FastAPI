from typing import List, ClassVar
from pydantic_settings import BaseSettings
from sqlalchemy.ext.declarative import declarative_base


class Settings(BaseSettings):
    #Configurações gerais da aplicação
    API_V1_STR: str = '/api/v1'
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/faculdade"
    DBBaseModel: ClassVar = declarative_base()
    BASE_MODEL: ClassVar = DBBaseModel

    class Config:
        case_sensitive = True


settings = Settings()        

