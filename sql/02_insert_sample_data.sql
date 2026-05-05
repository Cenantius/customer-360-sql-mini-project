INSERT INTO customers 
(customer_id, first_name, last_name, email, city, age_group, created_at, marketing_consent)
VALUES
(1, 'Aino', 'Korhonen', 'aino.korhonen@example.com', 'Helsinki', '25-34', '2024-01-15', 1),
(2, 'Mikko', 'Laine', 'mikko.laine@example.com', 'Tampere', '35-44', '2024-02-10', 1),
(3, 'Sara', 'Nieminen', 'sara.nieminen@example.com', 'Turku', '18-24', '2024-03-05', 0),
(4, 'Janne', 'Virtanen', 'janne.virtanen@example.com', 'Oulu', '45-54', '2024-01-22', 1),
(5, 'Emma', 'Heikkinen', 'emma.heikkinen@example.com', 'Espoo', '25-34', '2024-04-18', 1),
(6, 'Laura', 'Salonen', 'laura.salonen@example.com', 'Helsinki', '35-44', '2024-05-02', 0),
(7, 'Oskari', 'Mäkinen', 'oskari.makinen@example.com', 'Tampere', '25-34', '2024-02-27', 1),
(8, 'Noora', 'Koskinen', 'noora.koskinen@example.com', 'Lahti', '18-24', '2024-06-11', 1);

INSERT INTO orders
(order_id, customer_id, order_date, total_amount, status)
VALUES
(1, 1, '2024-02-01', 89.90, 'completed'),
(2, 1, '2024-03-15', 129.00, 'completed'),
(3, 2, '2024-03-20', 59.50, 'completed'),
(4, 4, '2024-04-02', 249.00, 'completed'),
(5, 5, '2024-05-10', 39.90, 'completed'),
(6, 5, '2024-06-01', 149.90, 'completed'),
(7, 7, '2024-06-05', 19.90, 'cancelled'),
(8, 8, '2024-07-12', 79.90, 'completed');

INSERT INTO website_sessions
(session_id, customer_id, session_date, channel, landing_page, device, converted)
VALUES
(1, 1, '2024-02-01', 'organic_search', '/products', 'mobile', 1),
(2, 1, '2024-03-14', 'email', '/campaign/spring', 'desktop', 1),
(3, 2, '2024-03-19', 'paid_search', '/products', 'mobile', 1),
(4, 3, '2024-03-21', 'organic_search', '/blog', 'mobile', 0),
(5, 4, '2024-04-01', 'direct', '/products', 'desktop', 1),
(6, 5, '2024-05-10', 'social', '/campaign/summer', 'mobile', 1),
(7, 6, '2024-05-12', 'organic_search', '/blog', 'desktop', 0),
(8, 7, '2024-06-05', 'email', '/campaign/summer', 'mobile', 0),
(9, 8, '2024-07-12', 'paid_search', '/products', 'desktop', 1),
(10, NULL, '2024-07-13', 'organic_search', '/blog', 'mobile', 0);

INSERT INTO email_campaigns
(campaign_id, campaign_name, campaign_type, sent_date)
VALUES
(1, 'Spring Sale', 'promotion', '2024-03-10'),
(2, 'Summer Launch', 'promotion', '2024-06-01'),
(3, 'Welcome Flow', 'automation', '2024-01-01');

INSERT INTO email_events
(event_id, customer_id, campaign_id, event_type, event_time)
VALUES
(1, 1, 1, 'open', '2024-03-10 09:15:00'),
(2, 1, 1, 'click', '2024-03-10 09:20:00'),
(3, 1, 1, 'purchase', '2024-03-15 14:30:00'),
(4, 2, 1, 'open', '2024-03-10 10:05:00'),
(5, 5, 2, 'open', '2024-06-01 08:45:00'),
(6, 5, 2, 'click', '2024-06-01 08:50:00'),
(7, 5, 2, 'purchase', '2024-06-01 12:10:00'),
(8, 7, 2, 'open', '2024-06-01 11:00:00'),
(9, 8, 2, 'click', '2024-06-02 13:00:00');