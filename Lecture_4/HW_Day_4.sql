--- USE Thao_test

USE Thao_HW_4; ---";" de end cau lenh
--- CREATE TABLE Thao_test..banhang
drop table if exists Thao_HW_4.dbo.banhang
CREATE TABLE Thao_HW_4.dbo.banhang   ---drop table if exists Thao_test.dbo.banhang
   (
   [ Store Id ] varchar(50),
	TRANS_DATE varchar(100),
	SALE_NAME NVARCHAR(255) ,
	SALE_ID VARCHAR(50),
	SALE_ADDRESS NVARCHAR(255) ,
	CUS_NAME NVARCHAR(255) ,
	CUS_ID VARCHAR(255) ,
	RETAIL_BILL VARCHAR(50) ,
	TOTAL_BILL VARCHAR(50) ,
	CCY_CODE VARCHAR(10) ,
	PRODCUCT_NAME NVARCHAR(255),
	UNIT_PRICE varchar(10),
	TRANS_TYPE VARCHAR(3),
	FCY_AMT FLOAT,
	LCY_AMT FLOAT,
	COMMISSION FLOAT,
	SALE_OFF FLOAT ,
	CHAMTRA FLOAT,
	MAT_DATE DATE,
	CUS_TYPE INT 
	)
BULK INSERT Thao_HW_4.DBO.BANHANG
FROM "C:\Users\HP\Downloads\Lesson1-data.csv"
	WITH 
	(
		FIRSTROW = 2,---- LẤY DỮ LIỆU TỪ FILE EXCEL BẮT ĐẦU TỪ DÒNG THỨ 2
		FIELDTERMINATOR = ',', ---- NGĂN CÁCH GIỮA CÁC CỘT BỞI DẤU TAB,PHẨY -----
		ROWTERMINATOR = '\n'
	)

SELECT TOP 1000 *   ----- * là all columns, top 1000 là số dòng được chỉ định
FROM Thao_HW_4.dbo.banhang
;






--- 1. Tính tổng số tiền theo từng mã cửa hàng và theo từng vùng dựa theo địa chỉ nhân viên (Miền Bắc, Miền Trung, Miền Nam). ---

SELECT 
		[ Store Id ],
		CASE
			WHEN SALE_ADDRESS IN ('AN GIANG', 'BẠC LIÊU') THEN 'MIENNAM'
			WHEN SALE_ADDRESS IN ('HÀ GIANG', 'HÀ NỘI') THEN 'MIENBAC'
		ELSE 'MIENTRUNG'
		END 'VUNGMIEN',
		SUM(FCY_AMT) AMOUNT
FROM Thao_HW_4.dbo.banhang
GROUP BY 
		[ Store Id ],
		CASE
			WHEN SALE_ADDRESS IN ('AN GIANG', 'BẠC LIÊU') THEN 'MIENNAM'
			WHEN SALE_ADDRESS IN ('HÀ GIANG', 'HÀ NỘI') THEN 'MIENBAC'
		ELSE 'MIENTRUNG'
		END;


--- 2. Tính tổng số tiền theo từng mã cửa hàng và theo từng nhóm năm của thời điểm giao dịch như sau từ tháng 1 – tháng 6 2019(Quý 1 2019), từ tháng 7 – tháng 12 2019(Quý 2 2019), từ tháng 1 – 6 năm 2020(Quý 1 2020), từ tháng 7 – 12 năm 2020(Quý 2 2020). ---


SELECT 
		[ Store Id ],
		CASE
			WHEN TRANS_DATE BETWEEN '2019-01-01' AND '2019-06-30' THEN N'Quý 2 2019'
			WHEN TRANS_DATE BETWEEN '2019-07-01' AND '2019-12-31' THEN N'Quý 2 2019'
			WHEN TRANS_DATE BETWEEN '2019-01-01' AND '2019-06-30' THEN N'Quý 1 2020'
		ELSE N'Quý 2 2020'
		END 'THEO_QUY',
		SUM(FCY_AMT) AMOUNT
FROM Thao_HW_4.dbo.banhang
GROUP BY 
		[ Store Id ],
		CASE
			WHEN TRANS_DATE BETWEEN '2019-01-01' AND '2019-06-30' THEN N'Quý 2 2019'
			WHEN TRANS_DATE BETWEEN '2019-07-01' AND '2019-12-31' THEN N'Quý 2 2019'
			WHEN TRANS_DATE BETWEEN '2019-01-01' AND '2019-06-30' THEN N'Quý 1 2020'
		ELSE N'Quý 2 2020'
		END;


--- 3. Tính tổng số tiền theo từng mã cửa hàng và theo từng nhóm mã khách hàng chia như sau:

---				Nhóm 1: Tên Khách Hàng nhỏ hơn 8 kí tự

---				Nhóm 2: Tên Khách Hàng từ 8 - 12 kí tự

---				Nhóm 3: Tên Khách Hàng từ 12 - 15 kí tự

---				Nhóm 4: Tên Khách Hàng > 15 kí tự

---		(Sử dụng hàm Len để đếm số kí tự từ tên khách hàng) ---

SELECT 
		[ Store Id ],
		CASE
			WHEN LEN(CUS_NAME) < 8 THEN 'GROUP 1'										--- len('a') vì 'abc...' là hàm truyền vào ---
			WHEN LEN(CUS_NAME) BETWEEN 8 AND 11 THEN 'GROUP 2'
			WHEN LEN(CUS_NAME) BETWEEN 12 AND 15 THEN 'GROUP 3'
		ELSE 'GROUP 4'
		END 'LEN_NAME',
		SUM(FCY_AMT) AMOUNT
FROM Thao_HW_4.dbo.banhang
GROUP BY 
		[ Store Id ],
		CASE
			WHEN LEN(CUS_NAME) < 8 THEN 'GROUP 1'
			WHEN LEN(CUS_NAME) BETWEEN 8 AND 11 THEN 'GROUP 2'
			WHEN LEN(CUS_NAME) BETWEEN 12 AND 15 THEN 'GROUP 3'
		ELSE 'GROUP 4'
		END;


--- 4. Lấy ra thông tin giao dịch có số tiền lớn nhất theo từng ngày và từng cửa hàng ---

SELECT a.*,
	   a.CCY_CODE
FROM 
	(
	SELECT DENSE_RANK ()
				OVER (PARTITION BY [ Store Id ],
								   TRANS_DATE 
				ORDER BY LCY_AMT DESC) AS RN,
		   * 
	FROM Thao_HW_4.dbo.BanHang
	) A
WHERE A.RN = 1;


--- 5. Lấy ra khách có số tiền lớn nhất theo từng ngày và từng cửa hàng ---

-- C1: --

with tbl_a as
	(
		SELECT a.*,
			   DENSE_RANK () 
					OVER (PARTITION BY a.[ Store Id ],
									   a.TRANS_DATE 
						  ORDER BY a.SOTIEN DESC) AS RN
		FROM 
			(
			SELECT
				[ Store Id ],
				TRANS_DATE,
				CUS_ID,
				SUM(LCY_AMT) AS SOTIEN
			FROM Thao_HW_4.dbo.BanHang
			GROUP BY
				[ Store Id ],
				TRANS_DATE,
				CUS_ID
			) a
	)
SELECT *
FROM tbl_a 
WHERE RN =	1;



-- C2: --

with tbl_a as
	(
		SELECT
			[ Store Id ],
			TRANS_DATE,
			CUS_ID,
			SUM(LCY_AMT) AS SOTIEN,
			DENSE_RANK () 
					OVER (PARTITION BY [ Store Id ],
										TRANS_DATE 
						  ORDER BY SUM(LCY_AMT) DESC) AS RN
		FROM Thao_HW_4.dbo.BanHang
		GROUP BY
			[ Store Id ],
			TRANS_DATE,
			CUS_ID
	)
SELECT *
FROM tbl_a 
WHERE RN =	1;


--- 6. Sử dụng insert into thêm dữ liệu vào bảng discount như trong file Lesson1-data.xlsb. ---

drop table if exists Thao_HW_4.dbo.Discount
CREATE TABLE Thao_HW_4.dbo.Discount
	(
	MucToiThieu int,
	MucToiDa int,
	MucChietKhau float,
	DieuKien float,
	[ Loai KH Toi Thieu ] int
	);



SELECT * 
FROM Thao_HW_4.dbo.Discount;

INSERT INTO Thao_HW_4.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau,DieuKien,[ Loai KH Toi Thieu ]) values (0,5,0.01,50,3);
INSERT INTO Thao_HW_4.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau,DieuKien,[ Loai KH Toi Thieu ]) values (5,10,0.015,100,3),(10,20,0.01575,500,2)
INSERT INTO Thao_HW_4.dbo.Discount select 20,40,0.0165375,1000,2;
INSERT INTO Thao_HW_4.dbo.Discount select 40,80,0.017364375,2000,1;
INSERT INTO Thao_HW_4.dbo.Discount select 80,160,0.01823259375,4000,1;
INSERT INTO Thao_HW_4.dbo.Discount select 160,320,0.0191442234375,8000,1
INSERT INTO Thao_HW_4.dbo.Discount select 320,640,0.020101434609375,16000,1;
INSERT INTO Thao_HW_4.dbo.Discount select 640,1280,0.0211065063398438,32000,1;
INSERT INTO Thao_HW_4.dbo.Discount select 1280,2560,0.0221618316568359,64000,1;
INSERT INTO Thao_HW_4.dbo.Discount select 2560,0,0.0232699232396777,128000,1;


--- 7. Tạo bảng và sử dụng insert into thêm 10 dòng dữ liệu vào bảng Cus_ID như trong file Lesson1-data.xlsb. ---

drop table if exists Thao_HW_4.dbo.Cus_ID
CREATE TABLE Thao_HW_4.dbo.Cus_ID
	(
	CUS_ID VARCHAR(255),
	CUS_NAME VARCHAR(255),
	ADDRESS NVARCHAR(255),
	SEX VARCHAR(50),
	COMPANY VARCHAR(50),
	EMAIL VARCHAR(255),
	PHONE_NUM INT
	);



SELECT * 
FROM Thao_HW_4.dbo.Cus_ID;

INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH209292','Aaron Adams',N'Đắk Nông','Oth','Cong ty 12043','Aaron Adams@gmail.com',0988902949;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH435992','Aaron Alexander',N'Hà Nội','Oth','Cong ty 9490','Aaron Alexander@gmail.com',0988842444;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH549765','Aaron Allen',N'Hòa Bình','mr','Cong ty 27994','Aaron Allen@gmail.com',0983005132;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH347133','Aaron Baker',N'Hòa Bình','Ms','Cong ty 6536','Aaron Baker@gmail.com',0981579936;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH244458','Aaron Bryant',N'Bình Dương','mr','Cong ty 20053','Aaron Bryant@gmail.com',0985014837;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH586829','Aaron Butler',N'Bắc Ninh','Oth','Cong ty 8653','Aaron Butler@gmail.com',0982052513;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH570918','Aaron Campbell',N'Thanh Hóa','Ms','Cong ty 25539','Aaron Campbell@gmail.com',0983260784;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH966479','Aaron Carter',N'Tây Ninh','mr','Cong ty 38435','Aaron Carter@gmail.com',0986307985;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH257276','Aaron Chen',N'Quảng Nam','Ms','Cong ty 33851','Aaron Chen@gmail.com',0985077084;
INSERT INTO Thao_HW_4.dbo.Cus_ID select 'MKH999590','Aaron Coleman',N'Bắc Giang','mr','Cong ty 29999','Aaron Coleman@gmail.com',0983963542;


--- 8. Update cột số điện thoại của bảng Cus_ID bằng cách thêm số 0 vào đầu ---

-- C1: --
UPDATE Thao_HW_4.DBO.Cus_ID
SET PHONE_NUM = STUFF(PHONE_NUM,1,1,'0');

-- C2: --
UPDATE Thao_HW_4.DBO.Cus_ID
SET PHONE_NUM = CONCAT('0',PHONE_NUM);

-- C3: --
UPDATE Thao_HW_4.DBO.Cus_ID
SET PHONE_NUM = '0' + PHONE_NUM;


--- 9. Update cột Email của bảng Cus_ID bằng cách xóa chữ @gmail.com đi ---

-- C1: --
UPDATE Thao_HW_4.DBO.Cus_ID
SET EMAIL = LEFT(EMAIL, LEN(EMAIL)-10);

-- C2: --
UPDATE Thao_HW_4.DBO.Cus_ID
SET EMAIL = LEFT(EMAIL, CHARINDEX('@', EMAIL)-1);							--- đuôi bất kì, kp Gmail nữa ---

--- 10. Xóa các công ty có tên có độ dài >= 13 kí tự ---

DELETE FROM Thao_HW_4.DBO.Cus_ID
WHERE LEN(CUS_NAME) >= 13;
SELECT *
FROM Thao_HW_4.DBO.Cus_ID;