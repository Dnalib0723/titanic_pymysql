SET GLOBAL local_infile = 1;

-- 建立使用者並授權（等價於 Bash 腳本）
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

-- 匯入 CSV（容器內 /titanic.csv）
LOAD DATA INFILE '/var/lib/mysql-files/titanic.csv'
INTO TABLE passengers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 將 Age 欄位中為 NULL 的補成平均值
UPDATE passengers
SET Age = (
    SELECT AVG(Age) FROM (
        SELECT Age FROM passengers WHERE Age IS NOT NULL
    ) AS subquery
)
WHERE Age IS NULL;

