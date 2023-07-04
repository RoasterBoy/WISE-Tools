import requests
import argparse
import os
import json

def add_meeting_registrant(meeting_id, email, first_name, last_name, access_token):
    url = f"https://api.zoom.us/v2/meetings/{meeting_id}/registrants"

    headers = {
        'content-type': 'application/json',
        'Authorization': f'Bearer {access_token}',
    }

    data = {
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
    }

    response = requests.post(url, headers=headers, data=json.dumps(data))

    if response.status_code == 201:
        print(f"Successfully added {first_name} {last_name} to the meeting.")
    else:
        print(f"Failed to add registrant to the meeting. Response: {response.text}")

def main():
    parser = argparse.ArgumentParser(description='Add a meeting registrant.')
    parser.add_argument('meeting_id', type=str, help='Zoom Meeting ID')
    parser.add_argument('email', type=str, help='Email address')
    parser.add_argument('first_name', type=str, help='First Name')
    parser.add_argument('last_name', type=str, help='Last Name')
    
    args = parser.parse_args()

    access_token = os.getenv('ZOOM_ACCESS_TOKEN')

    if access_token is None:
        print("ZOOM_ACCESS_TOKEN must be set.")
        exit(1)

    add_meeting_registrant(args.meeting_id, args.email, args.first_name, args.last_name, access_token)

if __name__ == "__main__":
    main()
