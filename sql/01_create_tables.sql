DROP TABLE IF EXISTS email_events;
DROP TABLE IF EXISTS email_campaigns;
DROP TABLE IF EXISTS website_sessions;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    city TEXT,
    age_group TEXT,
    created_at TEXT NOT NULL,,
    marketing_consent INTEGER NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    total_amount REAL NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE website_sessions (
    session_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    session_date TEXT NOT NULL,
    channel TEXT NOT NULL,
    landing_page TEXT NOT NULL,
    device TEXT NOT NULL,
    converted INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE email_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name TEXT NOT NULL,
    campaign_type TEXT NOT NULL,
    sent_date TEXT NOT NULL
);

CREATE TABLE email_events (
    event_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    campaign_id INTEGER NOT NULL,
    event_type TEXT NOT NULL,
    event_time TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES email_campaigns(campaign_id)
);