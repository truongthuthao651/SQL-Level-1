--- USE Thao_test

USE Thao_test; ---";" de end cau lenh
--- CREATE TABLE Thao_test..banhang
drop table if exists Thao_test.dbo.banhang
CREATE TABLE Thao_test.dbo.banhang   ---drop table if exists Thao_test.dbo.banhang
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
BULK INSERT Thao_test.DBO.BANHANG
FROM "C:\Users\HP\Downloads\Lesson1-data.csv"
	WITH 
	(
		FIRSTROW = 2,---- LẤY DỮ LIỆU TỪ FILE EXCEL BẮT ĐẦU TỪ DÒNG THỨ 2
		FIELDTERMINATOR = ',', ---- NGĂN CÁCH GIỮA CÁC CỘT BỞI DẤU TAB,PHẨY -----
		ROWTERMINATOR = '\n'
	)

SELECT TOP 1000 *   ----- * là all columns, top 1000 là số dòng được chỉ định
FROM Thao_test.dbo.banhang
;



----- CHECK ERRORS -----
SELECT * FROM SYS.MESSAGES
WHERE LANGUAGE_ID = 1033




SELECT        ----- pick some columns
   [ Store Id ],
   TRANS_DATE,
   SALE_NAME
FROM Thao_test.dbo.banhang
;

----- Check Information:
SELECT *
FROM Thao_test.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BANHANG'
ORDER BY ORDINAL_POSITION
;



----- Sắp xếp kqua QUERY:
----- Giảm dần:
SELECT TOP 100 *
FROM Thao_test.dbo.banhang
ORDER BY FCY_AMT DESC
;


----- Tăng dần:
SELECT TOP 1000 *
FROM Thao_test.dbo.banhang
ORDER BY FCY_AMT ASC   ----- mặc định là ASC -> có thể k cần khai báo vẫn hiểu
;



SELECT TOP 100 *
FROM Thao_test.dbo.banhang
ORDER BY TRANS_DATE ASC, FCY_AMT ASC      ----- TRANS_DATE, FCY_AMT ASC
;



SELECT TOP 100 *
FROM Thao_test.dbo.banhang
ORDER BY TRANS_DATE DESC, FCY_AMT ASC      ----- sắp xếp Trans xong rồi đên FCY, những cái nào Trans trùng thì mới sxep FCY theo ASC -----
;



SELECT *
FROM Thao_test.dbo.banhang
WHERE [ Store Id ] = 'STORE 1'
ORDER BY [ Store Id ]
;



SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT > 100000000     ----- = WHERE LCY_AMT > 100e6
ORDER BY LCY_AMT ASC
;



SELECT *
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-02-28'
ORDER BY TRANS_DATE;



SELECT TOP 100 *
FROM 
     Thao_test.dbo.banhang
WHERE
     UNIT_PRICE IS NOT NULL     ----- >< UNIT_PRICE IS NULL
ORDER BY LCY_AMT;



SELECT *
FROM Thao_test.dbo.banhang
WHERE SALE_ADDRESS = 'DAK LAK' AND
      TRANS_DATE = '2019-06-17'
ORDER BY [ Store Id ] ASC;




SELECT *
FROM Thao_test.dbo.banhang
WHERE SALE_ADDRESS = 'DAK LAK' AND
      TRANS_DATE = '2019-06-17' AND
	  [ Store Id ] = 'STORE 1'
ORDER BY [ Store Id ] ASC;




SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT >= 10e6
ORDER BY LCY_AMT;



SELECT *
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-06-17'
ORDER BY LCY_AMT ASC;



SELECT *
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-06-17' AND
      CUS_ID = 'MKH536806' AND
	  CCY_CODE = 'VND';


SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT > 1e6 and 
	  LCY_AMT < 10e9
ORDER BY CUS_ID;



SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT BETWEEN 1e6 AND 1e9     ----- BETWEEN...AND: 1e6 <= ... <= 1e9
ORDER BY CUS_ID;



SELECT TOP 100 FORMAT(FCY_AMT,'#,###0') FORMAT_SOTIEN, *     ----- FORMAT(FCY_AMT,'#,###0') AS FORMAT_SOTIEN, * -----
FROM Thao_test.dbo.banhang
WHERE LCY_AMT > 1e6 and 
	  LCY_AMT < 10e9
ORDER BY LCY_AMT DESC;


SELECT *
FROM Thao_test.dbo.banhang A   ----- set banhang as A


ALTER TABLE Thao_test.dbo.banhang
ALTER COLUMN FCY_AMT FLOAT;           ----- sửa kiểu dữ liệu trong cột -----



--- Lấy ra ttin cửa hàng 1,2,3,4 trong tháng 11/2019, sắp xếp theo giảm dần số tiền quy đổi ---
SELECT *
FROM Thao_test.dbo.banhang
WHERE [ Store Id ] in ('store 1', 'store 2', 'store 3', 'store 4')  --- >< [ Store Id ] not in ('store 1', 'store 2', 'store 3', 'store 4') ---
	and MONTH(TRANS_DATE) = 11           --- or: TRANS_DATE BETWEEN '2019-11-01' AND '2019-11-30' ---
	AND YEAR(TRANS_DATE) = 2019
ORDER BY LCY_AMT DESC;




SELECT DISTINCT [ Store Id ]   ----- Lấy ra gtri Unique -----
FROM Thao_test.dbo.banhang
ORDER BY [ Store Id ];


SELECT DISTINCT [ Store Id ], TRANS_DATE   ----- SELECT những Store, Trans phát sinh -----
FROM Thao_test.dbo.banhang
ORDER BY TRANS_DATE;


--- Lấy ra TOÀN BỘ ttin giao dịch có số tiền nguyên tệ nhỏ nhất ---
SELECT *
FROM Thao_test.dbo.banhang           
WHERE FCY_AMT = (SELECT TOP 1 FCY_AMT             ----- SUB QUERY -----
					FROM Thao_test.dbo.banhang
					ORDER BY FCY_AMT ASC)
ORDER BY FCY_AMT;



SELECT *
FROM Thao_test.dbo.banhang           
WHERE LCY_AMT = (SELECT TOP 1 LCY_AMT             ----- SUB QUERY -----
					FROM Thao_test.dbo.banhang
					ORDER BY LCY_AMT ASC)
ORDER BY LCY_AMT;



select TOP 10 * 
from Thao_test.dbo.banhang 
where [ Store Id ] <> 'STORE 1'             ----- '<>' = '!=' -----
order by [ Store Id ]
;



SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME LIKE 'LUCAS G%' ;    --- like tên đầu ---


SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME LIKE '%GARCIA'  ;     --- like tên cuối ---


SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME LIKE '%IA%' ;          --- like ở giữa ---
----- % là các kí tự ẩn, bao gồm 'space' -----



--- Lấy tên KH có chứ 'L' ở vtri thứ 3:
SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME LIKE '__L%' ;      ----- mỗi dấu "_" là 1 blank cần điền -----


SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME not LIKE 'CAITLIN%';        ----- NOT LIKE >< LIKE -----


SELECT *
FROM Thao_test.dbo.banhang 
WHERE CUS_NAME LIKE '[A-Z]%' ;   --- Lấy ra KH có chữ cái đầu trong tên là từ A đến Z ---


SELECT *
FROM Thao_test.dbo.banhang 
WHERE [ Store Id ] LIKE 'STORE%[0-9]%' ;   --- 'STORE%[0-9]%' = 'STORE [0-9]%' ---




SELECT SUM(LCY_AMT) AS TONGTIENQUYDOI 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';


SELECT AVG(LCY_AMT) AS TBTIENQUYDOI 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';


SELECT MAX(LCY_AMT) AS MAXTIENQUYDOI 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';


SELECT MIN(LCY_AMT) AS MINTIENQUYDOI 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';


SELECT COUNT(*) AS SOLUONGGIAODICH 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';


--- Đếm số lượng KH giao dịch:
SELECT COUNT(DISTINCT CUS_ID) AS SOLUONGKH 
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02';







--- Lấy ra tổng số tiền quy đổi theo Store ID ---
SELECT 
		[ STORE ID ],
		SUM(FCY_AMT) AS TOTAL_FCY_AMT
FROM Thao_test.dbo.banhang 
GROUP BY [ STORE ID ]
ORDER BY [ STORE ID ];


--- đếm số lượng giao dịch của từng cửa hàng trong năm 2019, sắp xếp giảm dần theo mã CH ---
SELECT 
		[ STORE ID ],
		COUNT(*) AS TOTAL_TRANS_DATE
FROM Thao_test.dbo.banhang 
WHERE YEAR(TRANS_DATE) = 2019
GROUP BY [ STORE ID ]
ORDER BY [ STORE ID ] DESC;


--- tính tổng số tiền GD nguyên tệ theo từng cửa hàng và từng loại hàng hóa, sắp xếp theo mã cửa hàng ---
SELECT 
		[ STORE ID ],
		PRODCUCT_NAME,
		SUM(FCY_AMT)/1e6 AS TOTAL_FCY_AMT
FROM Thao_test.dbo.banhang 
GROUP BY [ STORE ID ], PRODCUCT_NAME
ORDER BY [ STORE ID ];




---  Lấy tổng số tiền theo nhân viên (mã nhân viên, tên nhân viên, địa chỉ) có loại hàng là Metal Angle,LL Road Pedal,Internal Lock Washer 9,Hex Nut 11 ---
SELECT 
		SALE_NAME,
		SALE_ADDRESS,
		SALE_ID,
		SUM(FCY_AMT)/1e6 AS TOTAL_FCY_AMT
FROM Thao_test.dbo.banhang 
WHERE PRODCUCT_NAME IN ('Metal Angle','LL Road Pedal','Internal Lock Washer 9','Hex Nut 11')
GROUP BY SALE_NAME,
		SALE_ADDRESS,
		SALE_ID;



---  Lấy tổng số tiền quy đổi theo từng mã cửa hàng có loại hàng bắt đầu bằng các chữ cái sau LL, ML, HL ---
SELECT 
		[ Store Id ],
		SUM(FCY_AMT)/1e6 AS TOTAL_FCY_AMT
FROM Thao_test.dbo.banhang 
WHERE PRODCUCT_NAME LIKE 'LL%' OR                --- = WHERE LEFT(PRODCUCT_NAME,2) IN ('LL', 'ML', 'HL') ---
		PRODCUCT_NAME LIKE 'ML%' OR 
		PRODCUCT_NAME LIKE 'HL%'
GROUP BY [ Store Id ];


--- Lấy tổng số tiền quy đổi theo từng mã cửa hàng có loại hàng từ vị trí số 2 bằng các chữ cái sau LL, ML, HL ---
SELECT [ Store Id ], 
	   SUM(FCY_AMT)/1e6 AS TOTAL_FCY_AMT
FROM Thao_test.dbo.banhang
WHERE SUBSTRING(PRODCUCT_NAME,2,2) in ('LL', 'ML','HL')   --- SUBSTRING(string, start, length) ---
GROUP BY [ Store Id ];



--- Lấy ra tổng số tiền theo từng mã cửa hàng có thời điểm giao dịch vào 4/2019 ---
SELECT 
	[ Store Id ],
	SUM(FCY_AMT) AS TOTAL_PRICE
FROM Thao_test.dbo.banhang
WHERE MONTH(TRANS_DATE) = 4 AND
	  YEAR(TRANS_DATE) = 2019
GROUP BY [ Store Id ];



--- Lấy ra tổng số tiền theo từng mã cửa hàng có thời điểm giao dịch vào ngày 2019-04-02 của những giao dịch có số tiền > 100e6 ---
SELECT 
	[ Store Id ],
	SUM(FCY_AMT) AS TOTAL_PRICE
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-04-02' AND
	  FCY_AMT > 100e6
GROUP BY [ Store Id ];



--- Lấy tổng số tiền giao dịch, tổng số tiền chiết khấu, tổng số tiền chậm trả theo từng mã cửa hàng có thời điểm giao dịch vào 2019-04-02 của những loại hàng có tên có từ 'Frame' ---
SELECT
		[ Store Id ],
		SUM(FCY_AMT) AS TOTAL_PRICE,
		SUM(COMMISSION) AS CK,
		SUM(CHAMTRA) AS CHAMTRA
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-04-02' AND
	  PRODCUCT_NAME LIKE '%FRAME%'
GROUP BY [ Store Id ];



--- Lấy ra số lượng giao dịch theo từng loại khách hàng trong ngày 2019-04-02 ---
SELECT 
		CUS_TYPE,
		COUNT(1) AS SOLUONGGIAODICH
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02'
GROUP BY CUS_TYPE;


--- Lấy ra tổng số tiền giao dịch, số lượng khách hàng theo từng loại khách hàng trong ngày 2019-04-02 ---
SELECT 
		CUS_TYPE,
		SUM(FCY_AMT) AS TOTAL_PRICE,
		COUNT(DISTINCT CUS_ID) AS SOLUONGGIAODICH
FROM Thao_test.dbo.banhang 
WHERE TRANS_DATE = '2019-04-02'
GROUP BY CUS_TYPE;


--- Lấy ra tổng số tiền giao dịch, số lượng giao dịch,tổng số tiền hoa hồng (bằng hoa hông * so tien nguyen te / 100) của từng cửa hàng và từng nhân viên trong cửa hàng đó ---
SELECT 
		[ Store Id ],
		SALE_ID,
		SUM(FCY_AMT) AS TOTAL_PRICE,
		COUNT(*) AS SOLUONGGIAODICH,
		SUM((COMMISSION * FCY_AMT) / 100)  TOTAL_HOAHONG
FROM Thao_test.dbo.banhang 
GROUP BY [ Store Id ],
		 SALE_ID;







----- Having: lọc kqua sau truy vấn và phải có lệnh Group By ở trước -----:
SELECT
		[ Store Id ],
		COUNT(*) AS SL
FROM Thao_test.dbo.banhang 
GROUP BY [ Store Id ]
HAVING COUNT(*) >= 5;


--- Lấy ra tổng số tiền giao dịch theo từng khách hàng của từng cửa hàng. Chỉ lấy ra những khách hàng có tổng số tiền > 500 triệu ---
SELECT
		CUS_ID,
		[ Store Id ],
		SUM(FCY_AMT) AS TONGTIEN
FROM Thao_test.dbo.banhang
GROUP BY CUS_ID, [ Store Id ]
HAVING SUM(FCY_AMT) > 5e8
ORDER BY TONGTIEN DESC;                            --- chỉ có Order By được gọi tên theo Alias ---


--- Lấy ra tổng số tiền giao dịch theo từng khách hàng của từng cửa hàng. Chỉ lấy ra những khách hàng có tổng số tiền > 500 triệu và chỉ lấy các giao dịch của ngày 2019-04-02 ---
SELECT
		CUS_ID,
		[ Store Id ],
		SUM(FCY_AMT) AS TONGTIEN
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-04-02'
GROUP BY CUS_ID, [ Store Id ]
HAVING SUM(FCY_AMT) > 5e8
ORDER BY TONGTIEN DESC; 


--- Lấy ra 10 nhân viên có số tiền giao dịch nhỏ nhất tại ngày 2019-04-02 của cửa hàng STORE 1 có tổng số tiền giao dịch > 500 triệu ---
SELECT
		SALE_ID,
		MIN(FCY_AMT) AS TONGTIEN
FROM Thao_test.dbo.banhang
WHERE TRANS_DATE = '2019-04-02' AND
	  [ Store Id ] = 'STORE 1'
GROUP BY SALE_ID
HAVING SUM(FCY_AMT) > 5e8
ORDER BY SALE_ID ASC; 



--- Lấy ra các giao dịch có số tiền bằng số tiền giao dịch nhỏ nhất và các  giao dịch có số tiền bằng số tiền giao dịch lớn nhất ---
SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT = ( SELECT MIN(LCY_AMT)
				  FROM Thao_test.dbo.banhang)
	OR LCY_AMT = ( SELECT MAX(LCY_AMT)
				  FROM Thao_test.dbo.banhang)
ORDER BY SALE_ID ASC; 




SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT = ( SELECT TOP 1 LCY_AMT
				  FROM Thao_test.dbo.banhang
				  ORDER BY LCY_AMT)
UNION ALL
SELECT *
FROM Thao_test.dbo.banhang
WHERE LCY_AMT = ( SELECT TOP 1 LCY_AMT
				  FROM Thao_test.dbo.banhang
				  ORDER BY LCY_AMT DESC);
----- UNION (bỏ giá trị trùng lặp -> kqua trả về toàn gtri Unique) / UNION ALL (nối 2 Select, k bỏ gtri trùng lặp) -----


--- CHARINDEX
--- tìm hiểu các hàm xử lý chuỗi, date time
--- tìm hiểu insert, update, delete, truncate, alter table, alter column 
--- https://v1study.com/sql-ham-xu-ly-chuoi-a570.html
---WINDOW NUMBER: ROW_NUMBER, RANK, DENSE_RANK, (LEAD, LAG, FIRST_VALUE...)---
	





---C1: use With:
WITH TEN_BANG_MUON_DAT AS 
		(SELECT 
			CUS_ID,
			SUM(LCY_AMT) AS TONG_TIEN
		FROM Thao_test.dbo.banhang
		GROUP BY CUS_ID)
		SELECT *
		FROM TEN_BANG_MUON_DAT;

---C2: subquery:---
SELECT TOP 100 *
FROM
		(SELECT 
			CUS_ID,
			SUM(LCY_AMT) AS TONG_TIEN
		FROM Thao_test.dbo.banhang
		GROUP BY CUS_ID) AS ABC;





----- Insert: thêm dữ liệu vào bảng có sẵn -----

drop table if exists Thao_test.dbo.Discount
CREATE TABLE Thao_test.dbo.Discount
	(
	MucToiThieu int,
	MucToiDa int,
	MucChietKhau float,
	DieuKien float,
	[ Loai KH Toi Thieu ] int
	);



SELECT * 
FROM Thao_test.dbo.Discount;

INSERT INTO Thao_test.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau,DieuKien,[ Loai KH Toi Thieu ]) values (0,5,0.01,50,3);
INSERT INTO Thao_test.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau,DieuKien) values (0,5,0.01,50);
INSERT INTO Thao_test.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau,[ Loai KH Toi Thieu ]) values (0,5,0.01,3)
INSERT INTO Thao_test.dbo.Discount (MucToiDa,MucChietKhau,[ Loai KH Toi Thieu ]) values (5,0.01,50);


--- tự Insert theo thứ tự các columns: ---
INSERT INTO Thao_test.dbo.Discount values (0,5,0.01,50,3);


--- dùng Select thay cho Values: ---
INSERT INTO Thao_test.dbo.Discount (MucToiThieu,MucToiDa,MucChietKhau)
select 1,7,0.02;




----- Delete dữ liệu có điều kiện từ bảng có sẵn -----
----- truncate table: xóa cả bảng -----

SELECT * 
FROM Thao_test.dbo.Discount;

DELETE FROM Thao_test.dbo.Discount
WHERE [ Loai KH Toi Thieu ] is null;


--- xóa cả bảng ---
TRUNCATE TABLE Thao_test.dbo.Discount;
-- Or --
DELETE FROM Thao_test.dbo.Discount;


DELETE Thao_test.dbo.Discount 
WHERE [ Loai KH Toi Thieu ] = 3 
		and DieuKien = 50;



----- Update dữ liệu trong bảng -----


SELECT * 
FROM Thao_test.dbo.Discount;

--- update cả cột ---
UPDATE Thao_test.dbo.Discount 
SET MucToiThieu = 111;

--- update có điều kiện ---
UPDATE Thao_test.dbo.Discount
SET DieuKien = 20 
WHERE DieuKien is null;


UPDATE Thao_test.dbo.Discount 
SET 
	DieuKien = 30,
	MucChietKhau = 0.02 
WHERE [ Loai KH Toi Thieu ] = 50 
		and DieuKien = 20;


----- Update từ 1 bảng khác -----


drop table if exists ##ABC;
CREATE TABLE ##ABC                       ----- Bảng tạm: ##ABC (mở đc trên cả tab khác) -----     
	(                                    -----           #ABC (chỉ mở đc trên tab Create) -----
	CusID int,
	Amount int,
	Income int
	)

CREATE TABLE ##XYZ 
	(
	CusID int,
	Salary int
	);

INSERT INTO ##ABC VALUES (1,50,null);
INSERT INTO ##ABC VALUES (2,100,null);
INSERT INTO ##ABC VALUES (3,150,null);

INSERT INTO ##XYZ VALUES (1,1000);
INSERT INTO ##XYZ VALUES (2,2000);
INSERT INTO ##XYZ VALUES (3,3000);

SELECT *
FROM ##ABC;

SELECT *
FROM ##XYZ;

UPDATE ##ABC
SET Income = Salary
FROM ##ABC AS A, ##XYZ AS B
WHERE 
		A.CusID = B.CusID;




----- Các hàm xử lý DateTime -----


SELECT CURRENT_TIMESTAMP;                                  --- 2 hàm này lấy ra Current Time ---
SELECT GETDATE();

SELECT DAY(getdate());                                     --- lấy ra ngày trong tháng (từ 1 đến 31) ---
SELECT MONTH(getdate());                                   --- lấy ra tháng của ngày truyền vào ---
SELECT YEAR(getdate());                                    --- lấy ra năm của ngày truyền vào ---
SELECT DATEPART(DW,getdate());                             --- lấy ra thứ tự ngày trong tuần ---
SELECT DATENAME (W,getdate());                             --- trả ra tên của ngày trong tuần ---



--- Select ngày/tháng... hơn hoặc kém ---
SELECT DATEADD(DD, 1, '2017/07/31') AS DateAdd;            --- cộng số học trên date, cho phép cộng số âm ---
SELECT DATEADD(D, 1, '2017/07/31') AS DateAdd;

SELECT DATEADD(MM, 1, '2017/08/25') AS DateAdd;

SELECT DATEADD(MONTH, -1, '2017/08/25') AS DateAdd;

--- K/c 2 different Date ---
SELECT DATEDIFF (dd, getdate(), '2021-12-20');              --- trả ra khoảng cách giữa 2 thời điểm, lấy ngày sau trừ ngày trước ---



-- ví dụ: --


SELECT 
	year(TRANS_DATE),
	TRANS_DATE ThoiDiemGiaoDich,
	count(*)
FROM Thao_test.dbo.BanHang
WHERE DATEADD(MONTH, 1, TRANS_DATE) <= '2019-04-02'
GROUP BY 
		TRANS_DATE
ORDER BY 2 DESC;





SELECT 
	[ Store Id ],
	TOTAL_BILL,
	TRANS_DATE,
	MAT_DATE,
	DATEDIFF(M,TRANS_DATE,MAT_DATE) as Thang,
	DATEDIFF(DD,TRANS_DATE,MAT_DATE) as DAYOFYEAR,
	DATEDIFF(YY,TRANS_DATE,MAT_DATE) as year
FROM Thao_test.dbo.BanHang;






----- Select...into...: tạo ra bản sao từ 1 bảng có sẵn -----


drop table if exists Thao_test..Banhang_new
SELECT TOP 1000 
		CUS_ID,
		CUS_NAME,
		SALE_ADDRESS
INTO Thao_test..Banhang_new
FROM Thao_test.dbo.BanHang;


SELECT * 
FROM Thao_test..Banhang_new;



--- tìm hiểu: STRING_AGG, STRING_SPLIT ---

SELECT @@VERSION;






--- Lấy ra thông tin giao dịch có số tiền lớn nhất theo từng ngày và từng cửa hàng ---


----- ROW NUMBER -----:1-2-3  ~ Identity

SELECT A.* 
FROM 
	(
	SELECT  *,
			ROW_NUMBER () 
				OVER (PARTITION BY [ Store Id ],       --- PARTITION BY: tách all gtri Unique thành từng nhóm một, để sắp xếp (ORDER BY) theo từng nhóm riêng ---				 
									TRANS_DATE	
					  ORDER BY LCY_AMT DESC)  AS RN
	FROM Thao_test.dbo.BanHang
	) A
WHERE A.RN = 1;



----- DENSE_RANK -----:1-1-2

SELECT a.*,
	   a.CCY_CODE
FROM 
	(
	SELECT DENSE_RANK ()
				OVER (PARTITION BY [ Store Id ],
								   TRANS_DATE 
				ORDER BY LCY_AMT DESC) AS RN,
		   * 
	FROM Thao_test.dbo.BanHang
	) A
WHERE A.RN = 1;



----- RANK -----: 1-1-3

SELECT A.*
FROM 
	(
	SELECT RANK () 
				OVER (PARTITION BY [ Store Id ],
								   TRANS_DATE 
					  ORDER BY LCY_AMT DESC) AS RN,
		   * 
	FROM Thao_test.dbo.BanHang
	) A
WHERE A.RN = 1;


-- learn: lead, lag, first_value, last_value, min, sum, max --





---	Lấy ra khách có số tiền lớn nhất theo từng ngày và từng cửa hàng ---

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
			FROM Thao_test.dbo.BanHang
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
		FROM Thao_test.dbo.BanHang
		GROUP BY
			[ Store Id ],
			TRANS_DATE,
			CUS_ID
	)
SELECT *
FROM tbl_a 
WHERE RN =	1;






----- JOIN STATEMENT -----



DROP TABLE IF EXISTS Thao_test.dbo.A, Thao_test.dbo.B;

CREATE TABLE Thao_test.dbo.A 
	(
	MACN VARCHAR(50),
	AMOUNT FLOAT
	);


CREATE TABLE Thao_test.DBO.B 
	(
	MACN VARCHAR(50),
	HOAHONG FLOAT
	);



INSERT INTO Thao_test.dbo.A VALUES ('MM100110','20000000')
INSERT INTO Thao_test.dbo.A VALUES ('MM100111','10000000')
INSERT INTO Thao_test.dbo.A VALUES ('MM100112','30000000')

INSERT INTO Thao_test.dbo.B VALUES ('MM100110','50000')
INSERT INTO Thao_test.dbo.B VALUES ('MM100110','20000')
INSERT INTO Thao_test.dbo.B VALUES ('MM100112','40000')
INSERT INTO Thao_test.dbo.B VALUES ('MM100114','45000');

SELECT * FROM Thao_test.dbo.A;
SELECT * FROM Thao_test.dbo.B;


-- LEFT JOIN --
SELECT c.*, d.*
FROM Thao_test.DBO.A  AS C 
LEFT JOIN Thao_test.DBO.B AS D 
		  ON C.MACN = D.MACN;	                    --- thêm AND / OR để map nhiều cột khác nữa vẫn OK ---

	

-- INNER JOIN --
SELECT * 
FROM Thao_test.DBO.A AS  A 
INNER JOIN Thao_test.DBO.B AS B
		   ON A.MACN = B.MACN;                      --- thêm AND / OR để map nhiều cột khác nữa vẫn OK --- 



-- RIGHT JOIN --
SELECT * 
FROM Thao_test.DBO.A AS A 
RIGHT JOIN Thao_test.DBO.B B 
		   ON A.MACN = B.MACN;                      --- thêm AND / OR để map nhiều cột khác nữa vẫn OK ---



-- FULL OUTER JOIN --
SELECT * 
FROM Thao_test.DBO.A  AS A 
FULL OUTER JOIN	Thao_test.DBO.B AS B 
			    ON A.MACN = B.MACN;                 --- thêm AND / OR để map nhiều cột khác nữa vẫn OK ---



-- CROSS JOIN --
SELECT * 
FROM Thao_test.DBO.A A 
CROSS JOIN 	Thao_test.DBO.B B;                --- số rows = số cột bảng A x số cột bảng B ---




----- XỬ LÝ BẢNG DATA CUS BỊ DUP DỮ LIỆU INTO THÀNH 1 BẢNG MỚI CÓ TÊN LÀ CUSTOMER_NEW

DROP TABLE IF EXISTS Thao_test.DBO.CUSTOMER_NEW;
SELECT A.* 
INTO Thao_test.DBO.CUSTOMER_NEW
FROM
(	
	SELECT A.*
	FROM
	(
		SELECT 
				*,
				ROW_NUMBER() 
						OVER (PARTITION BY CUS_ID 
							  ORDER BY [ADDRESS] DESC) STT
		FROM 
			Thao_test.DBO.CUSTOMER
	) A
	WHERE STT = 1
) A;


-- Check How many Data is duplicated --

SELECT 
		CUS_ID,
		COUNT(*) AS COUNT
FROM Thao_test.DBO.CUSTOMER
GROUP BY
		CUS_ID
HAVING 
		COUNT(*) >= 2;



/* 
3. DEMO BAI TAP 
*/

SELECT TOP 10 * 
FROM Thao_test.dbo.BANHANG;

SELECT TOP 10 * 
FROM Thao_test.dbo.CUSTOMER;


----- Lấy ra mã cửa hàng, mã KH, email, tên KH trong mỗi giao dịch trên bảng bán hàng -----
 

--USE Thao_test;--
--SP_SPACEUSED 'BANHANG';--                           --- CHECK số Rows của 1 bảng ---


SELECT 
	A.[ Store Id ],
	A.CUS_ID,
	B.CUS_NAME,
	B.EMAIL
FROM Thao_test.dbo.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID;

--- Check dữ liệu Unique: ---

-- C1: --
SELECT 
		DISTINCT CUS_ID 
FROM Thao_test.DBO.CUSTOMER;

-- C2: --
SELECT 
		CUS_ID
FROM Thao_test.DBO.CUSTOMER
GROUP BY CUS_ID;




----- Lấy ra KH có giao dịch nhưng không có tên trong bảng Khách Hàng -----

SELECT 
		A.*,
		B.CUS_NAME
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
WHERE
		B.CUS_ID IS NULL;




----- Lấy ra KH có giao dịch và có tên trong bảng Khách Hàng -----

-- C1: --
SELECT 
		A.*,
		B.CUS_NAME
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
WHERE
		B.CUS_ID IS NOT NULL;


-- C2: --
SELECT 
		A.*,
		B.CUS_NAME
FROM Thao_test.DBO.BANHANG A 
INNER JOIN Thao_test.DBO.CUSTOMER_NEW B
		   ON A.CUS_ID = B.CUS_ID;



----- Lấy ra KH có thông tin nhưng không có giao dịch -----

-- C1: --
SELECT 
		B.CUS_NAME,
		A.*
FROM Thao_test.DBO.BANHANG A 
RIGHT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		   ON A.CUS_ID = B.CUS_ID
WHERE
		A.CUS_ID IS NULL;


-- C2: --
SELECT *
FROM Thao_test.DBO.CUSTOMER_NEW A 
LEFT JOIN Thao_test.DBO.BANHANG B 
		  ON A.CUS_ID = B.CUS_ID
WHERE
		B.CUS_ID IS NULL;




----- Chỉ lấy ra KH có thông tin và có giao dịch -----

SELECT 
		A.*,
		B.CUS_NAME
FROM Thao_test.DBO.BANHANG A 
INNER JOIN Thao_test.DBO.CUSTOMER_NEW B 
		   ON A.CUS_ID = B.CUS_ID;




----- Tính tổng số tiền theo từng KH có thông tin tên KH và địa chỉ KH -----

SELECT 
		A.CUS_ID,
		B.CUS_NAME,
		B.[ADDRESS],
		SUM(A.FCY_AMT) SOTIENNGUYENTE
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
GROUP BY
		A.CUS_ID,
		B.CUS_NAME,
		B.[ADDRESS];




----- Tính tổng số tiền theo từng KH có thông tin tên KH và địa chỉ, email KH -----

SELECT
		A.CUS_ID,
		B.CUS_NAME,
		B.EMAIL,
		B.ADDRESS,
		SUM(A.FCY_AMT) AS AMOUNT
FROM Thao_test.DBO.BANHANG A
INNER JOIN Thao_test.DBO.CUSTOMER_NEW B 
		   ON A.CUS_ID = B.CUS_ID
GROUP BY 
		A.CUS_ID,
		B.CUS_NAME,
		B.EMAIL,
		B.ADDRESS;




----- Tính tổng số tiền của từng KH theo từng ngày giao dịch và phân chia nhóm địa chỉ của KH như sau, đồng thời sắp xếp ASC theo ngày giao dịch -----
-----					An Giang, Bạc Liêu --> Miền Nam
-----					Hà Giang, Hà Nội --> Miền Bắc
-----					Còn lại --> miền Trung


SELECT 
		A.CUS_ID,
		CASE 
			WHEN B.Address IN ('AN GIANG', 'BẠC LIÊU') THEN 'MIENNAM'
			WHEN B.[ADDRESS] IN ('HÀ GIANG', 'HÀ NỘI') THEN 'MIENBAC'
		ELSE 'MIENTRUNG'
		END 'VUNGMIEN',
		TRANS_DATE,
		SUM(FCY_AMT) AMOUNT
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
WHERE 
		B.CUS_ID IS NOT NULL
GROUP BY 
		A.CUS_ID,
		CASE 
			WHEN B.[ADDRESS] IN ('AN GIANG', 'BẠC LIÊU') THEN 'MIENNAM'
			WHEN B.[ADDRESS] IN ('HÀ GIANG', 'HÀ NỘI') THEN 'MIENBAC'
		ELSE 'MIENTRUNG'
		END,
		A.TRANS_DATE
ORDER BY 
		A.TRANS_DATE;




----- Tính tổng số tiền theo từng vùng miền của KH theo 3 miền Bắc, Trung, Nam được giao dịch trong ngày 02-04-2019 -----
-----					Nếu ở An Giang, Bạc Liêu --> miền Nam
-----					Còn lại --> others


SELECT 
		A.CUS_ID,
		CASE 
			WHEN B.[ADDRESS] IN ('AN GIANG','BẠC LIÊU') THEN 'MIENNAM'
		ELSE 'OTHERS' 
		END [ADDRESS],
		SUM(A.FCY_AMT) AS AMOUNT
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
WHERE
		B.CUS_ID IS NOT NULL 
		AND A.TRANS_DATE = '2019-04-02' 
GROUP BY
		A.CUS_ID,
		CASE WHEN B.[ADDRESS] IN ('AN GIANG','BẠC LIÊU') THEN 'MIENNAM'
		ELSE 'OTHERS' 
		END; 
		



----- Lấy tổng số tiền quy đổi theo triệu đồng theo các nhân viên và nhóm theo năm vào công ty từ 2016-2019 nhưng hệ số lương từ 5-9, SOTIENQUYDOI DESC -----

SELECT 
		A.SALE_ID,
		A.SALE_NAME,
		DATEPART(YEAR, DATE_START) NGAYVAOCONGTY,
		SUM(LCY_AMT)/1e6 SOTIENQUYDOI
FROM Thao_test.DBO.BANHANG A 
LEFT JOIN Thao_test.DBO.STAFF B 
		  ON A.SALE_ID = B.SALE_ID
WHERE
		DATEPART(YEAR,DATE_START) >= 2016 AND 
		DATEPART(YEAR,DATE_START) <= 2019 AND
		B.COEFF_SALARY BETWEEN 5 AND 9
GROUP BY
		A.SALE_ID,
		A.SALE_NAME,
		DATEPART(YEAR,B.[DATE_START])
ORDER BY 
		4 DESC;								  --- lấy ra dòng Select thứ 4 để Order By ---




SELECT *
FROM Thao_test.INFORMATION_SCHEMA.TABLES;                             -- view Tables --        

SELECT *
FROM Thao_test.sys.tables                                             -- view detailed (ngày thêm / xóa / chỉnh sửa bảng) --
ORDER BY name;

-- sp.rename --






----- 1.Lấy tổng số tiền của nhân viên có giao dịch trong ngày 02-04-2019, thông tin nhân viên phải có đủ tên, ngày vào công ty hệ và hệ số lương -----

-- C1: --

SELECT
		A.SALE_ID,
		B.SALE_NAME,
		B.DATE_START,
		B.COEFF_SALARY,
		SUM(A.LCY_AMT)/1e6 AS AMOUNT
FROM Thao_test.dbo.BANHANG A 
INNER JOIN Thao_test.dbo.STAFF B 
			   ON A.SALE_ID = B.SALE_ID
WHERE 
		A.TRANS_DATE = '2019-04-02'
GROUP BY 
		A.SALE_ID,
		B.SALE_NAME,
		B.DATE_START,
		B.COEFF_SALARY;
		

-- C2: --  

SELECT
		A.SALE_ID,
		B.SALE_NAME,
		B.DATE_START,
		B.COEFF_SALARY,
		SUM(A.LCY_AMT)/1e6 AS AMOUNT
FROM Thao_test.dbo.BANHANG A 
LEFT JOIN Thao_test.dbo.STAFF B 
			   ON A.SALE_ID = B.SALE_ID
WHERE 
		A.TRANS_DATE = '2019-04-02'
		AND B.SALE_ID IS NOT NULL
GROUP BY 
		A.SALE_ID,
		B.SALE_NAME,
		B.DATE_START,
		B.COEFF_SALARY;


----- 2.Lấy tổng số tiền của nhân viên có giao dịch trong ngày 02-04-2019 và vào công ty năm 2019 -----

-- C1: --

SELECT
		A.SALE_ID,
		B.SALE_NAME,
		SUM(A.lcy_amt)/1e6 AS AMOUNT
FROM Thao_test.dbo.BANHANG A
INNER JOIN Thao_test.dbo.STAFF B 
		   ON A.SALE_ID = B.SALE_ID
WHERE 
		YEAR(B.DATE_START) = 2019 
		AND A.TRANS_DATE = '2019-04-02'
GROUP BY
		A.SALE_ID,
		B.SALE_NAME
ORDER BY 
		A.SALE_ID,
		AMOUNT desc;
	

-- C2: --

SELECT
		A.SALE_ID,
		B.SALE_NAME,
		SUM(A.lcy_amt)/1e6 AS AMOUNT
FROM Thao_test.dbo.BANHANG A
LEFT JOIN Thao_test.dbo.STAFF B 
		   ON A.SALE_ID = B.SALE_ID
WHERE 
		YEAR(B.DATE_START) = 2019 
		AND A.TRANS_DATE = '2019-04-02'
		AND A.SALE_ID IS NOT NULL
GROUP BY
		A.SALE_ID,
		B.SALE_NAME
ORDER BY 
		A.SALE_ID,
		AMOUNT desc;
		

----- 3.Lấy thông tin giao dịch có thông tin địa điểm cửa hàng, thông tin tên khách hàng -----

-- C1: --

SELECT
		A.CUS_ID,
		A.[ Store Id ],
		B.[Địa điểm],
		C.CUS_NAME
FROM Thao_test.dbo.BANHANG A
LEFT JOIN Thao_test.dbo.BRANCH B 
		  ON A.[ Store Id ] = B.[Mã cửa hàng]
LEFT JOIN Thao_test.dbo.CUSTOMER_NEW C 
		  ON A.CUS_ID = C.CUS_ID
WHERE
		B.[Địa điểm] IS NOT NULL 
		AND C.CUS_NAME IS NOT NULL;
		
-- C2: --

SELECT
		A.CUS_ID,
		A.[ Store Id ],
		B.[Địa điểm],
		C.CUS_NAME
FROM Thao_test.dbo.BANHANG A
INNER JOIN Thao_test.dbo.BRANCH B 
		  ON A.[ Store Id ] = B.[Mã cửa hàng]
INNER JOIN Thao_test.dbo.CUSTOMER_NEW C 
		  ON A.CUS_ID = C.CUS_ID;


----- 4.Lấy thông tin giao dịch có thông tin địa điểm của hàng, thông tin email và số điện thoại khách hàng, và tỷ giá tại ngày đó -----

use Thao_test;
SP_HELP 'EXCHANGE';


SELECT
		A.[ Store Id ],
		D.[Địa điểm],
		B.EMAIL,
		B.[Phone Num],
		A.CCY_CODE,
		ISNULL(C.Exchange,1)
FROM Thao_test.dbo.BANHANG A
LEFT JOIN Thao_test.dbo.CUSTOMER_NEW B 
		  ON A.CUS_ID = B.CUS_ID
LEFT JOIN Thao_test.dbo.EXCHANGE C 
		  ON A.CCY_CODE = C.Type 
			 AND CONVERT(VARCHAR(8),CAST(A.TRANS_DATE AS DATE),112) = CONVERT(VARCHAR(8),C.DATE,112)
LEFT JOIN Thao_test.dbo.BRANCH D 
		  ON A.[ Store Id ] = D.[Mã cửa hàng]
ORDER BY A.TRANS_DATE;



----- 5.Tạo ra bảng dữ liệu danh sách giao dịch trong tháng 4 năm 2019 -----

-- C1: --

DROP TABLE IF EXISTS Thao_test.dbo.banhang_201904;
SELECT * 
INTO Thao_test.dbo.banhang_201904
FROM Thao_test.dbo.BANHANG
WHERE TRANS_DATE LIKE '2019-04%';


-- C2: --

DROP TABLE IF EXISTS Thao_test.dbo.banhang_201904;
WITH ABC AS
		(SELECT * 
		 FROM Thao_test.dbo.BANHANG
		 WHERE TRANS_DATE LIKE '2019-04%')
SELECT *
INTO Thao_test.dbo.banhang_201904
FROM ABC;


----- 6.Tạo ra bảng dữ liệu danh sách giao dịch trong tháng 6 năm 2019 -----
	
-- C1: --

DROP TABLE IF EXISTS Thao_test.dbo.banhang_201906;
SELECT * 
INTO Thao_test.dbo.banhang_201906
FROM Thao_test.dbo.BANHANG
WHERE TRANS_DATE LIKE '2019-04%';


-- C2: --

DROP TABLE IF EXISTS Thao_test.dbo.banhang_201906;
WITH ABC AS
		(SELECT * 
		 FROM Thao_test.dbo.BANHANG
		 WHERE TRANS_DATE LIKE '2019-04%')
SELECT *
INTO Thao_test.dbo.banhang_201906
FROM ABC;


----- 7.Tìm những nhân viên có giao dịch trong tháng 4-2019 nhưng không giao dịch trong tháng 6 năm 2019 từ 2 bảng vừa được tạo trên -----

-- C1: --
	
SELECT A.SALE_ID
FROM Thao_test.dbo.banhang_201904 A
LEFT JOIN
		(SELECT  
				SALE_ID
		 FROM Thao_test.dbo.banhang_201906
		 GROUP BY												--- xử lý Duplicated Data ---
				SALE_ID) B ON A.SALE_ID = B.SALE_ID
WHERE 
		B.SALE_ID IS NULL
GROUP BY 
		A.SALE_ID
ORDER BY 
		A.SALE_ID;


-- C2: --
	
SELECT 
		SALE_ID
FROM Thao_test.dbo.banhang_201904
WHERE 
		SALE_ID NOT IN (SELECT 
								SALE_ID 
						FROM Thao_HW_5.dbo.banhang_201906)
GROUP BY 
		SALE_ID;


-- C3: --

SELECT
		A.SALE_ID
FROM Thao_test.dbo.banhang_201904 A 
WHERE
		NOT EXISTS 
				(SELECT
						B.* 
				 FROM Thao_test.dbo.banhang_201906 B 
				 WHERE
						A.SALE_ID = B.SALE_ID)
GROUP BY A.SALE_ID;


----- 8.Tìm danh sách khách hàng có mua hàng trong cả tháng 4 và tháng 6 từ 2 bảng vừa được tạo trên -----

-- C1: --

SELECT	
		A.CUS_ID,
		A.CUS_NAME
FROM Thao_test.dbo.banhang_201904 A
INNER JOIN
		(SELECT
				CUS_ID
		 FROM Thao_test.dbo.banhang_201906
		 GROUP BY															--- xử lý Duplicated Data ---
				CUS_ID) B ON A.CUS_ID = B.CUS_ID
GROUP BY 
		A.CUS_ID,
		A.CUS_NAME;


-- C2: --

SELECT	
		A.CUS_ID,
		A.CUS_NAME
FROM Thao_test.dbo.banhang_201904 A
LEFT JOIN
		(SELECT
				CUS_ID
		 FROM Thao_test.dbo.banhang_201906
		 GROUP BY 
				CUS_ID														--- xử lý Duplicated Data ---
		 ) B ON A.CUS_ID = B.CUS_ID
WHERE B.CUS_ID IS NOT NULL
GROUP BY 
		A.CUS_ID,
		A.CUS_NAME;


----- 9.Tìm danh sách khách hàng có mua hàng trong tháng 4 nhưng không mua trong tháng 6 và ngược lại  từ 2 bảng vừa được tạo trên -----

-- C1: --

SELECT   
		ISNULL(A.CUS_ID,B.CUS_ID) AS CUS_ID,                                --- coalesce = ISNULL, { ISNULL(X,Y), Coalesce(X,Y,Z...) }: X or Y or Z... ---
		coalesce(A.CUS_NAME,B.CUS_NAME) AS CUS_NAME
FROM Thao_test.dbo.banhang_201904 A
FULL OUTER JOIN
		(SELECT 
				CUS_ID,
				CUS_NAME
		 FROM Thao_test.dbo.banhang_201906 
		 GROUP BY
				CUS_ID,
				CUS_NAME
		 ) B ON A.CUS_ID = B.CUS_ID
WHERE 
		 A.CUS_ID IS NULL
		 OR B.CUS_ID IS NULL
GROUP BY
		ISNULL(A.CUS_ID,B.CUS_ID),
		coalesce(A.CUS_NAME,B.CUS_NAME);


-- C2: --
		
SELECT		
		DISTINCT A.CUS_ID,
		B.CUS_ID
FROM Thao_test.dbo.banhang_201904 A
FULL OUTER JOIN
		(SELECT 
				CUS_ID,
				CUS_NAME
		 FROM Thao_test.dbo.banhang_201906 
		 GROUP BY
				CUS_ID,
				CUS_NAME
		 ) B ON A.CUS_ID = B.CUS_ID
WHERE
		A.CUS_ID NOT IN
					(SELECT 
							A.CUS_ID
					 FROM Thao_test.dbo.banhang_201904
					 INNER JOIN
							Thao_test.dbo.banhang_201906
							ON A.CUS_ID = B.CUS_ID);
 

-- C3: --

SELECT
		A.CUS_ID,
		A.CUS_NAME
FROM Thao_test.dbo.banhang_201904 A
LEFT JOIN
		(SELECT
				CUS_ID,
				CUS_NAME
		 FROM Thao_test.dbo.banhang_201906
		 GROUP BY
				 CUS_ID,
				 CUS_NAME) B ON A.CUS_ID = B.CUS_ID
WHERE 
		B.CUS_ID IS NULL
GROUP BY 
		A.CUS_ID,
		A.CUS_NAME

UNION

SELECT
		A.CUS_ID,
		A.CUS_NAME
FROM Thao_test.dbo.banhang_201906 A
LEFT JOIN
		(SELECT
				CUS_ID,
				CUS_NAME
		 FROM Thao_test.dbo.banhang_201904
		 GROUP BY
				 CUS_ID,
				 CUS_NAME) B ON A.CUS_ID = B.CUS_ID
WHERE 
		B.CUS_ID IS NULL
GROUP BY 
		A.CUS_ID,
		A.CUS_NAME;


----- 10.So sánh số tiền giao dịch của từng nhân viên từ tháng 4 đến tháng 6 -----

SELECT
		ISNULL(A.SALE_ID,B.SALE_ID) AS SALE_ID,
		SUM(ISNULL(A.LCY_AMT,0)) AS AMT_201904,
		ISNULL(B.AMT_201906,0) AS AMT_201906,
		SUM(ISNULL(A.LCY_AMT,0)) - ISNULL(B.amt_201906,0) AS CHENHLECH
FROM Thao_test.dbo.banhang_201904 A
FULL OUTER JOIN
		(SELECT
					SALE_ID,
					SUM(LCY_AMT) AS AMT_201906
		 FROM Thao_test.dbo.banhang_201906
		 GROUP BY
				SALE_ID) B ON A.SALE_ID = B.SALE_ID
GROUP BY
		ISNULL(A.SALE_ID,B.SALE_ID),
		B.AMT_201906
ORDER BY
		SALE_ID;


--- check tiền tổng 2 tháng ---

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201904
	
UNION ALL

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201906;


--- có giao dịch trong cả 2 tháng ---

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201904 
WHERE
		SALE_ID = '000-00-0639'
		
UNION ALL 

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201906
WHERE
		SALE_ID = '000-00-0639';
		

--- chỉ có giao dịch trong T4, không có giao dịch trong T6 ---

SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201904
WHERE
		SALE_ID = '000-00-3915'

UNION ALL

SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201906
WHERE
		SALE_ID = '000-00-3915';
		

--- chỉ có giao dịch trong T6, không có giao dịch trong T4 ---

SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201906
WHERE
		SALE_ID = '000-00-7326'

UNION ALL

SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201904
WHERE
		SALE_ID = '000-00-7326';
		





/* LESS_7: PIVOT, UNPIVOT; KEY IN TABLE, VIEW */


----- 11.So sánh số tiền mua hàng của từng khách hàng trong tháng 4 và tháng 6 -----

SELECT
		ISNULL(A.CUS_ID,B.CUS_ID) AS CUS_ID,
		SUM(ISNULL(A.LCY_AMT,0)) AS AMT_201904,
		ISNULL(B.amt_201906,0) AS AMT_201906,
		SUM(ISNULL(A.LCY_AMT,0)) - ISNULL(B.AMT_201906,0) AS CHENHLECH
FROM Thao_test.dbo.banhang_201904 A
FULL OUTER JOIN	
			(SELECT
					CUS_ID,
					SUM(LCY_AMT) AS AMT_201906
			 FROM Thao_test.dbo.banhang_201906
			 GROUP BY
					CUS_ID) B ON A.CUS_ID = B.CUS_ID
GROUP BY
		ISNULL(a.cus_id,b.CUS_ID),
		B.AMT_201906
ORDER BY
		CUS_ID;


--- check số tiền tháng 4 và tháng 6 ---

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201904

UNION ALL

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201906;


--- có giao dịch trong cả 2 tháng ---

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201904 
WHERE
		CUS_ID = 'MKH123474'

UNION ALL

SELECT
		SUM(LCY_AMT) 
FROM Thao_test.dbo.banhang_201906 
WHERE
		CUS_ID = 'MKH123474';
	

--- chỉ có giao dịch trong tháng 4 ---

SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201904
WHERE
		CUS_ID = 'MKH124937';


SELECT
		SUM(LCY_AMT)
FROM Thao_test.dbo.banhang_201906
WHERE
		CUS_ID = 'MKH124937';
	

----- 12. tính tổng số tiền tăng ròng của tháng 6 với tháng 4 của từng quản lý cửa hàng -----

SELECT * 
FROM Thao_test.dbo.BRANCH;

SELECT * 
FROM Thao_test.dbo.banhang;


WITH tbl_06 AS
		(SELECT
				B.[Quản lý],
				SUM(A.LCY_AMT) AS TOTAL_201906
		 FROM Thao_test.dbo.banhang_201906 A
		 INNER JOIN Thao_test.dbo.BRANCH B 
					ON A.[ Store Id ] = B.[Mã cửa hàng]
		 GROUP BY
				B.[Quản lý])
SELECT
		ISNULL(C.[Quản lý],B.[Quản lý]) AS Manager,
		ISNULL(B.TOTAL_201906,0) AS TOTAL_201906,
		SUM(ISNULL(A.LCY_AMT,0)) as TOTAL_201904,
		SUM(ISNULL(A.LCY_AMT,0)) - ISNULL(B.TOTAL_201906,0) NET_MANAGER
FROM Thao_test.dbo.banhang_201904 A
INNER JOIN Thao_test.dbo.BRANCH C 
		   ON A.[ Store Id ] = C.[Mã cửa hàng]
FULL OUTER JOIN tbl_06 B
				ON C.[Quản lý] = B.[Quản lý]
GROUP BY
		ISNULL(C.[Quản lý],B.[Quản lý]),
		ISNULL(B.TOTAL_201906,0)
ORDER BY
		Manager;


----- 13.Lấy ra giao dịch có số tiền lớn nhất theo từng ngày và từng cửa hàng và xem chiếm tỷ trọng bao nhiêu so với tổng của cửa hàng đó trong các ngày đó -----

-- C1: --

WITH TBL_A AS
		(SELECT * 
		 FROM
					(SELECT
							[ Store Id ],
							TRANS_DATE,
							LCY_AMT,
							ROW_NUMBER () 
									OVER (PARTITION BY 
												[ Store Id ],
												TRANS_DATE 
										  ORDER BY 
											LCY_AMT DESC) AS RN
					 FROM Thao_test.dbo.BANHANG) A
		 WHERE
				A.RN = 1)

SELECT
		A.[ Store Id ],
		A.TRANS_DATE,
		B.LCY_AMT AS MAX_AMT,
		SUM(A.LCY_AMT) AS TOTAL_AMT,
		B.LCY_AMT / SUM(A.LCY_AMT) AS A_RATE
FROM Thao_test.dbo.BANHANG A
INNER JOIN TBL_A AS B
		   ON A.[ Store Id ] = B.[ Store Id ] 
		   AND A.TRANS_DATE = B.TRANS_DATE
GROUP BY
		A.[ Store Id ],
		A.TRANS_DATE,
		B.LCY_AMT
ORDER BY
		A.[ Store Id ];
		

-- C2: --

WITH MAX_AMT AS
		(SELECT
				[ Store Id ],
				TRANS_DATE,
				MAX(LCY_AMT) AS MAX_AMT
		 FROM Thao_test.dbo.BANHANG
		 GROUP BY
				[ Store Id ],
				TRANS_DATE)
SELECT
		A.[ Store Id ],
		A.TRANS_DATE,
		B.MAX_AMT,
		SUM(A.LCY_AMT) AS TOTAL_AMT,
		B.MAX_AMT / SUM(A.LCY_AMT) AS RATE
FROM Thao_test.dbo.BANHANG A
INNER JOIN MAX_AMT B
		   ON A.TRANS_DATE = B.TRANS_DATE 
		   AND A.[ Store Id ] = B.[ Store Id ]
GROUP BY
		A.[ Store Id ],
		A.TRANS_DATE,
		B.MAX_AMT
ORDER BY
		A.[ Store Id ],
		A.TRANS_DATE;


----- 14.Lấy ra số tiền giao dịch lớn nhất của từng nhân viên tại từng cửa hàng trong năm 2019 xem chiếm tỷ trọng bao nhiêu trên tổng giao dịch của nhân viên đó trong cửa hàng trong năm 2019 -----

SELECT
		A.SALE_ID,
		A.[ Store Id ],
		MAX(A.LCY_AMT) AS MAX_AMT,
		B.TOTAL_AMT,
		MAX(A.LCY_AMT) / B.TOTAL_AMT AS RATE
FROM Thao_test.dbo.banhang A
INNER JOIN
		(SELECT
				SALE_ID,
				[ Store Id ],
				SUM(LCY_AMT) AS TOTAL_AMT
		 FROM Thao_test.dbo.banhang
		 WHERE
				YEAR(trans_date) = 2019
		 GROUP BY
				SALE_ID,
				[ Store Id ]) B ON A.SALE_ID = B.SALE_ID 
								   AND A.[ Store Id ] = B.[ Store Id ]
WHERE
		YEAR(A.TRANS_DATE) = 2019
GROUP BY
		A.SALE_ID,
		A.[ Store Id ],
		B.TOTAL_AMT
ORDER BY
		A.SALE_ID,
		A.[ Store Id ];
		

----- 15.Tính tổng số tiền giao dịch của từng nhân viên với từng cửa hàng trong từng tháng năm 2019 xem chiếm tỷ trọng bao nhiêu trên tổng doanh thu của cửa hàng trong từng tháng đó -----

SELECT
		A.SALE_ID,
		A.[ Store Id ],
		MONTH(CAST(A.TRANS_DATE AS DATE)) AS MONTH_ID,
		SUM(A.LCY_AMT) AS SUM_AMT,
		B.TOTAL_AMT,
		SUM(A.LCY_AMT) / B.TOTAL_AMT
FROM Thao_test.dbo.banhang A
INNER JOIN
		(SELECT
				[ Store Id ],
				MONTH(CAST(TRANS_DATE AS DATE)) MONTH_ID,
				SUM(LCY_AMT) AS TOTAL_AMT
		 FROM Thao_test.dbo.banhang
		 WHERE 
				YEAR(CAST(TRANS_DATE AS DATE)) = 2019
		 GROUP BY
				[ Store Id ],
				MONTH(CAST(TRANS_DATE AS DATE))) B ON A.[ Store Id ] = B.[ Store Id ] 
													  AND MONTH(CAST(A.TRANS_DATE AS DATE)) = B.MONTH_ID
WHERE
		YEAR(A.TRANS_DATE) = 2019
GROUP BY
		A.SALE_ID,
		A.[ Store Id ],
		MONTH(CAST(A.TRANS_DATE AS DATE)),
		B.TOTAL_AMT
ORDER BY
		A.SALE_ID,
		MONTH_ID,
		A.[ Store Id ];
	

----- 16.Update bảng Discount cột MucChietKhau = 0.01 nếu MucToiThieu từ 0 > 5, MucChietKhau = 0.02 nếu MucToiThieu từ 6 > 10, MucChietKhau = 0.03 nếu MucToiThieu từ 11 > 30 còn lại mức chiết khấu là 0.05 -----
----- 17.Update bảng Customer_New cột STT = 1 nếu Sex = 'MS', STT = 2 nếu Sex = 'MR' còn lại là STT = 3 -----


-- xóa cột --

ALTER TABLE THAO_TEST..CUSTOMER_NEW
DROP COLUMN STT;

-- thêm cột --

ALTER TABLE THAO_TEST..CUSTOMER_NEW
ADD STT INT;

ALTER TABLE THAO_TEST..CUSTOMER_NEW
ALTER COLUMN  STT VARCHAR(1);											--- đổi kiểu dữ liệu của 1 cột ---

-- update cột --

UPDATE THAO_TEST..CUSTOMER_NEW
SET CUSTOMER_NEW.STT = (CASE 
								WHEN CUSTOMER_NEW.Sex = 'MS' THEN 1
								WHEN CUSTOMER_NEW.Sex = 'MR' THEN 2
								ELSE 3
								END);


--- tính tiền t2=t1+t2, t3=t1+2+3,... ---

-- C1: --

WITH tbl_a AS
			(SELECT
					[ Store Id ],
					CONVERT(VARCHAR(6), CAST(TRANS_DATE AS DATE),112) AS MONTH_ID,
					SUM(LCY_AMT) / 1e6 AS AMOUNT
			 FROM Thao_test.dbo.BANHANG
			 WHERE
					YEAR(TRANS_DATE) = 2019
			 GROUP BY
					[ Store Id ],
					CONVERT(VARCHAR(6), CAST(TRANS_DATE AS DATE),112))
SELECT 
		*,
		SUM(AMOUNT)																	--- sdung: ( SUM...PARTITION ): SUM gtri Current với những gtri trước đó ---
				OVER(PARTITION BY [ Store Id ]										--- tham khảo thêm: ( MAX...PARTITION ) & ( MIN...PARTITION ) ... ---
					ORDER BY
							MONTH_ID,
							[ Store Id ] ASC) AS TONG_TIEN
FROM tbl_a
ORDER BY
		[ Store Id ],
		MONTH_ID;
		
		
-- C2: --

--- join bất đối xứng: ( >,<,>=,<= ) ---

WITH tbl_a AS
			(SELECT
					[ Store Id ],
					CONVERT(VARCHAR(6), CAST(TRANS_DATE AS DATE),112) AS MONTH_ID,
					SUM(LCY_AMT) / 1e6 AS AMOUNT
			 FROM Thao_test.dbo.BANHANG
			 WHERE 
					YEAR(TRANS_DATE) = 2019
			 GROUP BY
					[ Store Id ],
					CONVERT(VARCHAR(6), CAST(TRANS_DATE AS DATE),112))
SELECT 
		A.[ Store Id ],
		A.MONTH_ID, 
		SUM(B.AMOUNT) AS TONG_TIEN
FROM tbl_a A
INNER JOIN tbl_a B															--- self_join: 1 bảng tự Join chính bảng đó ---
		   ON A.[ Store Id ] = B.[ Store Id ] 
		   AND A.MONTH_ID >= B.MONTH_ID
GROUP BY
		A.[ Store Id ],
		A.MONTH_ID
ORDER BY
		[ Store Id ], 
		MONTH_ID;






--- PIVOT & UNPIVOT ( PIVOT: đưa dữ liệu từ chiều dọc sang chiều ngang, UNPIVOT: ngược lại ) ---

-- PIVOT --

DROP TABLE IF EXISTS ##B;
DROP TABLE IF EXISTS ##A;

SELECT PIV.*
INTO ##A
FROM
		(SELECT
				[ Store Id ],
				MONTH(CAST(TRANS_DATE AS DATE)) AS MONTH_ID,
				LCY_AMT
		 FROM Thao_test.DBO.BANHANG
		 WHERE 
				DATEPART(YY,TRANS_DATE) = '2019') SRC 
PIVOT 
		(SUM(LCY_AMT)
		 FOR [ Store Id ] IN ([STORE 1],[STORE 2],[STORE 3],[STORE 4],[STORE 5])) PIV;


SELECT PIV.*
INTO ##B
FROM
		(SELECT
				[ Store Id ],
				MONTH(CAST(TRANS_DATE AS DATE)) AS MONTH_ID,
				LCY_AMT
		 FROM Thao_test.DBO.BANHANG
		 WHERE 
				DATEPART(YY,TRANS_DATE) = '2019') SRC 
PIVOT 
		(SUM(LCY_AMT)
		 FOR MONTH_ID IN ([1],[2],[3],[4],[5])) PIV;


SELECT 
		[ Store Id ],
		MONTH(TRANS_DATE),
		SUM(LCY_AMT)
FROM Thao_test..BANHANG
WHERE
		[ Store Id ] = 'STORE 1' 
		and YEAR(TRANS_DATE) = '2019'
GROUP BY
		[ Store Id ],
		MONTH(TRANS_DATE)
ORDER BY 2;


-- UNPIVOT --

SELECT * 
FROM
		(SELECT * 
		 FROM ##A) AS SRC
UNPIVOT
		(LCY_AMT											--- LCY_AMT & [ Store Id ] trong UNPIVOT có thể đổi thành tên tùy ý, trong PIVOT thì không được đổi ---
		 FOR [ Store Id ] IN ([STORE 1], [STORE 2], [STORE 3], [STORE 4], [STORE 5])
		) AS UNPIV
ORDER BY MONTH_ID;






--- PIVOT & UNPIVOT ĐỘNG ---

-- PIVOT ĐỘNG --


DECLARE @P_NAME VARCHAR(MAX) = '';
SELECT
		@P_NAME = @P_NAME + QUOTENAME ([ Store Id ]) + ','
FROM Thao_test.DBO.BANHANG
WHERE 
		[ Store Id ] IN ('STORE 1','STORE 2','STORE 3','STORE 4','STORE 5','STORE 6')
GROUP BY 
		[ Store Id ]
ORDER BY 
		[ Store Id ];


SET @P_NAME = LEFT(@P_NAME, LEN(@P_NAME)-1)
--PRINT @P_NAME
BEGIN
		EXEC	
			('DROP TABLE IF EXISTS TEST_SQL.DBO.TBL_PIVOT;
				SELECT *
				INTO TEST_SQL.DBO.TBL_PIVOT
				FROM
				(
					SELECT
						STOREDID
						,MONTH(TRANS_DATE) AS MONTH_ID
						,LCY_AMT
					FROM TEST_SQL.DBO.BANHANG
					WHERE DATEPART(YY,TRANS_DATE) = ''2019''
				) SRC 
				PIVOT 
				(
					SUM(LCY_AMT) 
					FOR STOREDID IN ('+@P_NAME+')
				) PIV
				ORDER BY 1
			')
	END

go;

select * from Thao_test.DBO.TBL_PIVOT
--UNPIVOT DỘNG


DECLARE @P_NAME VARCHAR(MAX) = '';

SELECT @P_NAME = @P_NAME + QUOTENAME (COLUMN_NAME) + ','
FROM TEST_SQL.INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'TBL_PIVOT' AND
	COLUMN_NAME LIKE 'STORE%'
ORDER BY ORDINAL_POSITION
;
SET @P_NAME = LEFT(@P_NAME, LEN(@P_NAME)-1);

	BEGIN
		EXEC
			('
				SELECT * FROM
					(
					SELECT * FROM TEST_SQL.DBO.TBL_PIVOT
					) AS SRC
				UNPIVOT
				(LCY_AMT  FOR STORE_ID IN ('+ @P_NAME +')
				) AS UNPIV
				ORDER BY MONTH_ID;
			')
	END
	;


----- 4.Đưa ra kết quả kinh doanh theo 12 tháng của cửa hàng STORE 1 trong năm 2019, mỗi tháng là 1 cột trên bảng kết quả -----

SELECT * 
FROM
		(SELECT 
				[ Store Id ],
				MONTH(TRANS_DATE) AS THANG,
				LCY_AMT AS TOTAL
		 FROM Thao_test..BANHANG
		 WHERE 
				YEAR(TRANS_DATE) = '2019' 
				AND [ Store Id ] = 'STORE 1') SRC 
PIVOT
		(SUM(TOTAL) 
		 FOR THANG IN ([1], [2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) PIV
ORDER BY 1;






--- TẠO BẢNG VỚI KHÓA CHÍNH ( PRIMARY KEY ) ---

DROP TABLE IF EXISTS Thao_test..CUSTOMERS_PK;

SELECT * 
FROM Thao_test.dbo.CUSTOMER_NEW;


--- TẠO BẢNG CUSTOMERS_PK VỚI KHÓA CHÍNH ---

-- C1: --

CREATE TABLE Thao_test..CUSTOMERS_PK 
		(
			ID INT PRIMARY KEY ,
			[NAME] VARCHAR(20) NOT NULL,
			AGE  INT,
			[ADDRESS] VARCHAR(25), 
			SALARY FLOAT
		);


-- C2: --

DROP TABLE IF EXISTS Thao_test..CUSTOMERS_PK;
CREATE TABLE Thao_test..CUSTOMERS_PK 
		(
			ID INT,
			[NAME] VARCHAR(20) NOT NULL,
			AGE INT,
			[ADDRESS] VARCHAR(25), 
			SALARY FLOAT,
			CONSTRAINT PK_CUS PRIMARY KEY (ID)								--- tạo được tên Keys là PK_CUS ---
		);


--- DROP PRIMARY KEY ---

ALTER TABLE Thao_test..CUSTOMERS_PK
DROP CONSTRAINT PK_CUS;													


--- CREATE PRIMARY KEY ---

ALTER TABLE Thao_test..CUSTOMERS_PK
ADD CONSTRAINT PK_CUSS PRIMARY KEY (ID,[NAME]);								--- tạo được tên Keys là PK_CUSS ---

ALTER TABLE Thao_test..CUSTOMERS_PK
DROP CONSTRAINT PK_CUSS;													--- xóa tên Keys là PK_CUSS ---

ALTER TABLE Thao_test..CUSTOMERS_PK 
ADD CONSTRAINT PK_CUS PRIMARY KEY (ID);






-- ( PRIMARY KEY ) không được Duplicated hoặc NULL --

INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'HA ANH 1', 32, 'DA NANG', 2000.00 );
INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, 'HA ANH 2', 33, 'DA NANG', 3000.00);


SELECT * 
FROM Thao_test..CUSTOMERS_PK;

--INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, 'HA ANH 3', 25, 'HA NOI', 1500.00);		
--INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (NULL, 'VAN HA', 25, 'HA NOI', 1500.00 );

----> 2 dòng Insert trên không thỏa mãn vì giá trị ( PRIMARY KEY ) không được Duplicated hoặc NULL






DROP TABLE IF EXISTS Thao_test.DBO.CUSTOMERS_PK;
CREATE TABLE Thao_test.DBO.CUSTOMERS_PK 
		(
			ID INT ,
			NAME VARCHAR (20),
			AGE INT,
			[ADDRESS] CHAR (25),
			SALARY FLOAT,
			CONSTRAINT PK_CUS PRIMARY KEY (ID,[NAME])							--- 2 Primary keys ---
		);


INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'HA ANH 1', 32, 'DA NANG', 2000.00 );
INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'HA ANH 2', 33, 'DA NANG', 3000.00);

----> ID bị dup dữ liệu nhưng Name không bị dup, do đó cặp Keys(ID,Name) vẫn là Unique


SELECT * 
FROM Thao_test.dbo.CUSTOMERS_PK;

INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, 'HA ANH 13', 25, 'HA NOI', 1500.00);
--INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (NULL, 'VAN HA', 25, 'HA NOI', 1500.00 );
----> (ID,[NAME]), ID bị NULL nên không chạy được
--INSERT INTO Thao_test..CUSTOMERS_PK (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'HA ANH 2', 33, 'DA NANG', 3000.00);
----> (ID,[NAME]) cặp Keys bị Dup nên không chạy được


SELECT * 
FROM Thao_test.DBO.CUSTOMERS_PK;


--- TẠO BẢNG VỚI KHÓA NGOẠI ( FOREIGN KEY ) ---

DROP TABLE IF EXISTS Thao_test.DBO.PERSONS, Thao_test.DBO.Orders;
CREATE TABLE Thao_test.DBO.PERSONS
		(
			PERSONID INT PRIMARY KEY,
			LASTNAME VARCHAR(255),
			FIRSTNAME VARCHAR(255),
			AGE INT DEFAULT 3
		);

CREATE TABLE Thao_test..ORDERS 
		(
			ORDERID INT,
			ORDERNUMBER INT,
			PERSONID INT,
			PRIMARY KEY (ORDERID),
			FOREIGN KEY (PERSONID) REFERENCES Thao_test.dbo.PERSONS(PERSONID)
		);

ALTER TABLE Thao_test.DBO.ORDERS
DROP CONSTRAINT [FK__ORDERS__PERSONID__32AB8735];


ALTER TABLE Thao_test.DBO.ORDERS
ADD CONSTRAINT FK_ID															--- tạo được tên Keys là FK_ID cho Foreign Key ---
FOREIGN KEY (PERSONID)
REFERENCES Thao_test.dbo.PERSONS(PERSONID);


INSERT INTO Thao_test..PERSONS VALUES (1,'HANSEN','OLA',30);
INSERT INTO Thao_test..PERSONS VALUES (2,'SVENDSON','TOVE',23);
INSERT INTO Thao_test..PERSONS VALUES (3,'PETTERSEN','KARI',20);

INSERT INTO Thao_test..ORDERS VALUES (1,77895,3);
INSERT INTO Thao_test..ORDERS VALUES (2,44678,3);
INSERT INTO Thao_test..ORDERS VALUES (3,22456,2);
INSERT INTO Thao_test..ORDERS VALUES (4,24562,1);

--INSERT INTO Thao_test..ORDERS VALUES (5,24572,4);
----> Foreign Key ở bảng (..ORDERS) phải khớp và có values tại cột Primary Key ở trong bảng khác (..PERSONS )


SELECT * 
FROM Thao_test.dbo.PERSONS;

SELECT * 
FROM Thao_test..ORDERS ;






--- NULL & NOT NULL ---

DROP TABLE Thao_test..ORDERS;
DROP TABLE IF EXISTS Thao_test..PERSONS;

CREATE TABLE Thao_test..PERSONS
		(
			ID INT NOT NULL ,
			LASTNAME VARCHAR(255)  NOT NULL,			--- Not Null: không được Null, không ghi gì: có thể Null or không ---
			FIRSTNAME VARCHAR(255) NOT NULL,
			AGE INT 
		);

ALTER TABLE Thao_test..PERSONS
ALTER COLUMN LASTNAME varchar(255)  NULL;		--- nếu LASTNAME ở Create Table đang để Not Null mà muốn chuyển sang có thể Null thì phải đặt lệnh = 2 dòng này ---

INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',18);
--INSERT INTO Thao_test..PERSONS VALUES (1,'A',NULL,18);
----> FIRSTNAME không được NULL
INSERT INTO Thao_test..PERSONS VALUES (1,NULL ,'B',18);

SELECT * 
FROM Thao_test.dbo.PERSONS;


--- Giá trị DEFAULT ---

DROP TABLE IF EXISTS Thao_test..PERSONS;

CREATE TABLE Thao_test..PERSONS 
		(
			ID INT ,
			LASTNAME VARCHAR(255) NOT NULL,
			FIRSTNAME VARCHAR(255) NOT NULL,
			AGE INT DEFAULT 3						--- DEFAULT là giá trị mặc định, nếu điền Null thì là Null, không điền thì máy tự điền giá trị DEFAULT ---						
		);

INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',18)
INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',null)
INSERT INTO Thao_test..PERSONS(id,LASTNAME,FIRSTNAME) VALUES (1,'A','B');

SELECT * 
FROM Thao_test.dbo.PERSONS;


--- CONSTRAINT...CHECK(): ràng buộc có điều kiện ---

DROP TABLE IF EXISTS Thao_test..PERSONS;

CREATE TABLE Thao_test..PERSONS 
		(
			ID INT ,
			LASTNAME VARCHAR(255) NOT NULL,
			FIRSTNAME VARCHAR(255) NOT NULL,
			AGE INT
		);

-- thêm ràng buộc --												   --- trong ràng buộc >= 18, điền gtri NULL vẫn được ---

ALTER TABLE Thao_test..PERSONS
ADD CONSTRAINT check_age CHECK(AGE >= 18);

INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',19);
--INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',1);
----> AGE phải >= 18
INSERT INTO Thao_test..PERSONS VALUES (1,'A','B',null);

SELECT * 
FROM Thao_test.dbo.PERSONS;


-- xóa ràng buộc --

ALTER TABLE Thao_test..PERSONS
DROP CONSTRAINT check_age											--- gọi tên ràng buộc để DROP ---






----- VIEW TRONG SQL: tạo bảng View cho Users xem -----

DROP TABLE IF EXISTS Thao_test..CUSTOMERS_VW;

CREATE TABLE Thao_test..CUSTOMERS_VW 
		(
		 ID INT,
		 NAME VARCHAR (20),
		 AGE  INT,
		 [ADDRESS] CHAR (25),
		 SALARY FLOAT,
		 PRIMARY KEY (ID)
		);

INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'HA ANH', 32, 'DA NANG', 2000.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, 'VAN HA', 25, 'HA NOI', 1500.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (3, 'VU BANG', 23, 'VINH', 2000.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (4, 'THU MINH', 25, 'HA NOI', 6500.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (5, 'HAI AN', 27, 'HA NOI', 8500.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (6, 'HOANG', 22, 'HA NOI', 4500.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (7, 'BINH', 24, 'HA NOI', 10000.00 );
INSERT INTO Thao_test..CUSTOMERS_VW (ID,NAME,AGE,ADDRESS,SALARY) VALUES (8, 'BINH', 24, 'HA NOI', 10000.00 );

USE Thao_test;


DROP VIEW IF EXISTS CUSTOMERS_VIEW;

CREATE VIEW CUSTOMERS_VIEW 
AS
	SELECT 
			ID,
			NAME,
			AGE,
			ADDRESS,
			SALARY
	FROM Thao_test.dbo.CUSTOMERS_VW
	WHERE ID > 5;


SELECT * 
FROM CUSTOMERS_VIEW;


-- tạo 1 User mới --

CREATE LOGIN ABCXY
WITH PASSWORD = '123456a@';


-- add thêm quyền cho User --

GRANT SELECT ON Thao_test.dbo.CUSTOMERS_VW(ID,NAME,AGE,ADDRESS) to ABCXY;


-- thu hồi quyền từ 1 User đã được phân quyền trước đó --

REVOKE SELECT ON Thao_test.dbo.CUSTOMERS_VW FROM ABCXY;






-- DELETE VIEW --

DELETE FROM CUSTOMERS_VIEW;
SELECT * 
FROM Thao_test..CUSTOMERS_VW;				--- Delete VIEW thì bảng chính cũng bị Delete số Rows như VIEW ---


-- DELETE BẢNG CHÍNH --

DELETE FROM Thao_test..CUSTOMERS_VW;
SELECT * 
FROM CUSTOMERS_VIEW;						--- Delete bảng chính thì dữ liệu VIEW cũng bị xóa ---


INSERT INTO Thao_test..CUSTOMERS_VW(ID, NAME, AGE) VALUES(104, 'TEST', NULL);
INSERT INTO CUSTOMERS_VIEW(ID, NAME, AGE) VALUES(204, 'TEST', NULL);
UPDATE CUSTOMERS_VIEW 
SET AGE = 100 
WHERE NAME = 'TEST';
----> Delete / Insert / Update với (bảng VIEW / bảng chính) thì bảng còn lại cũng tự Delete / Insert / Update
----> Tuy nhiên nếu trong bảng VIEW được tạo có chứa Order BY / Group By / Sum... thì việc Delete / Insert / Update của bảng VIEW & bảng chính sẽ không a/h tới nhau


SELECT * 
FROM CUSTOMERS_VIEW;

SELECT * 
FROM Thao_test..CUSTOMERS_VW;














-- câu điều kiện if trong sql

IF (
	SELECT COUNT(*) FROM TEST_SQL.DBO.BANHANG
	WHERE CUS_ID = 'MKH648538'
	)
	> 0
	BEGIN
		PRINT 'KH CO GIAO DICH'
	END
ELSE
	BEGIN
		PRINT 'KH KHONG CO GIAO DICH'
	END
	;

-----	Bài tập

---Tạo các câu lệnh có thể tự động upload file Bán Hàng.csv lên SQL----
---Thỏa mãn các điều kiện sau------
---1. Nếu bảng bán hàng đã có thì phải tự động xóa đi và tạo lại. Chưa có thì tạo mới---------
---2. Kiểm tra dữ liệu sau khi up lên nếu tổng số dòng dữ liệu = 0 thì in ra lỗi như sau. 
-----"Kiểm tra lại dữ liệu trong file excel ban hang"---------
--ngược lại " data import thành công"


--1 Kiểm tra bảng bán hàng có không. Nếu có thì xóa đi
If exists
(
	Select *
	from Test_SQL.information_schema.tables
	where
		table_type = 'BASE TABLE' AND
		table_name = 'tbl_transaction'
)
begin 
	drop table TEST_SQL.dbo.tbl_transaction;
end
;

select * from TEST_SQL.sys.tables;

select object_id('tbl_transaction');

select object_name(1362103893)


--if not exists (select * from TEST_SQL.sys.objects where name = 'BANHANG' and type  = 'U')
--	begin
--		print 'a'
--	end
--else 
--	begin
--		print 'b'
--	end
	;

--2 Tạo bảng bán hàng.
CREATE TABLE TEST_SQL.DBO.tbl_transaction ---> CREATE DDL TABLE
(
	STOREDID VARCHAR(30),
	TRANS_DATE DATE,
	SALE_NAME NVARCHAR(255) ,
	SALE_ID VARCHAR(50),
	SALE_ADDRESS NVARCHAR(255) ,
	CUS_NAME NVARCHAR(255) ,
	CUS_ID VARCHAR(255) ,
	RETAIL_BILL VARCHAR(50) ,
	TOTAL_BILL VARCHAR(50) ,
	CCY_CODE VARCHAR(10) ,
	PRODCUCT_NAME NVARCHAR(255),
	UNIT_PRICE FLOAT,
	TRANS_TYPE VARCHAR(3),
	FCY_AMT FLOAT,
	LCY_AMT FLOAT,
	COMMISSION FLOAT,
	SALE_OFF FLOAT ,
	CHAMTRA FLOAT,
	MAT_DATE DATE,
	CUS_TYPE INT 
)
--3 Đưa dữ liệu từ file excel vào bảng bán hàng
BULK INSERT TEST_SQL.DBO.tbl_transaction
FROM 'D:\2. SQL TRAINING\LESSON 1\LESSION1-DATA.CSV'
	WITH 
	(
		FIRSTROW = 2,----LẤY DỮ LIỆU TỪ FILE EXCEL BẮT ĐẦU TỪ DÒNG THỨ 2
		FIELDTERMINATOR = ',', ---- NGĂN CÁCH GIỮA CÁC CỘT BỞI DẤU TAB,PHẨY-----
		ROWTERMINATOR = '\n'
	)

--4 Kiểm tra dữ liệu trong bảng bán hàng
if not exists (select 1 from  Test_SQL..Banhang)
--If (select count(*) from Test_SQL..Banhang) = 0
	begin 
		print 'Kiểm tra lại dữ liệu trong file excel bán hàng'
	end
	else
	begin
		print 'import data successfully'
	end	
	;


---Tạo các câu lệnh có thể tự động upload file Khách hàng.csv lên SQL----
---Thỏa mãn các điều kiện sau------
---1. Nếu bảng khách hàng đã có thì phải tự động xóa đi và tạo lại---------
---2. Xóa đi các dòng dữ liệu trùng mã khách hàng của file khách hàng.
---3. Kiểm tra dữ liệu sau khi up lên nếu tổng số dòng dữ liệu = 0 thì in ra lỗi như sau. "Kiểm tra lại dữ liệu trong file excel ban hang"---------
---4. Kiểm tra dữ liệu sau khi up lên nếu bị trùng mã khách hàng thì in ra lỗi như sau. "Kiểm tra lại dữ liệu trong file excel ban hang"---------

--b1: check nếu tồn tại xóa bảng cũ và tạo lại bảng 


If exists
(
	select * from TEST_SQL.sys.tables where name = 'customer_import'
)
begin 
	drop table Test_SQL.dbo.customer_import;
end
;
Create table Test_SQL.dbo.customer_import
(
	MaKH NVARCHAR(50),
	TenKH nvarchar (50),
	[Address] nvarchar (50),
	Sex nvarchar(50),
	Company nvarchar(50),
	email nvarchar(100),
	Phone varchar(20)
)

--import data to customer_import
BULK insert Test_SQL.dbo.customer_import
from 'D:\2. SQL Training\Lesson 8\customer.csv'
with 
	(
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001'
	)
	;

--b2: 

with tbl_a AS
	(
		Select 
		ROW_NUMBER() OVER(Partition by MaKH order by [Address] desc) as rn, *
		from Test_SQL.dbo.customer_import
	)

delete from tbl_a
where rn > 1;

--check data bảng import
if not exists (select * from TEST_SQL.dbo.customer_import)
begin 
	print 'Kiểm tra lại dữ liệu trong file excel khách hàng'
end
ELSE
begin
	print 'import data successfully'
end
;

-- kiểm tra dữ lệu bị dupplicate
if exists
(
	select
		MaKH,
		count(*) as sl
	from TEST_SQL.dbo.customer_import
	group by
		MaKH
	having count(*) > 1
)
begin 
	print 'Kiểm tra lại dữ liệu trong file excel khách hàng'
end
ELSE
	print 'data customer is ready'
;

---Tạo các câu lệnh có thể tự động upload file Bán Hàng.csv, KhachHang.CSV, TyGia.csv lên SQL----
---Thỏa mãn các điều kiện sau------
---1. Nếu các bảng đã có thì phải tự động xóa đi và tạo lại. Chưa có thì tạo mới---------
---2. Kiểm tra dữ liệu sau khi up lên nếu số dòng dữ liệu trong bất kì bảng nào = 0 thì in ra lỗi như sau. "Kiểm tra lại dữ liệu trong file excel"---------
---3. Thêm dữ liệu tỷ giá và thông tin khách hàng vào bảng bán hàng --------

---- 1. Kiểm tra bảng có chưa


if exists
(
	select *
	from TEST_SQL.information_schema.tables
	where
		table_type = 'BASE TABLE' AND
		table_name = 'transaction_temp'
)
begin
	drop table TEST_SQL.dbo.transaction_temp
end
;
if exists
(
	Select *
	from Test_SQL.information_schema.tables
	where
		table_type = 'BASE TABLE' AND
		table_name = 'exchange_import'
)
begin
	drop table TEST_SQL.dbo.exchange_import
end
;
if exists
(
	Select *
	from Test_SQL.information_schema.tables
	where
		table_type = 'BASE TABLE' AND
		table_name = 'customer_import'
)
begin
	drop table TEST_SQL.dbo.customer_import
end
----- 2. Tao ra bang moi

create table TEST_SQL.dbo.transaction_temp
	(
		STOREDID VARCHAR(30),
		TRANS_DATE DATE,
		SALE_NAME NVARCHAR(255) ,
		SALE_ID VARCHAR(50),
		SALE_ADDRESS NVARCHAR(255) ,
		CUS_NAME NVARCHAR(255) ,
		CUS_ID VARCHAR(255) ,
		RETAIL_BILL VARCHAR(50) ,
		TOTAL_BILL VARCHAR(50) ,
		CCY_CODE VARCHAR(10) ,
		PRODCUCT_NAME NVARCHAR(255),
		UNIT_PRICE FLOAT,
		TRANS_TYPE VARCHAR(3),
		FCY_AMT FLOAT,
		LCY_AMT FLOAT,
		COMMISSION FLOAT,
		SALE_OFF FLOAT ,
		CHAMTRA FLOAT,
		MAT_DATE DATE,
		CUS_TYPE INT 
)
;
create table TEST_SQL.dbo.exchange_import
	(
		Ngay date, 
		LoaiTien nvarchar(10),
		TyGia float
	)
	;
Create table Test_SQL.dbo.customer_import
(
	MaKH NVARCHAR(50),
	TenKH nvarchar (50),
	[Address] nvarchar (50),
	Sex nvarchar(50),
	Company nvarchar(50),
	email nvarchar(100),
	Phone varchar(20)
)
;


----3. Upload du lieu tu file csv

bulk insert TEST_SQL..transaction_temp
from 'D:\2. SQL Training\Lesson 8\txn_import.csv'
with 
	(
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n'
	)

bulk insert TEST_SQL.dbo.exchange_import
from 'D:\2. SQL Training\Lesson 8\exchange.csv'
with 
	(
		firstrow = 2,
		fieldterminator = ',',
		rowterminator = '\n',
		codepage = '65001'
	);

--Bước 4: kiểm tra upload thành công

If not exists (select 1 from TEST_SQL.dbo.transaction_import)
begin 
	print N'Kiểm tra lại dữ liệu trong file excel txn_import.csv'
end
else
begin
	print N'data transaction is ready'
end
;

If not exists (select 1 from TEST_SQL.dbo.exchange_import)
begin 
	print N'Kiểm tra lại dữ liệu trong file excel exchange.csv'
end
else
begin
	print N'data exchange rate is ready'
end
;

If not exists (select 1 from TEST_SQL.dbo.customer_import)
begin 
	print N'Kiểm tra lại dữ liệu trong file excel khachhang.csv'
end
else
begin
	print N'data khachhang rate is ready'
end
;;


--3. đẩy dữ liệu từ bảng temp vào bảng chính sau khi lấy thêm tỷ giá và thông tin Kh

if exists (select 1 from TEST_SQL.sys.tables where name = 'transaction_import')
	begin
		drop table TEST_SQL.dbo.transaction_import
	end
--join với tỷ giá và thông tin Kh
	select
		a.*,
		isnull(b.TyGia,1) as EXCHANGE_RATE,
		c.Company,
		c.email,
		c.TenKH,
		c.Phone
	into TEST_SQL.dbo.transaction_import
	from TEST_SQL.dbo.transaction_temp a
	left join TEST_SQL.dbo.exchange_import b 
		on a.CCY_CODE = b.LoaiTien and a.TRANS_DATE = b.Ngay
	left join 
		(
			select x.*
			from (
				select *, ROW_NUMBER () over (partition by MaKH order by [Address] desc) as rn
				from TEST_SQL.dbo.customer_import 
				) x
			where x.rn = 1
		) c
		on a.CUS_ID = c.MaKH
	;

--case thực tế báo cáo chạy khi data là ngày nào đó trong tuần;

--drop table if exists  TEST_SQL.dbo.report_date
--create table test_sql.dbo.report_date
--	(
--		report_date date
--	)
--;

--declare @date date  = '2021-12-25'
--while @date <= '2022-01-10'
--	begin
--		insert into TEST_SQL.dbo.report_date values (@date)
--	set @date = dateadd (d,1,@date)
--	end
--;

--select * from TEST_SQL.dbo.report_date;

--if
--	(	
--		select DATENAME(w, report_date) 
--		from TEST_SQL.dbo.report_date
--		where report_date = '2021-12-27'
--	) = 'MONDAY'
--begin
--	print 'a'
--end








----- Tìm bạn chung -----

DROP TABLE IF EXISTS Thao_test..FRIENDS;
CREATE TABLE Thao_test..FRIENDS 
	(
	USER1 int,
	USER2 int
	)

INSERT INTO Thao_test..FRIENDS VALUES (1, 2), (1, 3), (1, 4), (2, 3);

SELECT *
FROM Thao_test..FRIENDS;

SELECT
		USER1,
		COUNT(*) SL
FROM
		(
			SELECT 
					USER1,
					USER2
			FROM Thao_test..FRIENDS
			UNION ALL
			SELECT 
					USER2,
					USER1
			FROM Thao_test..FRIENDS
		) A
GROUP BY 
		USER1
ORDER BY
		2 DESC;


LINKKKKKKKKKKKKKKK


----- Tính lương 3 tháng liên tiếp, nếu không đủ thì bỏ qua -----

DROP TABLE IF EXISTS Thao_test..SALARIES;
CREATE TABLE Thao_test..SALARIES  
	(
	MONTH_ID int,
	SALARY float
	)

INSERT INTO Thao_test..SALARIES
VALUES 
(1, 2000),
(2, 3000),
(3, 5000),
(4, 4000),
(5, 2000),
(6, 1000),
(7, 2000),
(8, 4000),
(9, 5000);









1366,1388
1622,1640
2111,2184
