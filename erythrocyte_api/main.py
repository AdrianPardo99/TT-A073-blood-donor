import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

from utils.models import Petition, UnitBlood
from utils.function import knapsack

app = FastAPI(title=os.environ.get("APP_NAME"), version=os.environ.get("VERSION"))
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
        "title": os.environ.get("APP_NAME"),
        "description": "This API is working for solve Knapsack Problem with blood units",
        "version": os.environ.get("VERSION"),
    }
    return about


@app.post("/", response_model=list[UnitBlood])
def get_solution(petition: Petition):
    units = knapsack(
        petition.max_weight, petition.units, int(os.environ.get("MAX_ITERATION"))
    )
    return units
