-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema AmazonGo
-- -----------------------------------------------------
DROP DATABASE AmazonGo;
CREATE SCHEMA IF NOT EXISTS `amazongo` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin ;
USE `AmazonGo` ;

-- -----------------------------------------------------
-- Table `amazongo`.`Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Location` (
  `LocationID` INT NOT NULL,
  `LocationName` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  `Region` VARCHAR(45) NOT NULL,
  `Latitude` VARCHAR(45) NOT NULL,
  `Longitude` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`LocationID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Store` (
  `StoreID` VARCHAR(36) NOT NULL,
  `StoreName` VARCHAR(100) NOT NULL,
  `Hours` VARCHAR(100) NULL DEFAULT NULL,
  `LocationID` INT NOT NULL,
  PRIMARY KEY (`StoreID`, `LocationID`),
  INDEX `fk_Store_Location1_idx` (`LocationID` ASC) VISIBLE,
  CONSTRAINT `fk_Store_Location1`
    FOREIGN KEY (`LocationID`)
    REFERENCES `amazongo`.`Location` (`LocationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`Camera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Camera` (
  `CameraID` VARCHAR(36) NOT NULL,
  `LocationDescription` VARCHAR(255) NOT NULL,
  `StoreID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`CameraID`, `StoreID`),
  INDEX `fk_Camera_Store1_idx` (`StoreID` ASC) VISIBLE,
  CONSTRAINT `fk_Camera_Store1`
    FOREIGN KEY (`StoreID`)
    REFERENCES `amazongo`.`Store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`Subscription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Subscription` (
  `SubscriptionID` INT NOT NULL,
  `SubscriptionType` VARCHAR(45) NOT NULL,
  `SubscriptionCost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`SubscriptionID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Customers` (
  `CustomerID` VARCHAR(36) NOT NULL,
  `Name` VARCHAR(100) NOT NULL,
  `Email` VARCHAR(150) NOT NULL,
  `QRCodeURL` VARCHAR(255) NOT NULL,
  `PhoneNumber` VARCHAR(45) NOT NULL,
  `PasswordHash` VARCHAR(100) NOT NULL,
  `PreferredLanguage` VARCHAR(45) NULL DEFAULT 'English',
  `AccountStatus` VARCHAR(45) NOT NULL,
  `SubscriptionID` INT NOT NULL,
  PRIMARY KEY (`CustomerID`, `SubscriptionID`),
  UNIQUE INDEX `Email` (`Email` ASC) VISIBLE,
  INDEX `fk_Customers_Subscription1_idx` (`SubscriptionID` ASC) VISIBLE,
  CONSTRAINT `fk_Customers_Subscription1`
    FOREIGN KEY (`SubscriptionID`)
    REFERENCES `amazongo`.`Subscription` (`SubscriptionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`CameraEvent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`CameraEvent` (
  `CameraEventID` INT NOT NULL AUTO_INCREMENT,
  `EventType` ENUM('Enter', 'Exit') NOT NULL,
  `EventTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `CameraID` VARCHAR(36) NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`CameraEventID`, `CameraID`, `CustomerID`),
  INDEX `fk_CameraEvent_Camera1_idx` (`CameraID` ASC) VISIBLE,
  INDEX `fk_CameraEvent_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_CameraEvent_Camera1`
    FOREIGN KEY (`CameraID`)
    REFERENCES `amazongo`.`Camera` (`CameraID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CameraEvent_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`Session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Session` (
  `SessionID` INT NOT NULL AUTO_INCREMENT,
  `EntryTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `ExitTime` TIMESTAMP NULL DEFAULT NULL,
  `EntryMethod` VARCHAR(50) NULL DEFAULT 'QR Code',
  `StoreID` VARCHAR(36) NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`SessionID`, `StoreID`, `CustomerID`),
  INDEX `fk_Session_Store1_idx` (`StoreID` ASC) VISIBLE,
  INDEX `fk_Session_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Session_Store1`
    FOREIGN KEY (`StoreID`)
    REFERENCES `amazongo`.`Store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Session_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`Cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Cart` (
  `CartID` INT NOT NULL AUTO_INCREMENT,
  `CartStatus` VARCHAR(50) NULL DEFAULT 'Active',
  `SessionID` INT NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`CartID`, `SessionID`),
  INDEX `fk_Cart_Session1_idx` (`SessionID` ASC) VISIBLE,
  CONSTRAINT `fk_Cart_Session1`
    FOREIGN KEY (`SessionID`)
    REFERENCES `amazongo`.`Session` (`SessionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   CONSTRAINT `fk_CustomerID_Session1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`ItemShelf`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`ItemShelf` (
  `ItemShelfID` INT NOT NULL,
  `LocationDescription` VARCHAR(45) NULL,
  `StoreID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`ItemShelfID`, `StoreID`),
  INDEX `fk_ItemShelf_Store1_idx` (`StoreID` ASC) VISIBLE,
  CONSTRAINT `fk_ItemShelf_Store1`
    FOREIGN KEY (`StoreID`)
    REFERENCES `amazongo`.`Store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Item` (
  `ItemID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Price` DECIMAL(10,2) NOT NULL,
  `Category` VARCHAR(45) NOT NULL,
  `ItemDescription` VARCHAR(1000) NOT NULL,
  `Barcode` VARCHAR(45) NOT NULL,
  `Promotion` VARCHAR(45) NULL,
  `ItemShelfID` INT NOT NULL,
  PRIMARY KEY (`ItemID`, `ItemShelfID`),
  INDEX `fk_Item_ItemShelf1_idx` (`ItemShelfID` ASC) VISIBLE,
  CONSTRAINT `fk_Item_ItemShelf1`
    FOREIGN KEY (`ItemShelfID`)
    REFERENCES `amazongo`.`ItemShelf` (`ItemShelfID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`CartItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`CartItem` (
  `CartItemID` INT NOT NULL AUTO_INCREMENT,
  `Quantity` INT NULL DEFAULT '1',
  `ItemID` INT NOT NULL,
  `CartID` INT NOT NULL,
  PRIMARY KEY (`CartItemID`, `ItemID`, `CartID`),
  INDEX `fk_CartItem_Item1_idx` (`ItemID` ASC) VISIBLE,
  INDEX `fk_CartItem_Cart1_idx` (`CartID` ASC) VISIBLE,
  CONSTRAINT `fk_CartItem_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CartItem_Cart1`
    FOREIGN KEY (`CartID`)
    REFERENCES `amazongo`.`Cart` (`CartID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`SensorLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`SensorLogs` (
  `SensorLogID` INT NOT NULL AUTO_INCREMENT,
  `EventType` ENUM('PickUp', 'PutBack') NOT NULL,
  `LogTime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `ItemID` INT NOT NULL,
  `CartID` INT NOT NULL,
  PRIMARY KEY (`SensorLogID`, `ItemID`, `CartID`),
  INDEX `fk_SensorLogs_Item1_idx` (`ItemID` ASC) VISIBLE,
  INDEX `fk_SensorLogs_Cart1_idx` (`CartID` ASC) VISIBLE,
  CONSTRAINT `fk_SensorLogs_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SensorLogs_Cart1`
    FOREIGN KEY (`CartID`)
    REFERENCES `amazongo`.`Cart` (`CartID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`CustomerFeedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`CustomerFeedback` (
  `FeedbackLogID` INT NOT NULL,
  `FeedbackType` VARCHAR(45) NOT NULL,
  `FeedbackNotes` VARCHAR(45) NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`FeedbackLogID`, `CustomerID`),
  INDEX `fk_CustomerFeedback_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_CustomerFeedback_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`EmailVerifications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`EmailVerifications` (
  `EmailVerificationsID` INT NOT NULL,
  `VerificationStatus` VARCHAR(45) NOT NULL,
  `VerificationDate` DATE NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`EmailVerificationsID`, `CustomerID`),
  INDEX `fk_EmailVerifications_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_EmailVerifications_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`CustomerAddress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`CustomerAddress` (
  `CustomerAddressID` INT NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `Region` VARCHAR(45) NOT NULL,
  `PostalCode` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `AddressType` VARCHAR(45) NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`CustomerAddressID`, `CustomerID`),
  INDEX `fk_CustomerAddress_Customers1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_CustomerAddress_Customers1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `amazongo`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Receipt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Receipt` (
  `ReceiptID` INT NOT NULL,
  `TaxAmount` VARCHAR(45) NOT NULL,
  `TotalAmount` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  `SessionID` INT NOT NULL,
  PRIMARY KEY (`ReceiptID`, `SessionID`),
  INDEX `fk_Receipt_Session1_idx` (`SessionID` ASC) VISIBLE,
  CONSTRAINT `fk_Receipt_Session1`
    FOREIGN KEY (`SessionID`)
    REFERENCES `amazongo`.`Session` (`SessionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`PaymentMethods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`PaymentMethods` (
  `PaymentMethodID` INT NOT NULL,
  `CardNumber` VARBINARY(255) NOT NULL,
  `CardType` VARBINARY(45) NOT NULL,
  `CVV` VARBINARY(45) NOT NULL,
  `ExpirationDate` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `CustomerID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`PaymentMethodID`),
  FOREIGN KEY (`CustomerID`) REFERENCES `Customers`(`CustomerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


-- -----------------------------------------------------
-- Table `amazongo`.`Transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Transactions` (
  `TransactionID` INT NOT NULL,
  `TransactionStatus` VARCHAR(45) NULL,
  `ReceiptID` INT NOT NULL,
  `PaymentMethodID` INT NOT NULL,
  PRIMARY KEY (`TransactionID`, `ReceiptID`, `PaymentMethodID`),
  INDEX `fk_Transactions_Receipt1_idx` (`ReceiptID` ASC) VISIBLE,
  INDEX `fk_Transactions_PaymentMethods1_idx` (`PaymentMethodID` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_Receipt1`
    FOREIGN KEY (`ReceiptID`)
    REFERENCES `amazongo`.`Receipt` (`ReceiptID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_PaymentMethods1`
    FOREIGN KEY (`PaymentMethodID`)
    REFERENCES `amazongo`.`PaymentMethods` (`PaymentMethodID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`RefundRequest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`RefundRequest` (
  `RefundRequestID` INT NOT NULL,
  `RequestDate` DATE NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `TransactionID` INT NOT NULL,
  `Reason` VARCHAR(45) NOT NULL,
  `PriceAdjustment` VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (`RefundRequestID`, `TransactionID`),
  INDEX `fk_RefundRequest_Transactions1_idx` (`TransactionID` ASC) VISIBLE,
  CONSTRAINT `fk_RefundRequest_Transactions1`
    FOREIGN KEY (`TransactionID`)
    REFERENCES `amazongo`.`Transactions` (`TransactionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `amazongo`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Employees` (
  `EmployeeID` INT NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `PhoneNumber` VARCHAR(45) NOT NULL,
  `StoreID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`EmployeeID`, `StoreID`),
  INDEX `fk_Employees_Store1_idx` (`StoreID` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Store1`
    FOREIGN KEY (`StoreID`)
    REFERENCES `amazongo`.`Store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `amazongo`.`RefundResolution`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`RefundResolution` (
  `RefundResolutionID` INT NOT NULL,
  `ResolutionDate` DATE NOT NULL,
  `RefundRequestID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`RefundResolutionID`, `RefundRequestID`, `EmployeeID`),
  INDEX `fk_RefundResolution_RefundRequest1_idx` (`RefundRequestID` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_RefundRequest1`
    FOREIGN KEY (`RefundRequestID`)
    REFERENCES `amazongo`.`RefundRequest` (`RefundRequestID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RefundResolution_EmployeeID1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `amazongo`.`Employees` (`EmployeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`FeedbackResponse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`FeedbackResponse` (
  `FeedbackResponseID` INT NOT NULL,
  `ResponseNotes` VARCHAR(45) NULL,
  `FeedbackLogID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`FeedbackResponseID`, `FeedbackLogID`, `EmployeeID`),
  INDEX `fk_FeedbackResponse_CustomerFeedback1_idx` (`FeedbackLogID` ASC) VISIBLE,
  INDEX `fk_FeedbackResponse_Employees1_idx` (`EmployeeID` ASC) VISIBLE,
  CONSTRAINT `fk_FeedbackResponse_CustomerFeedback1`
    FOREIGN KEY (`FeedbackLogID`)
    REFERENCES `amazongo`.`CustomerFeedback` (`FeedbackLogID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FeedbackResponse_Employees1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `amazongo`.`Employees` (`EmployeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`ReceiptItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`ReceiptItem` (
  `ReceiptID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Quantity` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`ReceiptID`, `ItemID`),
  INDEX `fk_ReceiptItem_Item1_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `fk_ReceiptItem_Receipt1`
    FOREIGN KEY (`ReceiptID`)
    REFERENCES `amazongo`.`Receipt` (`ReceiptID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ReceiptItem_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Suppliers` (
  `SupplierID` INT NOT NULL,
  `SupplierName` VARCHAR(45) NOT NULL,
  `ItemID` INT NOT NULL,
  PRIMARY KEY (`SupplierID`, `ItemID`),
  INDEX `fk_Suppliers_Item1_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `fk_Suppliers_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`Inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`Inventory` (
  `InventoryID` INT NOT NULL,
  `StockLevel` INT NOT NULL,
  `LastUpdated` VARCHAR(45) NOT NULL,
  `ItemID` INT NOT NULL,
  `StoreID` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`InventoryID`, `ItemID`, `StoreID`),
  INDEX `fk_Inventory_Item1_idx` (`ItemID` ASC) VISIBLE,
  INDEX `fk_Inventory_Store1_idx` (`StoreID` ASC) VISIBLE,
  CONSTRAINT `fk_Inventory_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inventory_Store1`
    FOREIGN KEY (`StoreID`)
    REFERENCES `amazongo`.`Store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`RestockOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`RestockOrder` (
  `OrderID` INT NOT NULL,
  `RestockThreshold` INT NOT NULL,
  `SupplierID` INT NOT NULL,
  `InventoryID` INT NOT NULL,
  PRIMARY KEY (`OrderID`, `SupplierID`, `InventoryID`),
  INDEX `fk_RestockOrder_Suppliers1_idx` (`SupplierID` ASC) VISIBLE,
  INDEX `fk_RestockOrder_Inventory1_idx` (`InventoryID` ASC) VISIBLE,
  CONSTRAINT `fk_RestockOrder_Suppliers1`
    FOREIGN KEY (`SupplierID`)
    REFERENCES `amazongo`.`Suppliers` (`SupplierID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RestockOrder_Inventory1`
    FOREIGN KEY (`InventoryID`)
    REFERENCES `amazongo`.`Inventory` (`InventoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`FraudDetectionLog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`FraudDetectionLog` (
  `FraudDetectionLogID` INT NOT NULL AUTO_INCREMENT,
  `DetectionType` VARCHAR(100) NOT NULL,
  `Time` TIMESTAMP NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `TransactionID` INT NOT NULL,
  PRIMARY KEY (`FraudDetectionLogID`, `TransactionID`),
  INDEX `fk_FraudDetectionLog_Transactions1_idx` (`TransactionID` ASC) VISIBLE,
  CONSTRAINT `fk_FraudDetectionLog_Transactions1`
    FOREIGN KEY (`TransactionID`)
    REFERENCES `amazongo`.`Transactions` (`TransactionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`FraudResolution`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`FraudResolution` (
  `FraudResolutionID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `FraudDetectionLogID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`FraudResolutionID`, `FraudDetectionLogID`, `EmployeeID`),
  INDEX `fk_FraudResolution_FraudDetectionLog1_idx` (`FraudDetectionLogID` ASC) VISIBLE,
  INDEX `fk_FraudResolution_Employees1_idx` (`EmployeeID` ASC) VISIBLE,
  CONSTRAINT `fk_FraudResolution_FraudDetectionLog1`
    FOREIGN KEY (`FraudDetectionLogID`)
    REFERENCES `amazongo`.`FraudDetectionLog` (`FraudDetectionLogID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FraudResolution_Employees1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `amazongo`.`Employees` (`EmployeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `amazongo`.`TransactionItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `amazongo`.`TransactionItem` (
  `TransactionID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`TransactionID`, `ItemID`),
  INDEX `fk_TransactionItem_Item1_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `fk_TransactionItem_Transactions1`
    FOREIGN KEY (`TransactionID`)
    REFERENCES `amazongo`.`Transactions` (`TransactionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TransactionItem_Item1`
    FOREIGN KEY (`ItemID`)
    REFERENCES `amazongo`.`Item` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


USE `amazongo`;

DELIMITER $$
USE `amazongo`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `amazongo`.`AfterCameraExit`
AFTER INSERT ON `amazongo`.`cameraevent`
FOR EACH ROW
BEGIN
    -- Check if the event is an 'Exit'
    IF NEW.EventType = 'Exit' THEN
        -- Close the associated cart
        UPDATE Cart
        SET CartStatus = 'Completed'
        WHERE SessionID IN (
            SELECT SessionID
            FROM Session
            WHERE CustomerID = NEW.CustomerID AND ExitTime IS NULL
        );

        -- Mark the session as completed
        UPDATE Session
        SET ExitTime = NEW.EventTime
        WHERE CustomerID = NEW.CustomerID AND ExitTime IS NULL;
    END IF;
END$$

DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
