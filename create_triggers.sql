-- Триггерная функция для обновления баланса при добавлении/удалении записи в payments
CREATE OR REPLACE FUNCTION update_balance_on_insert_delete()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Уменьшаем баланс у плательщика
        UPDATE accounts SET balance = balance - NEW.amount WHERE id = NEW.source_account_id;
        -- Увеличиваем баланс у получателя
        UPDATE accounts SET balance = balance + NEW.amount WHERE id = NEW.destination_account_id;
    ELSIF TG_OP = 'DELETE' THEN
        -- Возвращаем баланс у плательщика
        UPDATE accounts SET balance = balance + OLD.amount WHERE id = OLD.source_account_id;
        -- Уменьшаем баланс у получателя
        UPDATE accounts SET balance = balance - OLD.amount WHERE id = OLD.destination_account_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для таблицы current_payments
CREATE TRIGGER trg_update_balance_on_insert_delete
AFTER INSERT OR DELETE ON current_payments
FOR EACH ROW EXECUTE FUNCTION update_balance_on_insert_delete();

-- Триггерная функция для архивации записи при добавлении в payments
CREATE OR REPLACE FUNCTION archive_payment_on_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO archived_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (NEW.source_account_id, NEW.destination_account_id, NEW.payment_date, NEW.amount);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для таблицы current_payments
CREATE TRIGGER trg_archive_payment_on_insert
AFTER INSERT ON current_payments
FOR EACH ROW EXECUTE FUNCTION archive_payment_on_insert();

-- Триггерная функция для обновления баланса и архивации при изменении записи в payments
CREATE OR REPLACE FUNCTION update_balance_and_archive_on_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Восстанавливаем баланс у старого плательщика и получателя
    UPDATE accounts SET balance = balance + OLD.amount WHERE id = OLD.source_account_id;
    UPDATE accounts SET balance = balance - OLD.amount WHERE id = OLD.destination_account_id;
    
    -- Уменьшаем баланс у нового плательщика и увеличиваем у получателя
    UPDATE accounts SET balance = balance - NEW.amount WHERE id = NEW.source_account_id;
    UPDATE accounts SET balance = balance + NEW.amount WHERE id = NEW.destination_account_id;
    
    -- Добавляем запись в архив
    INSERT INTO archived_payments (source_account_id, destination_account_id, payment_date, amount)
    VALUES (NEW.source_account_id, NEW.destination_account_id, NEW.payment_date, NEW.amount);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для таблицы current_payments
CREATE TRIGGER trg_update_balance_and_archive_on_update
AFTER UPDATE ON current_payments
FOR EACH ROW EXECUTE FUNCTION update_balance_and_archive_on_update();

-- Триггерная функция для удаления дочерних записей при удалении записи в parent_pages
CREATE OR REPLACE FUNCTION delete_child_pages()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM site_pages WHERE parent_page_id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для таблицы parent_pages
CREATE TRIGGER trg_delete_child_pages
AFTER DELETE ON parent_pages
FOR EACH ROW EXECUTE FUNCTION delete_child_pages();

