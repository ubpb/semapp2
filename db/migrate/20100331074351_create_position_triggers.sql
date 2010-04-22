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


CREATE OR REPLACE FUNCTION update_positions() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    update entries set position=position+1 where
      sem_app_id=NEW.sem_app_id and position >= NEW.position;
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    update entries set position=position-1 where
      sem_app_id=OLD.sem_app_id and position > OLD.position;
    RETURN OLD;
  END IF;
  RETURN NULL;
END $$ LANGUAGE 'plpgsql';


CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  headline_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();

CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  text_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();

CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  monograph_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();

CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  article_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();

CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  collected_article_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();

CREATE TRIGGER update_positions_trigger BEFORE INSERT OR DELETE ON
  miless_file_entries FOR EACH ROW EXECUTE PROCEDURE update_positions();


CREATE OR REPLACE FUNCTION reorder(integer, integer[]) RETURNS VOID AS $$
DECLARE
  var_sem_app_id       ALIAS FOR $1;
  var_new_order        ALIAS FOR $2;
  var_array_upbound    integer;
BEGIN
  var_array_upbound := ARRAY_UPPER(var_new_order, 1);

  UPDATE entries SET
    position = moo.p
      FROM (
        SELECT position as p, sem_app.ids[position] AS sid
          FROM (
            SELECT var_new_order
          ) AS sem_app(ids), generate_series(1, var_array_upbound) AS position
      ) AS moo
      WHERE id = moo.sid and sem_app_id = var_sem_app_id;
  NULL;
END
$$ LANGUAGE 'plpgsql';

