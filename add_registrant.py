import os
import sys
import requests
import jwt
import datetime
from dotenv import load_dotenv
from time import time
# load API key and secret from .bashrc
load_dotenv()

API_KEY = os.getenv("Zoom_KEY")
API_SEC = os.getenv("Zoom_SECRET")

# get the arguments from the command line
meeting_id = sys.argv[1]
email = sys.argv[2]
first_name = sys.argv[3]
last_name = sys.argv[4]

# encode the api key and secret
header = {"alg": "HS256", "typ": "JWT"}
payload = {
    "iss": API_KEY,
    "exp": time() + 5000
}
token = jwt.encode(payload, API_SEC, algorithm="HS256", headers=header)

# url for adding a registrant to a meeting
url = f"https://api.zoom.us/v2/meetings/{meeting_id}/registrants"

# headers
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

# data for the post request
data = {
    "email": email,
    "first_name": first_name,
    "last_name": last_name
}

# make the post request
response = requests.post(url, headers=headers, json=data)

# print the response
print(response.json())
