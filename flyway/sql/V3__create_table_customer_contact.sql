/* V3 - Crear tabla de contactos de clientes */
SET XACT_ABORT ON;

IF OBJECT_ID(N'dbo.CustomerContact', N'U') IS NULL
BEGIN
    CREATE TABLE app.CustomerContact
    (
        contact_id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        customer_code VARCHAR(50) NOT NULL,
        -- código de cliente (texto, sin FK obligatoria)
        email VARCHAR(320) NULL,
        phone VARCHAR(32) NULL,
        is_primary BIT NOT NULL CONSTRAINT DF_CustomerContact_is_primary DEFAULT(0),
        created_at DATETIME2(3) NOT NULL CONSTRAINT DF_CustomerContact_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at DATETIME2(3) NULL
    );

    -- Índices útiles
    CREATE UNIQUE INDEX UX_CustomerContact_customer_email
        ON app.CustomerContact (customer_code, email)
        WHERE email IS NOT NULL;

    CREATE INDEX IX_CustomerContact_customer
        ON app.CustomerContact (customer_code);
END;
