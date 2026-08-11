# FeedWise API

Production-ready FastAPI backend scaffold for FeedWise.

## Features
- JWT auth compatible with Supabase tokens
- Role-based permissions (`student`, `teacher`, `admin`, `reviewer`, `moderator`)
- Core gameplay loop API (feed -> investigation -> decision -> consequence)
- Skills, progress, badges, academy, newsroom, community, admin, analytics routes
- In-memory seed data for local development

## Quick start

```bash
cd backend/feedwise_api
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload
```

Open docs at `http://127.0.0.1:8000/docs`.

## Dev tokens

In `ENV=development`, use these bearer tokens:
- `dev-student`
- `dev-teacher`
- `dev-admin`
- `dev-reviewer`
- `dev-moderator`

Example:

```bash
curl -H "Authorization: Bearer dev-student" http://127.0.0.1:8000/api/v1/auth/me
```

## Tests

```bash
pytest -q
```
