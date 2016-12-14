﻿IF OBJECT_ID('finance.initialize_eod_operation') IS NOT NULL
DROP PROCEDURE finance.initialize_eod_operation;

GO

CREATE PROCEDURE finance.initialize_eod_operation(@user_id integer, @office_id integer, @value_date date)
AS
BEGIN
    DECLARE this            RECORD;    

    IF(@value_date IS NULL)
    BEGIN
        RAISERROR('Invalid date.', 10, 1);
    END;

    IF(NOT account.is_admin(@user_id))
    BEGIN
        RAISERROR('Access is denied.', 10, 1);
    END;

    IF(@value_date != finance.get_value_date(@office_id))
    BEGIN
        RAISERROR('Invalid value date.', 10, 1);
    END;

    SELECT * FROM finance.day_operation
    WHERE value_date=_value_date 
    AND office_id = @office_id INTO this;

    IF(this IS NULL)
    BEGIN
        INSERT INTO finance.day_operation(office_id, value_date, started_on, started_by)
        SELECT @office_id, @value_date, GETDATE(), @user_id;
    END
    ELSE    
    BEGIN
        RAISERROR('EOD operation was already initialized.', 10, 1);
    END;

    RETURN;
END;




--SELECT finance.initialize_eod_operation(1, 1, finance.get_value_date(1));
--delete from finance.day_operation

--select * from finance.day_operation


GO