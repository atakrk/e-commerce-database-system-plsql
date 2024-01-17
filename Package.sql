

--------------------------------------------------------
--  File created - Wednesday-January-17-2024   
--------------------------------------------------------


--------------------------------------------------------
--  DDL for Package FAVORITE_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "FAVORITE_OPERATION" AS
   PROCEDURE add_favorites (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER
   );

   PROCEDURE remove_favorites (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER
   );

   PROCEDURE get_user_favorites (
      p_user_id IN NUMBER
   );

END favorite_operation;

/
--------------------------------------------------------
--  DDL for Package LOG_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "LOG_OPERATION" AS
   PROCEDURE add_operation (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER,
      p_operation  IN VARCHAR2,
      p_order_id   IN NUMBER
   );

END log_operation;

/
--------------------------------------------------------
--  DDL for Package ORDER_HISTORY_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "ORDER_HISTORY_OPERATION" AS
   PROCEDURE save_order_history (
      p_user_id IN NUMBER
   );

END order_history_operation;

/
--------------------------------------------------------
--  DDL for Package ORDER_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "ORDER_OPERATION" AS
    /* Kullanıcı sepetini onaylayıp bir sipariş oluşturan prosedür*/
   PROCEDURE confirm_order (
      p_user_id IN NUMBER
   );

   PROCEDURE print_user_orders (
      p_user_id IN NUMBER
   );

   PROCEDURE cancel_order (
      p_order_id IN NUMBER
   );

   PROCEDURE print_order_by_status (
      p_user_id IN NUMBER, p_order_status VARCHAR2
   );

   PROCEDURE complete_order (
      p_order_id IN NUMBER
   );

END order_operation;

/
--------------------------------------------------------
--  DDL for Package PRINT_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "PRINT_OPERATION" AS
    /* Paketin içindeki prosedürler ve fonksiyonlar tanımlanır. */
  PROCEDURE print_user_info (
    p_user_id IN NUMBER,
    p_header  IN VARCHAR2
  );

  PROCEDURE print_error (
    p_header IN VARCHAR2
  );

END print_operation;

/

--------------------------------------------------------
--  DDL for Package PRODUCT_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "PRODUCT_OPERATION" IS
    -- Ürün kategorisi eklemek için prosedür
   PROCEDURE add_product_category (
      p_category_name IN VARCHAR2,
      p_description   IN VARCHAR2
   );

    -- Yeni ürün eklemek için prosedür
   PROCEDURE add_product (
      p_product_name    IN VARCHAR2,
      p_category_id     IN NUMBER,
      p_unit_price      IN NUMBER,
      p_stock_quantity  IN NUMBER,
      p_product_details IN VARCHAR2
   );

   PROCEDURE print_product_info (
      p_product_id IN NUMBER
   );

END product_operation;

/
--------------------------------------------------------
--  DDL for Package SHOPPING_CART_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "SHOPPING_CART_OPERATION" AS
   PROCEDURE add_product (
      p_user_id IN NUMBER, p_product_id IN NUMBER, p_quantity IN NUMBER
   );

   PROCEDURE remove_product (
      p_user_id IN NUMBER, p_product_id IN NUMBER
   );

   PROCEDURE clear_cart (
      p_user_id IN NUMBER
   );

   PROCEDURE print_user_cart (
      p_user_id IN NUMBER
   );

END shopping_cart_operation;

/
--------------------------------------------------------
--  DDL for Package USER_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE  "USER_OPERATION" AS
  FUNCTION login_user (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2
  ) RETURN BOOLEAN;

  FUNCTION get_user_id (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2
  ) RETURN NUMBER;

  PROCEDURE change_password (
    p_username     IN VARCHAR2,
    p_password    IN VARCHAR2,
    p_new_password IN VARCHAR2
  );

  PROCEDURE register_user (
    p_username    IN VARCHAR2,
    p_password    IN VARCHAR2,
    p_email       IN VARCHAR2,
    p_first_name  IN VARCHAR2,
    p_last_name   IN VARCHAR2,
    p_street      IN VARCHAR2,
    p_city        IN VARCHAR2,
    p_state       IN VARCHAR2,
    p_country     IN VARCHAR2,
    p_postal_code IN VARCHAR2
  );

END user_operation;

/
--------------------------------------------------------
--  DDL for Package Body FAVORITE_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "FAVORITE_OPERATION" AS

   PROCEDURE add_favorites (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER
   ) IS

      v_product_name   products.product_name%TYPE;
      v_unit_price     products.unit_price%TYPE;
      v_stock_quantity products.stock_quantity%TYPE;
      v_fav_count      NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id) AND is_product_exists (p_product_id)
      THEN
      -- Kullanıcı bilgilerini yazdır
         print_operation.print_user_info (p_user_id, 'FAVORİLER');
      -- Ürünün varlığını kontrol et

         -- Ürün detaylarını al
         SELECT product_name,
                unit_price,
                stock_quantity
         INTO
            v_product_name,
            v_unit_price,
            v_stock_quantity
         FROM products
         WHERE product_id = p_product_id;

         -- Ürünün kullanıcı favorilerinde olup olmadığını kontrol et

         v_fav_count := table_count ('user_favorites', 'user_id = '
                                                       || p_user_id
                                                       || ' AND product_id = '
                                                       || p_product_id);

         -- Eğer ürün zaten favorilerdeyse
         IF
            v_fav_count != 0
         THEN
            dbms_output.put_line ('The product is already in favorites for this user.');
         ELSE
            -- Ürünü favorilere ekle

            INSERT INTO user_favorites (
               user_id,
               product_id,
               favorite_date
            ) VALUES (
               p_user_id,
               p_product_id,
               sysdate
            );

            COMMIT;
            -- Favorilere ekleme başarılı mesajı
            dbms_output.put_line ('Product ID: '
                                  || p_product_id
                                  || ', Product Name: '
                                  || v_product_name
                                  || ', Unit Price: '
                                  || v_unit_price
                                  || ' TL'
                                  || ', Stock Quantity: '
                                  || v_stock_quantity
                                  || ' has been added to favorites.');

            log_operation.add_operation (p_user_id, p_product_id,
                                        'User added the product to favorites.', NULL);
         END IF;

      ELSE
         IF
            NOT is_user_exists (p_user_id) AND is_product_exists (p_product_id)
         THEN
            print_operation.print_error ('The specified user was not found.');
         ELSIF
            NOT is_product_exists (p_product_id) AND is_user_exists (p_user_id)
         THEN
            print_operation.print_user_info (p_user_id, 'FAVORILER');
            print_operation.print_error ('The specified product was not found.');
         ELSE
            print_operation.print_error ('Both user and product not found.');
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Genel hata durumu
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
   END add_favorites;

   PROCEDURE remove_favorites (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER
   ) IS

      v_product_name   products.product_name%TYPE;
      v_unit_price     products.unit_price%TYPE;
      v_stock_quantity products.stock_quantity%TYPE;
      v_count          NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id) AND is_product_exists (p_product_id)
      THEN
      -- Kullanıcı bilgilerini yazdır
         print_operation.print_user_info (p_user_id, 'FAVORILER');
      -- Favorilerdeki ürün sayısını kontrol et

         v_count := table_count ('user_favorites', 'user_id = '
                                                   || p_user_id
                                                   || ' AND product_id = '
                                                   || p_product_id);

      -- Eğer ürün favorilerdeyse
         IF
            v_count != 0
         THEN
         -- Ürün detaylarını al
            SELECT product_name,
                   unit_price,
                   stock_quantity
            INTO
               v_product_name,
               v_unit_price,
               v_stock_quantity
            FROM products
            WHERE product_id = p_product_id;

         -- Ürünü favorilerden çıkar

            DELETE FROM user_favorites
            WHERE user_id = p_user_id AND product_id = p_product_id;

            COMMIT;
         -- Favorilerden çıkarma başarılı mesajı
            dbms_output.put_line ('Product ID: '
                                  || p_product_id
                                  || ', Product Name: '
                                  || v_product_name
                                  || ', Unit Price: '
                                  || v_unit_price
                                  || ' TL'
                                  || ', Stock Quantity: '
                                  || v_stock_quantity
                                  || ' has been removed from favorites.');

            log_operation.add_operation (p_user_id, p_product_id,
                                        'User removed the product from favorites.', NULL);
         ELSE
         -- Favorilerde bu ürün yoksa mesaj ver 
            dbms_output.put_line ('This product is not in favorites.');
         END IF;

      ELSE
         IF
            NOT is_user_exists (p_user_id) AND is_product_exists (p_product_id)
         THEN
            print_operation.print_error ('The specified user was not found.');
         ELSIF
            NOT is_product_exists (p_product_id) AND is_user_exists (p_user_id)
         THEN
            print_operation.print_user_info (p_user_id, 'FAVORILER');
            print_operation.print_error ('The specified product was not found.');
         ELSE
            print_operation.print_error ('Both user and product not found.');
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         -- Genel hata durumu
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
   END remove_favorites;

   PROCEDURE get_user_favorites (
      p_user_id IN NUMBER
   ) IS
      v_favorite_count NUMBER;
      v_user_name      VARCHAR2 (100);
   BEGIN
      IF
         is_user_exists (p_user_id)
      THEN
      -- Kullanıcı bilgilerini yazdır
         print_operation.print_user_info (p_user_id, 'FAVORILER');
      -- Kullanıcının favori ürün sayısını kontrol et

         v_favorite_count := table_count ('user_favorites', 'user_id = ' || p_user_id);
         

      -- Eğer favori ürünler varsa
         IF
            v_favorite_count != 0
         THEN
            FOR fav IN (
               SELECT pf.product_id,
                      p.product_name,
                      p.unit_price,
                      p.stock_quantity
               FROM user_favorites pf
               JOIN products p ON pf.product_id = p.product_id
               WHERE pf.user_id = p_user_id
            ) LOOP
            -- Favori ürünleri listele
               dbms_output.put_line ('Product ID: '
                                     || fav.product_id
                                     || ', Product Name: '
                                     || fav.product_name
                                     || ', Unit Price: '
                                     || fav.unit_price
                                     || ' TL'
                                     || ', Stock Quantity: '
                                     || fav.stock_quantity);
            END LOOP;

            log_operation.add_operation (p_user_id, NULL,
                                        'User listed their favorites.', NULL);
         ELSE
         -- Kullanıcının favori ürünleri yoksa mesaj ver 
            dbms_output.put_line ('User does not have any favorite products.');
         END IF;

      ELSE
         print_operation.print_error ('The specified user was not found.');
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         -- Favori ürünler bulunamadıysa mesaj ver 
         dbms_output.put_line ('No favorite products found for this user.');
      WHEN OTHERS THEN
         -- Beklenmeyen bir hata oluştuysa mesaj ver 
         dbms_output.put_line ('An unexpected error occurred: ' || sqlerrm);
   END get_user_favorites;

END favorite_operation;

/
--------------------------------------------------------
--  DDL for Package Body LOG_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "LOG_OPERATION" AS

  -- Operasyon ekleme prosedürü
   PROCEDURE add_operation (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER,
      p_operation  IN VARCHAR2,
      p_order_id   IN NUMBER
   ) IS
   BEGIN
      -- operation_logs tablosuna yeni kayıt ekleme
      INSERT INTO operation_logs (
         user_id,
         product_id,
         operation,
         order_id
      ) VALUES (
         p_user_id,
         p_product_id,
         p_operation,
         p_order_id
      );

      -- İşlemi veritabanında kalıcı hale getir
      COMMIT;
   END add_operation;

END log_operation;

/
--------------------------------------------------------
--  DDL for Package Body ORDER_HISTORY_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "ORDER_HISTORY_OPERATION" AS

   -- Sipariş geçmişini kaydetme prosedürü

   PROCEDURE save_order_history (
      p_user_id IN NUMBER
   ) IS

      file_handle utl_file.file_type;
      file_name   VARCHAR2 (100) := 'user_'
                                  || p_user_id
                                  || '_order_history.csv';
      file_dir    VARCHAR2 (100) := 'ORDER_HISTORY_DIR';
   BEGIN
      -- Kullanıcı varsa işlemleri gerçekleştir
      IF
         is_user_exists (p_user_id)
      THEN
         -- CSV dosyasını yazmak için dosyayı aç
         file_handle := utl_file.fopen (file_dir, file_name,
                                       'W');

         -- CSV başlık satırını yaz
         utl_file.put_line (file_handle, 'Order ID; User ID; Order Date; Order Status; Product ID; Product Name; Quantity; Unit Price; Total Product Price');

         -- Sipariş detaylarını sorgula ve CSV'ye yaz
         FOR order_record IN (
            SELECT o.order_id,
                   o.user_id,
                   to_char (o.order_date, 'YYYY/MM/DD HH24:MI') AS order_date,
                   o.order_status,
                   od.product_id,
                   p.product_name,
                   od.quantity,
                   to_char (p.unit_price, 'FM999G999G990D00')
                   || ' TL' AS unit_price,
                   to_char (p.unit_price * od.quantity, 'FM999G999G990D00')
                   || ' TL' AS total_product_price
            FROM orders o
            JOIN order_details od ON o.order_id = od.order_id
            JOIN products p ON od.product_id = p.product_id
            WHERE o.user_id = p_user_id
         ) LOOP
            utl_file.put_line (file_handle, order_record.order_id
                                            || ';'
                                            || order_record.user_id
                                            || ';'
                                            || order_record.order_date
                                            || ';'
                                            || order_record.order_status
                                            || ';'
                                            || order_record.product_id
                                            || ';'
                                            || order_record.product_name
                                            || ';'
                                            || order_record.quantity
                                            || ';'
                                            || order_record.unit_price
                                            || ';'
                                            || order_record.total_product_price);
         END LOOP;

         -- Dosyayı kapat
         utl_file.fclose (file_handle);

         -- Kullanıcı bilgilerini yazdır ve işlemi logla
         print_operation.print_user_info (p_user_id, 'ORDER HISTORY');
         dbms_output.put_line ('Successfully saved previous order as csv file');
         dbms_output.put_line ('File name: '|| file_name);
         dbms_output.put_line ('File path: /opt/oracle');

         log_operation.add_operation (p_user_id, NULL,
                                     'User saved their previous order as csv file. File name: ' || file_name, NULL);
      ELSE
         -- Kullanıcı bulunamazsa hata mesajı yazdır
         print_operation.print_error ('The specified user was not found.');
      END IF;
         -- Hata olması durumunda dosyayı kapat 

   EXCEPTION
      WHEN OTHERS THEN
         IF
            utl_file.is_open (file_handle)
         THEN
            utl_file.fclose (file_handle);
         END IF;
         RAISE;
   END save_order_history;

END order_history_operation;

/
--------------------------------------------------------
--  DDL for Package Body ORDER_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "ORDER_OPERATION" AS
   -- Kullanıcı sepetini onaylayarak sipariş oluşturan prosedür 
   PROCEDURE confirm_order (
      p_user_id IN NUMBER
   ) IS

      v_cart_count          NUMBER;
      v_order_id            NUMBER;
      v_shipping_address_id NUMBER;
     -- Kullanıcının adres id'si için değişken

      CURSOR confirm_order_cursor IS
      SELECT ps.product_id,
             ps.quantity,
             p.unit_price
      FROM product_shoppingcart ps
      JOIN shopping_cart sc ON ps.cart_id = sc.cart_id
      JOIN products p ON ps.product_id = p.product_id
      WHERE sc.user_id = p_user_id;

   BEGIN
      IF
         is_user_exists (p_user_id)
      THEN
         print_operation.print_user_info (p_user_id, 'ORDERS');

    -- Kullanıcının mevcut sepetini kontrol et

         v_cart_count := table_count ('shopping_cart', 'user_id = ' || p_user_id);

    -- Eğer sepet varsa işleme devam et
         IF
            v_cart_count > 0
         THEN
        -- Kullanıcının adres id'sini al
            SELECT address_id
            INTO v_shipping_address_id
            FROM user_details
            WHERE user_id = p_user_id;

        -- Yeni sipariş oluştur
            INSERT INTO orders (
               user_id,
               order_date,
               address_id,
               order_status
            ) VALUES (
               p_user_id,
               sysdate,
               v_shipping_address_id,
               'OPEN'
            );

            v_order_id := orders_sequence.currval;

        -- Sepetteki her ürün için sipariş detayları oluştur
            FOR cart_product IN confirm_order_cursor LOOP
               INSERT INTO order_details (
                  order_id,
                  product_id,
                  quantity,
                  unit_price
               ) VALUES (
                  v_order_id,
                  cart_product.product_id,
                  cart_product.quantity,
                  cart_product.unit_price
               );

            END LOOP;

        -- Sepeti temizle
            clear_cart_order (p_user_id);

        -- İşlemi tamamla
            COMMIT;
            dbms_output.put_line ('Order successfully created. Order ID: ' || v_order_id);
            log_operation.add_operation (p_user_id, NULL,
                                        'User confirmed order.', v_order_id);
         ELSE
        -- Eğer sepet yoksa hata mesajı yazdır 
            dbms_output.put_line ('User does not have a shopping cart.');
         END IF;

      ELSE
         print_operation.print_error ('The specified user was not found.');
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
     -- Hata durumunda geri al
   END confirm_order;

   -- Kullanıcının tüm siparişlerini yazdıran prosedür 
   PROCEDURE print_user_orders (
      p_user_id IN NUMBER
   ) IS

      CURSOR print_user_all_order_cursor IS
      SELECT o.order_id,
             o.user_id,
             o.order_date,
             o.order_status,
             od.product_id,
             p.product_name,
             p.unit_price,
             od.quantity AS product_quantity,
             p.unit_price * od.quantity AS total_product_price
      FROM orders o
      JOIN order_details od ON o.order_id = od.order_id
      JOIN products p ON od.product_id = p.product_id
      WHERE o.user_id = p_user_id
      ORDER BY o.order_id,
               od.product_id;

      total_price   NUMBER := 0;
      v_order_count NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id)
      THEN
         print_operation.print_user_info (p_user_id, 'ORDERS');

        -- Kullanıcının sipariş sayısını kontrol et

         v_order_count := table_count ('orders', 'user_id = ' || p_user_id);
         IF
            v_order_count != 0
         THEN
            FOR order_info IN print_user_all_order_cursor LOOP
               total_price := total_price + order_info.total_product_price;
               dbms_output.put_line ('Order ID: ' || order_info.order_id);
               dbms_output.put_line ('User ID: ' || order_info.user_id);
               dbms_output.put_line ('Order Date: ' || order_info.order_date);
               dbms_output.put_line ('Order Status: ' || order_info.order_status);
               dbms_output.put_line ('Product ID: ' || order_info.product_id);
               dbms_output.put_line ('Product Name: ' || order_info.product_name);
               dbms_output.put_line ('Unit Price: '
                                     || order_info.unit_price
                                     || ' TL');
               dbms_output.put_line ('Product Quantity: ' || order_info.product_quantity);
               dbms_output.put_line ('Total Product Price: '
                                     || order_info.total_product_price
                                     || ' TL');
               dbms_output.put_line ('-------------------------------');
            END LOOP;

            dbms_output.put_line ('Order Total Price: '
                                  || total_price
                                  || ' TL');
            log_operation.add_operation (p_user_id, NULL,
                                        'User listed their orders.', NULL);
         ELSE
            dbms_output.put_line ('This user has no orders.');
         END IF;

      ELSE
      -- Eğer kullanıcı yoksa mesaj ver 

         print_operation.print_error ('The specified user was not found.');
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line ('Error: No orders found for this user.');
      WHEN OTHERS THEN
         dbms_output.put_line ('An unexpected error occurred: ' || sqlerrm);
   END print_user_orders;

  -- Kullanıcının belirli bir siparişini iptal eden prosedür 
   PROCEDURE cancel_order (
      p_order_id IN NUMBER
   ) IS

      CURSOR cancel_order_cursor IS
      SELECT product_id,
             quantity
      FROM order_details
      WHERE order_id = p_order_id;

      v_order_status orders.order_status%TYPE;
      v_product_id   products.product_id%TYPE;
      v_quantity     order_details.quantity%TYPE;
      v_user_id      NUMBER;
   BEGIN
        -- Sipariş durumunu ve kullanıcı ID'sini kontrol et
      SELECT order_status,
             user_id
      INTO
         v_order_status,
         v_user_id
      FROM orders
      WHERE order_id = p_order_id;

      print_operation.print_user_info (v_user_id, 'ORDERS');

        -- Eğer sipariş bulunamadıysa veya zaten iptal edilmişse hata ver
      IF
         v_order_status IS NULL
      THEN
         dbms_output.put_line ('Order does not exist.');
      ELSIF
         v_order_status = 'CANCELLED'
      THEN
         dbms_output.put_line ('Order is already cancelled.');
      ELSIF
         v_order_status = 'COMPLETE'
      THEN
         dbms_output.put_line ('Order is already completed.');
      ELSE
            -- Siparişi iptal et
         UPDATE orders
         SET
            order_status = 'CANCELLED'
         WHERE order_id = p_order_id;

            -- Siparişe ait ürünleri alıp stoklara geri ekle
         FOR order_products IN cancel_order_cursor LOOP
            v_product_id := order_products.product_id;
            v_quantity := order_products.quantity;

                -- Stokları geri ekle
            UPDATE products
            SET
               stock_quantity = stock_quantity + v_quantity
            WHERE product_id = v_product_id;

         END LOOP;

         COMMIT;
         dbms_output.put_line ('Order cancelled. Products restocked.');
         log_operation.add_operation (v_user_id, NULL,
                                     'User cancelled their order.', p_order_id);
      END IF;

   EXCEPTION
      WHEN no_data_found THEN
         print_operation.print_error ('The specified order not found.');
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
     -- Hata durumunda geri al
   END cancel_order;

   PROCEDURE print_order_by_status (
      p_user_id      IN NUMBER,
      p_order_status VARCHAR2
   ) IS

      CURSOR print_order_cursor IS
      SELECT o.order_id,
             o.user_id,
             o.order_date,
             o.order_status,
             od.product_id,
             p.product_name,
             p.unit_price,
             od.quantity AS product_quantity,
             p.unit_price * od.quantity AS total_product_price
      FROM orders o
      JOIN order_details od ON o.order_id = od.order_id
      JOIN products p ON od.product_id = p.product_id
      WHERE o.user_id = p_user_id AND o.order_status = p_order_status
      ORDER BY o.order_id,
               od.product_id;

      v_user_name        VARCHAR2 (100);
      v_open_order_count NUMBER;
      total_price        NUMBER := 0;
   BEGIN
      IF
         is_user_exists (p_user_id)
      THEN
         IF
            p_order_status IN ('CANCELLED', 'COMPLETE',
                               'OPEN')
         THEN 

        -- Kullanıcı adını ve soyadını yazdır

            print_operation.print_user_info (p_user_id, p_order_status || ' ORDERS');
         -- Kullanıcının 'OPEN' durumundaki sipariş sayısını kontrol et

            v_open_order_count := table_count ('orders', 'user_id = '
                                                         || p_user_id
                                                         || ' AND order_status = '''
                                                         || p_order_status
                                                         || '''');

            IF
               v_open_order_count != 0
            THEN
               FOR order_info IN print_order_cursor LOOP
                  total_price := total_price + order_info.total_product_price;
                  dbms_output.put_line ('Order ID: ' || order_info.order_id);
                  dbms_output.put_line ('User ID: ' || order_info.user_id);
                  dbms_output.put_line ('Order Date: ' || order_info.order_date);
                  dbms_output.put_line ('Order Status: ' || order_info.order_status);
                  dbms_output.put_line ('Product ID: ' || order_info.product_id);
                  dbms_output.put_line ('Product Name: ' || order_info.product_name);
                  dbms_output.put_line ('Unit Price: '
                                        || order_info.unit_price
                                        || ' TL');
                  dbms_output.put_line ('Product Quantity: ' || order_info.product_quantity);
                  dbms_output.put_line ('Total Product Price: '
                                        || order_info.total_product_price
                                        || ' TL');
                  dbms_output.put_line ('-------------------------------');
               END LOOP;

               dbms_output.put_line (p_order_status
                                     || ' Order Total Price: '
                                     || total_price
                                     || ' TL');
               log_operation.add_operation (p_user_id, NULL,
                                           'User listed their '
                                           || p_order_status
                                           || ' orders.', NULL);

            ELSE
               dbms_output.put_line ('This user''s '
                                     || p_order_status
                                     || ' no order available.');
            END IF;

         ELSE
            dbms_output.put_line ('Order status must be CANCELLED, COMPLETE or OPEN.');
         END IF;

      ELSE
      -- Eğer kullanıcı yoksa mesaj ver 

         print_operation.print_error ('The specified user was not found.');
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line ('This user has no orders.');
      WHEN OTHERS THEN
         dbms_output.put_line ('An unexpected error occurred: ' || sqlerrm);
   END print_order_by_status;

   PROCEDURE complete_order (
      p_order_id IN NUMBER
   ) IS
      v_order_status VARCHAR2 (20);
      v_user_id      NUMBER;
   BEGIN
    -- Verilen order_id'ye göre order'ın durumunu ve user_id'yi kontrol et
      SELECT order_status,
             user_id
      INTO
         v_order_status,
         v_user_id
      FROM orders
      WHERE order_id = p_order_id;

      print_operation.print_user_info (v_user_id, ' ORDERS');
      IF
         v_order_status IS NULL
      THEN
         dbms_output.put_line ('Order does not exist.');
      ELSIF
         v_order_status = 'CANCELLED'
      THEN
         dbms_output.put_line ('Order is already cancelled.');
      ELSIF
         v_order_status = 'COMPLETE'
      THEN
         dbms_output.put_line ('Order is already completed.');
      ELSE
            -- İstenilen order'ın status'unu "COMPLETED" olarak güncelle
         UPDATE orders
         SET
            order_status = 'COMPLETE'
         WHERE order_id = p_order_id;

         COMMIT;
         dbms_output.put_line ('Order successfully completed.');
         log_operation.add_operation (v_user_id, NULL,
                                     'User completed their order.', p_order_id);
      END IF;

   EXCEPTION
      WHEN no_data_found THEN
         print_operation.print_error ('Order does not exist.');
      WHEN OTHERS THEN
         dbms_output.put_line ('An error occurred: ' || sqlerrm);
         ROLLBACK;
     -- Hata durumunda geri al
   END complete_order;

END order_operation;

/
--------------------------------------------------------
--  DDL for Package Body PRINT_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "PRINT_OPERATION" AS

    -- Kullanıcının adını ve soyadını yazdıran prosedür
   PROCEDURE print_user_info (
      p_user_id IN NUMBER,
      p_header  IN VARCHAR2
   ) IS
      v_user_name VARCHAR2 (100);
   BEGIN
        -- Kullanıcı adı ve soyadını al (user_details tablosundan)
      SELECT ud.first_name
             || ' '
             || ud.last_name
      INTO v_user_name
      FROM user_details ud
      JOIN users u ON u.user_id = ud.user_id
      WHERE u.user_id = p_user_id;

        -- Kullanıcı adını ve soyadını yazdır
      dbms_output.put_line (chr (10)
                            || chr (10));
      dbms_output.put_line ('########### USER ###########');
      dbms_output.put_line ('User ID: ' || p_user_id);
      dbms_output.put_line ('User Name: ' || v_user_name);
      dbms_output.put_line ('=========== '
                            || p_header
                            || ' ===========');
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line ('User not found.');
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
   END print_user_info;

   PROCEDURE print_error (
      p_header IN VARCHAR2
   ) IS
   BEGIN
      dbms_output.put_line (chr (10));
      dbms_output.put_line ('########### ERROR ###########');
      dbms_output.put_line (p_header);
      dbms_output.put_line ('#############################');
   END print_error;

END print_operation;


--------------------------------------------------------
--  DDL for Package Body PRODUCT_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "PRODUCT_OPERATION" IS

   PROCEDURE add_product_category (
      p_category_name IN VARCHAR2,
      p_description   IN VARCHAR2
   ) IS
   BEGIN
      INSERT INTO product_categories (
         category_name,
         description
      ) VALUES (
         p_category_name,
         p_description
      );

      dbms_output.put_line ('Category added: ' || p_category_name);
      log_operation.add_operation (NULL, NULL,
                                  'New product category added', NULL);
      COMMIT;
   EXCEPTION
      WHEN dup_val_on_index
      THEN print_operation.print_error ('The category name already exists.');
      WHEN OTHERS
      THEN dbms_output.put_line ('Error: ' || sqlerrm);
   END add_product_category;

   PROCEDURE add_product (
      p_product_name    IN VARCHAR2,
      p_category_id     IN NUMBER,
      p_unit_price      IN NUMBER,
      p_stock_quantity  IN NUMBER,
      p_product_details IN VARCHAR2
   ) IS
   BEGIN
      INSERT INTO products (
         product_name,
         category_id,
         unit_price,
         stock_quantity,
         product_details
      ) VALUES (
         p_product_name,
         p_category_id,
         p_unit_price,
         p_stock_quantity,
         p_product_details
      );

      dbms_output.put_line ('Product added: ' || p_product_name);
      log_operation.add_operation (NULL, product_sequence.currval,
                                  'New product added', NULL);
      COMMIT;
   EXCEPTION
      WHEN dup_val_on_index
      THEN print_operation.print_error ('The product name already exists.');
      WHEN OTHERS
      THEN dbms_output.put_line ('Error: ' || sqlerrm);
   END add_product;

   PROCEDURE print_product_info (
      p_product_id IN NUMBER
   ) IS
      v_product_name   VARCHAR2 (100);
      v_stock_quantity NUMBER;
   BEGIN
      IF is_product_exists (p_product_id)
      THEN
         SELECT product_name,
                stock_quantity
         INTO
            v_product_name,
            v_stock_quantity
         FROM products
         WHERE product_id = p_product_id;

         dbms_output.put_line ('Product ID: '
                               || p_product_id
                               || ' | Product Name: '
                               || v_product_name
                               || ' | Stock Quantity: '
                               || v_stock_quantity);

      ELSE
      -- Eğer ürün yoksa mesaj ver 

       print_operation.print_error ('The specified product was not found.');
      END IF;
   EXCEPTION
      WHEN no_data_found
      THEN dbms_output.put_line ('No product found with ID ' || p_product_id);
      WHEN OTHERS
      THEN dbms_output.put_line ('Error occurred: ' || sqlerrm);
   END print_product_info;

END product_operation;

/
--------------------------------------------------------
--  DDL for Package Body SHOPPING_CART_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "SHOPPING_CART_OPERATION" AS

   PROCEDURE add_product (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER,
      p_quantity   IN NUMBER
   ) IS
      v_stock_quantity    NUMBER;
      v_existing_cart_id  NUMBER;
      v_cart_count        NUMBER;
      v_existing_quantity NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id) AND is_product_exists (p_product_id)
      THEN
         print_operation.print_user_info (p_user_id, 'SHOPPING CART');

   -- İlgili ürünün stok miktarını al
         SELECT stock_quantity
         INTO v_stock_quantity
         FROM products
         WHERE product_id = p_product_id;

   -- Eğer istenilen miktar stokta varsa işleme devam et, yoksa hata ver
         IF
            v_stock_quantity >= p_quantity
         THEN

      -- Kullanıcının mevcut sepetini kontrol et

            v_cart_count := table_count ('shopping_cart', 'user_id = ' || p_user_id);
            IF
               v_cart_count != 0
            THEN
               SELECT cart_id
               INTO v_existing_cart_id
               FROM shopping_cart
               WHERE user_id = p_user_id;
               

         -- Kullanıcının mevcut sepetinde aynı ürün var mı kontrol et
               SELECT nvl (SUM (quantity),
                           0)
               INTO v_existing_quantity
               FROM product_shoppingcart
               WHERE cart_id = v_existing_cart_id AND product_id = p_product_id;

               IF
                  v_existing_quantity > 0
               THEN
            -- Eğer ürün zaten sepette varsa, miktarını güncelle 
                  UPDATE product_shoppingcart
                  SET
                     quantity = quantity + p_quantity
                  WHERE cart_id = v_existing_cart_id AND product_id = p_product_id;

               ELSE
            -- Ürün sepette yoksa, yeni bir kayıt ekle 

                  INSERT INTO product_shoppingcart (
                     cart_id,
                     product_id,
                     quantity
                  ) VALUES (
                     v_existing_cart_id,
                     p_product_id,
                     p_quantity
                  );

               END IF;

            ELSE
         -- Eğer kullanıcının mevcut bir sepeti yoksa yeni sepet oluştur
               INSERT INTO shopping_cart (
                  user_id,
                  created_at,
                  expires_at
               ) VALUES (
                  p_user_id,
                  sysdate,
                  sysdate + 7
               );

               v_existing_cart_id := shopping_cart_sequence.currval;

         -- Ürünü yeni oluşturulan sepete ekle
               INSERT INTO product_shoppingcart (
                  cart_id,
                  product_id,
                  quantity
               ) VALUES (
                  v_existing_cart_id,
                  p_product_id,
                  p_quantity
               );

            END IF;

      -- Stokları güncelle ve işlemi tamamla
            update_stock_after_add (p_product_id, p_quantity);
            COMMIT;
            dbms_output.put_line ('The product was successfully added to the basket.');
            log_operation.add_operation (p_user_id, p_product_id,
                                        'user added a product to the shopping cart.', NULL);
         ELSE
      -- Yetersiz stok durumunda hata mesajı yaz 
            dbms_output.put_line ('Insufficient stock. Product could not be added to the shopping cart.');
         END IF;

      ELSE
         IF
            NOT is_user_exists (p_user_id) AND is_product_exists (p_product_id)
         THEN
            print_operation.print_error ('The specified user was not found.');
         ELSIF
            NOT is_product_exists (p_product_id) AND is_user_exists (p_user_id)
         THEN
            print_operation.print_user_info (p_user_id, 'SHOPPING CART');
            print_operation.print_error ('The specified product was not found.');
         ELSE
            print_operation.print_error ('Both user and product not found.');
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
   END add_product;

   PROCEDURE remove_product (
      p_user_id    IN NUMBER,
      p_product_id IN NUMBER
   ) IS
      v_cart_id    NUMBER;
      v_quantity   NUMBER;
      v_cart_count NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id) AND is_product_exists (p_product_id)
      THEN
         print_operation.print_user_info (p_user_id, 'SHOPPING CART');

    -- Kullanıcının mevcut sepetini kontrol et 
         SELECT cart_id
         INTO v_cart_id
         FROM shopping_cart
         WHERE user_id = p_user_id;

    -- Kullanıcının sepetinde belirtilen ürünün miktarını kontrol et 
         SELECT nvl (SUM (quantity),
                     0)
         INTO v_quantity
         FROM product_shoppingcart
         WHERE cart_id = v_cart_id AND product_id = p_product_id;

    -- Eğer belirtilen ürünün miktarı varsa, sepetten ürünü kaldır 
         IF
            v_quantity > 0
         THEN
            DELETE FROM product_shoppingcart
            WHERE cart_id = v_cart_id AND product_id = p_product_id;

            update_stock_after_remove (p_product_id, v_quantity);
            COMMIT;
            dbms_output.put_line ('The item has been successfully removed from the shopping cart.');
            log_operation.add_operation (p_user_id, p_product_id,
                                        'user removed the product from the shopping cart.', NULL);
            v_cart_count := table_count ('product_shoppingcart', 'cart_id = ' || v_cart_id);

        -- Sepette başka ürün kalmadıysa sepeti sil 
            IF
               (v_cart_count = 0)
            THEN
               DELETE FROM shopping_cart
               WHERE cart_id = v_cart_id;

               COMMIT;
               dbms_output.put_line ('The shopping cart is now empty and has been removed.');
            END IF;

         ELSE
            dbms_output.put_line ('The specified product was not found in your shopping cart.');
         END IF;

      ELSE
         IF
            NOT is_user_exists (p_user_id) AND is_product_exists (p_product_id)
         THEN
            print_operation.print_error ('The specified user was not found.');
         ELSIF
            NOT is_product_exists (p_product_id) AND is_user_exists (p_user_id)
         THEN
            print_operation.print_user_info (p_user_id, 'SHOPPING CART');
            print_operation.print_error ('The specified product was not found.');
         ELSE
            print_operation.print_error ('Both user and product not found.');
         END IF;
      END IF;
   EXCEPTION
      WHEN no_data_found THEN
         dbms_output.put_line ('The user''s shopping cart is empty or does not exist.');
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
     -- Hata durumunda geri al 
   END remove_product;

   PROCEDURE clear_cart (
      p_user_id IN NUMBER
   ) IS

      CURSOR cart_cursor IS
      SELECT product_id,
             quantity
      FROM product_shoppingcart ps
      JOIN shopping_cart sc ON ps.cart_id = sc.cart_id
      WHERE sc.user_id = p_user_id;

      v_product_id NUMBER;
      v_quantity   NUMBER;
      v_cart_count NUMBER;
   BEGIN
      IF
         is_user_exists (p_user_id)
      THEN
         print_operation.print_user_info (p_user_id, 'SHOPPING CART');
         v_cart_count := table_count ('shopping_cart', 'user_id = ' || p_user_id);
         IF
            v_cart_count != 0
         THEN
        -- Sepetteki ürünleri al
            FOR cart_products IN cart_cursor LOOP
               v_product_id := cart_products.product_id;
               v_quantity := cart_products.quantity;

            -- Stokları güncelle
               update_stock_after_remove (v_product_id, v_quantity);
            END LOOP;

        -- Sepeti temizle ve shopping_cart tablosundan sil
            DELETE FROM product_shoppingcart ps
            WHERE ps.cart_id IN (
               SELECT cart_id
               FROM shopping_cart
               WHERE user_id = p_user_id
            );

            DELETE FROM shopping_cart
            WHERE user_id = p_user_id;

            COMMIT;
            dbms_output.put_line ('The shopping cart has been cleared and stocks have been updated.');
            log_operation.add_operation (p_user_id, NULL,
                                        'the user has cleared his shopping cart and stocks have been updated.', NULL);
         ELSE
            dbms_output.put_line ('The user''s shopping cart is empty.');
         END IF;

      ELSE
         print_operation.print_error ('The specified user was not found.');
      END IF;
   END clear_cart;

   PROCEDURE print_user_cart (
      p_user_id IN NUMBER
   ) IS
      v_user_count NUMBER;
   BEGIN

         -- Eğer kullanıcı varsa
      IF
         is_user_exists (p_user_id)
      THEN
        -- Kullanıcı adını ve soyadını yazdır

         print_operation.print_user_info (p_user_id, 'SHOPPING CART');
      --Sepeti yazdıran cursorı çağır
         print_cart_cursor (p_user_id);

        -- Sepetin toplam tutarını hesapla ve yazdır
         DECLARE
            v_total_amount NUMBER := 0;
         BEGIN
            v_total_amount := calculate_cart_total (p_user_id);
            IF
               v_total_amount IS NULL
            THEN
               dbms_output.put_line ('');
            ELSE
               dbms_output.put_line ('-------------------------------');
               dbms_output.put_line ('total price of cart: '
                                     || v_total_amount
                                     || ' TL');
            END IF;

         END;

         log_operation.add_operation (p_user_id, NULL,
                                     'the user has viewed their shopping cart.', NULL);
      ELSE
      -- Eğer kullanıcı yoksa mesaj ver 
         print_operation.print_error ('The specified user was not found.');
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
   END print_user_cart;

END shopping_cart_operation;

/
--------------------------------------------------------
--  DDL for Package Body USER_OPERATION
--------------------------------------------------------

  CREATE OR REPLACE   PACKAGE BODY  "USER_OPERATION" AS

   FUNCTION login_user (
      p_username IN VARCHAR2,
      p_password IN VARCHAR2
   ) RETURN BOOLEAN IS
      v_hashed_password VARCHAR2 (4000);
      v_stored_password VARCHAR2 (4000);
      v_user_id         NUMBER;
   BEGIN
      v_user_id         := get_user_id (p_username, p_password);
    -- Kullanıcının kayıtlı şifresini al (user_details tablosundan)
      SELECT ud.password
      INTO v_stored_password
      FROM user_details ud
      JOIN users u ON u.user_id = ud.user_id
      WHERE u.username = p_username;

    -- Gelen şifreyi hashle ve karşılaştır
      v_hashed_password := get_sha256_hash (p_password);
      IF
         v_stored_password != v_hashed_password
      THEN
         RETURN FALSE;
      ELSE
         print_operation.print_user_info (v_user_id, 'LOGIN');
         log_operation.add_operation (v_user_id, NULL,
                                     p_username || ' successfully logged in', NULL);
         RETURN TRUE;
      END IF;

   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
   END login_user;

   FUNCTION get_user_id (
      p_username IN VARCHAR2,
      p_password IN VARCHAR2
   ) RETURN NUMBER IS
      v_user_id NUMBER;
   BEGIN
      SELECT u.user_id
      INTO v_user_id
      FROM users u
      JOIN user_details ud ON u.user_id = ud.user_id
      WHERE u.username = p_username AND ud.password = get_sha256_hash (p_password);

      RETURN v_user_id;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
   END get_user_id;

   PROCEDURE change_password (
      p_username     IN VARCHAR2,
      p_password     IN VARCHAR2,
      p_new_password IN VARCHAR2
   ) IS
      v_new_hashed_password VARCHAR2 (4000);
      v_user_id             NUMBER;
   BEGIN
      IF
         login_user (p_username, p_password)
      THEN
         v_new_hashed_password := get_sha256_hash (p_new_password);
         v_user_id             := get_user_id (p_username, p_password);
         UPDATE user_details
         SET
            password = v_new_hashed_password
         WHERE user_id = v_user_id;

         COMMIT;
         dbms_output.put_line ('User successfully changed password.');
         log_operation.add_operation (v_user_id, NULL,
                                     p_username || ' successfully changed password.', NULL);
      ELSE
         print_operation.print_error ('The username or password is incorrect.');
      END IF;
   END change_password;

   PROCEDURE register_user (
      p_username    IN VARCHAR2,
      p_password    IN VARCHAR2,
      p_email       IN VARCHAR2,
      p_first_name  IN VARCHAR2,
      p_last_name   IN VARCHAR2,
      p_street      IN VARCHAR2,
      p_city        IN VARCHAR2,
      p_state       IN VARCHAR2,
      p_country     IN VARCHAR2,
      p_postal_code IN VARCHAR2
   ) IS
      v_hashed_password VARCHAR2 (4000);
      v_count           NUMBER;
      v_address_id      NUMBER;
   BEGIN
    -- Kullanıcı adı benzersiz kontrolü
      SELECT COUNT (*)
      INTO v_count
      FROM users
      WHERE username = p_username;

      IF
         v_count > 0
      THEN
         print_operation.print_error ('The username already exists.');
         RETURN;
      END IF;

    -- E-posta benzersiz kontrolü
 
               v_count := table_count ('user_details', 'email = ' || p_email);

      

      IF
         v_count > 0
      THEN
         print_operation.print_error ('The e-mail address already exists.');
         RETURN;
      END IF;

    -- Adresi ekle
      INSERT INTO address (
         street,
         city,
         state,
         country,
         postal_code
      ) VALUES (
         p_street,
         p_city,
         p_state,
         p_country,
         p_postal_code
      ) RETURNING address_id INTO v_address_id;

    -- Kullanıcıyı ekle
      INSERT INTO users (username) VALUES (p_username);

    -- Kullanıcı detaylarını ekle
      v_hashed_password := get_sha256_hash (p_password);
      INSERT INTO user_details (
         user_id,
         password,
         email,
         first_name,
         last_name,
         address_id
      ) VALUES (
         users_sequence.CURRVAL,
         v_hashed_password,
         p_email,
         p_first_name,
         p_last_name,
         v_address_id
      );

      COMMIT;
      print_operation.print_user_info (users_sequence.currval, 'SIGN IN');
      dbms_output.put_line ('User successfully signed in.');

    -- Log işlemi

      log_operation.add_operation (users_sequence.currval, NULL,
                                  p_username || ' successfully signed in.', NULL);
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line ('Error: ' || sqlerrm);
         ROLLBACK;
   END register_user;

END user_operation;
