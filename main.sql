CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE messages (
    id INT PRIMARY KEY,
    user_id INT,
    message TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE rules (
    id INT PRIMARY KEY,
    rule_name VARCHAR(255),
    rule_description TEXT
);

CREATE TABLE linter_results (
    id INT PRIMARY KEY,
    user_id INT,
    rule_id INT,
    message_id INT,
    result BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (rule_id) REFERENCES rules(id),
    FOREIGN KEY (message_id) REFERENCES messages(id)
);

INSERT INTO users (id, name, email) VALUES
(1, 'John Doe', 'john@example.com'),
(2, 'Jane Doe', 'jane@example.com');

INSERT INTO messages (id, user_id, message) VALUES
(1, 1, 'Hello, world!'),
(2, 2, 'Hi, everyone!');

INSERT INTO rules (id, rule_name, rule_description) VALUES
(1, 'Rule 1', 'This is rule 1'),
(2, 'Rule 2', 'This is rule 2');

INSERT INTO linter_results (id, user_id, rule_id, message_id, result) VALUES
(1, 1, 1, 1, TRUE),
(2, 2, 1, 2, FALSE),
(3, 1, 2, 1, TRUE),
(4, 2, 2, 2, TRUE);

CREATE VIEW user_linter_results AS
SELECT u.name, r.rule_name, lr.result
FROM users u
JOIN linter_results lr ON u.id = lr.user_id
JOIN rules r ON lr.rule_id = r.id;

CREATE VIEW message_linter_results AS
SELECT m.message, r.rule_name, lr.result
FROM messages m
JOIN linter_results lr ON m.id = lr.message_id
JOIN rules r ON lr.rule_id = r.id;

CREATE PROCEDURE run_linter()
BEGIN
    INSERT INTO linter_results (user_id, rule_id, message_id, result)
    SELECT u.id, r.id, m.id, FALSE
    FROM users u
    JOIN messages m ON u.id = m.user_id
    JOIN rules r ON TRUE;
END;

CREATE TRIGGER update_linter_results
AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    CALL run_linter();
END;

SELECT * FROM user_linter_results;
SELECT * FROM message_linter_results;