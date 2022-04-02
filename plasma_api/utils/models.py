from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class UnitBlood(BaseModel):
    id: int
    blood_type: str
    compatible: Optional[bool]


class Petition(BaseModel):
    receptor_type: str
    units: list[UnitBlood]
