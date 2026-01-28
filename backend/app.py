# app.py
from flask import Flask, request, redirect, jsonify
import requests
import os
from dotenv import load_dotenv
import base64
from apple_music import (

  generate_token_apple, search_apple_song, create_apple_playlist, add_tracks_to_apple_playlist,
)
load_dotenv()

app = Flask(__name__)
CLIENT_ID = os.getenv("SPOTIFY_CLIENT_ID")
CLIENT_SECRET = os.getenv("SPOTIFY_CLIENT_SECRET")
REDIRECT_URI = os.getenv("SPOTIFY_REDIRECT_URI")


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
  return jsonify(r.json()), r.status_code



@app.route("/apple/developer-token")
def apple_developer_token():
    token = generate_token_apple()
    return jsonify({"developerToken": token})


@app.route("/apple/search", methods=["GET"])
def search_songs():
  response, status = search_apple_song()
  return jsonify(response), status

@app.route("/apple/create-playlist", methods=["POST"])
def create_playlist():
    data, status = create_apple_playlist()
    return jsonify(data), status

@app.route("/apple/add-tracks", methods=["POST"])
def add_tracks_to_playlist():
    data, status = add_tracks_to_apple_playlist()
    return jsonify(data), status

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)


