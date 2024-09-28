-- Создание таблиц для контрагентов
CREATE TABLE legal_agents (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255)
);

CREATE TABLE individual_agents (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Изменение таблицы orders, добавление статуса и внешнего ключа на контрагента
ALTER TABLE orders
ADD COLUMN agent_id INT,
ADD COLUMN status_id INT,
ADD FOREIGN KEY (agent_id) REFERENCES legal_agents(id),
ADD FOREIGN KEY (status_id) REFERENCES statuses(id);

-- Создание таблицы статусов
CREATE TABLE statuses (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL
);

-- Заполнение таблицы статусов
INSERT INTO statuses (status_name) VALUES
('Оформлен'),
('Выполняется'),
('Завершён');

-- Создание таблицы исполнителей
CREATE TABLE executors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    employee_number INT NOT NULL
);

-- Создание таблицы для связи между заказами и исполнителями
CREATE TABLE order_executors (
    order_id INT,
    executor_id INT,
    PRIMARY KEY (order_id, executor_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (executor_id) REFERENCES executors(id)
);

