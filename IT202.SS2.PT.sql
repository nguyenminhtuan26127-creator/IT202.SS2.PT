/*Giải pháp 1 — Hard Delete là xóa trực tiếp các bản ghi có tg nhưng được đánh dấu lrạng thái "Canceled" ra khỏi bảng ORDERS bằng lệnh DELETE FROM có điều kiện lọc. Dữ liệu sẽ biến mất hoàn toàn khỏi cơ sở dữ liệu sau khi thực thi.à "đã xóa" và sẽ bị lọc ra khỏi các truy vấn thông thường.
Giải pháp 2 — Soft Delete là không xóa thật, thay vào đó dùng lệnh UPDATE để chuyển giá trị cột cờ is_deleted từ 0 lên 1 cho tất cả đơn hàng bị hủy. Dữ liệu vẫn còn nguyên trong bản
Giải phóng dung lượng ổ cứng:  Hard Delete xóa hoàn toàn, giải phóng ngay lập tức. Soft Delete Dữ liệu vẫn tồn tại, không tiết kiệm dung lượng
Tốc độ truy vấn: Hard Delete Nhanh hơn vì bảng ít bản ghi hơn. Chậm hơn nếu không có index, Soft Delete mọi query đều phải lọc thêm cột is_deleted
Tính vẹn toàn lịch sử kế toán: Hard Delete Mất dữ liệu vĩnh viễn, không thể kiểm toán. Soft Delete Dữ liệu được giữ lại, kế toán vẫn tra cứu và đối soát được
*/
create database customers;

use customers;

CREATE TABLE ORDERS (
    OrderID     INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    OrderDate   DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status      VARCHAR(20),   -- 'Completed', 'Canceled', 'Pending'
    IsDeleted   TINYINT(1) DEFAULT 0  -- 0 = active, 1 = soft deleted
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO ORDERS (CustomerName, OrderDate, TotalAmount, Status) VALUES
('Nguyễn Văn A', '2023-01-10', 500000,  'Completed'),
('Khách hàng vãng lai', '2023-02-15', 1200000, 'Canceled'),  
('Trần Thị B',   '2023-05-20', 300000,  'Canceled'),          
('Lê Văn C',     '2024-01-05', 850000,  'Completed');

UPDATE ORDERS
SET IsDeleted = 1
WHERE Status = 'Canceled';

CREATE INDEX idx_isdeleted ON ORDERS (IsDeleted);
CREATE INDEX idx_status    ON ORDERS (Status);

SELECT * FROM ORDERS WHERE IsDeleted = 0;

SELECT * FROM ORDERS WHERE Status = 'Canceled';