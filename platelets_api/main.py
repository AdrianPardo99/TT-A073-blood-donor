import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

from utils.models import Petition
from utils.function import check_priority, check_distance, check_time

app = FastAPI(title="Platelets", version="0.1.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)


@app.get("/")
def information_about():
    about = {
        "title": "Platelets",
        "description": "This API is working for measure the distance between two blood banks or blood centers",
        "version": "0.1.0",
    }
    return about


@app.post("/")
def measure_distance(petition: Petition):
    if not check_priority(petition.deadline_type):
        return {
            "error": "Please fill the field deadline_type has no valid value for work"
        }
    # Check distance
    distance = check_distance(petition.origin, petition.destiny, petition.deadline_type)
    time = check_time(petition.origin, petition.destiny, petition.deadline_type)
    msg = ""
    if not distance:
        msg = "The distance between the two centers are too large for complete the deadline."
    if not time:
        if "." in msg:
            msg = msg.replace(
                " for complete the deadline.",
                " and the time between the two centers are too long for complete the deadline.",
            )
        else:
            msg = "The time between the two centers are too long for complete the deadline."
    response = {
        "distance": distance,
        "time": time,
        "message": msg,
    }
    return response
