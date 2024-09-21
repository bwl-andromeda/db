-- Добавление поля Статус счёта в таблицу Счета
ALTER TABLE accounts
ADD COLUMN id_status INT,
ADD CONSTRAINT fk_account_status FOREIGN KEY (id_status) REFERENCES account_statuses(id);

-- Удаление поля Системный счёт
ALTER TABLE accounts
DROP COLUMN is_system;

-- Добавление поля Дата создания в таблицу Счета
ALTER TABLE accounts
ADD COLUMN created_at TIMESTAMP DEFAULT NOW();

-- Установка значения по умолчанию для поля Баланс
ALTER TABLE accounts
ALTER COLUMN balance SET DEFAULT 0;

-- Установка значения по умолчанию для поля Дата и время в таблице Платежи
ALTER TABLE current_payments
ALTER COLUMN payment_date SET DEFAULT NOW();

-- Установка полей Дата и время и Сумма как NOT NULL
ALTER TABLE current_payments
ALTER COLUMN payment_date SET NOT NULL,
ALTER COLUMN amount SET NOT NULL;
