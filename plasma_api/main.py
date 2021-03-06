import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

from utils.models import Petition
from utils.function import iterate_every_unit

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
        "description": "This API is working for assign the compatibility between donor and receptor",
        "version": os.environ.get("VERSION"),
    }
    return about


@app.post("/")
def assing_compatibility(petition: Petition):
    iterate_every_unit(petition.receptor_type, petition.units, petition.max_weight)
    return petition
