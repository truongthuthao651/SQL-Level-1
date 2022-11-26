/*  CREATE DATABASE RETAIL;
	tạo 1 database -> click chuột phải -> chọn Tasks -> Import flat files
*/

/* Primary Keys: Unique & Not NULL */

USE RETAIL;
--- drop table if exists RETAIL.dbo.Customers;

/* C2: Nếu k import files trực tiếp vào thì có thể Create xong rồi Bulk Insert:

CREATE TABLE CUSTOMERS
--- schema: tên bảng, tên cột, loại dữ liệu trong cột
	(
	CUSTOMER_ID SMALLINT,
	CUSTOMER_NAME NVARCHAR(50),
	GENDER NVARCHAR(50),
	AGE TINYINT,
	HOME_ADDRESS NVARCHAR(50),
	ZIP_CODE INT,
	CITY NVARCHAR(50),
	STATE NVARCHAR(50),
	COUNTRY NVARCHAR(50),
	PRIMARY KEY (CUSTOMER_ID) --- declare PK
	);

BULK INSERT ...
	FROM "..."
		WITH 
*/

SELECT *
FROM RETAIL.dbo.Customers;

/* đổi master về bảng RETAIL thì mới chạy đc câu lệnh SELECT trên, k thì sdung câu lệnh sau:
	USE RETAIL;
*/

----- CHECK ERRORS -----
SELECT * FROM SYS.MESSAGES
WHERE LANGUAGE_ID = 1033;

----- Check Information:
SELECT 
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	IS_NULLABLE
FROM RETAIL.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customers'
ORDER BY ORDINAL_POSITION;

----- Check nội dung của bảng:
SELECT TOP 10 *
FROM RETAIL.dbo.Customers;

----- Check quy mô của bảng (Records):
SELECT COUNT(*)
FROM RETAIL.dbo.Customers;

----- BETWEEN...AND: 1e6 <= ... <= 1e9

--- ghép 2 cols thành 1 col (Note: chỉ ghép đc các cols cùng kiểu dữ liệu):
SELECT 
	customer_id,
	home_address + ' , ' + city AS dia_chi
FROM RETAIL.dbo.Customers;

--- DISTINCT:
--- lấy ra dsach các State:
SELECT 
	DISTINCT state
FROM RETAIL.dbo.Customers;

--- lấy ra 10% số rows: 
SELECT 
	TOP 10 PERCENT *
FROM RETAIL.dbo.Customers;

SELECT 
	TOP 20 *
FROM RETAIL.dbo.Sales;

SELECT 
	PRICE_PER_UNIT * QUANTITY
FROM RETAIL.dbo.Sales;

--- lấy thông tin KH sống tại bang New South Wales:
SELECT *
FROM RETAIL.dbo.customers
WHERE state = 'NEW SOUTH WALES';

--- lấy thông tin KH sống tại cả 2 bang New South Wales & Victoria:
--C1:
SELECT *
FROM RETAIL.dbo.customers
WHERE 
	state = 'NEW SOUTH WALES' OR         --- vì mỗi ng chỉ có 1 địa chỉ cư trú
	state = 'VICTORIA';
--C2:
SELECT *
FROM RETAIL.dbo.customers
WHERE 
	state IN ('NEW SOUTH WALES', 'VICTORIA');

/* sử dung lệnh LIKE:
		'% A %'
		'%A%'
		'%A'
		'A%'
*/

--- lấy ra các sp trong Description có màu 'red'
/* Hint: vì chữ 'red' có cả ở cuối từ 'coloured' --> dùng '% A %'
*/
SELECT *
FROM RETAIL.dbo.Products
WHERE 
	description LIKE '% red %';

--- đếm số lượng bản ghi ở bảng Orders:
SELECT COUNT(CUSTOMER_ID)
FROM RETAIL.dbo.Orders;

SELECT COUNT(*)   --- = COUNT(1)
FROM RETAIL.dbo.Orders;

--- đếm số lượng KH mua hàng:
SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM RETAIL.dbo.Orders;

--- tìm GTLN, GTNN của Payment:
SELECT 
	MAX(PAYMENT) MAX,
	MIN(PAYMENT) MIN
FROM RETAIL.dbo.Orders;

--- tìm SUM và AVG của Total_price:
SELECT 
	SUM(TOTAL_PRICE) TONG,
	AVG(TOTAL_PRICE) TRUNG_BINH
FROM RETAIL.dbo.[sales ];

--- có bnhieu KH trong mỗi State:
SELECT 
	STATE,
	COUNT(CUSTOMER_ID)
FROM RETAIL.dbo.customers
GROUP BY state;

--- đếm số lượng sp theo Product_type & Product_name:
SELECT 
	product_type,
	product_name,
	COUNT(1)
FROM RETAIL.dbo.products
GROUP BY 
	product_type,
	product_name;

--- in ra các loại sp:
SELECT 
	DISTINCT product_type
FROM RETAIL.dbo.products;

--- tính SUM Payment theo Cus_ID từ bảng Orders:
SELECT 
	CUSTOMER_ID,
	SUM(PAYMENT) 
FROM RETAIL.dbo.ORDERS
GROUP BY CUSTOMER_ID;

--- chọn ra các bản ghi từ bảng trên có AVG Payment >= 25000:
SELECT 
	CUSTOMER_ID,
	SUM(PAYMENT) 
FROM RETAIL.dbo.ORDERS
GROUP BY CUSTOMER_ID
HAVING AVG(PAYMENT) >= 25000;        --- HAVING luôn đi kèm với GROUP BY

--- đếm số lượng Pro_ID theo Pro_type & sắp xếp DESC theo Pro_type:
SELECT 
	PRODUCT_TYPE,
	COUNT(PRODUCT_ID) 
FROM RETAIL.dbo.products
GROUP BY product_type
ORDER BY product_type DESC;

--- đếm số lượng KH theo Gender & sắp xếp ASC theo số lượng đó:
SELECT 
	gender,
	COUNT(CUSTOMER_ID) AS SLKH
FROM RETAIL.dbo.customers
GROUP BY gender
ORDER BY SLKH;

--- với từng City thuộc bang South Australia, đếm sluong KH có độ tuổi từ 20-50
SELECT 
	CITY,
	COUNT (CUSTOMER_ID)
FROM RETAIL.dbo.customers
WHERE STATE = 'South Australia' AND age >= 20 AND age <= 50
GROUP BY city;

--- tính AVG Total_Price cho các Pro_ID & có SUM(Quantity) >= 20:
SELECT 
	product_id,
	AVG(TOTAL_PRICE)
FROM RETAIL.dbo.[sales ]
GROUP BY product_id
HAVING SUM(QUANTITY) >= 20;

--- lấy chi tiết Order từ các KH sống tại bang New South Wales:
SELECT
	TABLE_A.customer_id,
	order_id,
	customer_name,
	gender,
	AGE,
	order_date,
	state
FROM 
	(SELECT	
		ORDER_ID,
		customer_id,
		order_date
	FROM RETAIL.dbo.orders) AS TABLE_A
	LEFT JOIN
	(SELECT 
		customer_id,
		customer_name,
		gender,
		age,
		state
	FROM RETAIL.dbo.customers) AS TABLE_B
	ON
		TABLE_A.customer_id = TABLE_B.customer_id
WHERE state = 'New South Wales';

--- thông tin về Payment của các KH có đặt hàng và sống tại Victoria or New South Wales:
SELECT 
	order_id,
	A.customer_id,
	payment,
	state
FROM 
	(SELECT
		order_id,
		customer_id,
		payment
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT	
		customer_id,
		state
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
WHERE state IN ('New South Wales', 'Victoria')
ORDER BY payment DESC;

--- đếm số lượng KH có đặt hàng (dữ liệu đi vào bảng Orders) & có độ tuổi từ 20-30:
SELECT
	COUNT(A.CUSTOMER_ID) SO_LAN_DAT_HANG,
	COUNT(DISTINCT A.customer_id) SO_LUONG_KH
FROM
	(SELECT 
		customer_id
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		customer_id,
		age
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
WHERE 
	age >= 20 AND
	age <= 30;

--- lấy doanh số (Total_Price) của các sp được phân loại Orange trong bảng danh mục sp: product_id, colour, total_price:
SELECT
	A.product_id,
	colour,
	total_price
FROM 
	(SELECT 
		product_id,
		total_price
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		product_ID,
		colour
	FROM RETAIL.dbo.products) B
	ON
		A.product_id = B.product_ID
WHERE colour = 'Orange';

--- Cross Join: (All possible Outcomes: kết hợp tất cả có thể từ 2 Tables):
drop table if exists RETAIL.dbo.Meals;
drop table if exists RETAIL.dbo.Drinks;

CREATE TABLE RETAIL.dbo.Meals
	(
		Meal_Name VARCHAR(100)
	);

CREATE TABLE RETAIL.dbo.Drinks
	(
		Drink_Name VARCHAR(100)
	);

INSERT INTO RETAIL.dbo.Drinks
VALUES ('Orange Juice'), ('Tea'), ('Coffee');
INSERT INTO RETAIL.dbo.Meals
VALUES ('Omlet'), ('Fried Egg'), ('Sausage');

SELECT *
FROM RETAIL.dbo.Meals;
SELECT *
FROM RETAIL.dbo.Drinks;

SELECT *
FROM RETAIL.dbo.Meals
CROSS JOIN
RETAIL.dbo.Drinks;

/* Tạo 1 bảng từ 2 bảng có điều kiện: 20-40; 30-60
	Các cột cần show: customer_id, customer_name, age
*/

--- UNION & UNION ALL:
/* union chỉ lấy ra DISTINCT, union all lấy tất cả các bản ghi */

SELECT 
	COUNT(1)
FROM
	((SELECT
		customer_id,
		customer_name,
		age
	FROM RETAIL.dbo.customers
	WHERE age BETWEEN 20 AND 40)
UNION
	(SELECT
		customer_id,
		customer_name,
		age
	FROM RETAIL.dbo.customers
	WHERE age BETWEEN 30 AND 60)) A;

--- Hiển thị doanh thu (Total_Price) theo từng Product_Type:
SELECT 
	product_type,
	SUM(TOTAL_PRICE) DOANH_THU
FROM 
	(SELECT
		product_id,
		total_price
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		product_ID,
		product_type
	FROM RETAIL.dbo.products) B
	ON
		A.product_id = B.product_ID
GROUP BY product_type;

--- 5 sản phẩm được order nhiều nhất:
SELECT TOP 5
	product_name,
	COUNT(ORDER_ID) SLDH
FROM
	(SELECT
		product_id,
		order_id
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		product_ID,
		product_name
	FROM RETAIL.dbo.products) B
	ON
		A.product_id = B.product_ID
GROUP BY product_name
ORDER BY SLDH DESC;

--- hiển thị doanh thu của sản phẩm được phân loại là màu 'red':
SELECT
	product_name,
	colour,
	SUM(TOTAL_PRICE) DOANH_THU
FROM
	(SELECT
		product_id,
		total_price
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		product_ID,
		product_name,
		colour
	FROM RETAIL.dbo.products) B
	ON
		A.product_id = B.product_ID
WHERE colour = 'RED'
GROUP BY product_name, colour;


SELECT
	a.product_id,
	sales_id,
	QUANTITY,
	TOTAL_PRICE
FROM
	(SELECT
		product_id,
		sales_id,
		COUNT(quantity) QUANTITY,
		SUM(TOTAL_PRICE) TOTAL_PRICE
	FROM RETAIL.dbo.[sales ]
	GROUP BY
		product_id,
		sales_id) A
	LEFT JOIN
	(SELECT
		product_ID,
		product_name,
		colour
	FROM RETAIL.dbo.products) B
	ON
		A.product_id = B.product_ID
WHERE colour = 'RED'

--- lấy chi tiết KH order tại Victoria:
SELECT
	A.*
FROM
	(SELECT
		order_id,
		customer_id,
		payment,
		delivery_date
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		customer_id,
		state
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
WHERE STATE = 'Victoria';

--- Lấy chi tiết order của KH sống tại bang bắt đầu bằng 'N':
SELECT
	orders.*
FROM
	RETAIL.dbo.orders
	LEFT JOIN
	(SELECT
		customer_id,
		state
	FROM RETAIL.dbo.customers) B
	ON
		orders.customer_id = B.customer_id
WHERE STATE LIKE 'N%';

--- 5 KH có số lượng đơn đặt hàng cao nhất:
SELECT TOP 5
	A.customer_id,
	customer_name,
	COUNT(ORDER_ID)
FROM 
	(SELECT
		customer_id,
		order_id
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		customer_id,
		customer_name
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
GROUP BY 
	A.customer_id,
	customer_name
ORDER BY COUNT(ORDER_ID) DESC;

--- chi tiết KH order mà sống tại 'New South Wales' và mua 'Shirt':
SELECT
	A.customer_id,
	B.customer_name,
	B.age,
	B.gender,
	A.order_date,
	D.product_type,
	B.state
FROM
	(SELECT
		order_id,
		order_date,
		customer_id
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		customer_id,
		customer_name,
		age,
		gender,
		state
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
	LEFT JOIN
	(SELECT
		order_id,
		product_id
	FROM RETAIL.dbo.[sales ]) C
	ON
		A.order_id = C.order_id
	LEFT JOIN
	(SELECT
		product_ID,
		product_type
	FROM RETAIL.dbo.products) D
	ON
		C.product_id = D.product_ID
WHERE 
	D.product_type = 'Shirt' AND
	B.state = 'New South Wales';

--- Danh sách 5 KH có payment cao nhất:
SELECT TOP 5
	A.customer_id,
	customer_name,
	SUM(PAYMENT) PAYMENT
FROM 
	(SELECT
		customer_id,
		payment
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		customer_id,
		customer_name
	FROM RETAIL.dbo.customers) B
	ON 
		A.customer_id = B.customer_id
GROUP BY 
	A.customer_id,
	customer_name
ORDER BY PAYMENT DESC;

--- Danh sách 5 ngày Delivery_Date có doanh thu cao nhất:
SELECT TOP 5
	delivery_date,
	SUM(TOTAL_PRICE) DOANH_THU
FROM
	(SELECT
		order_id,
		total_price
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		order_id,
		delivery_date
	FROM RETAIL.dbo.orders) B
	ON
		A.order_id = B.order_id
GROUP BY delivery_date
ORDER BY DOANH_THU DESC;

--- 5 KH có Total_Price cao nhất:
SELECT TOP 5
	B.customer_id,
	customer_name,
	SUM(TOTAL_PRICE) TOTAL_PRICE
FROM
	(SELECT
		order_id,
		total_price
	FROM RETAIL.dbo.[sales ]) A
	LEFT JOIN
	(SELECT
		order_id,
		customer_id
	FROM RETAIL.dbo.orders) B
	ON
		A.order_id = B.order_id
	LEFT JOIN
	(SELECT
		customer_id,
		customer_name
	FROM RETAIL.dbo.customers) C
	ON
		B.customer_id = C.customer_id
GROUP BY
	B.customer_id,
	customer_name
ORDER BY TOTAL_PRICE DESC;


----- Check:
SELECT *
FROM RETAIL.dbo.ANZ;

----- Check Information:
SELECT 
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	IS_NULLABLE
FROM RETAIL.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ANZ'
ORDER BY ORDINAL_POSITION;

----- Check nội dung của bảng:
SELECT TOP 10 *
FROM RETAIL.dbo.ANZ;

----- Check quy mô của bảng (Records):
SELECT COUNT(*)
FROM RETAIL.dbo.ANZ; 

----- Check các Keys:
SELECT 
	COUNT(*) SLBG,
	COUNT(DISTINCT TRANSACTION_ID) SLGD,
	COUNT(DISTINCT MERCHANT_ID) SL_CHI_NHANH,
	COUNT(DISTINCT CUSTOMER_ID) SLKH
FROM RETAIL.dbo.ANZ;
/*  Đây là bảng giao dịch ngân hàng
	100 KH
	12043 giao dịch
	5725 chi nhánh
*/

SELECT TOP 10 *
FROM RETAIL.dbo.ANZ;


/*  SUBSTRING(chuỗi cần cắt, start, length) ~ LEFT(chuỗi cần cắt, length), RIGHT(chuỗi cần cắt, length)
	CHARINDEX()
*/

----- xử lý tách chuỗi long-lat:
SELECT 
	SUBSTRING(LONG_LAT, 1, 6) AS LONG, 
	SUBSTRING(LONG_LAT, 9, 5) AS LAT 
FROM RETAIL.dbo.ANZ;

SELECT 
	LEFT(LONG_LAT, 6) AS LONG, 
	RIGHT(LONG_LAT, 5) AS LAT 
FROM RETAIL.dbo.ANZ;

----- xử lý tách chuỗi merchant_long_lat:
SELECT TOP 20
	MERCHANT_LONG_LAT
FROM RETAIL.dbo.ANZ;

SELECT CHARINDEX(' ', '145.32 -37.78') - 1;
SELECT LEN('145.32 -37.78');

--- cắt bên trái:
SELECT DISTINCT
	SUBSTRING(MERCHANT_LONG_LAT, 1, CHARINDEX(' ', MERCHANT_LONG_LAT) - 1) MERCHANT_LONG
FROM RETAIL.dbo.ANZ;

--- cắt bên phải:
SELECT DISTINCT
	RIGHT(MERCHANT_LONG_LAT, LEN(MERCHANT_LONG_LAT) - CHARINDEX('-', MERCHANT_LONG_LAT)) MERCHANT_LAT
FROM RETAIL.dbo.ANZ;


----- Khảo sát Data Covid-19:
SELECT 
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	IS_NULLABLE
FROM RETAIL.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'COVID_VACCINE'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*)
FROM RETAIL.dbo.COVID_VACCINE;

SELECT TOP 10 *
FROM RETAIL.dbo.COVID_VACCINE;

SELECT
	MIN(TOTAL_VACCINATIONS) AS MIN,
	MAX (TOTAL_VACCINATIONS) AS MAX
FROM RETAIL.dbo.COVID_VACCINE;
-- check khoảng dữ liệu xem có hợp lý hay không


----- Subquery:
--- Tên sp có quantity (giao dịch) >= 2:
SELECT
	DISTINCT product_name
FROM RETAIL.dbo.products
WHERE product_ID IN (SELECT
						product_ID
					FROM RETAIL.dbo.[sales ]
					WHERE quantity >= 2);

--- Danh sách tên KH có payment >= 20000:
SELECT
	customer_name
FROM RETAIL.dbo.customers
WHERE customer_id IN (SELECT
							customer_id
						FROM RETAIL.dbo.orders
						WHERE payment >= 20000);


----- Bảng tạm CTE: 'with...as'
--- Tạo CTE cho 'customer' (lấy ttin nhân khẩu học): customer_id, age, gender, city, state:
WITH CUSTOMER_CTE 
AS (SELECT
		customer_id,
		age,
		gender,
		city,
		state
	FROM RETAIL.dbo.customers)
SELECT *
FROM CUSTOMER_CTE;

--- Dùng cách viết CTE trả ra số lượng Orders tính theo KH:
WITH ORDER_CTE 
AS (SELECT
		customer_id,
		COUNT(ORDER_ID) SLDH              --- bắt buộc phải alias, k đc để trống tên column trong bảng tạm CTE
	FROM RETAIL.dbo.orders
	GROUP BY customer_id)
SELECT *
FROM ORDER_CTE;


----- VIEW: 'create view...as'
--- Dùng cách tạo View trả ra bảng có tổng doanh thu (Total_Price) tính theo KH:
CREATE VIEW REVENUE_VIEW
AS
	SELECT
		customer_id,
		SUM(TOTAL_PRICE) TONG_DOANH_THU
	FROM 
		(SELECT
			order_id,
			total_price
		FROM RETAIL.dbo.[sales ]) A
		LEFT JOIN
		(SELECT
			order_id,
			customer_id
		FROM RETAIL.dbo.orders) B
		ON
			A.order_id = B.order_id
	GROUP BY customer_id;

SELECT *
FROM RETAIL.dbo.REVENUE_VIEW


----- Temp Table: phải Insert Into
--- Hiển thị dữ liệu gồm các cột customer_id, product_id, product_type, product_name:
drop table if exists #CHI_TIET_MUA_HANG;
/*  Bảng tạm: ##ABC (mở đc trên cả tab khác)
			  #ABC (chỉ mở đc trên tab Create)
*/

CREATE TABLE #CHI_TIET_MUA_HANG
	(
	CUSTOMER_ID SMALLINT,
	PRODUCT_NAME NVARCHAR(20),
	PRODUCT_TYPE NVARCHAR(30),
	PRODUCT_ID SMALLINT
	);

SELECT *
FROM #CHI_TIET_MUA_HANG;

INSERT INTO #CHI_TIET_MUA_HANG
SELECT
	customer_id,
	product_name,
	product_type,
	B.product_ID
FROM 
	(SELECT
		customer_id,
		order_id
	FROM RETAIL.dbo.orders) A
	LEFT JOIN
	(SELECT
		order_id,
		product_id
	FROM RETAIL.dbo.[sales ]) B
	ON
		A.order_id = B.order_id
	LEFT JOIN
	(SELECT
		product_ID,
		product_name,
		product_type
	FROM RETAIL.dbo.products) C
	ON
		B.product_id = C.product_ID;

SELECT *
FROM #CHI_TIET_MUA_HANG;

SELECT
	PRODUCT_NAME,
	COUNT(*)
FROM #CHI_TIET_MUA_HANG
GROUP BY PRODUCT_NAME;


----- PIVOT METHOD:
--- Số lượng liều Vaccine đã tiêm theo quốc gia: 2 loại Pfizer & AstraZeneca:
SELECT
	location,
	[Pfizer/BioNTech],
	[Oxford/AstraZenecal]
FROM
	(SELECT	
		location,
		vaccine,
		total_vaccinations
	FROM RETAIL.dbo.covid_vaccine) AS PIVOT_SOURCE
	PIVOT
	(MAX(total_vaccinations)			--- values in a col into a row along values of [Pfizer/BioNTech] & [Oxford/AstraZenecal]
	FOR VACCINE IN ([Pfizer/BioNTech], [Oxford/AstraZenecal])) AS PIVOT_TABLE;

--- Đếm sản lượng bán của các sản phẩm có màu đỏ (red) và màu xanh (green):
SELECT
	[RED],
	[GREEN]
FROM
	(SELECT
		colour,
		SUM(QUANTITY) QUANTITY
	FROM
		(SELECT 
			product_id,
			quantity
		FROM RETAIL.dbo.[sales ]) A
		LEFT JOIN
		(SELECT
			product_ID,
			product_type,
			colour
		FROM RETAIL.dbo.products) B
		ON 
			A.product_id = B.product_ID
	GROUP BY colour) AS PIVOT_SOURCE
	PIVOT
	(SUM(QUANTITY)
	FOR colour IN ([RED], [GREEN])) PIVOT_TABLE;


----- Ranking:
--- Xếp hạng các quốc gia về thứ tự nhận liều Vaccine:
SELECT
	location,
	TOTAL_VACCINE,
	date,
	ROW_NUMBER() OVER(ORDER BY DATE) AS ROW_NUMBER,
	RANK() OVER(ORDER BY DATE) AS RANK,
	DENSE_RANK() OVER(ORDER BY DATE) AS DENSE_RANK
FROM
	(SELECT
		location,
		vaccine,
		date,
		SUM(total_vaccinations) AS TOTAL_VACCINE
	FROM RETAIL.dbo.covid_vaccine
	GROUP BY 
		location,
		vaccine,
		date) A
ORDER BY
	date,
	location;

--- Xếp hạng các quốc gia theo số liều Vaccine:
SELECT
	location,
	TOTAL_VACCINATIONS,
	ROW_NUMBER() OVER(ORDER BY TOTAL_VACCINATIONS DESC) AS ROW_NB,
	RANK() OVER(ORDER BY TOTAL_VACCINATIONS DESC) AS RANK_,
	DENSE_RANK() OVER(ORDER BY TOTAL_VACCINATIONS DESC) AS DENSE_RANK_
FROM
	(SELECT
		location,
		MAX(TOTAL_VACCINATIONS) TOTAL_VACCINATIONS
	FROM RETAIL.dbo.covid_vaccine
	GROUP BY location) A;

--- Xếp hạng quốc gia theo số liều Vaccine trong từng ngày:
SELECT TOP 100
	location,
	date,
	total_vaccinations,
	RANK() OVER(PARTITION BY DATE ORDER BY TOTAL_VACCINATIONS DESC) AS RANK_
FROM RETAIL.dbo.covid_vaccine
ORDER BY date;

--- Xếp hạng quốc gia theo số liều Vaccine trong từng loại Vaccine:
SELECT
	location,
	vaccine,
	TOTAL_VACCINES,
	RANK() OVER(PARTITION BY VACCINE ORDER BY TOTAL_VACCINES) RANK_,
	DENSE_RANK() OVER(PARTITION BY VACCINE ORDER BY TOTAL_VACCINES) DENSE_RANK_,
	ROW_NUMBER() OVER(PARTITION BY VACCINE ORDER BY TOTAL_VACCINES) ROW_NUMBER_
FROM
	(SELECT
		location,
		vaccine,
		MAX(TOTAL_VACCINATIONS) TOTAL_VACCINES
	FROM RETAIL.dbo.covid_vaccine
	GROUP BY 
		location,
		vaccine) A;

--- Xếp hạng customer_id theo payment trong từng ngày order_date:
SELECT
	customer_id,
	order_date,
	PAYMENT,
	RANK() OVER(PARTITION BY ORDER_DATE ORDER BY PAYMENT DESC) RANK_,
	ROW_NUMBER() OVER(PARTITION BY ORDER_DATE ORDER BY PAYMENT DESC) ROW_NUMBER_,
	DENSE_RANK() OVER(PARTITION BY ORDER_DATE ORDER BY PAYMENT DESC) DENSE_RANK_
FROM
	(SELECT
		customer_id,
		order_date,
		SUM(PAYMENT) PAYMENT
	FROM RETAIL.dbo.orders
	GROUP BY 
		customer_id,
		order_date) A
ORDER BY order_date;

--- Đếm số lượng đơn hàng của KH tại 2 bang New South Wales và Victoria:
CREATE TABLE #TempOrders
	(
	customer_id smallint,
	num_order int,
	state varchar(30)
	);

INSERT INTO #TempOrders
SELECT
	A.customer_id,
	NUM_ORDER,
	state
FROM
	(SELECT
		customer_id,
		COUNT(ORDER_ID) NUM_ORDER
	FROM RETAIL.dbo.orders
	GROUP BY customer_id) A
	LEFT JOIN
	(SELECT
		customer_id,
		state
	FROM RETAIL.dbo.customers) B
	ON
		A.customer_id = B.customer_id
WHERE state IN ('New South Wales', 'Vitoria');

SELECT *
FROM #TempOrders;

SELECT
	customer_id,
	[New South Wales],
	[Vitoria]
FROM
	#TempOrders AS PIVOT_SOURCE
	PIVOT
	(SUM(NUM_ORDER)
	FOR STATE IN ([New South Wales], [Vitoria])) AS PIVOT_TABLE;

--- Ranking Topic:
/*	dùng cách viết CTE tạo 1 bảng có các trường: order_id, customer_id, payment, order_date, delivery_date
	xem thứ tự đơn hàng được delivery trong 1 ngày
*/
WITH CUS_DATE_CTE 
AS
	(SELECT *
	FROM RETAIL.dbo.orders)
SELECT 
	order_id,
	delivery_date,
	RANK() OVER(PARTITION BY DELIVERY_DATE ORDER BY DELIVERY_DATE) AS DELIVERY_RANK
FROM CUS_DATE_CTE;

--- Với mỗi customer_id, ngày nào là ngày đặt đơn hàng giá trị cao nhất (viết row_num(), rank(), dense_rank()):
SELECT
	customer_id,
	order_date,
	payment,
	RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY PAYMENT DESC) RANK_
FROM RETAIL.dbo.orders;

----- Define Data:
drop table if exists RETAIL.dbo.NhanVien;

CREATE TABLE RETAIL.dbo.NhanVien
	(
	ID int,
	TEN varchar(255),
	TUOI int,
	DIA_CHI varchar(255),
	LUONG float
	);

SELECT *
FROM RETAIL.dbo.NhanVien;

INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, TUOI, DIA_CHI, LUONG) VALUES(1, 'Thanh', 24, 'Haiphong', 2000.00);
INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, TUOI, DIA_CHI, LUONG) VALUES(2, 'Loan', 26, 'Hanoi', 1500.00);
INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, TUOI, DIA_CHI, LUONG) VALUES(3, 'Nga', 24, 'Hanam', 2000.00);
INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, TUOI, DIA_CHI, LUONG) VALUES(4, 'Manh', 29, 'Hue', 6500.00);
INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, TUOI, DIA_CHI, LUONG) VALUES(5, 'Huy', 28, 'Hatinh', 8500.00);
INSERT INTO RETAIL.dbo.NhanVien(ID, TEN, DIA_CHI) VALUES(6, 'Cao', 'HCM');
INSERT INTO RETAIL.dbo.NhanVien VALUES(7, 'Lam', 29, 'Hanoi', 15000.00);
	
SELECT *
FROM RETAIL.dbo.NhanVien;

--- Update các nhân viên < 26 tuổi, địa chỉ thành Hanoi:
UPDATE RETAIL.dbo.NhanVien
SET DIA_CHI = 'Hanoi'
WHERE TUOI < 26;

--- Update nhiều bản ghi (thay đổi mức lương của nhân viên):
drop table if exists RETAIL.dbo.Luong_moi;

CREATE TABLE RETAIL.dbo.Luong_moi
	(
	ID int,
	LUONG_MOI float
	);

INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(1, 2500.00);
INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(2, 1900.00);
INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(3, 3000.00);
INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(4, 7100.00);
INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(5, 9500.00);
INSERT INTO RETAIL.dbo.Luong_moi(ID, LUONG_MOI) VALUES(6, 5500.00);

SELECT *
FROM RETAIL.dbo.Luong_moi;

SELECT *
FROM RETAIL.dbo.NhanVien;

UPDATE RETAIL.dbo.NhanVien
SET NhanVien.LUONG = Luong_moi.LUONG_MOI
FROM RETAIL.dbo.Luong_moi
WHERE NhanVien.ID = Luong_moi.ID;

/*  DELETE: xóa bản ghi có đkien
	TRUNCATE: xóa sạch data trong bảng (nhưng metadata vẫn còn ghi nhận dữ liệu)
*/

DELETE RETAIL.dbo.NhanVien
WHERE LUONG < 3000;

TRUNCATE TABLE RETAIL.dbo.NhanVien;

----- Phân tích bộ dữ liệu ANZ:
--- EDA bảng ANZ:
SELECT TOP 10 *
FROM RETAIL.dbo.ANZ;

SELECT
	COUNT(ACCOUNT),
	COUNT(DISTINCT customer_id)
FROM RETAIL.dbo.ANZ;

/* Phân tích các yếu tố nhân khẩu học của KH:
*/

SELECT DISTINCT gender
FROM RETAIL.dbo.ANZ;

SELECT DISTINCT country
FROM RETAIL.dbo.ANZ;

SELECT
	MAX(AGE),
	MIN(AGE)
FROM RETAIL.DBO.ANZ;

/* Cắt ngưỡng phân khúc theo độ tuổi:
*/
--- đếm số lượng KH theo age_bin:
SELECT
	CASE
		WHEN AGE >= 18 AND AGE <= 23 THEN 'Student'
		WHEN AGE >= 24 AND AGE<= 35 THEN 'Young Professional'
		WHEN AGE >= 36 AND AGE <= 49 THEN 'Middle Age'
		WHEN AGE >= 50 AND AGE <= 65 THEN 'Pre-Retiree'
		WHEN AGE > 65 THEN 'Retiree'
	END AS AGE_BIN,
	COUNT(DISTINCT customer_id) SLKH,
	COUNT(TRANSACTION_ID) SLGD
FROM RETAIL.dbo.ANZ
GROUP BY					--- (group by không hiểu Alias của Case When)
	CASE
		WHEN AGE >= 18 AND AGE <= 23 THEN 'Student'
		WHEN AGE >= 24 AND AGE<= 35 THEN 'Young Professional'
		WHEN AGE >= 36 AND AGE <= 49 THEN 'Middle Age'
		WHEN AGE >= 50 AND AGE <= 65 THEN 'Pre-Retiree'
		WHEN AGE > 65 THEN 'Retiree'
	END;

/* Số lượng KH theo Gender:
*/
SELECT 
	gender,
	COUNT(DISTINCT customer_id) SLKH,
	COUNT(TRANSACTION_ID) SLGD
FROM RETAIL.dbo.ANZ
GROUP BY gender;


/* Phân tích Product Holding của KH:
*/

/* Số lượng giao dịch tính theo số loại giao dịch:
*/
SELECT
	txn_description,
	COUNT(TRANSACTION_ID) SLGD
FROM RETAIL.dbo.ANZ
GROUP BY txn_description;

/* Số lượng giao dịch có sử dụng thẻ vật lý:
*/
SELECT
	card_present_flag,
	COUNT(TRANSACTION_ID) SLGD
FROM RETAIL.dbo.ANZ
GROUP BY card_present_flag;

/* Đếm số lượng Merchant Active tại các bang:
*/
SELECT 
	merchant_state,
	COUNT(MERCHANT_ID)
FROM RETAIL.dbo.ANZ
GROUP BY merchant_state
ORDER BY COUNT(MERCHANT_ID) DESC;

/* Merchant nào có giá trị trung bình cao nhất:
*/
SELECT
	merchant_id,
	AVG(AMOUNT)
FROM RETAIL.dbo.ANZ
GROUP BY merchant_id
ORDER BY AVG(AMOUNT) DESC;


/* Phân tích về giao dịch:
*/

/* max, min các điểm P25, P50, P75, P95 của giá trị giao dịch: (NOTE: chỉ dùng được data continuous)
*/
SELECT DISTINCT balance
FROM RETAIL.dbo.ANZ;

--- Các điểm giá trị thống kê của số dư (balance):
SELECT DISTINCT
	PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY BALANCE) OVER() P25,
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY BALANCE) OVER() P50,
	PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY BALANCE) OVER() P75,
	PERCENTILE_DISC(1) WITHIN GROUP(ORDER BY BALANCE) OVER() P100
FROM RETAIL.dbo.ANZ;

--- SAME:
SELECT DISTINCT
	PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY BALANCE) OVER() P25,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY BALANCE) OVER() P50,
	PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY BALANCE) OVER() P75,
	PERCENTILE_CONT(1) WITHIN GROUP(ORDER BY BALANCE) OVER() P100
FROM RETAIL.dbo.ANZ;

--- Số lượng KH rơi vào từng Bin_balance:
SELECT
	CASE
		WHEN balance >= 0.24 AND balance <= 3158.51 THEN 'P25'
		WHEN balance > 3158.51 AND balance <= 6432.01 THEN 'P50'
		WHEN balance > 6432.01 AND balance <= 12466.31 THEN 'P75'
		ELSE 'P100'
	END BALANCE_BIN,
	COUNT(DISTINCT customer_id) SLKH,
	COUNT(TRANSACTION_ID) SLGD
FROM RETAIL.DBO.ANZ
GROUP BY
	CASE
		WHEN balance >= 0.24 AND balance <= 3158.51 THEN 'P25'
		WHEN balance > 3158.51 AND balance <= 6432.01 THEN 'P50'
		WHEN balance > 6432.01 AND balance <= 12466.31 THEN 'P75'
		ELSE 'P100'
	END;

--- Các khoảng giá trị của Amount:
SELECT DISTINCT
	PERCENTILE_DISC(0.25) WITHIN GROUP(ORDER BY AMOUNT) OVER() P25,
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY AMOUNT) OVER() P50,
	PERCENTILE_DISC(0.75) WITHIN GROUP(ORDER BY AMOUNT) OVER() P75,
	PERCENTILE_DISC(1) WITHIN GROUP(ORDER BY AMOUNT) OVER() P100
FROM RETAIL.dbo.ANZ;

--- Update tên các bang trong bảng:
UPDATE RETAIL.dbo.ANZ
SET merchant_state = CASE
							WHEN 'NSW' THEN 'New South Wales'
							WHEN 'QLD' THEN 'Queensland'
							WHEN 'ACT' THEN 'Australian Capital Territory'
							WHEN 'TAS' THEN 'Tasmania'
							WHEN 'SA' THEN 'South Australia'
							WHEN 'WA' THEN 'Western Australia'
							WHEN 'NT' THEN 'Northern Territory'
							WHEN 'VIC' THEN 'Victoria'
							ELSE NULL
					END;

--- Chữa btap về nhà:
drop table if exists RETAIL.dbo.Manager;
CREATE TABLE RETAIL.dbo.Manager
	(
	manager_id int,
	manager_name Varchar(255),
	manager_level int,
	region Varchar(255),
	salary float
	);

SELECT *
FROM RETAIL.dbo.Manager;

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Manager';

INSERT INTO RETAIL.dbo.Manager(manager_id, manager_name, manager_level, region, salary) 
VALUES
	(111, 'Chris', 2, 'Nunavut', 370),
	(112, 'William', 3, 'West', 240),
	(113, 'Erin', 3, 'Prarie', 377),
	(114, 'Sam', 4, 'West', 454),
	(115, 'Pat', 3, 'Ontario', 168);

SELECT *
FROM RETAIL.dbo.Manager;

--- Thêm 2 bản ghi:
INSERT INTO RETAIL.dbo.Manager
VALUES
	(116, 'Parker', 1, 'Quebec', 390),
	(117, 'Robert', 2, 'Prarie', 407);

--- Xóa tất cả ttin với manager_level = 2:
DELETE RETAIL.dbo.Manager
WHERE manager_level = 2;

--- Cập nhật salary trong bảng Manager là 500 với region là West & Quebec:
UPDATE RETAIL.dbo.Manager
SET salary = 500
WHERE region IN ('West', 'Quebec');


----- Phân tích Unicorn:
--- Xem schema: (cột nào, data type như thế nào?, ý nghĩa cột)
SELECT
	TABLE_NAME,
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'unicorn';

--- Số lượng bản ghi:
SELECT COUNT(*)
FROM RETAIL.dbo.Unicorn;					--- có 936 bản ghi ~ 936 cty

--- Hiển thị 1 số bản ghi:
SELECT TOP 10 *
FROM RETAIL.dbo.Unicorn;

--- Tỷ lệ NULL các cột:
SELECT
	SUM(CASE 
			WHEN investor_1 IS NULL THEN 1
			ELSE 0
		END) AS investor_1,
	SUM(CASE 
			WHEN investor_2 IS NULL THEN 1
			ELSE 0
		END) AS investor_2,
	SUM(CASE 
			WHEN investor_3 IS NULL THEN 1
			ELSE 0
		END) AS investor_3,
	SUM(CASE 
			WHEN investor_4 IS NULL THEN 1
			ELSE 0
		END) AS investor_4,
FROM RETAIL.dbo.Unicorn;					--- các cột investor 2->4 đều có 46 bản ghi NULL, các cty trong dsach khảo sát đều là các cty nhận được đầu tư

--- Check số lượng bản ghi của các cột Key:
SELECT TOP 10 *
FROM RETAIL.dbo.Unicorn;

SELECT 
	COUNT(*),
	COUNT(DISTINCT COMPANY)
FROM RETAIL.dbo.Unicorn;

--- Mỗi cty có bao nhiêu bản ghi:
SELECT 
	COMPANY,
	COUNT(*)
FROM RETAIL.dbo.Unicorn
GROUP BY COMPANY
HAVING COUNT(*) >= 2;

--- Con số thống kê của các cột có giá trị tính toán:
SELECT
	MAX(VALUATION_B),
	MIN(VALUATION_B)
FROM RETAIL.dbo.Unicorn;

--- Data Mining, EDA ~ Exploration data analysis:
/*  Theo quốc gia: 
	+) có bnhieu cty startup
	+) nhận được đầu tư trong dsach
	EDA univariate, SL company => phân bổ (dist) cty theo quốc gia
*/
SELECT
	COUNTRY,
	COUNT(*) AS NUM_COMPANY
FROM RETAIL.dbo.Unicorn
GROUP BY COUNTRY
ORDER BY COUNT(*) DESC;

--- tính theo TP, bnhieu cty nhận được đầu tư:
SELECT
	COUNTRY,
	CITY,
	COUNT(*) NUMBER
FROM RETAIL.dbo.Unicorn
GROUP BY 
	COUNTRY,
	CITY
ORDER BY COUNT(*) DESC;

--- theo lĩnh vực, có bnhieu cty nhận được đầu tư:
SELECT
	INDUSTRY,
	COUNT(COMPANY) NUM_STARTUP
FROM RETAIL.dbo.Unicorn
GROUP BY INDUSTRY
ORDER BY NUM_STARTUP DESC;

--- Có bnhieu cty nhận được đầu tư của 1,2,3,4 nhà đầu tư:
SELECT
	CASE
		WHEN investor_2 IS NULL THEN '1 investor'
		WHEN investor_3 IS NULL THEN '2 investors'
		WHEN investor_4 IS NULL THEN '3 investors'
		ELSE '4 investors'
	END NUM_INVESTORS,
	COUNT(*)
FROM RETAIL.dbo.Unicorn
GROUP BY 
	CASE
		WHEN investor_2 IS NULL THEN '1 investor'
		WHEN investor_3 IS NULL THEN '2 investors'
		WHEN investor_4 IS NULL THEN '3 investors'
		ELSE '4 investors'
	END;

--- Xem các Investors của từng Company:
SELECT
	CASE 
		WHEN investor_2 IS NULL THEN '1 investor'
		WHEN investor_3 IS NULL THEN '2 investors'
		WHEN investor_4 IS NULL THEN '3 investors'
		ELSE '4 investors'
	END NUM_INVESTORS,
	COMPANY,
	INVESTOR_1,
	INVESTOR_2,
	INVESTOR_3,
	INVESTOR_4
FROM RETAIL.dbo.Unicorn
WHERE COMPANY = 'Bolt'
ORDER BY 
	NUM_INVESTORS DESC,
	COMPANY ASC;

--- Công ty nào có định giá lớn nhất / nhỏ nhất, và gắn với nhà đầu tư nào?
	(SELECT *
	FROM RETAIL.dbo.Unicorn
	WHERE Valuation_B = (SELECT MAX(Valuation_B)
						FROM RETAIL.dbo.Unicorn))
UNION
	(SELECT *
	FROM RETAIL.dbo.Unicorn
	WHERE Valuation_B = (SELECT MIN(Valuation_B)
						FROM RETAIL.dbo.Unicorn))
ORDER BY Valuation_B DESC;

--- Với mỗi quốc gia, năm nào là năm có lượng Start-up thành lập nhiều nhất:
SELECT DISTINCT YEAR(DATE_JOINED)
FROM RETAIL.dbo.Unicorn;

--- Năm nào là năm sôi động nhất với từng quốc gia:
SELECT
	COUNTRY,
	YEAR,
	NUM_STARTUP,
	RANKING
FROM 
	(SELECT
		COUNTRY,
		YEAR(DATE_JOINED) AS YEAR,
		COUNT(*) NUM_STARTUP,
		ROW_NUMBER() OVER(PARTITION BY COUNTRY ORDER BY COUNT(COMPANY) DESC) AS RANKING
	FROM RETAIL.dbo.Unicorn
	GROUP BY
		COUNTRY,
		YEAR(DATE_JOINED)) A
WHERE RANKING = 1;

/* Insights:
- Dữ liệu về 936 công ty khởi nghiệp có định giá trên 1 tỷ USD
- Đăng ký trụ sở tại 45 quốc gia (trong đó có 244 thành phố)
- Chủ yếu thành lập trong năm 2021, đa phần nhận được đầu tư của 3 vòng
- Công ty được định giá cao nhất là 140 tỷ USD
*/

--- Data Analyst:
/* 1. Xử lý data phục vụ cho việc phân tích:
		- Làm sạch Data
		- Khảo sát và ghi lại các thông tin khảo sát (Biểu mẫu)
		- Lưu thành các bảng (tạo bảng lưu dữ liệu đã xử lý)
   2. Phân tích (EDA) --> feature engineering
   3. Trực quan hóa data (Visualization)
*/


----- Phân tích:
SELECT *
FROM RETAIL.dbo.wholesale;

--- Số lượng KH theo channel:
SELECT 
	Channel,
	COUNT(DISTINCT Customer_ID) SLKH
FROM RETAIL.dbo.wholesale
GROUP BY Channel;

--- Số lượng KH theo region:
SELECT
	Region,
	COUNT(DISTINCT Customer_ID) SLKH
FROM RETAIL.dbo.wholesale
GROUP BY Region;

--- Tổng value theo channel:
SELECT
	Channel,
	SUM(VALUE) TONG
FROM RETAIL.dbo.wholesale
GROUP BY Channel;

--- Tổng value theo region:
SELECT
	Region,
	SUM(VALUE) TONG
FROM RETAIL.dbo.wholesale
GROUP BY Region;

--- Value trung bình mỗi customer theo region:
SELECT
	Region,
	SUM(VALUE)/COUNT(DISTINCT Customer_ID) VALUE_TB
FROM RETAIL.dbo.wholesale
GROUP BY Region;

--- Value trung bình mỗi customer theo channel:
SELECT
	Channel,
	SUM(VALUE)/COUNT(DISTINCT Customer_ID) VALUE_TB
FROM RETAIL.dbo.wholesale
GROUP BY Channel;

--- Phân bổ SLKH theo các ngưỡng value:
SELECT
	Range,
	COUNT(DISTINCT Customer_ID) SLKH
FROM RETAIL.dbo.wholesale
GROUP BY Range;


----- Phân khúc Khách Hàng active: (sdung pp: RFM)
/*		RFM:
	- Recency: tính từ thời điểm quan sát thì thời điểm cus_id tương tác gần nhất với bạn trong bnhieu ngày
	- Frequency: trong 1 khoảng tgian nhất định, KH tương tác/mua hàng của bạn bnhieu lần
	- Monetary: con số tiền tổng/tbinh mà KH mua hàng của bạn là bnhieu
*/
SELECT TOP 10 *
FROM RETAIL.dbo.Retail_Data_Response;

SELECT TOP 10 *
FROM RETAIL.dbo.Retail_Data_Transactions;

SELECT MAX(trans_date) 
FROM RETAIL.dbo.Retail_Data_Transactions;

SELECT DISTINCT trans_date
FROM RETAIL.dbo.Retail_Data_Transactions
ORDER BY trans_date;

SELECT DAY(trans_date)
FROM RETAIL.dbo.Retail_Data_Transactions;

--- Lấy thông tin KH có response:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1)
SELECT *
FROM Retail_active;

--- Tính chỉ số RFM cho từng KH:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1),

	RFM
AS
	(SELECT
		customer_id,
		DATEDIFF(DAY, MAX(TRANS_DATE), '2015-04-01') RECENCY,
		COUNT(DISTINCT trans_date) FREQUENCY,
		SUM(TRAN_AMOUNT) MONETARY
	FROM Retail_active
	GROUP BY customer_id)
SELECT *
FROM RFM;

--- Quy giá trị RFM thành về khoảng [0,1]:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1),

	RFM
AS
	(SELECT
		customer_id,
		DATEDIFF(DAY, MAX(TRANS_DATE), '2015-04-01') RECENCY,
		COUNT(DISTINCT trans_date) FREQUENCY,
		SUM(TRAN_AMOUNT) MONETARY
	FROM Retail_active
	GROUP BY customer_id),

	RFM_percent_rank
AS
	(SELECT
		*,
		PERCENT_RANK() OVER(ORDER BY RECENCY DESC) r_percent_rank,
		PERCENT_RANK() OVER(ORDER BY FREQUENCY) f_percent_rank,
		PERCENT_RANK() OVER(ORDER BY MONETARY) m_percent_rank
	FROM RFM)
SELECT TOP 10 *
FROM RFM_percent_rank;

--- Chia nhóm r,f,m_percent:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1),

	RFM
AS
	(SELECT
		customer_id,
		DATEDIFF(DAY, MAX(TRANS_DATE), '2015-04-01') RECENCY,
		COUNT(DISTINCT trans_date) FREQUENCY,
		SUM(TRAN_AMOUNT) MONETARY
	FROM Retail_active
	GROUP BY customer_id),

	RFM_percent_rank
AS
	(SELECT
		*,
		PERCENT_RANK() OVER(ORDER BY RECENCY DESC) r_percent_rank,
		PERCENT_RANK() OVER(ORDER BY FREQUENCY) f_percent_rank,
		PERCENT_RANK() OVER(ORDER BY MONETARY) m_percent_rank
	FROM RFM),

	RFM_group
AS
	(SELECT 
		customer_id,
		r_percent_rank,
		f_percent_rank,
		m_percent_rank,
		CASE
			WHEN r_percent_rank >= 0.75 THEN 4
			WHEN r_percent_rank >= 0.5 THEN 3
			WHEN r_percent_rank >= 0.25 THEN 2
			ELSE 1
		END r_group,
		CASE
			WHEN f_percent_rank >= 0.75 THEN 4
			WHEN F_percent_rank >= 0.5 THEN 3
			WHEN f_percent_rank >= 0.25 THEN 2
			ELSE 1
		END f_group,
		CASE
			WHEN m_percent_rank >= 0.75 THEN 4
			WHEN m_percent_rank >= 0.5 THEN 3
			WHEN m_percent_rank >= 0.25 THEN 2
			ELSE 1
		END m_group
		FROM RFM_percent_rank)

SELECT TOP 10 *
FROM RFM_group;

--- concat nhóm R,F,M:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1),

	RFM
AS
	(SELECT
		customer_id,
		DATEDIFF(DAY, MAX(TRANS_DATE), '2015-04-01') RECENCY,
		COUNT(DISTINCT trans_date) FREQUENCY,
		SUM(TRAN_AMOUNT) MONETARY
	FROM Retail_active
	GROUP BY customer_id),

	RFM_percent_rank
AS
	(SELECT
		*,
		PERCENT_RANK() OVER(ORDER BY RECENCY DESC) r_percent_rank,
		PERCENT_RANK() OVER(ORDER BY FREQUENCY) f_percent_rank,
		PERCENT_RANK() OVER(ORDER BY MONETARY) m_percent_rank
	FROM RFM),

	RFM_group
AS
	(SELECT 
		customer_id,
		r_percent_rank,
		f_percent_rank,
		m_percent_rank,
		CASE
			WHEN r_percent_rank >= 0.75 THEN 4
			WHEN r_percent_rank >= 0.5 THEN 3
			WHEN r_percent_rank >= 0.25 THEN 2
			ELSE 1
		END r_group,
		CASE
			WHEN f_percent_rank >= 0.75 THEN 4
			WHEN F_percent_rank >= 0.5 THEN 3
			WHEN f_percent_rank >= 0.25 THEN 2
			ELSE 1
		END f_group,
		CASE
			WHEN m_percent_rank >= 0.75 THEN 4
			WHEN m_percent_rank >= 0.5 THEN 3
			WHEN m_percent_rank >= 0.25 THEN 2
			ELSE 1
		END m_group
		FROM RFM_percent_rank)

SELECT 
	customer_id,
	r_group,
	f_group,
	m_group,
	CONCAT(r_group, f_group, m_group) rfm_score
FROM RFM_group;

--- Chia tách phân khúc và naming theo từng ngưỡng RFM:
WITH Retail_active
AS
	(SELECT A.*
	FROM RETAIL.dbo.Retail_Data_Transactions A
	INNER JOIN
		RETAIL.dbo.Retail_Data_Response B
	ON A.customer_id = B.customer_id
	WHERE response = 1),

	RFM
AS
	(SELECT
		customer_id,
		DATEDIFF(DAY, MAX(TRANS_DATE), '2015-04-01') RECENCY,
		COUNT(DISTINCT trans_date) FREQUENCY,
		SUM(TRAN_AMOUNT) MONETARY
	FROM Retail_active
	GROUP BY customer_id),

	RFM_percent_rank
AS
	(SELECT
		*,
		PERCENT_RANK() OVER(ORDER BY RECENCY DESC) r_percent_rank,
		PERCENT_RANK() OVER(ORDER BY FREQUENCY) f_percent_rank,
		PERCENT_RANK() OVER(ORDER BY MONETARY) m_percent_rank
	FROM RFM),

	RFM_group
AS
	(SELECT 
		customer_id,
		r_percent_rank,
		f_percent_rank,
		m_percent_rank,
		CASE
			WHEN r_percent_rank >= 0.75 THEN 1
			WHEN r_percent_rank >= 0.5 THEN 2
			WHEN r_percent_rank >= 0.25 THEN 3
			ELSE 4
		END r_group,
		CASE
			WHEN f_percent_rank >= 0.75 THEN 1
			WHEN F_percent_rank >= 0.5 THEN 2
			WHEN f_percent_rank >= 0.25 THEN 3
			ELSE 4
		END f_group,
		CASE
			WHEN m_percent_rank >= 0.75 THEN 1
			WHEN m_percent_rank >= 0.5 THEN 2
			WHEN m_percent_rank >= 0.25 THEN 3
			ELSE 4
		END m_group
		FROM RFM_percent_rank),

	RFM_score
AS
	(SELECT 
		customer_id,
		r_group,
		f_group,
		m_group,
		CONCAT(r_group, f_group, m_group) rfm_score
	FROM RFM_group),

	RFM_segment
AS
	(SELECT
		customer_id,
		rfm_score,
		CASE
			WHEN rfm_score = 111 THEN 'best customers'
			WHEN rfm_score LIKE '[3-4][3-4][1-4]' THEN 'lost bad customers'
			WHEN rfm_score LIKE '[3-4]2[3-4]' THEN 'lost customers'
			WHEN rfm_score LIKE '21[1-4]' THEN 'almost lost'
			WHEN rfm_score LIKE '11[2-4]' THEN 'loyal customers'
			WHEN rfm_score LIKE '[1-2][1-3]1' THEN 'big spenders'
			WHEN rfm_score LIKE '[1-2]4[1-4]' THEN 'new customers'
			WHEN rfm_score LIKE '[3-4]1[1-4]' THEN 'hibernating customers'
			ELSE 'potential loyalists'
		end customer_segment
	FROM RFM_score)
	
SELECT 
	customer_segment,
	COUNT(CUSTOMER_ID)
FROM RFM_segment
GROUP BY customer_segment
ORDER BY COUNT(CUSTOMER_ID) DESC;

----- Dùng CAST() or CONVERT() để chuyển đổi dữ liệu