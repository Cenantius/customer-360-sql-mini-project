from pathlib import Path
import random

import pandas as pd
from faker import Faker

# Initialize Faker
fake = Faker()

# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

def generate_email_campaigns(number_of_campaigns: int = 10) -> pd.DataFrame:
    """
    Generate fake email campaign data for the Customer 360 project.

    Args:
        number_of_campaigns: Number of email campaigns to generate.

    Returns:
        A pandas DataFrame containing email campaign data.
    """

    campaigns = []

    campaign_types = [
        "newsletter",
        "promotion",
        "product_launch",
        "winback",
        "seasonal_sale",
    ]

    campaign_names = [
        "Spring Sale",
        "Summer Deals",
        "Autumn Collection",
        "Winter Offers",
        "New Product Launch",
        "Customer Winback",
        "VIP Discount",
        "Black Friday",
        "Cyber Monday",
        "Monthly Newsletter",
    ]

    for campaign_id in range(1, number_of_campaigns + 1):

        campaign = {
            "campaign_id": campaign_id,
            "campaign_name": campaign_names[campaign_id - 1],
            "campaign_type": random.choice(campaign_types),
            "send_date": fake.date_between(start_date="-1y", end_date="today"),
        }

        campaigns.append(campaign)

    return pd.DataFrame(campaigns)


def save_email_campaigns_csv(campaigns_df: pd.DataFrame) -> None:
    """
    Save generated email campaigns to data/raw/email_campaigns.csv.
    """

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    output_path = RAW_DATA_DIR / "email_campaigns.csv"

    campaigns_df.to_csv(output_path, index=False)

    print(f"Generated {len(campaigns_df)} email campaigns")
    print(f"Saved file to: {output_path}")


def main() -> None:
    """
    Main execution function.
    """

    campaigns_df = generate_email_campaigns(number_of_campaigns=10)

    save_email_campaigns_csv(campaigns_df)


if __name__ == "__main__":
    main()