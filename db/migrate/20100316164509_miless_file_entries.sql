CREATE TABLE miless_file_entries (
  title text,
  author character varying,
  comment text,
  pages_from integer,
  pages_to integer,

  source_title text,
  source_editor character varying,
  source_edition character varying,
  source_year character varying,
  source_publisher character varying,
  source_place character varying,
  source_ref character varying,
  source_signature character varying
) INHERITS (entries);