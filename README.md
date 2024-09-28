### 1. Анализ схемы БД на соответствие нормальным формам

Мы должны убедиться, что каждая таблица в схеме соответствует нормальным формам (1НФ, 2НФ, 3НФ):
- **1NF**: Все столбцы таблицы должны содержать атомарные значения.
- **2NF**: Таблица должна находиться в 1NF, и каждый неключевой атрибут должен зависеть от первичного ключа.
- **3NF**: Таблица должна находиться во 2NF, и ни один неключевой атрибут не должен зависеть от других неключевых атрибутов.

### 2. Предложенные изменения

**Контрагенты (agents)**:
- Возможно нарушение 2НФ и 3НФ, так как ФИО и Адрес зависят от Названия (в случае юридических лиц). Следует разделить эти данные на отдельные таблицы.

**Заказы (orders)**:
- Есть риск нарушения нормальных форм из-за многозначных атрибутов для статуса и исполнителей. Нам нужно создать отдельную таблицу для связи между заказами и исполнителями.

### Обновлённая схема после нормализации:

1. **Контрагенты (agents)**:
    - Таблица "Контрагенты" может быть разделена на две: "Юридические лица" и "Физические лица". Общие данные (например, Название и Адрес) могут остаться в одной таблице, а специфические данные (например, ФИО для физических лиц) — в другой.
  
    Таблицы:
    - `legal_agents (id, name, address, contact_person)`
    - `individual_agents (id, full_name, address)`

2. **Заказы (orders)**:
    - Необходимо добавить таблицу для хранения связей "Заказ - Исполнитель".
    - Также необходимо вынести статус заказа в отдельную таблицу для соответствия 3НФ.

    Таблицы:
    - `orders (id, amount, date, agent_id, status_id)`
    - `order_executors (order_id, executor_id)`
    - `statuses (id, status_name)`

3. **Исполнители (executors)**:
    - Таблица остается, но создаётся связь с заказами через новую таблицу связи `order_executors`.

    Таблицы:
    - `executors (id, full_name, phone, employee_number)`

### 3. Скрипт `alter_schema.sql`

```sql
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
```

### 4. Выводы

В ходе работы была проведена нормализация схемы базы данных, которая включала:
- Разделение данных о контрагентах на юридических и физических лиц.
- Введение новых таблиц для хранения статусов заказов и связи между заказами и исполнителями.
- Все отношения были приведены к третьей нормальной форме для устранения избыточности и возможных аномалий при обновлении данных.

Результатом работы является оптимизированная и нормализованная схема базы данных, которая улучшает её структурную целостность и производительность при выполнении операций.
