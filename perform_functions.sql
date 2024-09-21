-- Выполнение функций из create_functions.sql
SELECT sum_two_numbers(10, 20); -- 30

SELECT day_after_tomorrow(); -- Дата через 2 дня

SELECT total_payments_sum(); -- Сумма всех платежей

-- Создание противоположного платежа
SELECT create_opposite_payment(1);

-- Получение всех исходящих платежей клиента между датами
SELECT * FROM outgoing_payments(1, '2023-01-01', '2023-12-31');

-- Количество платежей между двумя клиентами
SELECT payment_count_between_clients(1, 2);

-- Создание платежа
SELECT create_payment('2024-01-01 12:00:00', 500.00, 1, 2);

-- Создание платежа и обновление баланса
SELECT create_payment_and_update_balance(500.00, 1, 2);

-- Создание 5 случайных платежей
SELECT create_random_payments('2024-01-01 12:00:00', 5);
