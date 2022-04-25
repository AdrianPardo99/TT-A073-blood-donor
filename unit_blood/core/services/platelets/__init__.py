import requests
import json

from django.conf import settings


class Client:
    def __init__(self):
        self.platelets_api = settings.PLATELETS_API

    def validate_response(self, r):
        """
        This method is responsible of:
            1. Saving the token to the request.session
            2. Deleting token from the request.session if any HTTPError is raised
            3. Also mimics requests.raise_for_status()
        """
        try:
            response = r.json()
        except:
            response = {}

        # raise_for_status()
        if r.status_code not in [200, 201, 204]:
            raise TransactionError(r)

        return response

    # If the return is not empty can we do the petition because the distance and time can complited without trouble
    def check_information(self, origin, destination, deadline_type):
        payload = {
            "deadline_type": deadline_type,
            "origin": {
                "name": origin.name,
                "lat": float(origin.latitude),
                "lng": float(origin.longitude),
            },
            "destiny": {
                "name": destination.name,
                "lat": float(destination.latitude),
                "lng": float(destination.longitude),
            },
        }
        _headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
        }
        url = f"{self.platelets_api}"
        # petition = requests.post(url=self.platelets_api, json=payload)
        r = requests.post(url, headers=_headers, data=json.dumps(payload))
        response = self.validate_response(r)
        # payload_response = json.loads(petition.text)
        return response.get("distance") != None and response.get("time") != None


class TransactionError(Exception):
    def __init__(self, response):
        super(TransactionError, self).__init__(response.status_code, response.reason)
