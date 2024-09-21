-- Удаление всех функций
DROP FUNCTION IF EXISTS sum_two_numbers(NUMERIC, NUMERIC);
DROP FUNCTION IF EXISTS day_after_tomorrow();
DROP FUNCTION IF EXISTS total_payments_sum();
DROP FUNCTION IF EXISTS create_opposite_payment(INT);
DROP FUNCTION IF EXISTS outgoing_payments(INT, DATE, DATE);
DROP FUNCTION IF EXISTS payment_count_between_clients(INT, INT);
DROP FUNCTION IF EXISTS create_payment(TIMESTAMP, NUMERIC, INT, INT);
DROP FUNCTION IF EXISTS create_payment_and_update_balance(NUMERIC, INT, INT);
DROP FUNCTION IF EXISTS create_random_payments(TIMESTAMP, INT);
