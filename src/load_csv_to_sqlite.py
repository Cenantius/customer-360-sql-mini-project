from pathlib import Path
import sqlite3

import pandas as pd

# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"
DATABASE_PATH = PROJECT_ROOT / "data" / "customer360.db"

def load_csv_to_sqlite(csv_filename: str, table_name: str, connection: sqlite3.Connection) -> None:
    """
    Load one CSV file into a SQLite database table.

    Args:
        csv_filename: Name of the CSV file in data/raw.
        table_name: Name of the database table to create or replace.
        connection: SQLite database connection. 
    """

    csv_path = RAW_DATA_DIR / csv_filename

    df = pd.read_csv(csv_path)

    # Take pandas DataFrame -> export to SQLite -> if the table exists, replace -> don't add additional pandas-idex-column
    df.to_sql(
        name=table_name,
        con=connection,
        if_exists="replace",
        index=False
    )

    print(f"Loaded {csv_filename} into table: {table_name}")

def main() -> None:
    """
    Main execution function.
    """

    DATABASE_PATH.parent.mkdir(parents=True, exist_ok=True)

    connection = sqlite3.connect(DATABASE_PATH)

    load_csv_to_sqlite("customers.csv", "customers", connection)
    load_csv_to_sqlite("orders.csv", "orders", connection)
    load_csv_to_sqlite("website_sessions.csv", "website_sessions", connection)
    load_csv_to_sqlite("email_campaigns.csv", "email_campaigns", connection)
    load_csv_to_sqlite("email_events.csv", "email_events", connection)

    connection.close()

    print(f"Database created at: {DATABASE_PATH}")


if __name__ == "__main__":
    main()