import psycopg2
import psycopg2.extras

def connect():
  conn = psycopg2.connect(
    # dbname = '', A REMPLACER AVEC LE NOM DE LA DB
    # host = '', LE HOST, SI IL Y EN A UN
    # password = "", LE MOT DE PASSE, SI IL Y EN A UN
    cursor_factory = psycopg2.extras.NamedTupleCursor
    )
  conn.autocommit = True
  return conn
