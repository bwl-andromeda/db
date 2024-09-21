-- Функция, возвращающая сумму двух чисел
CREATE OR REPLACE FUNCTION sum_two_numbers(a NUMERIC, b NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

-- Функция, возвращающая дату, которая будет послезавтра
CREATE OR REPLACE FUNCTION day_after_tomorrow()
RETURNS DATE AS $$
BEGIN
    RETURN CURRENT_DATE + INTERVAL '2 days';
END;
$$ LANGUAGE plpgsql;

-- Функция, возвращающая сумму всех проведённых платежей
CREATE OR REPLACE FUNCTION total_payments_sum()
RETURNS NUMERIC AS $$
BEGIN
    RETURN (SELECT SUM(amount) FROM current_payments);
END;
$$ LANGUAGE plpgsql;

-- Функция с параметром id платежа, которая создаёт 'противоположный' платёж
CREATE OR REPLACE FUNCTION create_opposite_payment(payment_id INT)
RETURNS VOID AS $$
DECLARE
    source_id INT;
    destination_id INT;
    payment_date TIMESTAMP;
    amount NUMERIC;
BEGIN
    SELECT source_account_id, destination_account_id, payment_date, amount
    INTO source_id, destination_id, payment_date, amount
    FROM current_payments WHERE id = payment_id;

    INSERT INTO current_payments(source_account_id, destination_account_id, payment_date, amount)
    VALUES (destination_id, source_id, payment_date, amount);
END;
$$ LANGUAGE plpgsql;

-- Функция с параметрами id клиента, дата1, дата2, возвращающая все исходящие платежи между датами
CREATE OR REPLACE FUNCTION outgoing_payments(client_id INT, date1 DATE, date2 DATE)
RETURNS TABLE(payment_date TIMESTAMP, amount NUMERIC, destination_account INT) AS $$
BEGIN
    RETURN QUERY
    SELECT cp.payment_date, cp.amount, cp.destination_account_id
    FROM current_payments cp
    JOIN accounts a ON cp.source_account_id = a.id
    WHERE a.id_owner = client_id
    AND cp.payment_date BETWEEN date1 AND date2;
END;
$$ LANGUAGE plpgsql;

-- Функция с параметрами id клиента1, id клиента2, возвращающая количество платежей между ними
CREATE OR REPLACE FUNCTION payment_count_between_clients(client1_id INT, client2_id INT)
RETURNS INT AS $$
BEGIN
    RETURN (SELECT COUNT(*)
            FROM current_payments cp
            JOIN accounts a1 ON cp.source_account_id = a1.id
            JOIN accounts a2 ON cp.destination_account_id = a2.id
            WHERE a1.id_owner = client1_id AND a2.id_owner = client2_id);
END;
$$ LANGUAGE plpgsql;

-- Функция, которая создаёт запись в таблице payments
CREATE OR REPLACE FUNCTION create_payment(payment_date TIMESTAMP, amount NUMERIC, payer_id INT, recipient_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (payer_id, recipient_id, payment_date, amount);
END;
$$ LANGUAGE plpgsql;

-- Функция, создающая запись в таблице payments и меняющая баланс
CREATE OR REPLACE FUNCTION create_payment_and_update_balance(amount NUMERIC, payer_id INT, recipient_id INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (payer_id, recipient_id, NOW(), amount);

    UPDATE accounts SET balance = balance - amount WHERE id = payer_id;
    UPDATE accounts SET balance = balance + amount WHERE id = recipient_id;
END;
$$ LANGUAGE plpgsql;

-- Функция с параметрами дата и количество(n), которая создаёт n записей в таблице payments
CREATE OR REPLACE FUNCTION create_random_payments(payment_date TIMESTAMP, n INT)
RETURNS VOID AS $$
DECLARE
    i INT;
    payer_id INT;
    recipient_id INT;
    amount NUMERIC;
BEGIN
    FOR i IN 1..n LOOP
        payer_id := (SELECT id FROM accounts ORDER BY random() LIMIT 1);
        recipient_id := (SELECT id FROM accounts WHERE id != payer_id ORDER BY random() LIMIT 1);
        amount := round(random() * 1000, 2);

        INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
        VALUES (payer_id, recipient_id, payment_date, amount);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
