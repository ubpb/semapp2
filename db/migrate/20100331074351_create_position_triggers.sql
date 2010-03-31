CREATE OR REPLACE FUNCTION make_plpgsql()
RETURNS VOID
LANGUAGE SQL
AS $$
  CREATE LANGUAGE plpgsql;
$$;

SELECT
    CASE
    WHEN EXISTS(
        SELECT 1
        FROM pg_catalog.pg_language
        WHERE lanname='plpgsql'
    )
    THEN NULL
    ELSE make_plpgsql() END;



CREATE OR REPLACE FUNCTION resync_position() RETURNS TRIGGER
AS $$ BEGIN
  CASE TG_OP
    WHEN 'INSERT' THEN
      update entries set position=position+1 where
        sem_app_id=NEW.sem_app_id and position >= NEW.position;
      RETURN NEW;
    WHEN 'DELETE' THEN
      update entries set position=position-1 where
        sem_app_id=OLD.sem_app_id and position > OLD.position;
      return OLD;
  END CASE;
END $$ LANGUAGE 'plpgsql';


CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  headline_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();

CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  text_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();

CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  monograph_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();

CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  article_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();

CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  collected_article_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();

CREATE TRIGGER id_manage_trigger BEFORE INSERT OR DELETE ON
  miless_file_entries FOR EACH ROW EXECUTE PROCEDURE resync_position();