#!/usr/bin/env python3
"""
Simple backend health ping for PythonAnywhere scheduled task or manual runs.
- Pings /health and /eligible_flights?hours=24&include_delayed=true
- Exits with non‑zero code on failure

Environment variables:
- FC_BACKEND_URL: Base URL (default: https://piotrs.pythonanywhere.com)
"""
import json
import os
import sys
import urllib.request
import urllib.error

BASE_URL = os.getenv('FC_BACKEND_URL', 'https://piotrs.pythonanywhere.com').rstrip('/')


def fetch(url: str):
    req = urllib.request.Request(
        url,
        headers={
            'User-Agent': 'FlightCompensationHealth/1.0',
            'Accept': 'application/json, text/plain, */*',
        },
        method='GET',
    )
    with urllib.request.urlopen(req, timeout=20) as resp:
        status = resp.getcode()
        body = resp.read().decode('utf-8', errors='replace')
        return status, body


def main() -> int:
    ok = True

    # 1) /health
    health_url = f"{BASE_URL}/health"
    try:
        status, body = fetch(health_url)
        print(f"[health] {status} {health_url}")
        if status != 200:
            print(body[:500])
            ok = False
    except Exception as e:
        print(f"[health] error: {e}")
        ok = False

    # 2) /eligible_flights
    elig_url = f"{BASE_URL}/eligible_flights?hours=24&include_delayed=true"
    try:
        status, body = fetch(elig_url)
        print(f"[eligible_flights] {status} {elig_url}")
        if status != 200:
            print(body[:500])
            ok = False
        else:
            try:
                data = json.loads(body)
                if not isinstance(data, list):
                    print("[eligible_flights] response is not a list")
                    ok = False
                else:
                    print(f"[eligible_flights] flights: {len(data)}")
            except Exception as pe:
                print(f"[eligible_flights] parse error: {pe}")
                ok = False
    except Exception as e:
        print(f"[eligible_flights] error: {e}")
        ok = False

    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
