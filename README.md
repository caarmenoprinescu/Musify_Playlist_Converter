# Musify – Playlist Converter


Cross-platform mobile application that enables seamless playlist conversion between Spotify and Apple Music.

## Current Status
✔ Spotify → Apple Music conversion fully functional  
🔄 Apple Music → Spotify conversion in final development stage  

The application implements secure authentication flows, real-time API communication, and cross-platform playlist mapping logic.

---

## Features

- Spotify PKCE authentication flow
- Apple Music MusicKit integration
- Secure token management backend (Flask + JWT)
- Cross-platform playlist conversion logic
- API rate limit handling
- Native iOS integration (Swift) for subscription validation and token handling
- Modern Flutter-based UI

---

## Tech Stack

### Frontend
- Flutter

### Backend
- Python (Flask)
- JWT Authentication

### APIs
- Spotify Web API
- Apple Music API (MusicKit)

### Additional
- Swift (iOS native integration)

---

## Project Structure

frontend/ – Flutter mobile application  
backend/ – Flask backend handling authentication and API logic  

---

## Screenshots

### Welcome Screen
![Welcome Screen](images2/screenshots/welcome.PNG)

### About Page
![About Page](images2/screenshots/about.PNG)

### Conversion Path Options
![Path Options](images2/screenshots/path_options.PNG)

### Required Permission & Authentication
![Security](images2/screenshots/security.PNG)

### Playlist Selection From User's Library
![Playlist Selection](images2/screenshots/playlists_selection.PNG)

### Converting Process
![Converting Process](images2/screenshots/converting_process.PNG)

### Conversion Completed
![Conversion Done](images2/screenshots/done.PNG)

