--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: make_plpgsql(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION make_plpgsql() RETURNS void
    LANGUAGE sql
    AS $$
  CREATE LANGUAGE plpgsql;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: application_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE application_settings (
    id integer NOT NULL,
    transit_source_semester_id integer,
    transit_target_semester_id integer
);


--
-- Name: application_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE application_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE application_settings_id_seq OWNED BY application_settings.id;


--
-- Name: book_shelf_refs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE book_shelf_refs (
    id integer NOT NULL,
    sem_app_id integer NOT NULL,
    sem_app_ref_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: book_shelf_refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE book_shelf_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_shelf_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE book_shelf_refs_id_seq OWNED BY book_shelf_refs.id;


--
-- Name: book_shelves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE book_shelves (
    id integer NOT NULL,
    ils_account character varying NOT NULL,
    slot_number character varying NOT NULL,
    sem_app_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: book_shelves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE book_shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_shelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE book_shelves_id_seq OWNED BY book_shelves.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE books (
    id integer NOT NULL,
    sem_app_id integer NOT NULL,
    creator_id integer,
    placeholder_id integer,
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
    updated_at timestamp without time zone,
    reference_copy integer
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE books_id_seq OWNED BY books.id;


--
-- Name: file_attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE file_attachments (
    id integer NOT NULL,
    creator_id integer,
    file_file_name character varying NOT NULL,
    file_content_type character varying NOT NULL,
    file_file_size integer NOT NULL,
    description text,
    scanjob boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone,
    media_id integer
);


--
-- Name: file_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE file_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE file_attachments_id_seq OWNED BY file_attachments.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    title character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media (
    id integer NOT NULL,
    instance_id integer,
    instance_type character varying(255),
    sem_app_id integer,
    creator_id integer,
    "position" integer,
    miless_entry_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_articles (
    id integer NOT NULL,
    author text,
    title text,
    subtitle text,
    journal text,
    place text,
    publisher text,
    volume text,
    year text,
    issue text,
    pages_from text,
    pages_to text,
    issn text,
    signature text,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_articles_id_seq OWNED BY media_articles.id;


--
-- Name: media_collected_articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_collected_articles (
    id integer NOT NULL,
    source_editor text,
    source_title text,
    source_subtitle text,
    source_year text,
    source_place text,
    source_publisher text,
    source_edition text,
    source_series_title text,
    source_series_volume text,
    source_signature text,
    source_isbn text,
    author text,
    title text,
    subtitle text,
    volume text,
    pages_from text,
    pages_to text,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_collected_articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_collected_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_collected_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_collected_articles_id_seq OWNED BY media_collected_articles.id;


--
-- Name: media_headlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_headlines (
    id integer NOT NULL,
    headline text,
    style integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_headlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_headlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_headlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_headlines_id_seq OWNED BY media_headlines.id;


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: media_monographs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_monographs (
    id integer NOT NULL,
    author text,
    title text,
    subtitle text,
    year text,
    place text,
    publisher text,
    edition text,
    isbn text,
    signature text,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_monographs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_monographs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_monographs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_monographs_id_seq OWNED BY media_monographs.id;


--
-- Name: media_texts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_texts (
    id integer NOT NULL,
    text text,
    publish_on timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_texts_id_seq OWNED BY media_texts.id;


--
-- Name: miless_passwords; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE miless_passwords (
    id integer NOT NULL,
    sem_app_id integer NOT NULL,
    password character varying NOT NULL
);


--
-- Name: miless_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE miless_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: miless_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE miless_passwords_id_seq OWNED BY miless_passwords.id;


--
-- Name: ownerships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ownerships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    sem_app_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ownerships_id_seq OWNED BY ownerships.id;


--
-- Name: scanjobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scanjobs (
    id integer NOT NULL,
    creator_id integer,
    state character varying,
    message text,
    pages_from integer,
    pages_to integer,
    signature character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    comment text,
    media_id integer
);


--
-- Name: scanjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scanjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scanjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scanjobs_id_seq OWNED BY scanjobs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sem_apps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sem_apps (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    semester_id integer NOT NULL,
    location_id integer NOT NULL,
    approved boolean DEFAULT false,
    title character varying NOT NULL,
    tutors text,
    shared_secret character varying,
    course_id character varying,
    miless_document_id character varying,
    miless_derivate_id character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    access_token character varying(255)
);


--
-- Name: sem_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sem_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sem_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sem_apps_id_seq OWNED BY sem_apps.id;


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE semesters (
    id integer NOT NULL,
    current boolean,
    title character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: semesters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE semesters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: semesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE semesters_id_seq OWNED BY semesters.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    login character varying NOT NULL,
    name character varying,
    email character varying,
    is_admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY application_settings ALTER COLUMN id SET DEFAULT nextval('application_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_shelf_refs ALTER COLUMN id SET DEFAULT nextval('book_shelf_refs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_shelves ALTER COLUMN id SET DEFAULT nextval('book_shelves_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY books ALTER COLUMN id SET DEFAULT nextval('books_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_attachments ALTER COLUMN id SET DEFAULT nextval('file_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_articles ALTER COLUMN id SET DEFAULT nextval('media_articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_collected_articles ALTER COLUMN id SET DEFAULT nextval('media_collected_articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_headlines ALTER COLUMN id SET DEFAULT nextval('media_headlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_monographs ALTER COLUMN id SET DEFAULT nextval('media_monographs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_texts ALTER COLUMN id SET DEFAULT nextval('media_texts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY miless_passwords ALTER COLUMN id SET DEFAULT nextval('miless_passwords_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ownerships ALTER COLUMN id SET DEFAULT nextval('ownerships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scanjobs ALTER COLUMN id SET DEFAULT nextval('scanjobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sem_apps ALTER COLUMN id SET DEFAULT nextval('sem_apps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY semesters ALTER COLUMN id SET DEFAULT nextval('semesters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: application_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);


--
-- Name: book_shelf_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_pkey PRIMARY KEY (id);


--
-- Name: book_shelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY book_shelves
    ADD CONSTRAINT book_shelves_pkey PRIMARY KEY (id);


--
-- Name: books_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: file_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY file_attachments
    ADD CONSTRAINT file_attachments_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: media_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_articles
    ADD CONSTRAINT media_articles_pkey PRIMARY KEY (id);


--
-- Name: media_collected_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_collected_articles
    ADD CONSTRAINT media_collected_articles_pkey PRIMARY KEY (id);


--
-- Name: media_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_headlines
    ADD CONSTRAINT media_headlines_pkey PRIMARY KEY (id);


--
-- Name: media_monographs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_monographs
    ADD CONSTRAINT media_monographs_pkey PRIMARY KEY (id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: media_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_texts
    ADD CONSTRAINT media_texts_pkey PRIMARY KEY (id);


--
-- Name: miless_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY miless_passwords
    ADD CONSTRAINT miless_passwords_pkey PRIMARY KEY (id);


--
-- Name: ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ownerships
    ADD CONSTRAINT ownerships_pkey PRIMARY KEY (id);


--
-- Name: scanjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scanjobs
    ADD CONSTRAINT scanjobs_pkey PRIMARY KEY (id);


--
-- Name: sem_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sem_apps
    ADD CONSTRAINT sem_apps_pkey PRIMARY KEY (id);


--
-- Name: semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_application_settings_on_transit_source_semester_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_application_settings_on_transit_source_semester_id ON application_settings USING btree (transit_source_semester_id);


--
-- Name: index_application_settings_on_transit_target_semester_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_application_settings_on_transit_target_semester_id ON application_settings USING btree (transit_target_semester_id);


--
-- Name: index_books_on_ils_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_on_ils_id ON books USING btree (ils_id);


--
-- Name: index_books_on_sem_app_id_and_ils_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_books_on_sem_app_id_and_ils_id ON books USING btree (sem_app_id, ils_id);


--
-- Name: index_books_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_books_on_state ON books USING btree (state);


--
-- Name: index_media_on_instance_id_and_instance_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_on_instance_id_and_instance_type ON media USING btree (instance_id, instance_type);


--
-- Name: index_media_on_sem_app_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_media_on_sem_app_id ON media USING btree (sem_app_id);


--
-- Name: index_miless_passwords_on_password; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_miless_passwords_on_password ON miless_passwords USING btree (password);


--
-- Name: index_ownerships_on_sem_app_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ownerships_on_sem_app_id ON ownerships USING btree (sem_app_id);


--
-- Name: index_ownerships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ownerships_on_user_id ON ownerships USING btree (user_id);


--
-- Name: index_sem_apps_on_miless_derivate_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sem_apps_on_miless_derivate_id ON sem_apps USING btree (miless_derivate_id);


--
-- Name: index_sem_apps_on_miless_document_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sem_apps_on_miless_document_id ON sem_apps USING btree (miless_document_id);


--
-- Name: index_semesters_on_current; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_semesters_on_current ON semesters USING btree (current);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: book_shelf_refs_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES sem_apps(id);


--
-- Name: book_shelf_refs_sem_app_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_sem_app_ref_id_fkey FOREIGN KEY (sem_app_ref_id) REFERENCES sem_apps(id);


--
-- Name: book_shelves_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY book_shelves
    ADD CONSTRAINT book_shelves_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES sem_apps(id);


--
-- Name: books_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: books_placeholder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_placeholder_id_fkey FOREIGN KEY (placeholder_id) REFERENCES sem_apps(id) ON DELETE SET NULL;


--
-- Name: books_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY books
    ADD CONSTRAINT books_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES sem_apps(id);


--
-- Name: file_attachments_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY file_attachments
    ADD CONSTRAINT file_attachments_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: miless_passwords_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY miless_passwords
    ADD CONSTRAINT miless_passwords_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES sem_apps(id);


--
-- Name: ownerships_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ownerships
    ADD CONSTRAINT ownerships_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES sem_apps(id);


--
-- Name: ownerships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ownerships
    ADD CONSTRAINT ownerships_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: scanjobs_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY scanjobs
    ADD CONSTRAINT scanjobs_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: sem_apps_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sem_apps
    ADD CONSTRAINT sem_apps_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: sem_apps_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sem_apps
    ADD CONSTRAINT sem_apps_location_id_fkey FOREIGN KEY (location_id) REFERENCES locations(id);


--
-- Name: sem_apps_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sem_apps
    ADD CONSTRAINT sem_apps_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES semesters(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20091110135349');

INSERT INTO schema_migrations (version) VALUES ('20100316164509');

INSERT INTO schema_migrations (version) VALUES ('20100322151832');

INSERT INTO schema_migrations (version) VALUES ('20100329085726');

INSERT INTO schema_migrations (version) VALUES ('20100331074351');

INSERT INTO schema_migrations (version) VALUES ('20100415105528');

INSERT INTO schema_migrations (version) VALUES ('20100422135750');

INSERT INTO schema_migrations (version) VALUES ('20100429082804');

INSERT INTO schema_migrations (version) VALUES ('20100730093922');

INSERT INTO schema_migrations (version) VALUES ('20131205132010');

INSERT INTO schema_migrations (version) VALUES ('20131206091102');

INSERT INTO schema_migrations (version) VALUES ('20131206102531');

INSERT INTO schema_migrations (version) VALUES ('20131206104235');

INSERT INTO schema_migrations (version) VALUES ('20131206110838');

INSERT INTO schema_migrations (version) VALUES ('20131210183357');

INSERT INTO schema_migrations (version) VALUES ('20131211151702');

INSERT INTO schema_migrations (version) VALUES ('20140122130820');

INSERT INTO schema_migrations (version) VALUES ('20140123162928');

INSERT INTO schema_migrations (version) VALUES ('20140211155653');

INSERT INTO schema_migrations (version) VALUES ('20140212083059');

INSERT INTO schema_migrations (version) VALUES ('20140212083933');
