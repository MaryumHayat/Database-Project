-- 1. First, let's see what's in the Notification table
SELECT * FROM Notification ORDER BY Date DESC, Time DESC;

-- 2. Check for notifications without Customer_id
SELECT * FROM Notification WHERE Customer_id IS NULL;

-- 3. If there are NULL values, we need to fix them
-- First, backup the table (optional)
SELECT * INTO Notification_Backup FROM Notification;

-- 4. Delete notifications with NULL Customer_id
DELETE FROM Notification WHERE Customer_id IS NULL;

-- 5. Now check which customers have notifications
SELECT DISTINCT Customer_id FROM Notification ORDER BY Customer_id;

-- 6. If you need to assign Customer_id to notifications, you can try:
-- (This assumes you know which customer created which notification)
-- UPDATE Notification SET Customer_id = [correct_customer_id] WHERE Customer_id IS NULL;

-- 7. Check if Customer_id column should be NOT NULL
-- If it should be NOT NULL, run:
ALTER TABLE Notification ALTER COLUMN Customer_id INT NOT NULL;

-- 8. Verify the fix
SELECT 
    n.Notification_id,
    n.Customer_id,
    c.Fname + ' ' + c.Lname as CustomerName,
    n.Message,
    n.Date,
    n.Time
FROM Notification n
LEFT JOIN Customer c ON n.Customer_id = c.Customer_id
ORDER BY n.Date DESC, n.Time DESC;


ALTER TABLE Notification ADD IsRead BIT NOT NULL DEFAULT 0;

ALTER TABLE Cat
ADD Room_id INT NULL;

-- Optional: FK
ALTER TABLE Cat
ADD CONSTRAINT FK_Cat_Room FOREIGN KEY (Room_id) REFERENCES Room(Room_id);

ALTER TABLE Appointment
ADD RoomAssigned BIT NOT NULL DEFAULT 0;

