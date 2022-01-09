drop table if exists Thao_HW_3.dbo.contract1
CREATE TABLE Thao_HW_3.dbo.contract1
	(
	NgayDuLieu VARCHAR(255),
	MaHopDong VARCHAR(255),
	MaKH VARCHAR(50),
	TenKH  VARCHAR(50),
	MaSanPham VARCHAR(50),
	LoaiTien VARCHAR(50),
	LaiSuat FLOAT,
	KyHan VARCHAR(255),
	MaChiNhanh VARCHAR(50),
	NgayMoHopDong VARCHAR(255),
	NgayTatToan VARCHAR(255),
	SoTien FLOAT
	)
BULK INSERT Thao_HW_3.dbo.contract1
FROM "C:\Users\HP\Downloads\data-btvn.csv"
	WITH 
	(
		FIRSTROW = 2,          ---- LẤY DỮ LIỆU TỪ FILE EXCEL BẮT ĐẦU TỪ DÒNG THỨ 2
		FIELDTERMINATOR = ',', ---- NGĂN CÁCH GIỮA CÁC CỘT BỞI DẤU TAB,PHẨY -----
		ROWTERMINATOR = '\n'
	);



--- 1. Lấy tổng số tiền theo từng mã chi nhánh ---
SELECT MACHINHANH,
	   SUM(SOTIEN) AS TOTAL_PRICE
FROM Thao_HW_3.dbo.contract1
GROUP BY MACHINHANH;



--- 2. Lấy tổng số tiền theo từng mã chi nhánh có kỳ hạn là 1,2,3,4,5,6 tháng ---
SELECT MACHINHANH,
	   SUM(SOTIEN) AS TOTAL_PRICE
FROM Thao_HW_3.dbo.contract1
WHERE KYHAN IN ('1','2','3','4','5','6')
GROUP BY MACHINHANH;


--- 3. Lấy tổng số tiền theo từng mã chi nhánh có ngày mở hợp đồng là 20170101 và chỉ lấy các chi nhánh có tổng số tiền > 1 tỷ ---
SELECT MACHINHANH,
	   SUM(SOTIEN) AS TOTAL_PRICE
FROM Thao_HW_3.dbo.contract1
WHERE NGAYDULIEU = '20170101'
GROUP BY MACHINHANH
HAVING SUM(SOTIEN) > 1e9;


--- 4. Lấy ra số tiền lớn nhất và nhỏ nhất theo từng chi nhánh ---
SELECT MACHINHANH,
	   MAX(SOTIEN) AS MAX_PRICE,
	   MIN(SOTIEN) AS MIN_PRICE
FROM Thao_HW_3.dbo.contract1
GROUP BY MACHINHANH;


--- 5. Lấy tổng số tiền theo từng mã chi nhánh và kỳ hạn đi kèm sắp xếp theo thứ tự tăng dần của tổng số tiền ---
SELECT MACHINHANH,
	   KYHAN,
	   SUM(SOTIEN) AS TOTAL_PRICE
FROM Thao_HW_3.dbo.contract1
GROUP BY MACHINHANH,
		 KYHAN
ORDER BY TOTAL_PRICE;



--- 6. Tính tổng số tiền theo từng mã chi nhánh,số tiền bình quân theo từng chi nhánh và tính tỷ lệ số tiền bình quân trên tổng số tiền ---
SELECT MACHINHANH,
	   AVG(SOTIEN) AS AVG_PRICE,
	   SUM(SOTIEN) AS TOTAL_PRICE,
	   (AVG(SOTIEN) / SUM(SOTIEN)) AS RATE
FROM Thao_HW_3.dbo.contract1
GROUP BY MACHINHANH
ORDER BY TOTAL_PRICE;



--- 7. Tính số lượng khách hàng theo mỗi chi nhánh(chú ý 1 khách hàng có nhiều hợp đồng), số lượng hợp đồng theo mỗi chi nhánh ---
SELECT MACHINHANH,
	   COUNT(DISTINCT MAKH) AS SL_KH,
	   COUNT(1) AS SL_HD
FROM Thao_HW_3.dbo.contract1
GROUP BY MACHINHANH;


--- 8. Lấy ra khách hàng có số tiền lớn nhất và khách hàng có số tiền nhỏ nhất ---
SELECT *
FROM Thao_HW_3.dbo.contract1
WHERE SOTIEN = (SELECT MAX(SOTIEN)
				FROM Thao_HW_3.dbo.contract1)
UNION
SELECT *
FROM Thao_HW_3.dbo.contract1
WHERE SOTIEN = (SELECT TOP 1 SOTIEN
				FROM Thao_HW_3.dbo.contract1
				ORDER BY SOTIEN)
ORDER BY SOTIEN DESC;



--- 9. Lấy ra tổng số tiền theo từng kỳ hạn chia theo các nhóm sau ---

			--- null => KKH

			--- (D03,D05,D06,D07,D08,D11,D12,D13,D14,D15,D17,D19,D20,D21,D22,D24) => CKH < 1M

			--- (1,2,3) => CKH <= 3M

			--- (4,5,6) => CKH 4-6M

			--- (7,8,9,10,11,12) => CKH 7-12M

			--- Các kỳ hạn còn lại vào nhóm CKH > 12M

SELECT 
		KYHAN,
		SUM(SOTIEN) AS TONG_TIEN
FROM Thao_HW_3.dbo.contract1
WHERE 
		KYHAN = 'NULL'
		OR (KyHan IN ('D03','D05','D06','D07','D08','D11','D12','D13','D14','D15','D17','D19','D20','D21','D22','D24')
			AND SoTien < 1e6)
		OR (KYHAN IN ('1', '2', '3')
			AND SOTIEN < 3e6)
		OR (KYHAN IN ('4', '5', '6')
			AND SOTIEN > 4e6
			AND SoTien < 6e6)
		OR (KYHAN IN ('7', '8', '9', '10', '11', '12')
			AND SOTIEN > 7e6
			AND SoTien < 12e6)
GROUP BY KYHAN
UNION
SELECT 
		KYHAN,
		SUM(SOTIEN) AS TONG_TIEN
FROM Thao_HW_3.dbo.contract1
WHERE 
		SoTien > 12e6
GROUP BY KYHAN;



--- 10. Lấy ra tổng số tiền theo từng chi nhánh chia theo các nhóm dựa vào số tiền trên hợp đồng như sau. Và sắp xếp kết quả theo mã chi nhánh tăng dần ---

			--- Dưới 500 triệu

			--- Từ 500 triệu – 1 tỷ

			--- Lớn hơn 1 tỷ và nhỏ hơn bằng 5 tỷ

			--- Lớn hơn 5 tỷ và nhỏ hơn bằng 10 tỷ

			--- Lớn hơn 10 tỷ

----- use union all or case when -----


SELECT 
		MaChiNhanh,
		SUM(SOTIEN) AS TONG_TIEN
FROM Thao_HW_3.dbo.contract1
WHERE 
		SoTien < 5e8
		OR (SoTien BETWEEN 5e8 AND 1e9)
		OR (SoTien > 1e9 AND SoTien <= 5e9)
		OR (SoTien > 5e9 AND SoTien <= 10e9)
		OR SoTien > 10e9
GROUP BY MaChiNhanh
ORDER BY MaChiNhanh ASC;
