-- Добавляем владельца счета
INSERT INTO account_owners (name) VALUES ('Owner 1');

-- Добавляем два счета, один для плательщика, другой для получателя
INSERT INTO accounts (balance, id_owner) VALUES (1000.00, 1);  -- Это будет id = 1
INSERT INTO accounts (balance, id_owner) VALUES (500.00, 1);   -- Это будет id = 2



-- Пример проверок для проверки триггеров

-- Добавляем запись в payments и проверяем баланс
INSERT INTO current_payments (source_account_id, destination_account_id, amount) 
VALUES (1, 2, 100.00);

-- Проверка обновления балансов
SELECT * FROM accounts WHERE id IN (1, 2);

-- Проверка архивации платежа
SELECT * FROM archived_payments WHERE source_account_id = 1 AND destination_account_id = 2;

-- Обновляем запись в payments и проверяем баланс
UPDATE current_payments SET amount = 200.00, source_account_id = 2, destination_account_id = 1 WHERE id = 1;

-- Проверка обновления балансов
SELECT * FROM accounts WHERE id IN (1, 2);

-- Проверка архивации после обновления
SELECT * FROM archived_payments WHERE source_account_id = 2 AND destination_account_id = 1;

-- Удаление родительской страницы
DELETE FROM parent_pages WHERE id = 1;

-- Проверка удаления дочерних страниц
SELECT * FROM site_pages WHERE parent_page_id = 1;

