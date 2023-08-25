USE master
GO
CREATE DATABASE shopapp
GO
USE shopapp
GO
--role
CREATE TABLE roles(
	[id] INT PRIMARY KEY IDENTITY,
	[name] VARCHAR(20) NOT NULL
);
GO
--user
CREATE TABLE users(
	[id] INT PRIMARY KEY IDENTITY,
	[fullname] VARCHAR(100) DEFAULT '',
	[phone_number] VARCHAR(10) NOT NULL,
	[address] VARCHAR(200) DEFAULT '',
	[date_of_birth] DATE,
	[password] VARCHAR(100) NOT NULL DEFAULT '', -- password đã mã hóa
	[created_at] DATETIME,
	[updated_at] DATETIME,
	[is_active] BIT DEFAULT 1,
	[facebook_account_id] INT DEFAULT 0,
	[google_account_id] INT DEFAULT 0,
	[role_id] INT,
	FOREIGN KEY (role_id) REFERENCES roles(id)
);
GO
--token
CREATE TABLE tokens(
	[id] INT PRIMARY KEY IDENTITY,
	[token] VARCHAR(255) UNIQUE NOT NULL,
	[token_type] VARCHAR(50) NOT NULL,
	[expiration_date] DATETIME,
	[revoked] BIT NOT NULL,
	[expired] BIT NOT NULL,
	[user_id] INT,
	FOREIGN KEY (user_id) REFERENCES users(id)
);
GO
--social_account
CREATE TABLE social_accounts(
	[id] INT PRIMARY KEY IDENTITY,
	[provider] VARCHAR(20) NOT NULL, -- Tên nhà social network
	[provider_id] VARCHAR(50) NOT NULL,
	[email] VARCHAR(150) NOT NULL, -- EMail tài khoản
	[name]	VARCHAR(100) NOT NULL, -- Tên người dùng
	[user_id] INT,
	FOREIGN KEY (user_id) REFERENCES users(id)
);
GO
--category
CREATE TABLE categories(
	[id] INT PRIMARY KEY IDENTITY,
	[name] VARCHAR(100) NOT NULL DEFAULT '',
);
GO
--product
CREATE TABLE products(
	[id] INT PRIMARY KEY IDENTITY,
	[name] VARCHAR(350) NOT NULL,
	[price] FLOAT NOT NULL CHECK(price >= 0),
	[thumbnail] VARCHAR(300) DEFAULT '', -- Link đến sản phẩm
	[description] TEXT DEFAULT '', 
	[created_at] DATETIME,
	[updated_at] DATETIME,
	[category_id] INT,
	FOREIGN KEY (category_id) REFERENCES categories(id)
);
GO
--order
CREATE TABLE orders(
	[id] INT PRIMARY KEY IDENTITY,
	[user_id] INT,
	[fullname] VARCHAR(100) DEFAULT '',
	[email] VARCHAR(100),
	[phone_number] VARCHAR(20) NOT NULL,
	[address] VARCHAR(200) NOT NULL, -- Địa chỉ nơi gửi
	[note] VARCHAR(100) DEFAULT '',
	[order_date] DATETIME DEFAULT CURRENT_TIMESTAMP, -- (CURRENT_TIMESTAMP) thời điểm hiện tại
	[status] VARCHAR(20), -- Trạng thái đơn hàng
	[total_money] FLOAT CHECK(total_money >= 0), -- Tổng tiền
	[shipping_method] VARCHAR(100), -- Phương thức vận chuyển
	[shipping_address] VARCHAR(200), -- Địa chỉ ship đến
	[shipping_date] DATE, -- Ngày gửi đến
	[tracking_number] VARCHAR(100), -- Số vận đơn
	[payment_method] VARCHAR(100), -- Phương thức thanh toán
	[active] BIT, -- Xóa đơn hàng (ẩn)
	FOREIGN KEY (user_id) REFERENCES users(id)
);
GO
--order_detail
CREATE TABLE order_details(
	[id] INT PRIMARY KEY IDENTITY,
	[order_id] INT,
	[product_id] INT,
	[price] FLOAT CHECK(price >= 0),
	[number_of_products] INT CHECK(number_of_products > 0),
	[total_money] FLOAT CHECK(total_money >= 0),
	[color] VARCHAR(20) DEFAULT '',
	FOREIGN KEY (order_id) REFERENCES orders(id),
	FOREIGN KEY (product_id) REFERENCES products(id)
);
GO