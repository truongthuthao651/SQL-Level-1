drop table if exists Thao_HW_2.dbo.contract
CREATE TABLE Thao_HW_2.dbo.contract
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
BULK INSERT Thao_HW_2.dbo.contract
FROM "C:\Users\HP\Downloads\data-btvn.csv"
	WITH 
	(
		FIRSTROW = 2,          ---- LẤY DỮ LIỆU TỪ FILE EXCEL BẮT ĐẦU TỪ DÒNG THỨ 2
		FIELDTERMINATOR = ',', ---- NGĂN CÁCH GIỮA CÁC CỘT BỞI DẤU TAB,PHẨY -----
		ROWTERMINATOR = '\n'
	)


--- 1. Lấy danh sách hợp đồng có số tiền > 100 triệu ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien > 100e6;


--- 2. lấy danh sách hợp đồng có số tiền < 500 triệu ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien < 500e6;


--- 3. lấy danh sách hợp đồng có mã chi nhánh VN0010549 ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE MaChiNhanh = 'VN0010549';


--- 4. lấy danh sách hợp đồng có mã chi nhánh VN0010549 và có số tiền > 100 triệu ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE MaChiNhanh = 'VN0010549' AND
	  SoTien > 100e6;


--- 5. lấy danh sách hợp đồng có số tiền < 100 triệu hoặc > 500 triệu ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien < 100e6 OR
      SoTien > 500e6;


--- 6. lấy danh sách hợp đồng có mã chi nhánh VN0010549 và có số tiền < 100 triệu hoặc > 500 triệu ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE MaChiNhanh = 'VN0010549' AND
	  (SoTien < 100e6 OR
	  SoTien > 500e6);


--- 7. lấy danh sách hợp đồng có mã chi nhánh VN0010549 có số tiền > 100 triệu và có kỳ hạn 24 tháng ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE MaChiNhanh = 'VN0010549' AND
	  SoTien > 100e6 AND
	  KyHan = '24';


--- 8. Lấy 10 hợp đồng có số tiền lớn nhất và lớn hơn 1 tỷ ---
SELECT TOP 10 *
FROM Thao_HW_2.dbo.contract
where SoTien > 1e9
order by SoTien desc;


--- 9. Lấy ra tổng số tiền ---
SELECT SUM(SoTien) AS TONGSOTIEN
FROM Thao_HW_2.dbo.contract;


--- 10. Lấy ra bình quân số tiền ---
SELECT AVG(SoTien) AS TBSOTIEN
FROM Thao_HW_2.dbo.contract;


--- 11. Lấy ra hợp đồng có tiền nhỏ nhất ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien =    (SELECT TOP 1 SoTien 
				   FROM Thao_HW_2.dbo.contract
				   ORDER BY SoTien ASC)
ORDER BY MaHopDong;


SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien = (SELECT  MIN(SoTien)
				FROM Thao_HW_2.dbo.contract);


--- 12. Lấy ra hợp đồng có tiền lớn nhất ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien = (SELECT  MAX(SoTien)
				FROM Thao_HW_2.dbo.contract)
;


SELECT *
FROM Thao_HW_2.dbo.contract
WHERE SoTien =    (SELECT TOP 1 SoTien 
				   FROM Thao_HW_2.dbo.contract
				   ORDER BY SoTien DESC)
ORDER BY MaHopDong;



--- 13. Lấy ra danh sách các chi nhánh ---
SELECT DISTINCT
	MaChiNhanh
FROM Thao_HW_2.dbo.contract
ORDER BY 1;


--- 14. Lấy ra danh sách Loại tiền ---
SELECT DISTINCT
	LoaiTien
FROM Thao_HW_2.dbo.contract;


--- 15. Lấy ra danh sách các chi nhánh và các kỳ hạn đi kèm ---
SELECT DISTINCT
	MaChiNhanh,
	KyHan
FROM Thao_HW_2.dbo.contract;



--- 16. Lấy ra danh sách các chi nhánh và các kỳ hạn đi kèm có số tiền > 1 tỷ ---
SELECT DISTINCT
	MaChiNhanh,
	KyHan
FROM Thao_HW_2.dbo.contract
WHERE SoTien > 1e9;



--- 17. Lấy ra danh sách các hợp đồng có tên khách hàng bắt đầu bằng ‘Sandra’ ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE TenKH LIKE 'Sandra %';



--- 18. Lấy ra danh sách các hợp đồng có tên khách hàng kết thúc bằng ‘Garcia’ ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE TenKH LIKE '% Garcia';



--- 19. Lấy ra danh sách các hợp đồng có tên khách hàng có từ ‘isac’ ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE TenKH LIKE '%Isaac%';
	  
--- 20. Lấy ra danh sách các hợp đồng có tên khách hàng có từ ‘isac’ và loại tiền là VND. ---
SELECT *
FROM Thao_HW_2.dbo.contract
WHERE TenKH LIKE '%Isaac%'
	  AND LoaiTien = 'VND';