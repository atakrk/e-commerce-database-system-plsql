--------------------------------------------------------
--  File created - Wednesday-January-17-2024   
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Trigger OPERATION_LOGS_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "OPERATION_LOGS_ON_INSERT" BEFORE
   INSERT ON operation_logs
   FOR EACH ROW
BEGIN
   SELECT operation_logs_sequence.NEXTVAL
   INTO :new.log_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger ORDERS_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "ORDERS_ON_INSERT" BEFORE
   INSERT ON orders
   FOR EACH ROW
BEGIN
   SELECT orders_sequence.NEXTVAL
   INTO :new.order_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger ORDER_DETAILS_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "ORDER_DETAILS_ON_INSERT" BEFORE
   INSERT ON order_details
   FOR EACH ROW
BEGIN
   SELECT order_details_sequence.NEXTVAL
   INTO :new.detail_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger PRODUCT_CATEGORIES_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "PRODUCT_CATEGORIES_ON_INSERT" BEFORE
   INSERT ON product_categories
   FOR EACH ROW
BEGIN
   SELECT product_categories_sequence.NEXTVAL
   INTO :new.category_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger PRODUCT_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "PRODUCT_ON_INSERT" BEFORE
   INSERT ON products
   FOR EACH ROW
BEGIN
   SELECT product_sequence.NEXTVAL
   INTO :new.product_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger SHOPPING_CART_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "SHOPPING_CART_ON_INSERT" BEFORE
   INSERT ON shopping_cart
   FOR EACH ROW
BEGIN
   SELECT shopping_cart_sequence.NEXTVAL
   INTO :new.cart_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger USERS_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "USERS_ON_INSERT" BEFORE
   INSERT ON users
   FOR EACH ROW
BEGIN
   SELECT users_sequence.NEXTVAL
   INTO :new.user_id
   FROM dual;

END;
/
--------------------------------------------------------
--  DDL for Trigger USER_FAVORITES_ON_INSERT
--------------------------------------------------------

  CREATE OR REPLACE   TRIGGER  "USER_FAVORITES_ON_INSERT" BEFORE
   INSERT ON user_favorites
   FOR EACH ROW
BEGIN
   SELECT user_favorites_sequence.NEXTVAL
   INTO :new.favorite_id
   FROM dual;

END;
/
