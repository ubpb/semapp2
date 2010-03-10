--
-- Users
--
CREATE TABLE users (
  id serial NOT NULL PRIMARY KEY,
  login character varying NOT NULL,
  "name" character varying NOT NULL,
  email character varying NULL
);

CREATE UNIQUE INDEX index_users_on_login ON users(login);
CREATE INDEX index_users_on_email ON users(email);

--
-- Sessions
--
CREATE TABLE sessions (
  id serial NOT NULL PRIMARY KEY,
  session_id character varying NOT NULL,
  data text,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE INDEX index_sessions_on_session_id ON sessions(session_id);
CREATE INDEX index_sessions_on_updated_at ON sessions(updated_at);

--
-- Authorities & Authorities <> Users
--
CREATE TABLE authorities (
  id serial NOT NULL PRIMARY KEY,
  name character varying NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_authorities_on_name ON authorities(name);

CREATE TABLE authorities_users (
  authority_id integer REFERENCES authorities NOT NULL,
  user_id integer REFERENCES users NOT NULL
);

CREATE UNIQUE INDEX index_authorities_users_on_authority_id_and_user_id ON authorities_users(authority_id, user_id);

--
-- Semesters
--
CREATE TABLE semesters (
  id serial NOT NULL PRIMARY KEY,
  current boolean,
  title character varying NOT NULL,
  "position" integer DEFAULT 0 NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_semesters_on_current ON semesters(current);

--
-- Locations
--
CREATE TABLE locations (
  id serial NOT NULL PRIMARY KEY,
  title character varying NOT NULL,
  "position" integer DEFAULT 0 NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

--
-- SemApps
--
CREATE TABLE sem_apps (
  id serial NOT NULL PRIMARY KEY,
  creator_id integer REFERENCES users NOT NULL,
  semester_id integer REFERENCES semesters NOT NULL,
  location_id integer REFERENCES locations NOT NULL,
  approved boolean DEFAULT false NOT NULL,
  marked boolean DEFAULT false NOT NULL,
  title character varying NOT NULL,
  tutors text NOT NULL,
  shared_secret character varying NOT NULL,
  course_id character varying,
  miless_document_id character varying,
  miless_derivate_id character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_sem_apps_on_semester_id_and_course_id ON sem_apps(semester_id, course_id);
CREATE INDEX index_sem_apps_on_miless_document_id ON sem_apps(miless_document_id);
CREATE INDEX index_sem_apps_on_miless_derivate_id ON sem_apps(miless_derivate_id);

--
-- Book Shelves
--
CREATE TABLE book_shelves (
  id serial NOT NULL PRIMARY KEY,
  ils_account character varying NOT NULL,
  slot_number character varying NOT NULL,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_book_shelves_on_sem_app_id ON book_shelves(sem_app_id);
CREATE UNIQUE INDEX index_book_shelves_on_ils_account ON book_shelves(ils_account);

--
-- Books
--
CREATE TABLE books (
  id serial NOT NULL PRIMARY KEY,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  creator_id integer REFERENCES users NULL,
  placeholder_id integer REFERENCES sem_apps NULL,
  ils_id character varying,
  signature character varying,
  title character varying,
  author character varying,
  edition character varying,
  place character varying,
  publisher character varying,
  year character varying,
  isbn character varying,
  comment text,
  state character varying NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_books_on_sem_app_id_and_ils_id ON books(sem_app_id, ils_id);
CREATE INDEX index_books_on_ils_id ON books(ils_id);
CREATE INDEX index_books_on_state ON books(state);

--
-- Ownerships
--
CREATE TABLE ownerships (
  id serial NOT NULL PRIMARY KEY,
  user_id integer REFERENCES users NOT NULL,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE INDEX index_ownerships_on_user_id ON ownerships(user_id);
CREATE INDEX index_ownerships_on_sem_app_id ON ownerships(sem_app_id);

--
-- SemApp entries
--
CREATE TABLE entries (
  id         serial NOT NULL PRIMARY KEY,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  creator_id integer REFERENCES users NULL,
  "position" integer,
  publish_on timestamp without time zone,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  miless_entry_id character varying
);

CREATE INDEX index_entries_on_miless_entry_id ON entries(miless_entry_id);

CREATE TABLE headline_entries (
  headline character varying
) INHERITS (entries);

CREATE TABLE text_entries (
  text text
) INHERITS (entries);

CREATE TABLE monograph_entries (
  author character varying,
  title text,
  subtitle text,
  "year" character varying,
  place character varying,
  publisher character varying,
  edition character varying,
  isbn character varying,
  signature character varying,
  comment text
) INHERITS (entries);

CREATE TABLE article_entries (
  author character varying,
  title text,
  subtitle text,
  journal character varying,
  place character varying,
  publisher character varying,
  volume character varying,
  "year" character varying,
  issue character varying,
  pages_from integer,
  pages_to integer,
  issn character varying,
  signature character varying,
  comment text
) INHERITS (entries);

CREATE TABLE collected_article_entries (
  source_editor character varying,
  source_title text,
  source_subtitle text,
  source_year character varying,
  source_place character varying,
  source_publisher character varying,
  source_edition character varying,
  source_series_title text,
  source_series_volume character varying,
  source_signature character varying,
  source_isbn character varying,
  author character varying,
  title text,
  subtitle text,
  volume character varying,
  pages_from integer,
  pages_to integer,
  comment text
) INHERITS (entries);

--
-- (File) Attachments
--
CREATE TABLE file_attachments (
  id serial NOT NULL PRIMARY KEY,
  creator_id integer REFERENCES users NULL,
  entry_id integer NOT NULL, --REFERENCES entries NOT NULL,
  file_file_name character varying NOT NULL,
  file_content_type character varying NOT NULL,
  file_file_size integer NOT NULL,
  description text,
  scanjob boolean DEFAULT false NOT NULL
);

CREATE INDEX index_file_attachments_on_entry_id ON file_attachments(entry_id);

--
-- Scanjobs
--
CREATE TABLE scanjobs (
  id serial NOT NULL PRIMARY KEY,
  creator_id integer REFERENCES users NULL,
  entry_id integer NOT NULL, --REFERENCES entries NOT NULL,
  "state" character varying,
  message text,
  pages_from integer,
  pages_to integer,
  signature character varying,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE INDEX index_scanjobs_on_entry_id ON scanjobs(entry_id);


--
-- Miless Passwords
--
CREATE TABLE miless_passwords (
  id serial NOT NULL PRIMARY KEY,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  password character varying NOT NULL
);

CREATE INDEX index_miless_passwords_on_password ON miless_passwords(password);
