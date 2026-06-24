python
// scripts/migrate.py
"""Apply Supabase migrations in order."""
import os
from pathlib import Path
import psycopg2

MIGRATIONS_DIR = Path(__file__).parent.parent / 'supabase' / 'migrations'


def run_migrations() -> None:
    """Connect to the database and execute every .sql migration in lexical order."""
    database_url = os.environ.get('DATABASE_URL')
    if not database_url:
        raise RuntimeError('DATABASE_URL environment variable is not set.')

    conn = psycopg2.connect(database_url)
    try:
        cur = conn.cursor()
        for sql_file in sorted(MIGRATIONS_DIR.glob('*.sql')):
            sql_text = sql_file.read_text(encoding='utf-8')
            cur.execute(sql_text)
            print(f'Applied migration: {sql_file.name}')
        conn.commit()
        cur.close()
    finally:
        conn.close()


if __name__ == '__main__':
    run_migrations()
    print('All migrations applied.')

