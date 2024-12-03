DROP DATABASE AmazonGo;
CREATE DATABASE AmazonGo;
USE AmazonGo;

CREATE TABLE Customers (
    CustomerID VARCHAR(36) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    QRCodeURL VARCHAR(255) NOT NULL -- Used for session validation
);

CREATE TABLE Store (
    StoreID VARCHAR(36) PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    Hours VARCHAR(100)
);

CREATE TABLE Session (
    SessionID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID VARCHAR(36) NOT NULL,
    StoreID VARCHAR(36) NOT NULL,
    EntryTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ExitTime TIMESTAMP NULL,
    EntryMethod VARCHAR(50) DEFAULT 'QR Code',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Cart (
    CartID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID VARCHAR(36) NOT NULL,
    StoreID VARCHAR(36) NOT NULL,
    CartStatus VARCHAR(50) DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE Item (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE CartItem (
    CartItemID INT AUTO_INCREMENT PRIMARY KEY,
    CartID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT DEFAULT 1,
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE SensorLogs (
    SensorLogID INT AUTO_INCREMENT PRIMARY KEY,
    CartID INT NOT NULL, -- Link to Cart instead of Session
    ItemID INT NOT NULL, -- FK to Item
    CustomerID VARCHAR(36) NOT NULL, -- FK to Customers
    EventType ENUM('PickUp', 'PutBack') NOT NULL,
    LogTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Camera (
    CameraID VARCHAR(36) PRIMARY KEY,
    StoreID VARCHAR(36) NOT NULL,
    LocationDescription VARCHAR(255),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

CREATE TABLE CameraEvent (
    CameraEventID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID VARCHAR(36) NOT NULL,
    CameraID VARCHAR(36) NOT NULL,
    EventType ENUM('Enter', 'Exit') NOT NULL,
    EventTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (CameraID) REFERENCES Camera(CameraID)
);

DELIMITER $$

CREATE TRIGGER AfterCameraExit
AFTER INSERT ON CameraEvent
FOR EACH ROW
BEGIN
    -- Check if the event is an 'Exit'
    IF NEW.EventType = 'Exit' THEN
        -- Close the associated cart
        UPDATE Cart
        SET CartStatus = 'Completed'
        WHERE CustomerID = NEW.CustomerID AND CartStatus = 'Active';

        -- Mark the session as completed
        UPDATE Session
        SET ExitTime = NEW.EventTime
        WHERE CustomerID = NEW.CustomerID AND ExitTime IS NULL;
    END IF;
END $$

DELIMITER ;