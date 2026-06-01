from pathlib import Path
import random

import pandas as pd
from faker import Faker

# Initialize Faker
fake = Faker()

# Define project paths
# "__file__" = the location of this exact Python file
# ".parents[0]" == cd ..
# ".parents[1]" == cd ../..
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

# 100 is the default number of customers here, if not given a parameter
def generate_customers(number_of_customers: int = 100) -> pd.DataFrame:
    """
    Generate fake customer data for the Customer 360 project.

    Args:
        number_of_customers: Number of customers to generate.

    Returns:
        A pandas DataFrame containing customer data.
    """

    customers = []

    cities = [
        "Helsinki",
        "Espoo",
        "Tampere",
        "Turku",
        "Oulu",
        "Vantaa",
        "Jyväskylä",
        "Lahti",
    ]

    age_groups = [
        "18-24",
        "25-34",
        "35-44",
        "45-54",
        "55-64",
        "65+",
    ]

    # range(1, 101) = 1-100
    for customer_id in range(1, number_of_customers + 1):
        first_name = fake.first_name()
        last_name = fake.last_name()

        # Python's dictionary aka key-value structure
        customer = {
            "customer_id": customer_id,
            "first_name": first_name,
            "last_name": last_name,
            # F-string structure (variables can be applied)
            "email": f"{first_name.lower()}.{last_name.lower()}{customer_id}@example.com",
            "city": random.choice(cities),
            "age_group": random.choice(age_groups),
            "signup_date": fake.date_between(start_date="-2y", end_date="today"),
            "marketing_consent": random.choice([True, False]),
        }

        customers.append(customer)

    return pd.DataFrame(customers)

# "-> None:" = this function has no return value, it only saves a file
def save_customers_csv(customers_df: pd.DataFrame) -> None:
    """
    Save generated customers to data/raw/customers.csv.
    """
    # "parents=True" = create the path folders, if there aren't any
    # "exist_ok=True" = don't stop at an error, even if the path folders are there 
    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    output_path = RAW_DATA_DIR / "customers.csv"

    # "index=False" = don't create a row-index
    customers_df.to_csv(output_path, index=False)

    # len = length (how many customers are created)
    print(f"Generated {len(customers_df)} customers")
    print(f"Saved file to: {output_path}")

def main() -> None:
    customers_df = generate_customers(number_of_customers=100)
    save_customers_csv(customers_df)

# If this file is ran, run the main()-function
if __name__ == "__main__":
    main()