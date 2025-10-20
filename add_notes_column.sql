-- ===================================================================
-- Add notes column to StockTransactions table
-- ===================================================================

USE DentalClinicDB_MVP;
GO

-- Add notes column to StockTransactions table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StockTransactions') AND name = 'notes')
BEGIN
    ALTER TABLE StockTransactions 
    ADD notes NVARCHAR(500) NULL;
    
    PRINT 'Added notes column to StockTransactions table';
END
ELSE
BEGIN
    PRINT 'Notes column already exists in StockTransactions table';
END
GO

-- Verify the column was added
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'StockTransactions' 
AND COLUMN_NAME = 'notes';
GO

PRINT 'StockTransactions table structure updated successfully!';
