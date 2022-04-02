from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class UnitBlood(BaseModel):
    id: int
    blood_type: str
    compatible: Optional[bool]
    weight: Optional[int]
    profit: Optional[int]


class Petition(BaseModel):
    receptor_type: str
    max_weight: int
    units: list[UnitBlood]
