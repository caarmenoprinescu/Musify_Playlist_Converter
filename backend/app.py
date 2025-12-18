# app.py
from flask import Flask, request, redirect, jsonify
import requests
import os
from dotenv import load_dotenv
import base64
# from apple_music import (
#     generate_developer_token,
#     search_song_in_catalog,
#     create_playlist,
#     add_tracks_to_playlist,
# )
load_dotenv()

app = Flask(__name__)

CLIENT_ID = os.getenv("SPOTIFY_CLIENT_ID")
CLIENT_SECRET = os.getenv("SPOTIFY_CLIENT_SECRET")
REDIRECT_URI = os.getenv("SPOTIFY_REDIRECT_URI")
#generate_developer_token()
@app.route("/login")
def login():
    scope = "playlist-read-private playlist-modify-private user-read-email user-read-private"

    auth_url = (
        "https://accounts.spotify.com/authorize"
        f"?client_id={CLIENT_ID}"
        "&response_type=code"
        f"&redirect_uri={REDIRECT_URI}"
        f"&scope={scope}"
    )

    return redirect(auth_url)


@app.route("/callback")
def callback():
    code = request.args.get("code")
    if not code:
        return "Error: No code provided", 400

    token_url = "https://accounts.spotify.com/api/token"
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    data = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": REDIRECT_URI,
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET
    }

    response = requests.post(token_url, headers=headers, data=data)
    if response.status_code != 200:
        return jsonify({"error": response.text}), 400

    token_data = response.json()
    access_token = token_data.get("access_token")
    refresh_token = token_data.get("refresh_token")

    if not access_token or not refresh_token:
        return jsonify({"error": "Missing tokens"}), 400

    # Redirect back to Flutter via custom scheme
    return redirect(
        f"musify://callback?access_token={access_token}&refresh_token={refresh_token}"
    )


@app.route("/spotify/refresh", methods=["POST"])
def refresh_token():
    refresh_token = request.json.get("refresh_token")
    if not refresh_token:
        return jsonify({"error": "Missing refresh_token"}), 400

    token_url = "https://accounts.spotify.com/api/token"
    auth_header = base64.b64encode(f"{CLIENT_ID}:{CLIENT_SECRET}".encode()).decode()
    headers = {"Authorization": f"Basic {auth_header}"}
    data = {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token
    }

    response = requests.post(token_url, headers=headers, data=data)
    return jsonify(response.json())


@app.route("/spotify/me")
def spotify_me():
    auth_header = request.headers.get("Authorization")
    if not auth_header:
        return jsonify({"error": "Missing Authorization"}), 400

    token = auth_header.split(" ")[1]
    url = "https://api.spotify.com/v1/me"

    r = requests.get(url, headers={"Authorization": f"Bearer {token}"})

    return jsonify(r.json())


@app.route("/spotify/me/playlists")
def spotify_me_playlists():
  auth_header = request.headers.get("Authorization")
  if not auth_header:
    return jsonify({"error": "Missing Authorization"}), 400

  token = auth_header.split(" ")[1]
  url = "https://api.spotify.com/v1/me/playlists"

  r = requests.get(url, headers={"Authorization": f"Bearer {token}"})

  return jsonify(r.json())


@app.route("/spotify/playlists/<playlist_id>")
def spotify_each_playlist(playlist_id):
  auth_header = request.headers.get("Authorization")
  if not auth_header:
    return jsonify({"error": "Missing Authorization"}), 400

  token = auth_header.split(" ")[1]
  url = f"https://api.spotify.com/v1/playlists/{playlist_id}"

  r = requests.get(url, headers={"Authorization": f"Bearer {token}"})

  return jsonify(r.json())



# next - apple music logic


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)


