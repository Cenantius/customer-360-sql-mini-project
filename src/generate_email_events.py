from pathlib import Path
import random

import pandas as pd
from faker import Faker

# Initialize Faker
fake = Faker()

# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

def generate_email_events(
    customers_df: pd.DataFrame,
    campaigns_df: pd.DataFrame
) -> pd.DataFrame:
    """
    Generate fake email event data for the Customer 360 project.

    Args:
        customers_df: DataFrame containing customer data.
        campaigns_df: DataFrame containing email campaign data.

    Returns:
        A pandas DataFrame containing email event data.
    """

    events = []

    event_id = 1

    for _, campaign in campaigns_df.iterrows():

        # Each campaign is sent to a random sample of customers
        campaign_customers = customers_df.sample(
            n=random.randint(40, 90),
            random_state=None
        )

        for _, customer in campaign_customers.iterrows():

            # Every selected customer receives the email
            sent_event = {
                "event_id": event_id,
                "campaign_id": campaign["campaign_id"],
                "customer_id": customer["customer_id"],
                "event_type": "sent",
                "event_date": campaign["send_date"],
            }

            events.append(sent_event)
            event_id += 1

            # Some customers open the email
            opened = random.choice([True, True, False])

            if opened:
                open_event = {
                    "event_id": event_id,
                    "campaign_id": campaign["campaign_id"],
                    "customer_id": customer["customer_id"],
                    "event_type": "open",
                    "event_date": fake.date_between(
                        start_date=campaign["send_date"],
                        end_date="today"
                    ),
                }

                events.append(open_event)
                event_id += 1

                # Some customers who opened also click
                clicked = random.choice([True, False, False])

                if clicked:
                    click_event = {
                        "event_id": event_id,
                        "campaign_id": campaign["campaign_id"],
                        "customer_id": customer["customer_id"],
                        "event_type": "click",
                        "event_date": fake.date_between(
                            start_date=campaign["send_date"],
                            end_date="today"
                        ),
                    }

                    events.append(click_event)
                    event_id += 1

                    # Some customers who clicked also purchase
                    purchased = random.choice([True, False, False, False])

                    if purchased:
                        purchase_event = {
                            "event_id": event_id,
                            "campaign_id": campaign["campaign_id"],
                            "customer_id": customer["customer_id"],
                            "event_type": "purchase",
                            "event_date": fake.date_between(
                                start_date=campaign["send_date"],
                                end_date="today"
                            ),
                        }

                        events.append(purchase_event)
                        event_id += 1

    return pd.DataFrame(events)

def save_email_events_csv(events_df: pd.DataFrame) -> None:
    """
    Save generated email events to data/raw/email_events.csv.
    """

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    output_path = RAW_DATA_DIR / "email_events.csv"

    events_df.to_csv(output_path, index=False)

    print(f"Generated {len(events_df)} email events")
    print(f"Saved file to: {output_path}")


def main() -> None:
    """
    Main execution function.
    """

    customers_path = RAW_DATA_DIR / "customers.csv"
    campaigns_path = RAW_DATA_DIR / "email_campaigns.csv"

    customers_df = pd.read_csv(customers_path)
    campaigns_df = pd.read_csv(campaigns_path)

    campaigns_df["send_date"] = pd.to_datetime(campaigns_df["send_date"]).dt.date

    events_df = generate_email_events(customers_df, campaigns_df)

    save_email_events_csv(events_df)


if __name__ == "__main__":
    main()