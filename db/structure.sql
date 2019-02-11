SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: make_plpgsql(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.make_plpgsql() RETURNS void
    LANGUAGE sql
    AS $$
  CREATE LANGUAGE plpgsql;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: application_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_settings (
    id integer NOT NULL,
    transit_source_semester_id integer,
    transit_target_semester_id integer,
    restrict_download_of_files_restricted_by_copyright boolean DEFAULT false NOT NULL
);


--
-- Name: application_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_settings_id_seq OWNED BY public.application_settings.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: book_shelf_refs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_shelf_refs (
    id integer NOT NULL,
    sem_app_id integer NOT NULL,
    sem_app_ref_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: book_shelf_refs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.book_shelf_refs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_shelf_refs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.book_shelf_refs_id_seq OWNED BY public.book_shelf_refs.id;


--
-- Name: book_shelves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_shelves (
    id integer NOT NULL,
    ils_account character varying NOT NULL,
    slot_number character varying NOT NULL,
    sem_app_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    semester_id integer
);


--
-- Name: book_shelves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.book_shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: book_shelves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.book_shelves_id_seq OWNED BY public.book_shelves.id;


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
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

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: file_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_attachments (
    id integer NOT NULL,
    creator_id integer,
    file_file_name character varying NOT NULL,
    file_content_type character varying NOT NULL,
    file_file_size integer NOT NULL,
    description text,
    scanjob boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone,
    media_id integer,
    restricted_by_copyright boolean DEFAULT true NOT NULL
);


--
-- Name: file_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_attachments_id_seq OWNED BY public.file_attachments.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    title character varying NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
    id integer NOT NULL,
    instance_id integer,
    instance_type character varying(255),
    sem_app_id integer,
    creator_id integer,
    "position" integer,
    miless_entry_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hidden boolean DEFAULT false,
    hidden_until timestamp without time zone
);


--
-- Name: media_articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_articles (
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

CREATE SEQUENCE public.media_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_articles_id_seq OWNED BY public.media_articles.id;


--
-- Name: media_collected_articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_collected_articles (
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

CREATE SEQUENCE public.media_collected_articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_collected_articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_collected_articles_id_seq OWNED BY public.media_collected_articles.id;


--
-- Name: media_headlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_headlines (
    id integer NOT NULL,
    headline text,
    style integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_headlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_headlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_headlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_headlines_id_seq OWNED BY public.media_headlines.id;


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: media_monographs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_monographs (
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

CREATE SEQUENCE public.media_monographs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_monographs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_monographs_id_seq OWNED BY public.media_monographs.id;


--
-- Name: media_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_texts (
    id integer NOT NULL,
    text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_texts_id_seq OWNED BY public.media_texts.id;


--
-- Name: miless_passwords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.miless_passwords (
    id integer NOT NULL,
    sem_app_id integer NOT NULL,
    password character varying NOT NULL
);


--
-- Name: miless_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.miless_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: miless_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.miless_passwords_id_seq OWNED BY public.miless_passwords.id;


--
-- Name: ownerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ownerships (
    id integer NOT NULL,
    user_id integer NOT NULL,
    sem_app_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ownerships_id_seq OWNED BY public.ownerships.id;


--
-- Name: scanjobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scanjobs (
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

CREATE SEQUENCE public.scanjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scanjobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scanjobs_id_seq OWNED BY public.scanjobs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sem_apps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sem_apps (
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

CREATE SEQUENCE public.sem_apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sem_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sem_apps_id_seq OWNED BY public.sem_apps.id;


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.semesters (
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

CREATE SEQUENCE public.semesters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: semesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.semesters_id_seq OWNED BY public.semesters.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying NOT NULL,
    name character varying,
    email character varying,
    is_admin boolean DEFAULT false NOT NULL,
    ilsuserid character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: application_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings ALTER COLUMN id SET DEFAULT nextval('public.application_settings_id_seq'::regclass);


--
-- Name: book_shelf_refs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelf_refs ALTER COLUMN id SET DEFAULT nextval('public.book_shelf_refs_id_seq'::regclass);


--
-- Name: book_shelves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelves ALTER COLUMN id SET DEFAULT nextval('public.book_shelves_id_seq'::regclass);


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: file_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_attachments ALTER COLUMN id SET DEFAULT nextval('public.file_attachments_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: media_articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_articles ALTER COLUMN id SET DEFAULT nextval('public.media_articles_id_seq'::regclass);


--
-- Name: media_collected_articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_collected_articles ALTER COLUMN id SET DEFAULT nextval('public.media_collected_articles_id_seq'::regclass);


--
-- Name: media_headlines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_headlines ALTER COLUMN id SET DEFAULT nextval('public.media_headlines_id_seq'::regclass);


--
-- Name: media_monographs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_monographs ALTER COLUMN id SET DEFAULT nextval('public.media_monographs_id_seq'::regclass);


--
-- Name: media_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_texts ALTER COLUMN id SET DEFAULT nextval('public.media_texts_id_seq'::regclass);


--
-- Name: miless_passwords id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.miless_passwords ALTER COLUMN id SET DEFAULT nextval('public.miless_passwords_id_seq'::regclass);


--
-- Name: ownerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships ALTER COLUMN id SET DEFAULT nextval('public.ownerships_id_seq'::regclass);


--
-- Name: scanjobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scanjobs ALTER COLUMN id SET DEFAULT nextval('public.scanjobs_id_seq'::regclass);


--
-- Name: sem_apps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sem_apps ALTER COLUMN id SET DEFAULT nextval('public.sem_apps_id_seq'::regclass);


--
-- Name: semesters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.semesters ALTER COLUMN id SET DEFAULT nextval('public.semesters_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: application_settings application_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: book_shelf_refs book_shelf_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_pkey PRIMARY KEY (id);


--
-- Name: book_shelves book_shelves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelves
    ADD CONSTRAINT book_shelves_pkey PRIMARY KEY (id);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- Name: file_attachments file_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_attachments
    ADD CONSTRAINT file_attachments_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: media_articles media_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_articles
    ADD CONSTRAINT media_articles_pkey PRIMARY KEY (id);


--
-- Name: media_collected_articles media_collected_articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_collected_articles
    ADD CONSTRAINT media_collected_articles_pkey PRIMARY KEY (id);


--
-- Name: media_headlines media_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_headlines
    ADD CONSTRAINT media_headlines_pkey PRIMARY KEY (id);


--
-- Name: media_monographs media_monographs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_monographs
    ADD CONSTRAINT media_monographs_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: media_texts media_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_texts
    ADD CONSTRAINT media_texts_pkey PRIMARY KEY (id);


--
-- Name: miless_passwords miless_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.miless_passwords
    ADD CONSTRAINT miless_passwords_pkey PRIMARY KEY (id);


--
-- Name: ownerships ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships
    ADD CONSTRAINT ownerships_pkey PRIMARY KEY (id);


--
-- Name: scanjobs scanjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scanjobs
    ADD CONSTRAINT scanjobs_pkey PRIMARY KEY (id);


--
-- Name: sem_apps sem_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sem_apps
    ADD CONSTRAINT sem_apps_pkey PRIMARY KEY (id);


--
-- Name: semesters semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_application_settings_on_transit_source_semester_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_settings_on_transit_source_semester_id ON public.application_settings USING btree (transit_source_semester_id);


--
-- Name: index_application_settings_on_transit_target_semester_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_settings_on_transit_target_semester_id ON public.application_settings USING btree (transit_target_semester_id);


--
-- Name: index_books_on_ils_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_ils_id ON public.books USING btree (ils_id);


--
-- Name: index_books_on_sem_app_id_and_ils_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_books_on_sem_app_id_and_ils_id ON public.books USING btree (sem_app_id, ils_id);


--
-- Name: index_books_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_books_on_state ON public.books USING btree (state);


--
-- Name: index_media_on_instance_id_and_instance_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_instance_id_and_instance_type ON public.media USING btree (instance_id, instance_type);


--
-- Name: index_media_on_sem_app_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_sem_app_id ON public.media USING btree (sem_app_id);


--
-- Name: index_miless_passwords_on_password; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_miless_passwords_on_password ON public.miless_passwords USING btree (password);


--
-- Name: index_ownerships_on_sem_app_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_sem_app_id ON public.ownerships USING btree (sem_app_id);


--
-- Name: index_ownerships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_user_id ON public.ownerships USING btree (user_id);


--
-- Name: index_sem_apps_on_miless_derivate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sem_apps_on_miless_derivate_id ON public.sem_apps USING btree (miless_derivate_id);


--
-- Name: index_sem_apps_on_miless_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sem_apps_on_miless_document_id ON public.sem_apps USING btree (miless_document_id);


--
-- Name: index_semesters_on_current; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_semesters_on_current ON public.semesters USING btree (current);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_ilsuserid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_ilsuserid ON public.users USING btree (ilsuserid);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_login ON public.users USING btree (login);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: book_shelf_refs book_shelf_refs_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES public.sem_apps(id);


--
-- Name: book_shelf_refs book_shelf_refs_sem_app_ref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelf_refs
    ADD CONSTRAINT book_shelf_refs_sem_app_ref_id_fkey FOREIGN KEY (sem_app_ref_id) REFERENCES public.sem_apps(id);


--
-- Name: book_shelves book_shelves_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_shelves
    ADD CONSTRAINT book_shelves_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES public.sem_apps(id);


--
-- Name: books books_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: books books_placeholder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_placeholder_id_fkey FOREIGN KEY (placeholder_id) REFERENCES public.sem_apps(id) ON DELETE SET NULL;


--
-- Name: books books_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES public.sem_apps(id);


--
-- Name: file_attachments file_attachments_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_attachments
    ADD CONSTRAINT file_attachments_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: miless_passwords miless_passwords_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.miless_passwords
    ADD CONSTRAINT miless_passwords_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES public.sem_apps(id);


--
-- Name: ownerships ownerships_sem_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships
    ADD CONSTRAINT ownerships_sem_app_id_fkey FOREIGN KEY (sem_app_id) REFERENCES public.sem_apps(id);


--
-- Name: ownerships ownerships_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships
    ADD CONSTRAINT ownerships_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: scanjobs scanjobs_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scanjobs
    ADD CONSTRAINT scanjobs_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: sem_apps sem_apps_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sem_apps
    ADD CONSTRAINT sem_apps_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: sem_apps sem_apps_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sem_apps
    ADD CONSTRAINT sem_apps_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: sem_apps sem_apps_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sem_apps
    ADD CONSTRAINT sem_apps_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES public.semesters(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20091110135349'),
('20100316164509'),
('20100322151832'),
('20100329085726'),
('20100331074351'),
('20100415105528'),
('20100422135750'),
('20100429082804'),
('20100730093922'),
('20131205132010'),
('20131206091102'),
('20131206102531'),
('20131206104235'),
('20131206110838'),
('20131210183357'),
('20131211151702'),
('20140122130820'),
('20140123162928'),
('20140211155653'),
('20140212083059'),
('20140212083933'),
('20140314111534'),
('20140317105704'),
('20150703070412'),
('20161201103459'),
('20161201115436'),
('20170405074158'),
('20170405075029'),
('20170407085332'),
('20180912131113'),
('20190211105330');


