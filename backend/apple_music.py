# apple_music.py
import os
import time
from flask import Flask, request, redirect, jsonify
import  jwt
import requests
from dotenv import load_dotenv
from flask import jsonify

load_dotenv()


APPLE_TEAM_ID = os.getenv("APPLE_TEAM_ID")
APPLE_KEY_ID = os.getenv("APPLE_KEY_ID")


PRIVATE_KEY_PATH = "AuthKey_FPHR7M24PZ.p8"

with open(PRIVATE_KEY_PATH, "r") as f:
    PRIVATE_KEY = f.read()

def generate_token_apple():
    headers = {
        "alg": "ES256",
        "kid": APPLE_KEY_ID
    }

    payload = {
        "iss": APPLE_TEAM_ID,
        "iat": int(time.time()),
        "exp": int(time.time()) + 15777000  # max ~6 luni
    }

    token = jwt.encode(
        payload,
        PRIVATE_KEY,
        algorithm="ES256",
        headers=headers
    )

    return token



def search_apple_song():

  terms = request.args.getlist("terms")

  developer_token = request.headers.get("Authorization")
  if not developer_token:
    return jsonify({"error": "Missing Authorization header"}), 401

  headers = {
    "Authorization": developer_token,
  }

  for current_song_terms in terms:
    url = (
      "https://api.music.apple.com/v1/catalog/ro/search"
      "?types=songs"
      f"&term={current_song_terms}"
      "&limit=1"
    )

    r = requests.get(url, headers=headers)
    data = r.json()

    songs = (
      data.get("results", {})
      .get("songs", {})
      .get("data", [])
    )

    if songs:
      song = songs[0]
      return {
        "found": True,
        "used_term": current_song_terms,
        "apple_song_id": song.get("id"),
        "attributes": song.get("attributes", {}),
      },200

  return {
    "found": False
  },200


def get_song_by_id():
  id = request.args.getlist("id")
  developer_token = request.headers.get("Authorization")
  if not developer_token:
    return jsonify({"error": "Missing Authorization header"}), 401

  headers = {
    "Authorization": developer_token,
  }

  url=(
    f"https://api.music.apple.com/v1/catalog/ro/songs/{id}"

  )

  r = requests.get(url, headers=headers)
  data = r.json()


def create_apple_playlist():
  playlist_data = request.get_json()
  developer_token = request.headers.get("Authorization")
  user_token = request.headers.get("Music-User-Token")

  if not developer_token or not user_token:
    return {"error": "Missing Apple Music tokens"}, 401

  headers = {
    "Authorization": developer_token,
    "Music-User-Token": user_token,
    "Content-Type": "application/json",
  }

  url="https://api.music.apple.com/v1/me/library/playlists"

  body = {
    "attributes": {
      "name": playlist_data.get("name"),
      "description": playlist_data.get("description"),
      "isPublic": playlist_data.get("public", False),
    }
  }
  r = requests.post(url, headers=headers, json=body)

  if r.status_code not in (200, 201):
    return {
      "error": "Failed to create Apple playlist",
      "details": r.json(),
    }, r.status_code

  return r.json(), 201

def add_tracks_to_apple_playlist():
  payload = request.get_json() or {}
  developer_token = request.headers.get("Authorization")
  user_token = request.headers.get("Music-User-Token")
  playlist_id = payload.get("playlist_id")
  song_ids = payload.get("song_ids")  # list
  single_song_id = payload.get("song_id")  # optional


  if not developer_token or not user_token:
      return {"error": "Missing Apple Music tokens"}, 401

  if not playlist_id:
    return {"error": "Missing playlist_id"}, 400

  if song_ids is None:
    if not single_song_id:
      return {"error": "Missing song_id or song_ids"}, 400
    song_ids = [single_song_id]

  headers = {
    "Authorization": developer_token,
    "Music-User-Token": user_token,
    "Content-Type": "application/json",
  }

  url = f"https://api.music.apple.com/v1/me/library/playlists/{playlist_id}/tracks"

  body = {
    "data": [{
      "id":str(sid),
      "type": "song",

    }for sid in song_ids]
  }
  r = requests.post(url, headers=headers, json=body)

  if r.status_code not in (200, 201, 202, 204):

    try:
      details = r.json()
    except Exception:
      details = {"raw": r.text}
    return {
      "error": "Failed to add songs to Apple playlist",
      "status_code": r.status_code,
      "details": details,
    }, r.status_code


  try:
    return r.json(), 201
  except Exception:
    return {"ok": True}, 201
