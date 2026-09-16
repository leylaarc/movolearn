"""Parent-owned API for Movo Learn child profiles and learning progress.

This service stores children's learning data. Treat it as sensitive:

- Parents own the account. Children never log in.
- Collect nickname, age/birthday, levels, interests, and lesson scores — not last names,
  photos, location, or contact information for the child.
- Production must use HTTPS, Postgres with encryption at rest, and a strong FAMILY_API_SECRET_KEY.

Run locally:

    cd backend/family-api
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    cp .env.example .env
    uvicorn app.main:app --host 127.0.0.1 --port 8088

The iOS app (Debug) talks to http://127.0.0.1:8088. Point FamilyAPIBaseURL at your
HTTPS host before TestFlight / App Store.
"""
