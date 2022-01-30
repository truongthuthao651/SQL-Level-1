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




--- 2. Tính tổng số tiền theo từng mã cửa hàng và theo từng nhóm năm của thời điểm giao dịch như sau từ tháng 1 – tháng 6 2019(Quý 1 20219), từ tháng 7 – tháng 12 2019(Quý 2 20219), từ tháng 1 – 6 năm 2020(Quý 1 20220), từ tháng 7 – 12 năm 2020(Quý 2 20220). ---




--- 3. Tính tổng số tiền theo từng mã cửa hàng và theo từng nhóm mã khách hàng chia như sau:

---				Nhóm 1: Tên Khách Hàng nhỏ hơn 8 kí tự

---				Nhóm 2: Tên Khách Hàng từ 8 - 12 kí tự

---				Nhóm 3: Tên Khách Hàng từ 12 - 15 kí tự

---				Nhóm 4: Tên Khách Hàng > 15 kí tự

---		(Sử dụng hàm Len để đếm số kí tự từ tên khách hàng) ---




--- 4. Lấy ra thông tin giao dịch có số tiền lớn nhất theo từng ngày và từng cửa hàng ---




--- 5. Lấy ra khách có số tiền lớn nhất theo từng ngày và từng cửa hàng ---




--- 6. Sử dụng insert into thêm dữ liệu vào bảng discount như trong file Lesson1-data.xlsb. ---




--- 7. Tạo bảng và sử dụng insert into thêm 10 dòng dữ liệu vào bảng Cus_ID như trong file Lesson1-data.xlsb. ---




--- 8. Update cột số điện thoại của bảng Cus_ID bằng cách thêm số 0 vào đầu ---




--- 9. Update cột Email của bảng Cus_ID bằng cách xóa chữ @gmail.com đi ---




--- 10. Xóa các công ty có tên có độ dài >= 13 kí tự ---


