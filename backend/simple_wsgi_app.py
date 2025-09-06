"""
Ultra-simple WSGI application for Flight Compensation API (repository copy)
- Uses only Python standard libraries; no Flask dependency
- Provides canonical route /eligible_flights and a temporary alias /eu-compensation-eligible
- Normalizes records to the shape expected by the Flutter app (AviationStackService)

Deploying on PythonAnywhere:
- On the server, you can copy this file content into /var/www/piotrs_pythonanywhere_com_wsgi.py
- Or import this module from a small WSGI loader file

Data file location:
- By default uses ./data/flight_compensation_data.json relative to this file
- Override via environment variable FC_DATA_FILE
"""

import sys
import os
import json
import logging
from datetime import datetime, timedelta
import urllib.parse

# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler(sys.stdout)],
)
logger = logging.getLogger(__name__)

# -----------------------------------------------------------------------------
# Data file
# -----------------------------------------------------------------------------
DEFAULT_DATA_PATH = os.path.join(os.path.dirname(__file__), "..", "data", "flight_compensation_data.json")
DATA_FILE = os.environ.get("FC_DATA_FILE", os.path.abspath(DEFAULT_DATA_PATH))

os.makedirs(os.path.dirname(DATA_FILE), exist_ok=True)
if not os.path.exists(DATA_FILE):
    with open(DATA_FILE, "w") as f:
        json.dump({"flights": []}, f)


def load_flight_data():
    try:
        with open(DATA_FILE, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, FileNotFoundError):
        logger.warning("Error reading data file. Starting with empty flight list.")
        return {"flights": []}


# -----------------------------------------------------------------------------
# Helpers / normalization
# -----------------------------------------------------------------------------

def parse_query_string(qs: str) -> dict:
    if not qs:
        return {}
    params = {}
    for part in qs.split("&"):
        if "=" in part:
            k, v = part.split("=", 1)
            params[k] = urllib.parse.unquote_plus(v)
    return params


def json_bytes(data) -> bytes:
    return json.dumps(data).encode("utf-8")


def as_iso(dt_str: str) -> str:
    if not dt_str:
        return ""
    try:
        return datetime.fromisoformat(dt_str.replace("Z", "+00:00")).isoformat()
    except Exception:
        return dt_str


def nested_iata(node: dict) -> str:
    if not isinstance(node, dict):
        return ""
    if isinstance(node.get("iata"), str):
        return node["iata"]
    airport = node.get("airport")
    if isinstance(airport, dict) and isinstance(airport.get("iata"), str):
        return airport["iata"]
    return ""


def compute_delay_minutes(record: dict) -> int:
    if isinstance(record.get("delay_minutes"), (int, float)):
        return int(record["delay_minutes"])  # already normalized
    if isinstance(record.get("delayMinutes"), (int, float)):
        return int(record["delayMinutes"])  # pre-normalized key
    try:
        dep = record.get("departure", {}) or {}
        arr = record.get("arrival", {}) or {}
        dep_actual = dep.get("actual")
        dep_scheduled = dep.get("scheduled")
        arr_actual = arr.get("actual")
        arr_scheduled = arr.get("scheduled")
        if arr_actual and arr_scheduled:
            a1 = datetime.fromisoformat(arr_actual.replace("Z", "+00:00"))
            a0 = datetime.fromisoformat(arr_scheduled.replace("Z", "+00:00"))
            return max(0, int((a1 - a0).total_seconds() // 60))
        if dep_actual and dep_scheduled:
            d1 = datetime.fromisoformat(dep_actual.replace("Z", "+00:00"))
            d0 = datetime.fromisoformat(dep_scheduled.replace("Z", "+00:00"))
            return max(0, int((d1 - d0).total_seconds() // 60))
    except Exception:
        pass
    return 0


def normalize_for_flutter(raw: dict) -> dict:
    # flight number
    flight_iata = ""
    if isinstance(raw.get("flight"), str):
        flight_iata = raw["flight"]
    elif isinstance(raw.get("flight"), dict) and isinstance(raw["flight"].get("iata"), str):
        flight_iata = raw["flight"]["iata"]
    else:
        flight_iata = raw.get("flight_iata") or ""

    airline_map = raw.get("airline") if isinstance(raw.get("airline"), dict) else {}
    airline_name = airline_map.get("name") or raw.get("airline_name") or ""
    airline_iata = airline_map.get("iata") or raw.get("airline_iata") or ""

    dep_node = raw.get("departure") if isinstance(raw.get("departure"), dict) else {}
    arr_node = raw.get("arrival") if isinstance(raw.get("arrival"), dict) else {}

    dep_iata = nested_iata(dep_node)
    arr_iata = nested_iata(arr_node)

    dep_sched = dep_node.get("scheduled") or raw.get("departure_scheduled_time") or ""
    arr_sched = arr_node.get("scheduled") or raw.get("arrival_scheduled_time") or ""

    status = raw.get("status") or raw.get("flight_status") or "UNKNOWN"
    if isinstance(status, str):
        status = status.upper()

    delay_minutes = compute_delay_minutes(raw)
    distance_km = raw.get("distance_km") or raw.get("distance") or 0
    try:
        distance_km = int(distance_km)
    except Exception:
        distance_km = 0

    normalized = {
        "flight_iata": flight_iata or "UNKNOWN",
        "airline": {"name": airline_name, "iata": airline_iata},
        "airline_name": airline_name or "Unknown Airline",
        "airline_iata": airline_iata or "",
        "departure": {"iata": dep_iata, "scheduled": as_iso(dep_sched)},
        "arrival": {"iata": arr_iata, "scheduled": as_iso(arr_sched)},
        "departure_airport_iata": dep_iata,
        "arrival_airport_iata": arr_iata,
        "status": status,
        "delay_minutes": delay_minutes,
        "distance_km": distance_km,
        "departure_scheduled_time": as_iso(dep_sched),
        "arrival_scheduled_time": as_iso(arr_sched),
    }

    if isinstance(raw.get("id"), str):
        normalized["id"] = raw["id"]

    return normalized


def is_eligible_simple(n: dict) -> bool:
    status = (n.get("status") or "").upper()
    delay = int(n.get("delay_minutes") or 0)
    return ("CANCELLED" in status) or (delay >= 180) or ("DIVERTED" in status)


def filter_by_hours(n_list: list, hours: int | None) -> list:
    if hours is None:
        return n_list
    try:
        cutoff = datetime.utcnow() - timedelta(hours=hours)
        out = []
        for n in n_list:
            ds = n.get("departure_scheduled_time") or ""
            if not ds:
                continue
            try:
                dt = datetime.fromisoformat(ds.replace("Z", "+00:00"))
            except Exception:
                try:
                    dt = datetime.fromisoformat(ds)
                except Exception:
                    continue
            if dt.tzinfo is not None:
                dt_utc = dt.astimezone(tz=None).replace(tzinfo=None)
            else:
                dt_utc = dt
            if dt_utc >= cutoff:
                out.append(n)
        return out
    except Exception:
        return n_list


# -----------------------------------------------------------------------------
# The WSGI application
# -----------------------------------------------------------------------------

def application(environ, start_response):
    path = (environ.get("PATH_INFO") or "").rstrip("/")
    method = environ.get("REQUEST_METHOD", "GET")
    params = parse_query_string(environ.get("QUERY_STRING", ""))

    logger.info(f"Received {method} request to {path} with params: {params}")

    headers_json = [
        ("Content-Type", "application/json"),
        ("Access-Control-Allow-Origin", "*"),
        ("Access-Control-Allow-Methods", "GET, POST, OPTIONS"),
        ("Access-Control-Allow-Headers", "Content-Type"),
    ]

    try:
        if path in ("", "/"):
            start_response("200 OK", [("Content-Type", "text/plain")])
            return [b"Flight Compensation API is running..."]

        # Eligible flights (ALIAS supported)
        elif path in ("/eligible_flights", "/eu-compensation-eligible"):
            hours = None
            if "hours" in params:
                try:
                    hours = int(params["hours"])  # expects 24 in production
                except ValueError:
                    hours = None

            data = load_flight_data()
            raw = data.get("flights", [])
            normalized = [normalize_for_flutter(f) for f in raw]
            if hours is not None:
                normalized = filter_by_hours(normalized, hours)

            eligible = [n for n in normalized if is_eligible_simple(n)]

            start_response("200 OK", headers_json)
            return [json_bytes(eligible)]

        # Normalized raw list
        elif path == "/api/flights":
            data = load_flight_data()
            raw = data.get("flights", [])
            normalized = [normalize_for_flutter(f) for f in raw]
            start_response("200 OK", headers_json)
            return [json_bytes({"flights": normalized})]

        # Single flight by id (normalized)
        elif path.startswith("/api/flights/"):
            flight_id = path.split("/")[-1]
            data = load_flight_data()
            for f in data.get("flights", []):
                if f.get("id") == flight_id:
                    start_response("200 OK", headers_json)
                    return [json_bytes({"flight": normalize_for_flutter(f)})]
            start_response("404 Not Found", headers_json)
            return [json_bytes({"error": "Flight not found"})]

        # Health
        elif path in ("/health", "/status"):
            info = {
                "status": "healthy",
                "timestamp": datetime.now().isoformat(),
                "data_file": {
                    "exists": os.path.exists(DATA_FILE),
                    "path": DATA_FILE,
                    "size_bytes": os.path.getsize(DATA_FILE) if os.path.exists(DATA_FILE) else 0,
                },
            }
            start_response("200 OK", headers_json)
            return [json_bytes(info)]

        # Debug helpers
        elif path == "/check_data_file":
            info = {
                "exists": os.path.exists(DATA_FILE),
                "path": DATA_FILE,
            }
            if info["exists"]:
                st = os.stat(DATA_FILE)
                info.update({
                    "size_bytes": st.st_size,
                    "last_modified": datetime.fromtimestamp(st.st_mtime).isoformat(),
                })
                try:
                    flights = load_flight_data().get("flights", [])
                    normalized = [normalize_for_flutter(f) for f in flights]
                    info["flight_count"] = len(flights)
                    info["eligible_flight_count"] = len([n for n in normalized if is_eligible_simple(n)])
                except Exception as e:
                    info["error"] = f"Read error: {e}"
            start_response("200 OK", headers_json)
            return [json_bytes(info)]

        elif path == "/debug_flight_data":
            data = load_flight_data()
            raw = data.get("flights", [])
            normalized = [normalize_for_flutter(f) for f in raw]
            sample = {
                "total_raw_flights": len(raw),
                "total_normalized": len(normalized),
                "sample_normalized": normalized[:2] if normalized else [],
            }
            start_response("200 OK", headers_json)
            return [json_bytes(sample)]

        else:
            logger.warning(f"Endpoint not found: {path}")
            start_response("404 Not Found", headers_json)
            return [json_bytes({"error": "Resource not found"})]

    except Exception as e:
        logger.error(f"Unhandled error: {e}")
        start_response("500 Internal Server Error", headers_json)
        return [json_bytes({"error": "Internal server error", "details": str(e)})]
