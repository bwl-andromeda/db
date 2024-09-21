-- Выполнение процедур
CALL create_payment_proc('2024-01-01 12:00:00', 500.00, 1, 2);

CALL create_payment_and_return_id(500.00, 1, 2, new_id := NULL);
SELECT new_id;

CALL create_payment_and_check_archive(500.00, 1, 2, '2023-01-01 12:00:00', new_id := NULL);
SELECT new_id;

CALL create_random_payments_proc('2024-01-01 12:00:00', 5);

CALL check_client_balance(1, is_correct := NULL, delta := NULL);
SELECT is_correct, delta;

CALL create_page_with_hierarchy('Платежи', NULL, new_id := NULL);
SELECT new_id;

CALL get_root_page('Исходящие платежи', root_id := NULL);
SELECT root_id;
