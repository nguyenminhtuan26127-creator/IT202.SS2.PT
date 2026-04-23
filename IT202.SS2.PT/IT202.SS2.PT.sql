/*Phân tích & đề xuất 
Bảng có 2 triệu bản ghi → thao tác DDL dễ gây lock bảng
INT làm mất số 0 đầu → sai dữ liệu nghiệp vụ
Cần đổi sang VARCHAR(15) nhưng không được làm sập hệ thống

Có 2 hướng:
ALTER trực tiếp → nhanh nhưng dễ lock, rủi ro cao
Add–Copy–Drop → chậm hơn nhưng an toàn, ít ảnh hưởng hệ thống

Kết luận
Chọn Add–Copy–Drop vì:
Tránh downtime
An toàn dữ liệu
Phù hợp hệ thống đang chạy
*/
-- Thêm cột mới
CREATE DATABASE IF NOT EXISTS demo_db;
USE demo_db;

ALTER TABLE USERS 
DROP COLUMN Phone_new;
ALTER TABLE USERS 
ADD COLUMN Phone_new VARCHAR(15);

-- Copy dữ liệu
SET SQL_SAFE_UPDATES = 0;
UPDATE USERS
SET Phone_new = CAST(Phone AS CHAR)
WHERE Phone IS NOT NULL;

-- Xóa cột cũ
ALTER TABLE USERS 
DROP COLUMN Phone;

-- Đổi tên cột mới
ALTER TABLE USERS 
RENAME COLUMN Phone_new TO Phone;