-- CoRead Cloudflare D1 initial schema
-- Based on lib/db.mjs in the coread-cloudflare-d1 branch.
-- This migration creates the tables used by the current SQLite application.
-- It does not migrate existing user data.

CREATE TABLE IF NOT EXISTS books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  total_paragraphs INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT (datetime('now')),
  cover_image TEXT
);

CREATE TABLE IF NOT EXISTS book_paragraphs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  idx INTEGER NOT NULL,
  content TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS book_comments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER NOT NULL,
  paragraph_idx INTEGER NOT NULL,
  sel_start_idx INTEGER,
  sel_end_idx INTEGER,
  sel_end_para_idx INTEGER,
  selected_text TEXT,
  from_who TEXT DEFAULT 'human',
  content TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  reply_to INTEGER
);

CREATE TABLE IF NOT EXISTS book_progress (
  book_id INTEGER PRIMARY KEY,
  page INTEGER DEFAULT 1,
  paragraph_offset INTEGER DEFAULT 0,
  updated_at DATETIME DEFAULT (datetime('now')),
  last_opened_at DATETIME,
  finished_at TEXT
);

CREATE TABLE IF NOT EXISTS reading_daily (
  book_id INTEGER NOT NULL,
  book_title TEXT,
  reading_date TEXT NOT NULL,
  seconds INTEGER NOT NULL DEFAULT 0,
  updated_at DATETIME DEFAULT (datetime('now')),
  PRIMARY KEY (book_id, reading_date)
);

CREATE TABLE IF NOT EXISTS reading_record_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  book_id INTEGER,
  book_title TEXT,
  reading_date TEXT,
  from_who TEXT DEFAULT 'ai',
  content TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS reading_finished (
  book_id INTEGER PRIMARY KEY,
  book_title TEXT NOT NULL,
  finished_at TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS config (
  key TEXT PRIMARY KEY,
  value TEXT
);

CREATE TABLE IF NOT EXISTS reading_checkpoints (
  session_id TEXT NOT NULL,
  book_id INTEGER NOT NULL,
  reading_date TEXT NOT NULL,
  elapsed_ms INTEGER NOT NULL,
  start_min INTEGER,
  PRIMARY KEY (session_id, reading_date)
);

CREATE TABLE IF NOT EXISTS reading_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reader TEXT NOT NULL DEFAULT 'ai',
  session_id TEXT NOT NULL,
  book_id INTEGER NOT NULL,
  book_title TEXT,
  reading_date TEXT NOT NULL,
  start_min INTEGER,
  paragraphs INTEGER NOT NULL DEFAULT 0,
  chars INTEGER NOT NULL DEFAULT 0,
  seconds REAL NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_reading_log_reader
  ON reading_log(reader, created_at);

CREATE TABLE IF NOT EXISTS backup_assets (
  book_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  data BLOB NOT NULL,
  PRIMARY KEY (book_id, name)
);
