
SET GLOBAL local_infile = 1;

CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON titanic.* TO 'user'@'%';
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS passengers (
  PassengerId INT,
  Survived INT,
  Pclass INT,
  Name VARCHAR(255),
  Sex VARCHAR(10),
  Age FLOAT,
  SibSp INT,
  Parch INT,
  Ticket VARCHAR(50),
  Fare FLOAT,
  Cabin VARCHAR(50),
  Embarked VARCHAR(10)
);

LOAD DATA INFILE '/var/lib/mysql-files/titanic.csv'
INTO TABLE passengers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

UPDATE passengers
SET Age = (
    SELECT AVG(Age) FROM (
        SELECT Age FROM passengers WHERE Age IS NOT NULL
    ) AS subquery
)
WHERE Age IS NULL;
