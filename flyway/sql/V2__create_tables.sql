-- Tabla de clientes
IF OBJECT_ID('dbo.Customer', 'U') IS NULL
BEGIN
    CREATE TABLE app.Customer
    (
        CustomerId INT IDENTITY(1,1) PRIMARY KEY,
        DocumentType VARCHAR(10) NOT NULL,
        DocumentNumber VARCHAR(32) NOT NULL,
        FullName NVARCHAR(200) NOT NULL,
        Email VARCHAR(200) NULL,
        CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
        UpdatedAt DATETIME2(3) NULL
    );
    CREATE UNIQUE INDEX UX_Customer_Doc ON app.Customer (DocumentType, DocumentNumber);
END
GO

-- Tabla de cuentas
IF OBJECT_ID('dbo.Account', 'U') IS NULL
BEGIN
    CREATE TABLE app.Account
    (
        AccountId BIGINT IDENTITY(1,1) PRIMARY KEY,
        CustomerId INT NOT NULL,
        AccountNumber VARCHAR(34) NOT NULL,
        Currency CHAR(3) NOT NULL DEFAULT 'PEN',
        Balance DECIMAL(18,2) NOT NULL DEFAULT 0,
        Status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
        CreatedAt DATETIME2(3) NOT NULL DEFAULT SYSDATETIME(),
        CONSTRAINT FK_Account_Customer FOREIGN KEY (CustomerId)
            REFERENCES app.Customer(CustomerId)
    );
    CREATE UNIQUE INDEX UX_Account_AccountNumber ON app.Account (AccountNumber);
END
GO
