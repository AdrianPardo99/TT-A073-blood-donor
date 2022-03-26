# Coordinate model
# This file include the model for check the time and distance between blood banks

from pydantic import BaseModel


class Coordinate(BaseModel):
    name: str
    lat: float
    lng: float


class Petition(BaseModel):
    deadline_type: int
    origin: Coordinate
    destiny: Coordinate
