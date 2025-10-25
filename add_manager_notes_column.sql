-- Add manager_notes column to ScheduleRequests table
ALTER TABLE ScheduleRequests ADD manager_notes NVARCHAR(500) NULL;
GO
