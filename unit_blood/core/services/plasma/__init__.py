import requests
import json

from django.conf import settings


class Client:
    def __init__(self):
        self.plasma_api = settings.PLASMA_API

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

    def check_information(self, receptor_type, max_weight, units):
        payload = {
            "receptor_type": receptor_type,
            "max_weight": max_weight,
            "units": units.data,
        }
        _headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
        }

        url = f"{self.plasma_api}"
        r = requests.post(url, headers=_headers, data=json.dumps(payload))
        response = self.validate_response(r)
        if "units" in response.keys():
            return response.get("units")
        return []


class TransactionError(Exception):
    def __init__(self, response):
        super(TransactionError, self).__init__(response.status_code, response.reason)
