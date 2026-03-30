CREATE DATABASE DZ_Ecommerce COLLATE Arabic_CI_AS;
GO

USE DZ_Ecommerce;
GO

CREATE TABLE Wilayas (
    WilayaID VARCHAR(5) PRIMARY KEY,
    NameAr NVARCHAR(100) COLLATE Arabic_CI_AS  NOT NULL,
    NameFr NVARCHAR(100) NOT NULL
);

CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    Street NVARCHAR(200) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    PostalCode VARCHAR(10),
    WilayaID VARCHAR(5),
    Phone VARCHAR(20),
    FOREIGN KEY (WilayaID) REFERENCES Wilayas(WilayaID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    DefaultAddressID INT,
    FOREIGN KEY (DefaultAddressID) REFERENCES Addresses(AddressID)
);

ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_Users
FOREIGN KEY (UserID) REFERENCES Users(UserID);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    NameAr NVARCHAR(100) COLLATE Arabic_CI_AS  NOT NULL,
    NameFr NVARCHAR(100) NOT NULL,
    ParentCategoryID INT NULL,
    Description NVARCHAR(500),
    ImageURL VARCHAR(255),
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    NameAr NVARCHAR(200) COLLATE Arabic_CI_AS  NOT NULL,
    NameFr NVARCHAR(200) NOT NULL,
    DescriptionAr NVARCHAR(MAX),
    DescriptionFr NVARCHAR(MAX),
    Price DECIMAL(10,2) NOT NULL,
    OldPrice DECIMAL(10,2),
    Quantity INT DEFAULT 0,
    SKU VARCHAR(50) UNIQUE,
    CategoryID INT NOT NULL,
    Brand NVARCHAR(100),
    Weight DECIMAL(8,2),
    Dimensions NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    UpdatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL,
    IsPrimary BIT DEFAULT 0,
    DisplayOrder INT DEFAULT 0,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE ProductSpecifications (
    SpecificationID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    SpecNameAr NVARCHAR(100) COLLATE Arabic_CI_AS ,
    SpecNameFr NVARCHAR(100),
    SpecValueAr NVARCHAR(200),
    SpecValueFr NVARCHAR(200),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT DEFAULT 1,
    AddedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    OrderNumber VARCHAR(20) UNIQUE NOT NULL,
    UserID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    ShippingCost DECIMAL(10,2) DEFAULT 0,
    Status VARCHAR(50) DEFAULT 'pending',
    ShippingAddressID INT,
    BillingAddressID INT,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50) DEFAULT 'pending',
    Notes NVARCHAR(500),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ShippingAddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    UserID INT NOT NULL,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(1000),
    ReviewDate DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 0,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    LowStockThreshold INT DEFAULT 5,
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    Code VARCHAR(50) UNIQUE,
    DiscountType VARCHAR(20), -- percentage, fixed
    DiscountValue DECIMAL(10,2),
    MinOrderAmount DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    UsageLimit INT,
    UsedCount INT DEFAULT 0,
    IsActive BIT DEFAULT 1
);

INSERT INTO Wilayas (WilayaID, NameAr, NameFr) VALUES
('dz-01', 'أدرار', 'Adrar'),
('dz-02', 'الشلف', 'Chlef'),
('dz-03', 'الأغواط', 'Laghouat'),
('dz-04', 'أم البواقي', 'Oum El Bouaghi'),
('dz-05', 'باتنة', 'Batna'),
('dz-06', 'بجاية', 'Béjaïa'),
('dz-07', 'بسكرة', 'Biskra'),
('dz-08', 'بشار', 'Béchar'),
('dz-09', 'البليدة', 'Blida'),
('dz-10', 'البويرة', 'Bouira'),
('dz-16', 'الجزائر', 'Alger'),
('dz-31', 'وهران', 'Oran'),
('dz-25', 'قسنطينة', 'Constantine'),
('dz-19', 'سطيف', 'Sétif'),
('dz-42', 'تلمسان', 'Tlemcen');

INSERT INTO Categories (NameAr, NameFr, ParentCategoryID, Description) VALUES
('حواسيب محمولة', 'Ordinateurs Portables', NULL, 'أجهزة الحاسوب المحمولة بأنواعها'),
('حواسيب مكتبية', 'Ordinateurs de Bureau', NULL, 'أجهزة الحاسوب المكتبية'),
('مكونات الحاسوب', 'Composants PC', NULL, 'قطع ومكونات الحاسوب'),
('طرفيات', 'Périphériques', NULL, 'الأجهزة الطرفية للحاسوب'),
('برامج', 'Logiciels', NULL, 'البرامج والتطبيقات'),
('شبكات', 'Réseaux', NULL, 'معدات الشبكات والإنترنت');

INSERT INTO Categories (NameAr, NameFr, ParentCategoryID, Description) VALUES
('لابتوب للألعاب', 'Gaming Laptop', 1, 'حواسيب محمولة مخصصة للألعاب'),
('لابتوب للأعمال', 'Laptop Business', 1, 'حواسيب محمولة للأعمال'),
('معالجات', 'Processeurs', 3, 'وحدات المعالجة المركزية'),
('كروت شاشة', 'Cartes Graphiques', 3, 'كروت الرسوميات'),
('لوحات أم', 'Cartes Mères', 3, 'لوحات الأم للحواسيب'),
('شاشات', 'Écrans', 4, 'شاشات العرض'),
('طابعات', 'Imprimantes', 4, 'الطابعات بأنواعها'),
('أنظمة تشغيل', 'Systèmes d''exploitation', 5, 'أنظمة التشغيل المختلفة'),
('برامج مكافحة الفيروسات', 'Antivirus', 5, 'برامج الحماية من الفيروسات');

INSERT INTO Products (NameAr, NameFr, DescriptionAr, DescriptionFr, Price, OldPrice, Quantity, SKU, CategoryID, Brand, Weight, IsActive) VALUES
('لابتوب ديل إكس بي إس 13', 'Dell XPS 13', 'حاسوب محمول خفيف وقوي بشاشة 13.4 بوصة', 'Ordinateur portable léger et puissant avec écran 13.4 pouces', 180000.00, 195000.00, 15, 'DLL-XPS13-2024', 1, 'Dell', 1.2, 1),
('لابتوب ألعاب أسوس روغ', 'Asus ROG Gaming Laptop', 'حاسوب ألعاب بشاشة 144 هرتز ومعالج i7', 'PC Gaming avec écran 144Hz et processeur i7', 280000.00, 300000.00, 8, 'ASUS-ROG-G15', 7, 'ASUS', 2.5, 1),
('حاسوب مكتبي آبل آي ماك', 'Apple iMac', 'حاسوب آي ماك بشاشة 24 بوصة ورام 8 جيجا', 'iMac avec écran 24 pouces et 8GB RAM', 320000.00, NULL, 5, 'APP-IMAC24', 2, 'Apple', 5.0, 1),
('معالج إنتل كور i9', 'Intel Core i9', 'معالج إنتل كور i9 الجيل الثالث عشر', 'Processeur Intel Core i9 13ème génération', 85000.00, 90000.00, 25, 'INT-I9-13900K', 9, 'Intel', 0.3, 1),
('كارت شاشة إنفيديا RTX 4080', 'Nvidia RTX 4080', 'كارت شاشة إنفيديا RTX 4080 بذاكرة 16 جيجا', 'Carte graphique Nvidia RTX 4080 16GB', 220000.00, 240000.00, 12, 'NVD-RTX4080-16G', 10, 'NVIDIA', 1.8, 1),
('شاشة سامسونج 27 بوصة', 'Samsung 27" Monitor', 'شاشة سامسونج مقاس 27 بوصة بدقة 4K', 'Écran Samsung 27 pouces 4K UHD', 75000.00, 80000.00, 30, 'SAM-27UHD', 12, 'Samsung', 4.5, 1),
('طابعة ليزر إتش بي', 'HP Laser Printer', 'طابعة ليزر ملونة من إتش بي', 'Imprimante laser couleur HP', 45000.00, 50000.00, 18, 'HP-LASER-COLOR', 13, 'HP', 15.0, 1),
('لوحة أم أسوس للعب', 'Asus Gaming Motherboard', 'لوحة أم مخصصة للألعاب من أسوس', 'Carte mère gaming Asus', 55000.00, 60000.00, 22, 'ASUS-MB-GAMING', 11, 'ASUS', 1.0, 1),
('ويندوز 11 برو', 'Windows 11 Pro', 'ترخيص ويندوز 11 النسخة الاحترافية', 'Licence Windows 11 Professionnel', 25000.00, 28000.00, 100, 'WIN11-PRO', 14, 'Microsoft', 0.1, 1),
('ماك بوك برو 14 بوصة', 'MacBook Pro 14"', 'حاسوب ماك بوك برو بشريحة M2 Pro', 'MacBook Pro 14" avec puce M2 Pro', 350000.00, 380000.00, 7, 'APP-MBP14-M2', 1, 'Apple', 1.6, 1),
('لوحة مفاتيح ميكانيكية', 'Clavier Mécanique', 'لوحة مفاتيح ميكانيكية مع إضاءة RGB', 'Clavier mécanique avec rétroéclairage RGB', 12000.00, 15000.00, 50, 'KB-MECH-RGB', 4, 'Logitech', 1.1, 1),
('ماوس ألعاب لاسلكي', 'Souris Gaming Sans Fil', 'ماوس ألعاب لاسلكي دقة 16000 DPI', 'Souris gaming sans fil 16000 DPI', 8000.00, 10000.00, 45, 'MS-GAMING-WL', 4, 'Razer', 0.3, 1),
('قرص صلب SSD 1 تيرا', 'SSD 1TB', 'قرص صلب من نوع SSD سعة 1 تيرابايت', 'Disque dur SSD 1TB NVMe', 18000.00, 22000.00, 40, 'SSD-1TB-NVME', 3, 'Samsung', 0.1, 1),
('رام 16 جيجا DDR5', 'RAM 16GB DDR5', 'ذاكرة وصول عشوائي 16 جيجا DDR5', 'Mémoire RAM 16GB DDR5', 14000.00, 16000.00, 35, 'RAM-16G-DDR5', 3, 'Corsair', 0.2, 1),
('كرتون حماية ماك بوك', 'Coque MacBook', 'كرتون حماية لماك بوك من السيليكون', 'Coque de protection silicone pour MacBook', 4000.00, 5000.00, 60, 'CASE-MAC-SIL', 4, 'Spigen', 0.3, 1),
('كاميرا ويب 4K', 'Webcam 4K', 'كاميرا ويب بدقة 4K مع ميكروفون', 'Webcam 4K avec microphone intégré', 25000.00, 30000.00, 20, 'WEBCAM-4K', 4, 'Logitech', 0.5, 1),
('ماسح ضوئي للمستندات', 'Scanner de documents', 'ماسح ضوئي سريع للمستندات', 'Scanner rapide pour documents', 35000.00, 40000.00, 15, 'SCAN-DOC-FAST', 4, 'Canon', 3.0, 1),
('مولد طاقة احتياطي', 'Onduleur', 'مولد طاقة احتياطي 1500 فولت أمبير', 'Onduleur 1500VA pour PC', 30000.00, 35000.00, 25, 'UPS-1500VA', 4, 'APC', 8.0, 1),
('مايكروسوفت أوفيس 2023', 'Microsoft Office 2023', 'حزمة مايكروسوفت أوفيس 2023', 'Suite Microsoft Office 2023', 35000.00, 40000.00, 80, 'OFFICE-2023', 5, 'Microsoft', 0.1, 1),
('كاسبرسكي أنتي فيروس', 'Kaspersky Antivirus', 'برنامج كاسبرسكي للحماية من الفيروسات', 'Antivirus Kaspersky 1 an', 7000.00, 8000.00, 120, 'KAV-1YR', 15, 'Kaspersky', 0.1, 1);

INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Phone, RegistrationDate, IsActive) VALUES
('محمد', 'بن عمر', 'mohamed.benomar@email.com', '$2y$10$hashedpassword1', '0550123456', '20230115', 1),
('فاطمة', 'زيد', 'fatima.zid@email.com', '$2y$10$hashedpassword2', '0551234567', '20230220', 1),
('أحمد', 'بوعزة', 'ahmed.bouazza@email.com', '$2y$10$hashedpassword3', '0552345678', '20230310', 1),
('سارة', 'موسى', 'sara.moussa@email.com', '$2y$10$hashedpassword4', '0553456789', '20230405', 1),
('يوسف', 'قاسم', 'youssef.kacem@email.com', '$2y$10$hashedpassword5', '0554567890', '20230512', 1),
('ليلى', 'طالب', 'lila.taleb@email.com', '$2y$10$hashedpassword6', '0555678901', '20230618', 1),
('خالد', 'رحماني', 'khaled.rahmany@email.com', '$2y$10$hashedpassword7', '0556789012', '20230722', 1),
('نور', 'سعيد', 'nour.said@email.com', '$2y$10$hashedpassword8', '0557890123', '20230830', 1),
('عمر', 'بلعيد', 'omar.belaid@email.com', '$2y$10$hashedpassword9', '0558901234', '20230914', 1),
('حبيبة', 'عمران', 'habiba.imran@email.com', '$2y$10$hashedpassword10', '0559012345', '20231025', 1);

INSERT INTO Addresses (UserID, Street, City, PostalCode, WilayaID, Phone) VALUES
(1, 'شارع العربي بن مهيدي 123', 'الجزائر الوسطى', '16000', 'dz-16', '0550123456'),
(1, 'حي 5 جويلية 45', 'باب الزوار', '16111', 'dz-16', '0550123456'),
(2, 'شارع الاستقلال 78', 'وهران', '31000', 'dz-31', '0551234567'),
(3, 'شارع 8 مايو 1945 12', 'قسنطينة', '25000', 'dz-25', '0552345678'),
(4, 'حي الأمير عبد القادر 34', 'سطيف', '19000', 'dz-19', '0553456789'),
(5, 'شارع بن بولعيد 56', 'تلمسان', '13000', 'dz-42', '0554567890'),
(6, 'شارع الجمهورية 89', 'الشلف', '02000', 'dz-02', '0555678901'),
(7, 'حي النصر 23', 'باتنة', '05000', 'dz-05', '0556789012'),
(8, 'شارع 1 نوفمبر 1954 67', 'بجاية', '06000', 'dz-06', '0557890123'),
(9, 'حي السلام 90', 'أم البواقي', '04000', 'dz-04', '0558901234'),
(10, 'شارع الأمير عبد القادر 11', 'الأغواط', '03000', 'dz-03', '0559012345');

UPDATE Users SET DefaultAddressID = 1 WHERE UserID = 1;
UPDATE Users SET DefaultAddressID = 3 WHERE UserID = 2;
UPDATE Users SET DefaultAddressID = 4 WHERE UserID = 3;
UPDATE Users SET DefaultAddressID = 5 WHERE UserID = 4;
UPDATE Users SET DefaultAddressID = 6 WHERE UserID = 5;
UPDATE Users SET DefaultAddressID = 7 WHERE UserID = 6;
UPDATE Users SET DefaultAddressID = 8 WHERE UserID = 7;
UPDATE Users SET DefaultAddressID = 9 WHERE UserID = 8;
UPDATE Users SET DefaultAddressID = 10 WHERE UserID = 9;
UPDATE Users SET DefaultAddressID = 11 WHERE UserID = 10;

INSERT INTO ProductImages (ProductID, ImageURL, IsPrimary, DisplayOrder) VALUES
(1, '/images/products/dell-xps-13-1.jpg', 1, 1),
(1, '/images/products/dell-xps-13-2.jpg', 0, 2),
(2, '/images/products/asus-rog-1.jpg', 1, 1),
(3, '/images/products/imac-1.jpg', 1, 1),
(4, '/images/products/intel-i9-1.jpg', 1, 1),
(5, '/images/products/rtx-4080-1.jpg', 1, 1),
(6, '/images/products/samsung-monitor-1.jpg', 1, 1),
(7, '/images/products/hp-printer-1.jpg', 1, 1),
(8, '/images/products/asus-mb-1.jpg', 1, 1),
(9, '/images/products/windows11-1.jpg', 1, 1),
(10, '/images/products/macbook-pro-1.jpg', 1, 1);

INSERT INTO ProductSpecifications (ProductID, SpecNameAr, SpecNameFr, SpecValueAr, SpecValueFr) VALUES
(1, 'المعالج', 'Processeur', 'إنتل كور i7 الجيل الثالث عشر', 'Intel Core i7 13ème génération'),
(1, 'الذاكرة العشوائية', 'Mémoire RAM', '16 جيجابايت', '16GB'),
(1, 'سعة التخزين', 'Stockage', '512 جيجابايت SSD', '512GB SSD'),
(1, 'نظام التشغيل', 'Système d''exploitation', 'ويندوز 11 برو', 'Windows 11 Pro'),
(2, 'المعالج', 'Processeur', 'إنتل كور i9 الجيل الثالث عشر', 'Intel Core i9 13ème génération'),
(2, 'كارت الشاشة', 'Carte graphique', 'إنفيديا RTX 4070', 'Nvidia RTX 4070'),
(2, 'شاشة العرض', 'Écran', '15.6 بوصة، 144 هرتز', '15.6 pouces, 144Hz'),
(4, 'الجيل', 'Génération', 'الجيل الثالث عشر', '13ème génération'),
(4, 'عدد الأنوية', 'Nombre de cœurs', '24 نواة', '24 cœurs'),
(5, 'الذاكرة', 'Mémoire', '16 جيجابايت GDDR6X', '16GB GDDR6X');

INSERT INTO Cart (UserID, ProductID, Quantity, AddedDate) VALUES
(1, 1, 1, '20240110'),
(1, 12, 2, '20240110'),
(2, 5, 1, '20240111'),
(3, 6, 1, '20240112'),
(3, 13, 1, '20240112'),
(4, 10, 1, '20240113');

INSERT INTO Orders (OrderNumber, UserID, OrderDate, TotalAmount, ShippingCost, Status, ShippingAddressID, BillingAddressID, PaymentMethod, PaymentStatus) VALUES
('ORD-2024001', 1, '20240105', 195000.00, 1500.00, 'delivered', 1, 1, 'credit_card', 'paid'),
('ORD-2024002', 2, '20240106', 120000.00, 1200.00, 'processing', 3, 3, 'cash_on_delivery', 'pending'),
('ORD-2024003', 3, '20240107', 85000.00, 1000.00, 'shipped', 4, 4, 'bank_transfer', 'paid'),
('ORD-2024004', 4, '20240108', 350000.00, 2000.00, 'pending', 5, 5, 'credit_card', 'pending'),
('ORD-2024005', 5, '20240109', 18000.00, 800.00, 'delivered', 6, 6, 'cash_on_delivery', 'paid');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, TotalPrice) VALUES
(1, 1, 1, 180000.00, 180000.00),
(1, 11, 1, 12000.00, 12000.00),
(1, 12, 1, 8000.00, 8000.00),
(2, 5, 1, 220000.00, 220000.00),
(3, 4, 1, 85000.00, 85000.00),
(4, 10, 1, 350000.00, 350000.00),
(5, 13, 1, 18000.00, 18000.00);

INSERT INTO Reviews (ProductID, UserID, Rating, Comment, ReviewDate, IsApproved) VALUES
(1, 1, 5, 'منتج ممتاز، الخدمة سريعة والتوصيل في الوقت المحدد', '20240110', 1),
(1, 2, 4, 'جيد جداً لكن السعر مرتفع قليلاً', '20240111', 1),
(4, 3, 5, 'أداء رائع، أنصح به للمهوسين بالألعاب', '20240112', 1),
(6, 4, 4, 'شاشة جميلة وجودة عالية', '20240113', 1),
(10, 5, 5, 'ماك بوك رائع، الأداء مذهل', '20240114', 1);

INSERT INTO Inventory (ProductID, Quantity, LowStockThreshold) VALUES
(1, 15, 5),
(2, 8, 3),
(3, 5, 2),
(4, 25, 5),
(5, 12, 3),
(6, 30, 5),
(7, 18, 4),
(8, 22, 5),
(9, 100, 10),
(10, 7, 2),
(11, 50, 10),
(12, 45, 8),
(13, 40, 8),
(14, 35, 7),
(15, 60, 12),
(16, 20, 4),
(17, 15, 3),
(18, 25, 5),
(19, 80, 15),
(20, 120, 20);

INSERT INTO Promotions (Code, DiscountType, DiscountValue, MinOrderAmount, StartDate, EndDate, UsageLimit, UsedCount, IsActive) VALUES
('DZ10', 'percentage', 10.00, 50000.00, '20240101', '20241231', 1000, 150, 1),
('TECH2024', 'fixed', 5000.00, 100000.00, '20240101', '20240630', 500, 80, 1),
('RAMADAN25', 'percentage', 15.00, 30000.00, '20240310', '20240410', 2000, 300, 1),
('FREE_SHIPPING', 'fixed', 0.00, 50000.00, '20240101', '20241231', NULL, 250, 1);