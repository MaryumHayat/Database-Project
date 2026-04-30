-- Insert Admin user
INSERT INTO Users (Username, Password, Role)
VALUES ('admin', 'admin123', 'Admin');

-- Insert Staff users
INSERT INTO Users (Username, Password, Role)
VALUES ('staff1', 'staff123', 'Staff');

INSERT INTO Users (Username, Password, Role)
VALUES ('staff2', 'staff456', 'Staff');

-- Insert Vet users
INSERT INTO Users (Username, Password, Role)
VALUES ('vet1', 'vet123', 'Vet');

INSERT INTO Users (Username, Password, Role)
VALUES ('vet2', 'vet456', 'Vet');
