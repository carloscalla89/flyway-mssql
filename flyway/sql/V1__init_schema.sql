-- db/sql/V1__init_schema.sql

-- Crear esquema (si vas a separar objetos por esquema)
IF NOT EXISTS (SELECT *
FROM sys.schemas
WHERE name = 'app')
BEGIN
    EXEC('CREATE SCHEMA app');
END;
GO