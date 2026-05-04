from typing import Optional
from pydantic import BaseModel as SchemaBaseModel


class CoursesSchema(SchemaBaseModel):
    id: Optional[int]
    titulo: str
    aulas: int
    horas: int
    
    class Config():
        orm_mode = True
        