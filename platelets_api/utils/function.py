import os
import requests
import json
import re
from math import radians, cos, sin, asin, sqrt

from . import DeadlineType, DistanceDeadlineType, TimeDeadlineType
from .models import Coordinate


def check_priority(deadline_type):
    return deadline_type in (
        DeadlineType.MAXIMUM,
        DeadlineType.PRIORITY,
        DeadlineType.HIGH,
        DeadlineType.MEDIUM,
        DeadlineType.LOW,
    )


# Haversine formula
def haversine_function(origin: Coordinate, destiny: Coordinate):
    lats = (radians(origin.lat), radians(destiny.lat))
    delta_lat = radians(destiny.lat - origin.lat)
    delta_lng = radians(destiny.lng - origin.lng)
    r = 6371  # Earth radius in km
    a = sin(delta_lat / 2) ** 2 + cos(lats[0]) * cos(lats[1]) * sin(delta_lng / 2) ** 2
    c = 2 * asin(sqrt(a))
    return r * c


def check_distance(origin: Coordinate, destiny: Coordinate, deadline_type):
    type = deadline_type - 1
    distance = haversine_function(origin, destiny)
    if type == 0:
        return distance
    if DistanceDeadlineType.CHOICES[type] >= distance:
        return distance
    return None


def calculate_time(origin: Coordinate, destiny: Coordinate):
    API_GOOGLE = os.getenv("API_GOOGLE")
    url = f"https://maps.googleapis.com/maps/api/distancematrix/json?origins={origin.lat},{origin.lng}&destinations={destiny.lat},{destiny.lng}&key={API_GOOGLE}"
    payload = {}
    headers = {}
    response = requests.request("GET", url, headers=headers, data=payload)
    dictionary_response = json.loads(response.text)
    status = dictionary_response.get("rows")[0].get("elements")[0].get("status")
    time = None
    if status == "OK":
        time = (
            dictionary_response.get("rows")[0]
            .get("elements")[0]
            .get("duration")
            .get("text")
        )
        if "day" not in time:
            time = "0 day " + time
        if "hour" not in time:
            time = "0 hour " + time
        if "min" not in time:
            time += " 0 min"
        time = re.sub("[a-z]", "", time)
        time = time.split(" ")
        while True:
            if "" not in time:
                break
            time.remove("")
        min = 0
        pos = 0
        time.reverse()
        for i in time:
            if pos == 1:
                min += int(i) * 60
            elif pos == 2:
                min += int(i) * 60 * 24
            else:
                min += int(i)
            pos += 1
        time = min
    return time


def check_time(origin: Coordinate, destiny: Coordinate, deadline_type):
    type = deadline_type - 1
    time = calculate_time(origin, destiny)
    if time and type != 0:
        if TimeDeadlineType.CHOICES[type] <= time:
            return None
    return time
