from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class UnitBlood(BaseModel):
    id: int
    weight: int
    profit: int


class Petition(BaseModel):
    max_weight: int
    units: list[UnitBlood]
