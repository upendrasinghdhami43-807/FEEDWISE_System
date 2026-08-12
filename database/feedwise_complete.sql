-- ============================================================
-- FEEDWISE — COMPLETE DATABASE MIGRATION
-- Paste this entire file into the Supabase SQL Editor and run.
-- Generated: 2026-08-12
-- ============================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- HELPER: updated_at trigger function
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_id        UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email          TEXT UNIQUE NOT NULL,
  name           TEXT NOT NULL,
  role           TEXT NOT NULL DEFAULT 'student'
                   CHECK (role IN ('student', 'teacher', 'admin', 'moderator')),
  age_group      TEXT CHECK (age_group IN ('age16to18', 'age19to21', 'age22to24', 'age25plus')),
  locale         TEXT NOT NULL DEFAULT 'en',
  avatar_url     TEXT,
  xp             INTEGER NOT NULL DEFAULT 0,
  level          INTEGER NOT NULL DEFAULT 1,
  current_streak INTEGER NOT NULL DEFAULT 0,
  best_streak    INTEGER NOT NULL DEFAULT 0,
  last_active_date DATE,
  baseline_completed BOOLEAN NOT NULL DEFAULT false,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_auth_id ON users(auth_id);
CREATE INDEX idx_users_role ON users(role);

CREATE TRIGGER trigger_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- 2. USER SKILLS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS user_skills (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  source_verification REAL NOT NULL DEFAULT 50.0,
  evidence_evaluation REAL NOT NULL DEFAULT 50.0,
  ai_literacy         REAL NOT NULL DEFAULT 50.0,
  bias_detection      REAL NOT NULL DEFAULT 50.0,
  digital_safety      REAL NOT NULL DEFAULT 50.0,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Auto-create user_skills when user is created
CREATE OR REPLACE FUNCTION create_user_skills()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_skills (user_id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_skills
  AFTER INSERT ON users
  FOR EACH ROW EXECUTE FUNCTION create_user_skills();

-- ============================================================
-- 3. SCENARIOS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS scenarios (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title             TEXT NOT NULL,
  description       TEXT,
  category          TEXT NOT NULL,
  difficulty        INTEGER NOT NULL DEFAULT 3 CHECK (difficulty BETWEEN 1 AND 5),
  languages         TEXT[] NOT NULL DEFAULT ARRAY['en'],
  status            TEXT NOT NULL DEFAULT 'draft'
                      CHECK (status IN ('draft', 'in_review', 'fact_checked', 'mil_reviewed', 'published', 'archived')),
  expected_action   TEXT NOT NULL CHECK (expected_action IN ('share', 'verify', 'report', 'ignore')),
  correct_reasoning TEXT,
  learning_objective TEXT,
  target_skills     TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  created_by        UUID REFERENCES users(id),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_scenarios_status ON scenarios(status);
CREATE INDEX idx_scenarios_category ON scenarios(category);
CREATE INDEX idx_scenarios_difficulty ON scenarios(difficulty);

CREATE TRIGGER trigger_scenarios_updated_at
  BEFORE UPDATE ON scenarios
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- 4. CONTENT ITEMS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS content_items (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scenario_id     UUID NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
  headline        TEXT NOT NULL,
  body            TEXT,
  source_name     TEXT NOT NULL,
  source_avatar_url TEXT,
  author_name     TEXT,
  image_url       TEXT,
  video_url       TEXT,
  content_type    TEXT NOT NULL DEFAULT 'socialPost'
                    CHECK (content_type IN ('article', 'socialPost', 'image', 'video', 'screenshot')),
  publish_date    TIMESTAMPTZ,
  likes           INTEGER NOT NULL DEFAULT 0,
  comments        INTEGER NOT NULL DEFAULT 0,
  shares          INTEGER NOT NULL DEFAULT 0,
  is_trending     BOOLEAN NOT NULL DEFAULT false,
  tags            TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_content_items_scenario ON content_items(scenario_id);

-- ============================================================
-- 5. EVIDENCE ITEMS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS evidence_items (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scenario_id   UUID NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
  category      TEXT NOT NULL
                  CHECK (category IN ('source', 'date', 'evidence', 'language', 'crossSource', 'image', 'author', 'context')),
  status        TEXT NOT NULL
                  CHECK (status IN ('supported', 'uncertain', 'missing', 'neutral')),
  label         TEXT NOT NULL,
  value         TEXT NOT NULL,
  explanation   TEXT NOT NULL,
  sort_order    INTEGER NOT NULL DEFAULT 0,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_evidence_scenario ON evidence_items(scenario_id);

-- ============================================================
-- 6. CONSEQUENCES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS consequences (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scenario_id       UUID NOT NULL REFERENCES scenarios(id) ON DELETE CASCADE,
  decision          TEXT NOT NULL CHECK (decision IN ('share', 'verify', 'report', 'ignore')),
  reach             INTEGER NOT NULL DEFAULT 0,
  further_shares    INTEGER NOT NULL DEFAULT 0,
  credibility_delta INTEGER NOT NULL DEFAULT 0,
  community_impact  TEXT,
  missed_clues      TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  explanation       TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(scenario_id, decision)
);

-- ============================================================
-- 7. LESSONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS lessons (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scenario_id       UUID REFERENCES scenarios(id) ON DELETE SET NULL,
  module_id         TEXT,
  primary_skill     TEXT NOT NULL,
  title             TEXT NOT NULL,
  explanation       TEXT NOT NULL,
  tips              TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  key_takeaway      TEXT,
  content_blocks    JSONB NOT NULL DEFAULT '[]'::JSONB,
  quiz_data         JSONB,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  read_time_seconds INTEGER NOT NULL DEFAULT 60,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_lessons_scenario ON lessons(scenario_id);
CREATE INDEX idx_lessons_module ON lessons(module_id);

-- ============================================================
-- 8. DECISION RECORDS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS decision_records (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  scenario_id         UUID NOT NULL REFERENCES scenarios(id),
  decision            TEXT NOT NULL CHECK (decision IN ('share', 'verify', 'report', 'ignore')),
  investigation_steps TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
  process_score       REAL NOT NULL DEFAULT 0,
  is_correct          BOOLEAN NOT NULL DEFAULT false,
  time_spent_seconds  INTEGER,
  xp_earned           INTEGER NOT NULL DEFAULT 0,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_decisions_user ON decision_records(user_id);
CREATE INDEX idx_decisions_scenario ON decision_records(scenario_id);
CREATE INDEX idx_decisions_created ON decision_records(created_at);

-- ============================================================
-- 9. USER BADGES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS user_badges (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  badge_type  TEXT NOT NULL,
  unlocked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, badge_type)
);

CREATE INDEX idx_badges_user ON user_badges(user_id);

-- ============================================================
-- 10. LESSON PROGRESS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS lesson_progress (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lesson_id    UUID NOT NULL REFERENCES lessons(id),
  quiz_score   REAL,
  completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, lesson_id)
);

-- ============================================================
-- 11. NEWSROOM SCENARIOS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS newsroom_scenarios (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  story_headline   TEXT NOT NULL,
  briefing         TEXT NOT NULL,
  sources          JSONB NOT NULL DEFAULT '[]'::JSONB,
  correct_decision TEXT NOT NULL CHECK (correct_decision IN ('publish', 'verify', 'hold', 'reject')),
  consequences     JSONB NOT NULL DEFAULT '{}'::JSONB,
  learning_point   TEXT NOT NULL,
  status           TEXT NOT NULL DEFAULT 'published',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 12. COMMUNITY SUBMISSIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS community_submissions (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         UUID NOT NULL REFERENCES users(id),
  claim           TEXT NOT NULL,
  category        TEXT NOT NULL,
  source_platform TEXT,
  source_url      TEXT,
  source_account  TEXT,
  reason          TEXT,
  screenshot_url  TEXT,
  language        TEXT NOT NULL DEFAULT 'en',
  status          TEXT NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'approved', 'rejected', 'archived')),
  moderator_id    UUID REFERENCES users(id),
  moderator_note  TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_submissions_status ON community_submissions(status);

-- ============================================================
-- 13. TEACHER CLASSES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS classes (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  teacher_id  UUID NOT NULL REFERENCES users(id),
  name        TEXT NOT NULL,
  grade       TEXT,
  section     TEXT,
  join_code   TEXT UNIQUE NOT NULL DEFAULT substring(md5(random()::text) from 1 for 8),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS class_members (
  class_id   UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  joined_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (class_id, user_id)
);

-- ============================================================
-- 14. ASSIGNMENTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS assignments (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  class_id     UUID NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
  teacher_id   UUID NOT NULL REFERENCES users(id),
  title        TEXT NOT NULL,
  scenario_ids UUID[] NOT NULL DEFAULT ARRAY[]::UUID[],
  due_date     DATE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 15. SKILL HISTORY TABLE (for radar chart progression)
-- ============================================================
CREATE TABLE IF NOT EXISTS skill_snapshots (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  source_verification REAL NOT NULL,
  evidence_evaluation REAL NOT NULL,
  ai_literacy         REAL NOT NULL,
  bias_detection      REAL NOT NULL,
  digital_safety      REAL NOT NULL,
  recorded_at         DATE NOT NULL DEFAULT CURRENT_DATE,
  UNIQUE(user_id, recorded_at)
);

CREATE INDEX idx_snapshots_user ON skill_snapshots(user_id);

-- ============================================================
-- 16. NOTIFICATIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS notifications (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type       TEXT NOT NULL,
  title      TEXT NOT NULL,
  body       TEXT,
  data       JSONB DEFAULT '{}',
  is_read    BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = FALSE;

-- ============================================================
-- TRIGGER: Auto-calculate level from XP
-- ============================================================
CREATE OR REPLACE FUNCTION calculate_level()
RETURNS TRIGGER AS $$
BEGIN
  NEW.level = CASE
    WHEN NEW.xp >= 18000 THEN 10
    WHEN NEW.xp >= 12000 THEN 9
    WHEN NEW.xp >= 8000  THEN 8
    WHEN NEW.xp >= 5500  THEN 7
    WHEN NEW.xp >= 3500  THEN 6
    WHEN NEW.xp >= 2000  THEN 5
    WHEN NEW.xp >= 1000  THEN 4
    WHEN NEW.xp >= 500   THEN 3
    WHEN NEW.xp >= 200   THEN 2
    ELSE 1
  END;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_level
  BEFORE UPDATE OF xp ON users
  FOR EACH ROW EXECUTE FUNCTION calculate_level();

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE scenarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE consequences ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE decision_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users
CREATE POLICY "Users can read own profile" ON users
  FOR SELECT USING (auth.uid() = auth_id);
CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = auth_id);

-- Skills
CREATE POLICY "Users can read own skills" ON user_skills
  FOR SELECT USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users can update own skills" ON user_skills
  FOR UPDATE USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Scenarios (public read for published)
CREATE POLICY "Anyone can read published scenarios" ON scenarios
  FOR SELECT USING (status = 'published');

-- Content Items
CREATE POLICY "Read content for published scenarios" ON content_items
  FOR SELECT USING (scenario_id IN (SELECT id FROM scenarios WHERE status = 'published'));

-- Evidence
CREATE POLICY "Read evidence for published scenarios" ON evidence_items
  FOR SELECT USING (scenario_id IN (SELECT id FROM scenarios WHERE status = 'published'));

-- Consequences
CREATE POLICY "Read consequences for published scenarios" ON consequences
  FOR SELECT USING (scenario_id IN (SELECT id FROM scenarios WHERE status = 'published'));

-- Lessons
CREATE POLICY "Anyone can read lessons" ON lessons
  FOR SELECT USING (true);

-- Decisions
CREATE POLICY "Users can read own decisions" ON decision_records
  FOR SELECT USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users can insert own decisions" ON decision_records
  FOR INSERT WITH CHECK (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Badges
CREATE POLICY "Users can read own badges" ON user_badges
  FOR SELECT USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Lesson Progress
CREATE POLICY "Users can read own lesson progress" ON lesson_progress
  FOR SELECT USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users can insert own lesson progress" ON lesson_progress
  FOR INSERT WITH CHECK (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Community
CREATE POLICY "Read approved or own submissions" ON community_submissions
  FOR SELECT USING (
    status = 'approved' OR
    user_id IN (SELECT id FROM users WHERE auth_id = auth.uid())
  );
CREATE POLICY "Users can submit" ON community_submissions
  FOR INSERT WITH CHECK (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- Notifications
CREATE POLICY "Users read own notifications" ON notifications
  FOR SELECT USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));
CREATE POLICY "Users update own notifications" ON notifications
  FOR UPDATE USING (user_id IN (SELECT id FROM users WHERE auth_id = auth.uid()));

-- ============================================================
-- SEED DATA — 5 Scenarios with full content
-- ============================================================

-- Scenario 1: AI Earthquake Prediction
INSERT INTO scenarios (id, title, description, category, difficulty, languages, status, expected_action, correct_reasoning, learning_objective, target_skills)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'AI Earthquake Prediction',
  'An unverified claim about AI predicting earthquakes goes viral.',
  'aiGeneratedContent', 3, ARRAY['en', 'ne'], 'published', 'verify',
  'Extraordinary claim with no primary source, no identified institution, and no independent confirmation.',
  'Understand that extraordinary scientific claims require extraordinary evidence.',
  ARRAY['sourceVerification', 'evidenceEvaluation', 'aiLiteracy']
);

INSERT INTO content_items (scenario_id, headline, body, source_name, content_type, publish_date, likes, comments, shares, is_trending, tags)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'Scientists discover an AI that predicts earthquakes 48 hours before they happen',
  'A groundbreaking AI system developed by researchers can now predict earthquakes up to 48 hours in advance with 94% accuracy.',
  'FutureScienceDaily', 'socialPost', '2026-03-12', 17200, 3400, 8700, true,
  ARRAY['AI', 'Science', 'Earthquake', 'Technology']
);

INSERT INTO evidence_items (scenario_id, category, status, label, value, explanation, sort_order) VALUES
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'source', 'uncertain', 'Publisher', 'FutureScienceDaily', 'Not a recognized scientific publisher.', 1),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'source', 'missing', 'Author', 'Not identified', 'No named author or researcher.', 2),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'date', 'supported', 'Published', 'March 12, 2026', 'Recent publication date.', 3),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'evidence', 'missing', 'Primary Source', 'Not provided', 'No link to a peer-reviewed study.', 4),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'evidence', 'missing', 'Institution', 'Not identified', 'No research institution named.', 5),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'language', 'uncertain', 'Framing', 'High emotional', '"Groundbreaking", "save millions" — strong certainty for unconfirmed claim.', 6),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'crossSource', 'missing', 'Confirmation', 'None', 'No major source has confirmed.', 7);

INSERT INTO consequences (scenario_id, decision, reach, further_shares, credibility_delta, missed_clues, explanation) VALUES
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'share', 12400, 2100, -12, ARRAY['No primary source', 'No confirmation', 'Emotional language'], 'You shared an unverified extraordinary claim.'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'verify', 0, 0, 5, ARRAY[]::TEXT[], 'You correctly flagged this for verification.'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'report', 0, 0, 8, ARRAY[]::TEXT[], 'You helped protect others from misinformation.'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'ignore', 0, 0, 2, ARRAY['Could have reported'], 'The claim continued spreading without correction.');

INSERT INTO lessons (scenario_id, primary_skill, title, explanation, tips, key_takeaway, sort_order, read_time_seconds)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'sourceVerification', 'Check the Original Source',
  'Extraordinary claims should link to primary sources — peer-reviewed studies, named researchers, or recognized institutions.',
  ARRAY['Who are the scientists?', 'Where was it published?', 'Which institution?', 'Can others confirm?'],
  'A widely shared claim can still be unsupported.', 1, 60
);

-- Scenario 2: Political Quote Out of Context
INSERT INTO scenarios (id, title, description, category, difficulty, languages, status, expected_action, correct_reasoning, learning_objective, target_skills)
VALUES (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  'Election Quote Out of Context',
  'A clipped video appears to show a candidate admitting fraud.',
  'politicalMisinformation', 4, ARRAY['en'], 'published', 'verify',
  'The clip omits a clarifying sentence that reverses the meaning.',
  'Learn to check full context before drawing conclusions from clips.',
  ARRAY['biasDetection', 'sourceVerification']
);

INSERT INTO content_items (scenario_id, headline, body, source_name, content_type, publish_date, likes, comments, shares, is_trending, tags)
VALUES (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  'BREAKING: Candidate admits vote tampering in leaked clip',
  'A viral video clip appears to show a political candidate openly admitting to vote tampering during a private meeting.',
  'PoliticalAlertNow', 'video', '2026-04-05', 24300, 6100, 11200, true,
  ARRAY['Politics', 'Election', 'Breaking']
);

INSERT INTO evidence_items (scenario_id, category, status, label, value, explanation, sort_order) VALUES
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'source', 'uncertain', 'Publisher', 'PoliticalAlertNow', 'Known for sensational political clips.', 1),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'context', 'missing', 'Full Video', 'Not provided', 'Only a 15-second clip; full recording not linked.', 2),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'crossSource', 'supported', 'Archive Match', '2019 stream archive', 'Full speech available in 2019 archive shows different meaning.', 3),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'language', 'uncertain', 'Framing', 'Loaded caption', 'Caption uses certainty language like "admits" and "caught".', 4);

INSERT INTO consequences (scenario_id, decision, reach, further_shares, credibility_delta, missed_clues, explanation) VALUES
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'share', 16000, 3100, -18, ARRAY['Out-of-context clip', 'No full video'], 'You spread a misleading political clip.'),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'verify', 180, 25, 16, ARRAY[]::TEXT[], 'You correctly checked the full context.'),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'report', 120, 16, 12, ARRAY[]::TEXT[], 'You flagged the misleading content.'),
  ('b2c3d4e5-f6a7-8901-bcde-f12345678901', 'ignore', 980, 212, -8, ARRAY['No intervention'], 'The misleading clip continued circulating.');

INSERT INTO lessons (scenario_id, primary_skill, title, explanation, tips, key_takeaway, sort_order, read_time_seconds)
VALUES (
  'b2c3d4e5-f6a7-8901-bcde-f12345678901',
  'biasDetection', 'Check Full Context of Clips',
  'Short video clips can completely change meaning when removed from context. Always look for the full recording.',
  ARRAY['Find the full video', 'Check the original event date', 'Look for the next sentence', 'Compare multiple sources'],
  'A 15-second clip can reverse the meaning of a 15-minute speech.', 1, 75
);

-- Scenario 3: Deepfake Celebrity Endorsement
INSERT INTO scenarios (id, title, description, category, difficulty, languages, status, expected_action, correct_reasoning, learning_objective, target_skills)
VALUES (
  'c3d4e5f6-a7b8-9012-cdef-123456789012',
  'Deepfake Celebrity Endorsement',
  'A viral video shows a celebrity promising quick wealth from an investment app.',
  'aiGeneratedContent', 5, ARRAY['en'], 'published', 'report',
  'Deepfake video with scam urgency patterns. No official confirmation from celebrity.',
  'Recognize deepfake artifacts and scam urgency patterns.',
  ARRAY['aiLiteracy', 'digitalSafety']
);

INSERT INTO content_items (scenario_id, headline, body, source_name, content_type, publish_date, likes, comments, shares, is_trending, tags)
VALUES (
  'c3d4e5f6-a7b8-9012-cdef-123456789012',
  'Famous actor reveals secret investment app — "I made $50K in a week"',
  'A video shows a well-known actor endorsing a new investment platform, claiming anyone can make thousands from home.',
  'MoneyTipsViral', 'video', '2026-05-18', 31000, 7800, 15400, true,
  ARRAY['Scam', 'Deepfake', 'Finance', 'Celebrity']
);

INSERT INTO evidence_items (scenario_id, category, status, label, value, explanation, sort_order) VALUES
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'source', 'missing', 'Official Statement', 'None', 'No official confirmation from the celebrity or their management.', 1),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'image', 'uncertain', 'Video Artifacts', 'Lip sync issues', 'Subtle lip-sync mismatches and unnatural eye movement.', 2),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'language', 'uncertain', 'Urgency Trigger', 'Act now before midnight', 'Classic scam pressure language.', 3),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'crossSource', 'missing', 'Platform Registration', 'Unregistered', 'Investment platform not found in financial authority registries.', 4);

INSERT INTO consequences (scenario_id, decision, reach, further_shares, credibility_delta, missed_clues, explanation) VALUES
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'share', 22000, 4800, -25, ARRAY['Deepfake artifacts', 'Urgency scam cues', 'No registration'], 'You exposed others to a financial scam.'),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'verify', 230, 31, 8, ARRAY['Should also report'], 'Verification is good, combine with report for scams.'),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'report', 140, 10, 18, ARRAY[]::TEXT[], 'You helped get the scam removed quickly.'),
  ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'ignore', 1500, 320, -10, ARRAY['No protective action'], 'The scam continued victimizing people.');

INSERT INTO lessons (scenario_id, primary_skill, title, explanation, tips, key_takeaway, sort_order, read_time_seconds)
VALUES (
  'c3d4e5f6-a7b8-9012-cdef-123456789012',
  'aiLiteracy', 'Spotting Deepfake Videos',
  'AI-generated videos often have subtle visual artifacts. Combined with urgency language, they signal scams.',
  ARRAY['Check lip sync', 'Look for unnatural blinking', 'Verify with official channels', 'Check financial registries'],
  'If a celebrity endorsement seems too good to be true, it probably is.', 1, 90
);

-- Scenario 4: Flood Footage Reused
INSERT INTO scenarios (id, title, description, category, difficulty, languages, status, expected_action, correct_reasoning, learning_objective, target_skills)
VALUES (
  'd4e5f6a7-b8c9-0123-defa-234567890123',
  'Flood Footage Reused',
  'Old disaster footage is presented as current breaking news.',
  'misinformation', 2, ARRAY['en', 'ne'], 'published', 'verify',
  'Reverse image search reveals 2018 footage. Metadata mismatch.',
  'Learn to verify the date and origin of viral images and videos.',
  ARRAY['sourceVerification', 'evidenceEvaluation']
);

INSERT INTO content_items (scenario_id, headline, body, source_name, content_type, publish_date, likes, comments, shares, is_trending, tags)
VALUES (
  'd4e5f6a7-b8c9-0123-defa-234567890123',
  'DEVASTATING: City completely submerged — rescue operations underway',
  'Shocking footage shows an entire city district underwater. Hundreds reportedly stranded.',
  'BreakingAlerts24', 'video', '2026-06-22', 8900, 2100, 4500, true,
  ARRAY['Flood', 'Disaster', 'Breaking', 'Emergency']
);

INSERT INTO evidence_items (scenario_id, category, status, label, value, explanation, sort_order) VALUES
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'source', 'uncertain', 'Publisher', 'BreakingAlerts24', 'Aggregator account, not a news organization.', 1),
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'date', 'uncertain', 'Date Mismatch', '2018 metadata', 'Reverse image search links to 2018 post.', 2),
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'crossSource', 'supported', 'Archive Match', '2018 flood footage', 'Video matches archived footage from a different country.', 3);

INSERT INTO consequences (scenario_id, decision, reach, further_shares, credibility_delta, missed_clues, explanation) VALUES
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'share', 9800, 2000, -14, ARRAY['Ignored date mismatch', 'No source check'], 'You spread panic with outdated footage.'),
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'verify', 110, 12, 12, ARRAY[]::TEXT[], 'You verified the date and corrected the record.'),
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'report', 85, 9, 9, ARRAY[]::TEXT[], 'You flagged the misleading repost.'),
  ('d4e5f6a7-b8c9-0123-defa-234567890123', 'ignore', 500, 100, -5, ARRAY['No correction'], 'Confusion persisted among your network.');

INSERT INTO lessons (scenario_id, primary_skill, title, explanation, tips, key_takeaway, sort_order, read_time_seconds)
VALUES (
  'd4e5f6a7-b8c9-0123-defa-234567890123',
  'sourceVerification', 'Verify Dates and Origins',
  'Old images and videos regularly resurface during new events. Always verify when footage was originally captured.',
  ARRAY['Use reverse image search', 'Check image metadata', 'Compare with news archives', 'Look for date stamps'],
  'Viral footage is not always current footage.', 1, 60
);

-- Scenario 5: Data Privacy Rumor
INSERT INTO scenarios (id, title, description, category, difficulty, languages, status, expected_action, correct_reasoning, learning_objective, target_skills)
VALUES (
  'e5f6a7b8-c9d0-1234-efab-345678901234',
  'Messaging App Privacy Scare',
  'A post claims a major messaging app now publicly leaks all private chats.',
  'digitalSafety', 3, ARRAY['en'], 'published', 'verify',
  'Official advisory shows a limited backup bug, not a full leak. Claim is exaggerated.',
  'Distinguish between actual security incidents and exaggerated panic posts.',
  ARRAY['digitalSafety', 'evidenceEvaluation']
);

INSERT INTO content_items (scenario_id, headline, body, source_name, content_type, publish_date, likes, comments, shares, is_trending, tags)
VALUES (
  'e5f6a7b8-c9d0-1234-efab-345678901234',
  'WARNING: Popular messaging app LEAKS all your private chats to the public',
  'Delete the app NOW! A security researcher has confirmed that all chats are being leaked to external servers.',
  'TechWatchdog', 'socialPost', '2026-07-01', 19500, 4200, 9800, true,
  ARRAY['Privacy', 'Security', 'Warning', 'Technology']
);

INSERT INTO evidence_items (scenario_id, category, status, label, value, explanation, sort_order) VALUES
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'source', 'supported', 'Publisher Known', 'TechWatchdog', 'Known tech commentary account, sometimes sensational.', 1),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'evidence', 'supported', 'Official Advisory', 'Limited bug disclosure', 'Company issued advisory: backup bug affected some users, not all chats.', 2),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'language', 'uncertain', 'Urgency', 'Delete NOW', 'Panic language designed to bypass critical thinking.', 3),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'crossSource', 'supported', 'Official Response', 'Company blog post', 'Company confirmed a minor backup vulnerability, patched within hours.', 4);

INSERT INTO consequences (scenario_id, decision, reach, further_shares, credibility_delta, missed_clues, explanation) VALUES
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'share', 14000, 2600, -12, ARRAY['Misread advisory scope', 'Panic language'], 'You spread overstated panic.'),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'verify', 170, 20, 15, ARRAY[]::TEXT[], 'You provided accurate context to your network.'),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'report', 95, 11, 6, ARRAY['Claim partly true'], 'Reporting was processed but content not removed since partly true.'),
  ('e5f6a7b8-c9d0-1234-efab-345678901234', 'ignore', 600, 120, -4, ARRAY['Missed chance to clarify'], 'Friends remained confused and worried.');

INSERT INTO lessons (scenario_id, primary_skill, title, explanation, tips, key_takeaway, sort_order, read_time_seconds)
VALUES (
  'e5f6a7b8-c9d0-1234-efab-345678901234',
  'digitalSafety', 'Read Official Advisories',
  'When a security scare appears, always check the company official response before panicking or spreading the claim.',
  ARRAY['Check the company blog', 'Read the full advisory', 'Distinguish scope (some vs all)', 'Verify the researchers credentials'],
  'Panic posts often exaggerate real but limited security issues.', 1, 75
);

-- Newsroom Scenarios
INSERT INTO newsroom_scenarios (id, story_headline, briefing, sources, correct_decision, consequences, learning_point) VALUES
(
  'nr-001-0000-0000-000000000001',
  'Local Factory Explosion — 3 Reported Injured',
  'Your newsroom receives a tip about a factory explosion with injuries. You have 20 minutes before the evening bulletin.',
  '[{"name":"Eyewitness video","type":"social_media","reliability":"low","content":"Shaky phone video showing smoke from a building"},{"name":"Fire department scanner","type":"official","reliability":"medium","content":"Units dispatched to industrial zone"},{"name":"Factory spokesperson","type":"primary","reliability":"high","content":"Confirms minor incident, no serious injuries"}]'::JSONB,
  'verify',
  '{"publish":{"headline":"Factory explosion confirmed","impact":"Premature report caused public panic","score":-10},"verify":{"headline":"Verified: Minor factory incident, no serious injuries","impact":"Accurate, responsible reporting","score":15},"hold":{"headline":"Story held pending verification","impact":"Missed timely report but maintained credibility","score":5},"reject":{"headline":"Story not published","impact":"Competitors broke the story first","score":-5}}'::JSONB,
  'Always verify with primary sources before publishing breaking news, even under deadline pressure.'
),
(
  'nr-002-0000-0000-000000000002',
  'Celebrity Death Hoax Trending on Social Media',
  'A trending hashtag claims a famous actor has died. Your social media editor wants to run it immediately.',
  '[{"name":"Trending hashtag","type":"social_media","reliability":"low","content":"#RIP[Actor] trending with 50K tweets"},{"name":"Fan account","type":"social_media","reliability":"low","content":"Unverified claim with old photo"},{"name":"Actors official account","type":"primary","reliability":"high","content":"No recent activity, last post 3 days ago"}]'::JSONB,
  'hold',
  '{"publish":{"headline":"Actor confirmed dead","impact":"Fake news published, credibility destroyed","score":-20},"verify":{"headline":"Checking reports of actors death","impact":"Cautious but premature attention","score":0},"hold":{"headline":"Awaiting official confirmation","impact":"Responsible journalism, story later confirmed as hoax","score":15},"reject":{"headline":"Hoax not published","impact":"Correctly identified as likely hoax","score":10}}'::JSONB,
  'Social media trends are not confirmation. Wait for official or primary source verification.'
);

-- ============================================================
-- DONE! Your FeedWise database is ready.
-- ============================================================
