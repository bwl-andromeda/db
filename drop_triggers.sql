-- Удаляем триггеры
DROP TRIGGER IF EXISTS trg_update_balance_on_insert_delete ON current_payments;
DROP TRIGGER IF EXISTS trg_archive_payment_on_insert ON current_payments;
DROP TRIGGER IF EXISTS trg_update_balance_and_archive_on_update ON current_payments;
DROP TRIGGER IF EXISTS trg_delete_child_pages ON parent_pages;

-- Удаляем функции триггеров
DROP FUNCTION IF EXISTS update_balance_on_insert_delete;
DROP FUNCTION IF EXISTS archive_payment_on_insert;
DROP FUNCTION IF EXISTS update_balance_and_archive_on_update;
DROP FUNCTION IF EXISTS delete_child_pages;

