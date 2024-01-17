--------------------------------------------------------
--  File created - Wednesday-January-17-2024   
--------------------------------------------------------


--------------------------------------------------------
--  DDL for Procedure ADVANCED_FILTER_PRODUCTS
--------------------------------------------------------
 

  CREATE OR REPLACE   PROCEDURE  "ADVANCED_FILTER_PRODUCTS" (
    p_category_name IN VARCHAR2 DEFAULT NULL,
    p_min_price IN NUMBER DEFAULT NULL,
    p_max_price IN NUMBER DEFAULT NULL,
    p_order_by IN VARCHAR2 DEFAULT 'product_name',
    p_order_direction IN VARCHAR2 DEFAULT 'ASC'
) AS
    v_sql VARCHAR2(1000);
    v_where_clause VARCHAR2(500) := ' WHERE 1=1';
    v_order_by_clause VARCHAR2(100);
    TYPE t_cursor IS REF CURSOR;
    v_cursor t_cursor;
    v_product_name VARCHAR2(100);
    v_unit_price NUMBER;
BEGIN
    -- Dinamik WHERE koşulunu oluşturma
    IF p_category_name IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND pc.category_name = ''' || p_category_name || '''';
    END IF;

    IF p_min_price IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND p.unit_price >= ' || p_min_price;
    END IF;

    IF p_max_price IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND p.unit_price <= ' || p_max_price;
    END IF;

    -- Sıralama koşulunu oluşturma
    v_order_by_clause := ' ORDER BY ' || p_order_by || ' ' || p_order_direction;

    -- SQL sorgusunu oluşturma
    v_sql := 'SELECT p.product_name, p.unit_price
              FROM products p
              JOIN product_categories pc ON p.category_id = pc.category_id'
              || v_where_clause
              || v_order_by_clause;

    -- Dinamik SQL sorgusunu çalıştırma
    OPEN v_cursor FOR v_sql;
    LOOP
        FETCH v_cursor INTO v_product_name, v_unit_price;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_product_name || ', ' || v_unit_price);
    END LOOP;
    CLOSE v_cursor;
  
END advanced_filter_products;

/
--------------------------------------------------------
--  DDL for Procedure CLEAR_CART_ORDER
--------------------------------------------------------
 

  CREATE OR REPLACE   PROCEDURE  "CLEAR_CART_ORDER" (
   p_user_id IN NUMBER
) IS
BEGIN

        -- Sepeti temizle ve shopping_cart tablosundan sil
   DELETE FROM product_shoppingcart ps
   WHERE ps.cart_id IN (
      SELECT cart_id
      FROM shopping_cart
   );

   DELETE FROM shopping_cart
   WHERE user_id = p_user_id;

   COMMIT;
END clear_cart_order;

/
--------------------------------------------------------
--  DDL for Procedure PRINT_CART_CURSOR
--------------------------------------------------------
 

  CREATE OR REPLACE   PROCEDURE  "PRINT_CART_CURSOR" (
   p_user_id IN NUMBER
) IS
BEGIN
   FOR cart_record IN (
      SELECT ps.product_id,
             p.product_name,
             p.unit_price,
             ps.quantity,
             p.unit_price * ps.quantity AS total_price
      FROM product_shoppingcart ps
      JOIN products p ON ps.product_id = p.product_id
      JOIN shopping_cart sc ON ps.cart_id = sc.cart_id
      WHERE sc.user_id = p_user_id
   ) LOOP
      dbms_output.put_line ('Product ID: '
                            || cart_record.product_id
                            || ' | Product Name: '
                            || cart_record.product_name
                            || ' | Product Price: '
                            || cart_record.unit_price
                            || ' TL'
                            || ' | Quantity: '
                            || cart_record.quantity
                            || ' | Total Price: '
                            || cart_record.total_price
                            || ' TL');
   END LOOP;
END print_cart_cursor;

/
--------------------------------------------------------
--  DDL for Procedure UPDATE_STOCK_AFTER_ADD
--------------------------------------------------------
 

  CREATE OR REPLACE   PROCEDURE  "UPDATE_STOCK_AFTER_ADD" (
   p_product_id IN NUMBER,
   p_quantity   IN NUMBER
) IS
BEGIN
   UPDATE products
   SET
      stock_quantity = stock_quantity - p_quantity
   WHERE product_id = p_product_id;

   COMMIT;
END update_stock_after_add;

/
--------------------------------------------------------
--  DDL for Procedure UPDATE_STOCK_AFTER_REMOVE
--------------------------------------------------------
 

  CREATE OR REPLACE   PROCEDURE  "UPDATE_STOCK_AFTER_REMOVE" (
   p_product_id IN NUMBER,
   p_quantity   IN NUMBER
) IS
BEGIN
        -- Sepetten kaldırılan ürünleri stoklara geri ekle
   UPDATE products
   SET
      stock_quantity = stock_quantity + p_quantity
   WHERE product_id = p_product_id;

   COMMIT;
END update_stock_after_remove;


--------------------------------------------------------
--  DDL for Function CALCULATE_CART_TOTAL
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "CALCULATE_CART_TOTAL" (
   p_user_id IN NUMBER
) RETURN NUMBER IS
   v_total_amount NUMBER := 0;
   v_cart_count   NUMBER := 0;
    BEGIN
            -- Kullanıcının sepetindeki ürünlerin toplam tutarını hesapla
    SELECT COUNT (*)
    INTO v_cart_count
    FROM shopping_cart sc
    WHERE sc.user_id = p_user_id;

            -- Eğer kullanıcıya ait bir sepet yoksa veya sepet boşsa, hata mesajı ver
    IF v_cart_count != 0
    THEN
        SELECT SUM (ps.quantity * p.unit_price)
        INTO v_total_amount
        FROM product_shoppingcart ps
        JOIN products p ON ps.product_id = p.product_id
        JOIN shopping_cart sc ON ps.cart_id = sc.cart_id
        WHERE sc.user_id = p_user_id;

        RETURN v_total_amount;
    ELSE
        dbms_output.put_line ('The user''s shopping cart is empty or does not exist.');
        RETURN NULL;
    END IF;

    EXCEPTION
    WHEN OTHERS
    THEN
                    -- Hata durumunda burada gerekli işlemler yapılabilir, hata mesajı yazdırılabilir.
        dbms_output.put_line ('Hata: ' || sqlerrm);
        RETURN NULL;
        -- Hata durumunda NULL döndür
END calculate_cart_total;

/
--------------------------------------------------------
--  DDL for Function FILTER
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "FILTER" (
   p_category_name   IN VARCHAR2 DEFAULT NULL,
   p_min_price       IN NUMBER DEFAULT NULL,
   p_max_price       IN NUMBER DEFAULT NULL,
   p_order_by        IN VARCHAR2 DEFAULT 'product_name',
   p_order_direction IN VARCHAR2 DEFAULT 'ASC'
) RETURN SYS_REFCURSOR
AS
   v_cursor          SYS_REFCURSOR;
   v_sql             VARCHAR2(1000);
   v_where_clause    VARCHAR2(500) := ' WHERE 1=1';
   v_order_by_clause VARCHAR2(100);
BEGIN
    -- Dinamik WHERE koşulunu oluşturma
    IF p_category_name IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND pc.category_name = ''' || p_category_name || '''';
    END IF;

    IF p_min_price IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND p.unit_price >= ' || p_min_price;
    END IF;

    IF p_max_price IS NOT NULL THEN
        v_where_clause := v_where_clause || ' AND p.unit_price <= ' || p_max_price;
    END IF;

    -- Sıralama koşulunu oluşturma
    v_order_by_clause := ' ORDER BY ' || p_order_by || ' ' || p_order_direction;

    -- SQL sorgusunu oluşturma
    v_sql := 'SELECT p.product_name, p.unit_price
              FROM products p
              JOIN product_categories pc ON p.category_id = pc.category_id'
            || v_where_clause
            || v_order_by_clause;

    -- Cursor'u açarak sonuçları döndürme
    OPEN v_cursor FOR v_sql;
RETURN v_cursor;
END filter;

/
--------------------------------------------------------
--  DDL for Function GET_SHA256_HASH
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "GET_SHA256_HASH" (
   p_input IN VARCHAR2
) RETURN VARCHAR2 AS
   v_hash_raw RAW (2000);
   v_hash_hex VARCHAR2 (4000);
BEGIN
   v_hash_raw := dbms_crypto.hash (utl_i18n.string_to_raw (p_input, 'AL32UTF8'), dbms_crypto.hash_sh256);

   v_hash_hex := lower (rawtohex (v_hash_raw));
   RETURN v_hash_hex;
END get_sha256_hash;

/
--------------------------------------------------------
--  DDL for Function IS_CATEGORY_EXISTS
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "IS_CATEGORY_EXISTS" (
   p_category_name IN product_categories.category_name%TYPE
) RETURN BOOLEAN IS
   v_count NUMBER;
BEGIN
   SELECT COUNT (*)
   INTO v_count
   FROM product_categories
   WHERE category_name = p_category_name;

   IF v_count > 0
   THEN RETURN TRUE;
   ELSE RETURN FALSE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
        -- Hata durumunda FALSE döndür veya isteğe bağlı olarak bir hata mesajı göster 
        RETURN FALSE;
END is_category_exists;

/
--------------------------------------------------------
--  DDL for Function IS_PRODUCT_EXISTS
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "IS_PRODUCT_EXISTS" (
   p_product_id IN products.product_id%TYPE
) RETURN BOOLEAN IS
   v_count NUMBER;
BEGIN
   SELECT COUNT (*)
   INTO v_count
   FROM products
   WHERE product_id = p_product_id;

   IF v_count > 0
   THEN RETURN TRUE;
   ELSE RETURN FALSE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
        -- Hata durumunda FALSE döndür veya isteğe bağlı olarak bir hata mesajı göster 
        RETURN FALSE;
END is_product_exists;

/
--------------------------------------------------------
--  DDL for Function IS_USER_EXISTS
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "IS_USER_EXISTS" (
   p_user_id IN users.user_id%TYPE
) RETURN BOOLEAN IS
   v_count NUMBER;
BEGIN
   SELECT COUNT (*)
   INTO v_count
   FROM users
   WHERE user_id = p_user_id;

   IF v_count > 0
   THEN RETURN TRUE;
   ELSE RETURN FALSE;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
        -- Hata durumunda FALSE döndür veya isteğe bağlı olarak bir hata mesajı göster 
    RETURN FALSE;
END is_user_exists;

/
--------------------------------------------------------
--  DDL for Function TABLE_COUNT
--------------------------------------------------------

  CREATE OR REPLACE   FUNCTION  "TABLE_COUNT" (
   table_name_in IN all_tables.table_name%TYPE,
   where_in      IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER IS
   l_table_name all_tables.table_name%TYPE;
   l_return     NUMBER;
BEGIN
   l_table_name := sys.dbms_assert.sql_object_name (table_name_in);
   EXECUTE IMMEDIATE 'SELECT COUNT (*)       
            FROM '
                     || l_table_name
                     || CASE
      WHEN
         where_in IS NOT NULL
      THEN
         ' WHERE ' || where_in
      ELSE NULL
   END
   INTO l_return;

   RETURN l_return;
END;

/
