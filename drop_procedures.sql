-- Удаление всех процедур
DROP PROCEDURE IF EXISTS create_payment_proc(TIMESTAMP, NUMERIC, INT, INT);
DROP PROCEDURE IF EXISTS create_payment_and_return_id(NUMERIC, INT, INT, OUT INT);
DROP PROCEDURE IF EXISTS create_payment_and_check_archive(NUMERIC, INT, INT, TIMESTAMP, OUT INT);
DROP PROCEDURE IF EXISTS create_random_payments_proc(TIMESTAMP, INT);
DROP PROCEDURE IF EXISTS check_client_balance(INT, OUT BOOLEAN, OUT NUMERIC);
DROP PROCEDURE IF EXISTS create_page_with_hierarchy(TEXT, INT, OUT INT);
DROP PROCEDURE IF EXISTS get_root_page(TEXT, OUT INT);
