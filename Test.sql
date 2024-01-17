--############################ USER OPERATION TESTS ####################################

--================= KULLANICI GIRISI =================
DECLARE
   v_username     VARCHAR2 (50) := 'acoz';
   v_password     VARCHAR2 (50) := 'acoz_pass';
   v_new_password NUMBER;
   v_login_result BOOLEAN;
BEGIN
    
    -- Kullanıcı girişi doğrulama testi
   v_login_result := user_operation.login_user (v_username, v_password);
   v_new_password := user_operation.get_user_id (v_username, v_password);
   IF
      v_login_result
   THEN
      dbms_output.put_line ('User successfully logged in');
   ELSE
      dbms_output.put_line ('User failed to log in');
   END IF;

END;

--================= KULLANICI GIRISI =================
DECLARE
   v_username     VARCHAR2 (50) := 'user12';
   v_password     VARCHAR2 (50) := 'password1';
   v_new_password VARCHAR2 (50) := 'new_test_password';
   v_login_result BOOLEAN;
BEGIN
    
    -- Kullanıcı girişi doğrulama testi
   v_login_result := user_operation.login_user (v_username, v_password);
   IF
      v_login_result
   THEN
      dbms_output.put_line ('Kullanıcı girişi doğrulandı.');
   ELSE
      dbms_output.put_line ('Kullanıcı girişi doğrulanamadı.');
   END IF;
    
    -- Şifre değiştirme testi 
      --user_operation.change_password (v_username,v_password, v_new_password);

    /* Kullanıcı girişi doğrulama testi (yeni şifre ile)
  v_login_result := user_operation.login_user (v_username, v_new_password);
  IF v_login_result
  THEN dbms_output.put_line ('Yeni şifre ile kullanıcı girişi doğrulandı.');
  ELSE dbms_output.put_line ('Yeni şifre ile kullanıcı girişi doğrulanamadı.');
  END IF;
   */
END;

--================= YENI ÜYE GIRISI  =================

BEGIN
    -- Kullanıcı 1
   user_operation.register_user (p_username => 'user1', p_password => 'password1',
                                p_email => 'user1@example.com', p_first_name => 'John',
                                p_last_name => 'Doe', p_street => '123 Elm Street',
                                p_city => 'Springfield', p_state => 'State1',
                                p_country => 'Country1', p_postal_code => '12345');

    -- Kullanıcı 2
   user_operation.register_user (p_username => 'user2', p_password => 'password2',
                                p_email => 'user2@example.com', p_first_name => 'Jane',
                                p_last_name => 'Doe', p_street => '456 Maple Avenue',
                                p_city => 'Springfield', p_state => 'State2',
                                p_country => 'Country2', p_postal_code => '23456');

    -- Kullanıcı 3
   user_operation.register_user (p_username => 'user3', p_password => 'password3',
                                p_email => 'user3@example.com', p_first_name => 'Alice',
                                p_last_name => 'Smith', p_street => '789 Oak Lane',
                                p_city => 'Springfield', p_state => 'State3',
                                p_country => 'Country3', p_postal_code => '34567');

END;

  
--############################ SHOPPING CART TESTS ####################################

--================= SEPETE ÜRÜN EKLEME  =================

DECLARE
   v_user_id    NUMBER := 1;
     -- Kullanıcı ID'si
   v_product_id NUMBER := 3;
     -- Ürün ID'si
   v_quantity   NUMBER := 2;
BEGIN
   shopping_cart_operation.add_product (v_user_id, v_product_id,
                                       v_quantity);
END;

--================= SEPETI GÖRÜNTÜLE  =================

DECLARE
   v_user_id NUMBER := 1;
BEGIN
   shopping_cart_operation.print_user_cart (v_user_id);
END;
--================= SEPETI TEMIZLE  =================

---- clear cart test
DECLARE
   v_user_id NUMBER := 1;
BEGIN
   shopping_cart_operation.clear_cart (v_user_id);
END;
--================= SEPETTEN ÜRÜN ÇIKAR  =================

DECLARE
   v_user_id    NUMBER := 2;
   v_product_id NUMBER := 55;
BEGIN
    -- shopping_cart_operation içindeki add_product prosedürünü çağırarak ürünü sepete eklemeye çalışma
   shopping_cart_operation.remove_product (v_user_id, v_product_id);
END;

--############################ ORDER OPERATION TESTS ####################################

--================= KULLANICI SIPARIŞLERINI GÖRÜNTÜLE  =================

DECLARE
   v_user_id NUMBER := 1;
BEGIN
   order_operation.print_user_orders (v_user_id);
END;
--================= KULLANICININ SEPETINI ONAYLA  =================

DECLARE
   v_user_id NUMBER := 1;
BEGIN
   order_operation.confirm_order (v_user_id);
END;

--================= KULLANICININ SIPARIŞLERINI DURUMUNA GÖRE GÖRÜNTÜLE =================

DECLARE
   v_user_id      NUMBER := 2;
   v_order_status VARCHAR2 (20) := 'OPEN';
BEGIN
   order_operation.print_order_by_status (v_user_id, v_order_status);
END;
--================= KULLANICININ SIPARIŞLERINI IPTAL ET =================

DECLARE
   v_order_id NUMBER := 2;
BEGIN
   order_operation.cancel_order (v_order_id);
END;
--================= KULLANICININ SIPARIŞLERINI TAMAMLA =================

DECLARE
   v_order_id NUMBER := 24;
BEGIN
   order_operation.complete_order (v_order_id);
END;

--############################ FAVORITE OPERATION TESTS ####################################

--================= ÜRÜNÜ FAVORILERE EKLE =================

DECLARE
   v_user_id    NUMBER := 3;
   v_product_id NUMBER := 4;
BEGIN
   favorite_operation.add_favorites (v_user_id, v_product_id);
END;
--================= KULLANICININ FAVORILERINI GÖRÜNTÜLE =================

DECLARE
   v_user_id NUMBER := 1;
BEGIN
   favorite_operation.get_user_favorites (v_user_id);
END;
--================= ÜRÜNÜ FAVORILERDEN KALDIR =================

DECLARE
   v_user_id    NUMBER := 3;
   v_product_id NUMBER := 4;
BEGIN
   favorite_operation.remove_favorites (v_user_id, v_product_id);
END;

--############################ PRODUCT FILTERS TESTS ####################################

DECLARE
   TYPE rc_emp IS REF CURSOR;
   v_results      rc_emp;
   v_product_name products.product_name%TYPE;
   v_unit_price   products.unit_price%TYPE;
BEGIN
   -- Fonksiyonu çağırma ve cursor'u almak
   v_results := filter (p_category_name => NULL, p_min_price => 1,
                       p_order_direction => 'asc');

   -- Cursor üzerinden sonuçları alıp yazdırma
   LOOP
      FETCH v_results INTO
         v_product_name,
         v_unit_price;
      EXIT WHEN
         v_results%notfound;

      dbms_output.put_line ('Product Name: '
                            || v_product_name
                            || ' Unit Price: '
                            || v_unit_price
                            || ' TL');

   END LOOP;

   -- Cursor'u kapatma
   CLOSE v_results;
END;

--############################ ORDER HISTORY TESTS ####################################

DECLARE
   v_user_id       NUMBER := 1;
BEGIN
   order_history_operation.save_order_history (v_user_id);
END;

--############################ PRODUCT OPERATION TESTS ####################################

DECLARE
   v_category_name   VARCHAR2 (50) := 'Books';
   v_description     VARCHAR2 (200) := 'test';
   v_product_name    VARCHAR2 (100) := 'test';
   v_category_id     NUMBER := 1;
     -- Örnek bir kategori ID'si. Var olan bir ID kullanılmalıdır.
   v_unit_price      NUMBER := 999.99;
   v_stock_quantity  NUMBER := 50;
   v_product_details VARCHAR2 (200) := 'test';
BEGIN
    -- Kategori ekleme testi
   product_operation.add_product_category (v_category_name, v_description);

    -- Ürün ekleme testi
   product_operation.add_product (v_product_name, v_category_id,
                                 v_unit_price, v_stock_quantity,
                                 v_product_details);
   product_operation.print_product_info (1);
END;

--######################################################################################



