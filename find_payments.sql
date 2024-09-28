-- Запрос для поиска счёта, на который поступило больше всего денег в 2022 году
SELECT destination_account_id, SUM(amount) as total_received
FROM current_payments
WHERE EXTRACT(YEAR FROM payment_date) = 2022
GROUP BY destination_account_id
ORDER BY total_received DESC
LIMIT 1;
-------------- Добавление (EXPLAIN)
-- Добавляем EXPLAIN (ANALYZE) перед запросом
EXPLAIN (ANALYZE)
SELECT destination_account_id, SUM(amount) as total_received
FROM current_payments
WHERE EXTRACT(YEAR FROM payment_date) = 2022
GROUP BY destination_account_id
ORDER BY total_received DESC
LIMIT 1;

