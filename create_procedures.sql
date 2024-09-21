-- Процедура, которая создаёт запись в таблице payments
CREATE OR REPLACE PROCEDURE create_payment_proc(payment_date TIMESTAMP, amount NUMERIC, payer_id INT, recipient_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (payer_id, recipient_id, payment_date, amount);
END;
$$;

-- Процедура с OUT параметром new_id
CREATE OR REPLACE PROCEDURE create_payment_and_return_id(amount NUMERIC, payer_id INT, recipient_id INT, OUT new_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (payer_id, recipient_id, NOW(), amount) RETURNING id INTO new_id;

    UPDATE accounts SET balance = balance - amount WHERE id = payer_id;
    UPDATE accounts SET balance = balance + amount WHERE id = recipient_id;
END;
$$;

-- Процедура для создания записи и обновления архива, если дата платежа старая
CREATE OR REPLACE PROCEDURE create_payment_and_check_archive(amount NUMERIC, payer_id INT, recipient_id INT, payment_date TIMESTAMP, OUT new_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO current_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (payer_id, recipient_id, payment_date, amount) RETURNING id INTO new_id;

    UPDATE accounts SET balance = balance - amount WHERE id = payer_id;
    UPDATE accounts SET balance = balance + amount WHERE id = recipient_id;

    IF payment_date < NOW() - INTERVAL '2 weeks' THEN
        INSERT INTO archived_payments (source_account_id, destination_account_id, payment_date, amount)
        VALUES (payer_id, recipient_id, payment_date, amount);
    END IF;
END;
$$;

-- Процедура, создающая n случайных платежей
CREATE OR REPLACE PROCEDURE create_random_payments_proc(payment_date TIMESTAMP, n INT)
LANGUAGE plpgsql AS $$
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
$$;

-- Процедура для проверки корректности баланса клиента
CREATE OR REPLACE PROCEDURE check_client_balance(client_id INT, OUT is_correct BOOLEAN, OUT delta NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE
    actual_balance NUMERIC;
    expected_balance NUMERIC;
BEGIN
    SELECT SUM(balance) INTO actual_balance FROM accounts WHERE id_owner = client_id;

    SELECT SUM(amount) INTO expected_balance
    FROM current_payments
    WHERE source_account_id IN (SELECT id FROM accounts WHERE id_owner = client_id)
       OR destination_account_id IN (SELECT id FROM accounts WHERE id_owner = client_id);

    delta := actual_balance - expected_balance;
    is_correct := (delta = 0);
END;
$$;

-- Процедура для создания иерархии страниц
CREATE OR REPLACE PROCEDURE create_page_with_hierarchy(name TEXT, parent_id INT, OUT new_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO site_pages (name, parent_page_id) VALUES (name, parent_id) RETURNING id INTO new_id;
END;
$$;

-- Процедура для получения самого верхнего уровня в иерархии
CREATE OR REPLACE PROCEDURE get_root_page(name TEXT, OUT root_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    WITH RECURSIVE page_hierarchy AS (
        SELECT id, parent_page_id
        FROM site_pages
        WHERE name = name
        UNION ALL
        SELECT sp.id, sp.parent_page_id
        FROM site_pages sp
        JOIN page_hierarchy ph ON sp.id = ph.parent_page_id
    )
    SELECT id INTO root_id FROM page_hierarchy WHERE parent_page_id IS NULL;
END;
$$;
