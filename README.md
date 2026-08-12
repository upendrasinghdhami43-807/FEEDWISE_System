# 🧠 FEEDWISE — Don't Just Scroll. Think.

> **A practical Media & Information Literacy platform for the AI era.**
> 
> UNESCO MIL Challenge 2026 Entry

![FeedWise](https://img.shields.io/badge/UNESCO-MIL%20Challenge%202026-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115+-009688?logo=fastapi)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?logo=supabase)

---

## 🎯 What is FeedWise?

FeedWise is an interactive digital information environment where young people:

1. **Experience** realistic social-media scenarios in a simulated feed
2. **Investigate** sources, evidence, and language using the TrustLens panel
3. **Decide** whether to Share, Verify, Report, or Ignore each claim
4. **See Consequences** of their decisions with real impact numbers
5. **Learn** practical MIL skills through bite-sized lessons and quizzes
6. **Track Progress** across 5 skill dimensions with a skill radar chart

---

## 🏗️ Architecture

```
feedwise/
├── apps/
│   ├── feedwise_mobile/      ← Flutter user app (iOS/Android/Web)
│   └── feedwise_studio/      ← Flutter admin/teacher portal (Web)
├── backend/
│   └── feedwise_api/         ← FastAPI REST API
├── database/
│   └── feedwise_complete.sql ← Full Supabase migration
├── implement/                ← Design documents & blueprints
└── progress/                 ← Phase-by-phase progress reports
```

---

## 🚀 Quick Start

### Prerequisites
- Flutter 3.27+
- Python 3.12+
- A Supabase project (free tier works)

### 1. Database Setup
```bash
# Create a Supabase project at https://supabase.com
# Open SQL Editor → Paste database/feedwise_complete.sql → Run
```

### 2. Backend
```bash
cd backend/feedwise_api
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Fill in your Supabase URL and keys in .env
uvicorn app.main:app --reload
```

### 3. User App
```bash
cd apps/feedwise_mobile
flutter pub get
flutter run -d chrome   # or connect a device
```

### 4. Admin Studio
```bash
cd apps/feedwise_studio
flutter pub get
flutter run -d chrome
```

---

## 📱 Key Features

| Feature | Description |
|---------|-------------|
| **Social Feed** | Realistic scenario cards with engagement numbers |
| **TrustLens** | Evidence investigation panel (source, date, cross-source, language) |
| **Decision Engine** | Share / Verify / Report / Ignore with consequence simulation |
| **Consequence Ripple** | Visual impact: reach, shares, credibility delta |
| **MIL Academy** | Structured lessons organized by skill dimension |
| **Newsroom Mode** | Play as an editor deciding what to publish |
| **Skill Radar** | 5-axis chart tracking MIL competency growth |
| **Badge System** | Achievement-based progression (Source Detective, AI Aware, etc.) |
| **Community** | Students submit real-world claims for review |
| **Teacher Dashboard** | Class management, assignments, student analytics |

---

## 🎓 5 MIL Skill Dimensions

1. **Source Verification** — Can the student identify credible sources?
2. **Evidence Evaluation** — Can they assess the quality of evidence?
3. **AI Literacy** — Can they recognize AI-generated content?
4. **Bias Detection** — Can they spot framing and manipulation?
5. **Digital Safety** — Can they protect themselves online?

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| User App | Flutter (Dart) + Riverpod + GoRouter |
| Admin Portal | Flutter Web |
| Backend API | FastAPI (Python) |
| Database | Supabase (PostgreSQL + Auth + RLS) |
| Hosting | Render.com (API) + Firebase Hosting (Web) |

---

## 📊 UNESCO Evaluation Alignment

| Criteria | FeedWise Response |
|----------|-------------------|
| **Theme Alignment** | Directly targets Media & Information Literacy for the AI era |
| **Clarity** | Clear learning loop: Feed → Investigate → Decide → Learn |
| **Innovation** | Simulated social feed + consequence engine + skill radar |
| **Feasibility** | Open source, free-tier hosting, works offline with mock data |
| **Impact/Inclusion** | Multi-language support, age-appropriate, classroom integration |

---

## 📝 License

This project is created for the UNESCO MIL Challenge 2026.

---

## 👨‍💻 Team

- **Upendra Singh Dhami** — Developer & Designer
