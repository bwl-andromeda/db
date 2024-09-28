-- Заполнение таблицы current_payments 100000 записями
DO $$
DECLARE
    i INT;
    source_account_id INT;
    destination_account_id INT;
    payment_amount DECIMAL(10, 2);
    payment_date TIMESTAMP;
BEGIN
    FOR i IN 1..100000 LOOP
        -- Генерация случайных значений для платежей
        source_account_id := (SELECT id FROM accounts ORDER BY RANDOM() LIMIT 1);
        destination_account_id := (SELECT id FROM accounts WHERE id != source_account_id ORDER BY RANDOM() LIMIT 1);
        payment_amount := ROUND((RANDOM() * 1000 + 1)::numeric, 2);
        payment_date := '2022-01-01'::date + (RANDOM() * 365)::int * '1 day'::interval;

        -- Вставка платежа
        INSERT INTO current_payments (source_account_id, destination_account_id, amount, payment_date)
        VALUES (source_account_id, destination_account_id, payment_amount, payment_date);
    END LOOP;
END $$;

