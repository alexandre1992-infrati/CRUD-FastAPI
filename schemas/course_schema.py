from typing import Optional
from pydantic import BaseModel as SchemaBaseModel


class CoursesSchema(SchemaBaseModel):
    id: Optional[int] = None
    titulo: str
    aulas: int
    horas: int

    model_config = {
        "from_attributes": True
    }
        