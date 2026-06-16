# ETL-loader (Extract, Transform, Load)
# Path helps build paths safely
from pathlib import Path
# os reads environment variables (.env)
import os

# pandas reads CSV-files
import pandas as pd
# pyodbc connects Python to the Azure SQL Database
import pyodbc
# load_dotenv reads the .env-file
from dotenv import load_dotenv

# Finds the project root and data/raw
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

# Connect to the Azure SQL Database
def get_connection() -> pyodbc.Connection:
    """
    Create a connection to Azure SQL Database using environment variables.
    """

    load_dotenv()

    server = os.getenv("AZURE_SQL_SERVER")
    database = os.getenv("AZURE_SQL_DATABASE")
    username = os.getenv("AZURE_SQL_USERNAME")
    password = os.getenv("AZURE_SQL_PASSWORD")

    connection_string = (
        # Microsoft Windows driver, which lets Python communicate with the SQL Server / Azure SQL DB
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER=tcp:{server},1433;"
        f"DATABASE={database};"
        f"UID={username};"
        f"PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )

    # Opens the correct database connection and returns it to the rest of the code
    return pyodbc.connect(connection_string)

def load_csv_to_table(
        csv_filename: str,
        table_name: str,
        connection: pyodbc.Connection
) -> None:
    """
    Load a CSV file into an existing Azure SQL table.

    Args:
        csv_filename: Name of the CSV file in data/raw.
        table_name: Target Azure SQL table name.
        connection: Active Azure SQL connection.
    """

    csv_path = RAW_DATA_DIR / csv_filename

    df = pd.read_csv(csv_path)

    cursor = connection.cursor()

    # Clear the existing table before loading fresh data
    cursor.execute(f"DELETE FROM {table_name};")
    connection.commit()

    columns = list(df.columns)

    column_names = ", ".join(columns)

    # if there are 4 columns, this becomes "?, ?, ?, "
    # in pyodbc, "?" is a parameter
    placeholders = ", ".join(["?"] * len(columns))

    insert_sql = f"""
    INSERT INTO {table_name} ({column_names})
    VALUES ({placeholders});
    """

    # This changes the DataFrame rows into tuples
    rows = [tuple(row) for row in df.itertuples(index=False, name=None)]

    # This speeds up the upload of multiple rows into SQL Server
    cursor.fast_executemany = True
    cursor.executemany(insert_sql, rows)
    connection.commit()

    print(f"Loaded {len(df)} rows into {table_name}")

def main() -> None:
    """
    Load all generated CSV files into Azure SQL Database.
    """

    connection = get_connection()

    cursor = connection.cursor()

    cursor.execute("SELECT DB_NAME();")
    print("Connected to database:", cursor.fetchone()[0])

    try:
        # Load parent tables first
        load_csv_to_table("customers.csv", "customers", connection)
        load_csv_to_table("email_campaigns.csv", "email_campaigns", connection)

        # Load child tables after parent tables
        load_csv_to_table("orders.csv", "orders", connection)
        load_csv_to_table("website_sessions.csv", "website_sessions", connection)
        load_csv_to_table("email_events.csv", "email_events", connection)

        print("All CSV files loaded into Azure SQL successfully.")

    finally:
        connection.close()

if __name__ == "__main__":
    main()