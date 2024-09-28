-- Проверка представления списка платежей за последний месяц
SELECT * FROM payments_last_month;

-- Проверка представления счетов с балансом больше 1000
SELECT * FROM accounts_with_balance_over_1000;

-- Проверка представления счетов с суммой всех входящих платежей
SELECT * FROM accounts_with_incoming_payments;

-- Проверка представления счетов с суммой исходящих платежей, где сумма больше 100
SELECT * FROM accounts_with_outgoing_payments_above_100;

-- Проверка представления счетов с суммой исходящих платежей больше 1000
SELECT * FROM accounts_with_large_outgoing_payments;

-- Проверка представления всех страниц с названием родительской страницы
SELECT * FROM pages_with_parent_name;

-- Проверка представления всех платежей с источником
SELECT * FROM all_payments_with_source;

