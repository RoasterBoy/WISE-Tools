import jwt
import requests
from time import time

API_KEY="IVMrYpbJRo6J_3IM1vxeLg"
API_SECRET="UCoTaqBGMERLF9xQM4it1SC5DW6ptpYPlewt"

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
    )

    return token

print(generateToken()
       )
