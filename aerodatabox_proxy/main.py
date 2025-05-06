from fastapi import FastAPI, Query
from fastapi.middleware.cors import CORSMiddleware
import requests
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For dev; restrict in prod!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = os.getenv("AERODATABOX_API_KEY", 7cd24ea427msh7ec30eb49e4bafcp1fcbe0jsn43298646c50d)
API_HOST = "aerodatabox.p.rapidapi.com"

@app.get("/recent-arrivals")
def recent_arrivals(icao: str):
    url = f"https://{API_HOST}/airports/icao/{icao}/flights/arrived"
    headers = {
        "X-RapidAPI-Key": API_KEY,
        "X-RapidAPI-Host": API_HOST
    }
    response = requests.get(url, headers=headers)
    return response.json()