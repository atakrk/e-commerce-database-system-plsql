BEGIN
    -- Kullanıcı 1
   user_authentication_pkg.add_user (p_username => 'user1', p_password => 'password1',
                                    p_email => 'user1@example.com', p_first_name => 'John',
                                    p_last_name => 'Doe', p_street => '123 Elm Street',
                                    p_city => 'Springfield', p_state => 'State1',
                                    p_country => 'Country1', p_postal_code => '12345');

    -- Kullanıcı 2
   user_authentication_pkg.add_user (p_username => 'user2', p_password => 'password2',
                                    p_email => 'user2@example.com', p_first_name => 'Jane',
                                    p_last_name => 'Doe', p_street => '456 Maple Avenue',
                                    p_city => 'Springfield', p_state => 'State2',
                                    p_country => 'Country2', p_postal_code => '23456');

    -- Kullanıcı 3
   user_authentication_pkg.add_user (p_username => 'user3', p_password => 'password3',
                                    p_email => 'user3@example.com', p_first_name => 'Alice',
                                    p_last_name => 'Smith', p_street => '789 Oak Lane',
                                    p_city => 'Springfield', p_state => 'State3',
                                    p_country => 'Country3', p_postal_code => '34567');

END;
--- *** 10 örnek kategori girişi ***
INSERT INTO product_categories (category_name, description)
VALUES 
     ('Electronics', 'Electronic products'),
    ( 'Apparel', 'Clothing and fashion products'),
    ( 'Footwear', 'Shoes and accessories'),
    ( 'Home', 'Home appliances and decoration products'),
    ('Cosmetics', 'Cosmetics and beauty products'),
    ('Sports', 'Sports products'),
    ( 'Toys', 'Toys and game materials'),
    ( 'Books', 'Books and literature products'),
    ( 'Music', 'Music instruments and equipment'),
    ( 'Watch', 'Watches and accessories');
    
    -- Elektronik Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
   ('Laptop Model A', 1, 1200.50, 50, 'High performance laptop'),
    ('Smartphone', 1, 899.99, 75, 'State-of-the-art smartphone'),
    ('Wireless Headphones', 1, 79.95, 100, 'Wireless headphones with Bluetooth connection'),
    ('Tablet', 1, 499.00, 45, 'Portable tablet device'),
    ('Smart Watch', 1, 299.50, 60, 'Smart watch that measures health');

-- Giyim Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
    ('T-shirt', 2, 25.99, 150, 'Cotton men''s t-shirt'),
    ('Shirt', 2, 35.50, 120, 'Classic style shirt'),
    ('Sweater', 2, 45.75, 80, 'Warm winter sweater'),
    ('Pants', 2, 39.95, 100, 'Women''s trousers'),
    ('Jeans', 2, 49.99, 90, 'Men''s denim jeans');

-- Ayakkabı Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
    ('Sports Shoes', 3, 79.99, 200, 'Comfortable sports shoes'),
    ('High Heels', 3, 59.95, 180, 'Women''s high heel shoes'),
    ('Winter Boots', 3, 99.50, 150, 'Warm winter boots'),
    ('Sandal', 3, 29.99, 220, 'Comfortable summer sandals'),
    ('Boots', 3, 89.50, 160, 'Men''s boots');

-- Ev & Yaşam Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
    ('Kitchen Robot', 4, 129.99, 100, 'Food preparation robot'),
    ('Tea Maker', 4, 59.50, 120, 'Practical tea maker'),
    ('Rug', 4, 199.95, 80, 'Modern patterned rug'),
    ('Desk Lamp', 4, 34.99, 150, 'Ideal desk lamp for reading'),
    ('Bathroom Set', 4, 79.50, 90, 'Elegant bathroom set');

-- Kozmetik Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
   ('Blush', 5, 12.99, 200, 'Vivid colored blush'),
    ('Lipstick', 5, 9.50, 180, 'Matte lipstick'),
    ('Makeup Brush', 5, 7.75, 150, 'Makeup brush set'),
    ('Perfume', 5, 49.99, 220, 'Floral perfume'),
    ('Eye Shadow Palette', 5, 24.50, 160, 'Eye shadow palette');

-- Spor Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
    ('Yoga Mat', 6, 29.99, 100, 'Non-slip yoga mat'),
    ('Running Shoes', 6, 79.50, 120, 'Flexible running shoes'),
    ('Fitness Band', 6, 49.95, 80, 'Sports band'),
    ('Exercise Ball', 6, 14.99, 150, 'Fitness exercise ball'),
    ('Sports Bag', 6, 39.50, 90, 'Sports equipment bag');

-- Oyuncak Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
  ('Toy Car', 7, 9.99, 200, 'Toy car for kids'),
    ('Baby Diaper', 7, 19.50, 180, 'Diapers for your baby'),
    ('Wooden Blocks', 7, 29.50, 150, 'Wooden toy blocks'),
    ('Soft Toy', 7, 5.99, 220, 'Soft toy bear'),
    ('Play-Doh', 7, 8.50, 160, 'Play-Doh set');

-- Kitap Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
   ('Novel', 8, 14.99, 250, 'Bestselling novel'),
    ('Science Fiction', 8, 19.50, 180, 'Science fiction book'),
    ('Manga', 8, 9.50, 200, 'Manga in comic book style'),
    ('Classic Literature', 8, 12.99, 170, 'Classic literature work'),
    ('Children''s Book', 8, 8.50, 220, 'Book for children');

-- Müzik Kategorisi için örnek ürünler
INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
VALUES 
    ('Electric Guitar', 9, 299.99, 100, 'Electric guitar set'),
    ('Keyboard', 9, 499.50, 120, 'Professional keyboard'),
    ('Microphone', 9, 129.95, 80, 'Studio microphone'),
    ('Acoustic Guitar', 9, 199.99, 150, 'Acoustic guitar'),
    ('Drum Set', 9, 799.50, 90, 'Drum set');
-- Saat Kategorisi için örnek ürünler
   INSERT INTO products ( product_name, category_id, unit_price, stock_quantity, product_details)
     VALUES 
     ('Leather Strap Watch', 10, 89.99, 200, 'Elegant leather strap watch'),
     ('Metal Bracelet Watch', 10, 99.50, 180, 'Modern metal bracelet watch'),
     ('Sports Watch', 10, 79.95, 150, 'Waterproof sports watch'),
     ('Classic Watch', 10, 149.99, 220, 'Classic style watch'),
     ('Smartwatch', 10, 199.50, 160, 'Smart wristwatch');

