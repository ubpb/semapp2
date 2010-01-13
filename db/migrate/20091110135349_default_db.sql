--
-- Users
--
CREATE TABLE users (
  id serial NOT NULL PRIMARY KEY,
  login character varying(255) NOT NULL,
  "name" character varying(255) NOT NULL,
  email character varying(255) NULL
);

CREATE UNIQUE INDEX index_users_on_login ON users(login);
CREATE INDEX index_users_on_email ON users(email);

--
-- Sessions
--
CREATE TABLE sessions (
  id serial NOT NULL PRIMARY KEY,
  session_id character varying(255) NOT NULL,
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
  name character varying(255) NOT NULL,
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
  title character varying(255) NOT NULL,
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
  title character varying(255) NOT NULL,
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
  title character varying(255) NOT NULL,
  tutors text NOT NULL,
  shared_secret character varying(255) NOT NULL,
  course_id character varying(255),
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_sem_apps_on_semester_id_and_title ON sem_apps(semester_id, title);
CREATE UNIQUE INDEX index_sem_apps_on_semester_id_and_course_id ON sem_apps(semester_id, course_id);


--
-- Book Shelves
--
CREATE TABLE book_shelves (
  id serial NOT NULL PRIMARY KEY,
  ils_account character varying(255) NOT NULL,
  slot_number character varying(255) NOT NULL,
  sem_app_id integer REFERENCES sem_apps,
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
  ils_id character varying(255) NOT NULL,
  signature character varying(255) NOT NULL,
  title character varying(255) NOT NULL,
  author character varying(255) NOT NULL,
  edition character varying(255),
  place character varying(255),
  publisher character varying(255),
  year character varying(255),
  isbn character varying(255),
  comment text,
  scheduled_for_addition boolean DEFAULT false NOT NULL,
  scheduled_for_removal boolean DEFAULT false NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE UNIQUE INDEX index_books_on_sem_app_id_and_ils_id ON books(sem_app_id, ils_id);
CREATE INDEX index_books_on_ils_id ON books(ils_id);
CREATE INDEX index_books_on_scheduled_for_addition ON books(scheduled_for_addition);
CREATE INDEX index_books_on_scheduled_for_removal ON books(scheduled_for_removal);

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
-- SemApp entries & attachments
--
CREATE TABLE sem_app_entries (
  id serial NOT NULL PRIMARY KEY,
  sem_app_id integer REFERENCES sem_apps NOT NULL,
  "position" integer,
  publish_on timestamp without time zone,
  created_at timestamp without time zone,
  updated_at timestamp without time zone
);

CREATE TABLE sem_app_text_entries (
  body_text text NOT NULL
) INHERITS (sem_app_entries);

CREATE TABLE sem_app_headline_entries (
  headline character varying(255) NOT NULL
) INHERITS (sem_app_entries);

CREATE TABLE sem_app_file_entries (
  description text NOT NULL
) INHERITS (sem_app_entries);

CREATE TABLE sem_app_monograph_reference_entries (
  author character varying NOT NULL,
  title text NOT NULL,
  subtitle text,
  "year" character varying,
  place character varying,
  publisher character varying,
  edition character varying,
  url character varying,
  isbn character varying
) INHERITS (sem_app_entries);

CREATE TABLE sem_app_article_reference_entries (
  author character varying NOT NULL,
  title text NOT NULL,
  subtitle text,
  journal character varying,
  volume character varying,
  "year" character varying,
  issue character varying,
  pages character varying,
  url character varying,
  issn character varying
) INHERITS (sem_app_entries);

CREATE TABLE sem_app_collected_article_reference_entries (
  source_editor character varying NOT NULL,
  source_title text,
  source_subtitle text,
  source_year character varying,
  source_place character varying,
  source_publisher character varying,
  source_edition character varying,
  source_series_title text,
  source_series_volume character varying,
  author character varying,
  title text,
  subtitle text,
  volume character varying,
  pages character varying,
  url character varying
) INHERITS (sem_app_entries);

CREATE TABLE attachments (
  id serial NOT NULL PRIMARY KEY,
  sem_app_entry_id integer NOT NULL, --REFERENCES sem_app_entries(id) DEFERRABLE INITIALLY DEFERRED NOT NULL,
  attachable_file_name character varying(255) NOT NULL,
  attachable_content_type character varying(255) NOT NULL,
  attachable_file_size integer NOT NULL,
  description text
);
