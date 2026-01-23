-- Seed data for Aliya Divani app

-- Restaurants (safe insert: ignore if id already exists)
INSERT INTO restaurants (id, name, image_url, rating, reviews, description, created_at) VALUES
(1, 'Warung Nasi Enak', 'https://images.unsplash.com/photo-1600891964599-f61ba0e24092', 4.7, 124, 'Warung nasi dengan resep tradisional.', now()),
(2, 'Kopi & Roti', 'https://images.unsplash.com/photo-1547044055-0d85b3a7f5b6', 4.5, 98, 'Kafe nyaman untuk sarapan dan ngopi.', now())
ON CONFLICT (id) DO NOTHING;

-- Foods (safe insert)
INSERT INTO foods (id, restaurant_id, name, category, price, rating, reviews, image_url, description, ingredients, created_at) VALUES
(1, 1, 'Nasi Goreng Spesial', 'Makanan', 25000, 4.8, 210, 'https://images.unsplash.com/photo-1601050690596-4e1d0c3a8b4b', 'Nasi goreng spesial dengan bumbu rahasia.', ARRAY['nasi','telur','bawang','kecap'], now()),
(2, 1, 'Ayam Bakar', 'Makanan', 30000, 4.6, 76, 'https://images.unsplash.com/photo-1544025162-d76694265947', 'Ayam bakar madu.', ARRAY['ayam','madu','bumbu'], now()),
(3, 2, 'Pancake Blueberry', 'Dessert', 45000, 4.4, 54, 'https://images.unsplash.com/photo-1551782450-a2132b4ba21d', 'Pancake lembut dengan topping blueberry.', ARRAY['tepung','susu','blueberry'], now()),
(4, 2, 'Latte', 'Minuman', 22000, 4.5, 88, 'https://images.unsplash.com/photo-1511920170033-f8396924c348', 'Kopi latte creamy.', ARRAY['kopi','susu'], now())
ON CONFLICT (id) DO NOTHING;

-- Promos (safe insert by code)
INSERT INTO promos (code, discount_percentage, min_order_amount, description, is_active, expires_at) VALUES
('WELCOME10', 10.00, 50000, 'Diskon 10% untuk pesanan pertama', true, now() + interval '30 days'),
('MIDNIGHT50', 50.00, 100000, 'Diskon 50% untuk pesanan tengah malam', true, now() + interval '90 days')
ON CONFLICT (code) DO NOTHING;

-- Comments
INSERT INTO comments (id, user_id, user_name, user_image, content, replies, like_count, created_at) VALUES
(gen_random_uuid(), NULL, 'Ginda', '', 'Makanannya enak dan pelayanan cepat!', '[]', 12, now()),
(gen_random_uuid(), NULL, 'User', '', 'Suka pancake-nya, recommended.', '[]', 4, now());

-- Addresses (example)
INSERT INTO addresses (user_id, label, street, city, postal_code, lat, lng, is_default, created_at) VALUES
((select id from auth.users limit 1), 'Rumah', 'Jl. Melati No.10', 'Bandung', '40123', -6.914744, 107.609810, true, now());

-- Sample orders (minimal)
INSERT INTO orders (id, user_id, restaurant_id, items, subtotal, tax, shipping_cost, discount_amount, total, status, delivery_address, ordered_at) VALUES
(gen_random_uuid(), (select id from auth.users limit 1), 1, '[{"food_id":1,"qty":2}]', 50000, 5000, 10000, 0, 65000, 'completed', 'Jl. Melati No.10', now());
