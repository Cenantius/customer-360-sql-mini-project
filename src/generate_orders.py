from pathlib import Path
import random

import pandas as pd
from faker import Faker

# Initialize Faker
fake = Faker()

# Define project paths
PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"


def generate_orders(customers_df: pd.DataFrame) -> pd.DataFrame:
    """
    Generate fake order data for the Customer 360 project.

    Args:
        customers_df: DataFrame containing customer data.

    Returns:
        A pandas DataFrame containing order data.
    """

    orders = []

    # Unique order ID counter
    order_id = 1

    # Loop through all customers
    for _, customer in customers_df.iterrows():

        # Each customer can have 0-10 orders
        number_of_orders = random.randint(0, 10)

        # Generate orders for this customer
        # We use "_" as the variable name since we don't need the actual value from the loop
        for _ in range(number_of_orders):

            order = {
                "order_id": order_id,
                "customer_id": customer["customer_id"],
                "order_date": fake.date_between(
                    start_date=customer["signup_date"],
                    end_date="today"
                ),
                "order_amount": round(random.uniform(20, 500), 2),
                "order_status": random.choice([
                    "completed",
                    "completed",
                    "completed",
                    "cancelled",
                    "refunded"
                ])
            }

            orders.append(order)

            # Increase order ID
            order_id += 1

    return pd.DataFrame(orders)


def save_orders_csv(orders_df: pd.DataFrame) -> None:
    """
    Save generated orders to data/raw/orders.csv.
    """

    RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)

    output_path = RAW_DATA_DIR / "orders.csv"

    orders_df.to_csv(output_path, index=False)

    print(f"Generated {len(orders_df)} orders")
    print(f"Saved file to: {output_path}")


def main() -> None:
    """
    Main execution function.
    """

    customers_path = RAW_DATA_DIR / "customers.csv"

    customers_df = pd.read_csv(customers_path)
    
    # FIX: convert signup_date to proper date type
    customers_df["signup_date"] = pd.to_datetime(customers_df["signup_date"]).dt.date

    orders_df = generate_orders(customers_df)

    save_orders_csv(orders_df)


# Run the script
if __name__ == "__main__":
    main()