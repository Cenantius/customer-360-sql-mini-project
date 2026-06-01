from pathlib import Path
import random

import pandas as pd
from faker import Faker

# Initialize Faker
fake = Faker()

# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

def generate_website_sessions(customers_df: pd.DataFrame) -> pd.DataFrame:
    """
    Generate fake website session data for the Customer 360 project.
    
    Args:
        customers_df: DataFrame containing customer data.
        
    Returns:
        A pandas DataFrame containing website session data.
    """

    sessions = []

    session_id = 1

    channels = [
        "google",
        "facebook",
        "instagram",
        "email",
        "direct",
        "organic",
        "paid_search",
    ]

    device_types = [
        "desktop",
        "mobile",
        "tablet",
    ]

    landing_pages = [
        "/",
        "/products",
        "/sale",
        "/new-arrivals",
        "/about",
        "/contact",
    ]

    # Loop through all customers
    for _, customer in customers_df.iterrows():

        # Each customer can have 1-15 website sessions
        number_of_sessions = random.randint(1, 15)

        for _ in range(number_of_sessions):

            channel = random.choice(channels)

            # Simple conversion logic:
            # email and paid_search are slightly more likely to convert
            if channel in ["email", "paid_search"]:
                converted = random.choice([True, False, False])
            else:
                converted = random.choice([True, False, False, False, False])

            session = {
                "session_id": session_id,
                "customer_id": customer["customer_id"],
                "session_date": fake.date_between(
                    start_date=customer["signup_date"],
                    end_date="today"
                ),
                "channel": channel,
                "device_type": random.choice(device_types),
                "landing_page": random.choice(landing_pages),
                "converted": converted,
            }

            sessions.append(session)

            session_id += 1

    return pd.DataFrame(sessions)

def save_website_sessions_csv(sessions_df: pd.DataFrame) -> None:
    """
    Save generated website sessions to data/raw/website_sessions.csv.
    """

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    output_path = RAW_DATA_DIR / "website_sessions.csv"

    sessions_df.to_csv(output_path, index=False)

    print(f"Generated {len(sessions_df)} website sessions")
    print(f"Saved file to: {output_path}")

def main() -> None:
    """
    Main execution function.
    """

    customers_path = RAW_DATA_DIR / "customers.csv"

    customers_df = pd.read_csv(customers_path)

    # Convert signup_date from text into proper date type
    customers_df["signup_date"] = pd.to_datetime(customers_df["signup_date"]).dt.date

    sessions_df = generate_website_sessions(customers_df)

    save_website_sessions_csv(sessions_df)


if __name__ == "__main__":
    main()