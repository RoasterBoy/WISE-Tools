import jwt
import requests
import json
import sys
from time import time

import os
API_KEY = os.environ.get('Zoom_KEY')
API_SECRET = os.environ.get('Zoom_SECRET')
#MEETING=sys.argv[1]
# create a function to generate a token using the pyjwt library
def generateToken():
        token = jwt.encode(
                # Create a payload of the token containing API Key & expiration time
                {"iss": API_KEY, "exp": time() + 5000},
                # Secret used to generate token signature
                API_SECRET,
                # Specify the hashing alg
                algorithm='HS256'
                # Convert token to utf-8
        ).decode('utf-8')
                
        return token

print(generateToken())