Tên Project: App quản lý tập luyện cá nhân.

Thành Viên:
Phan Văn Phát - 23017073
Nguyễn Hoàng Phong - 23010247
Hoàng Hải Nam - 23017272

## Báo cáo Bài tập thực hành số 2: Lập trình đối tượng Dart
**Project:** App quản lý tập luyện cá nhân
**Thành viên:** Phát - 23017073

### 1. Đối tượng đảm nhận: `UserProfile`
- **Mô tả:** Quản lý thông tin cá nhân của người dùng và tính toán chỉ số khối cơ thể (BMI) để đánh giá tình trạng sức khỏe.
- **Các thuộc tính chính:** 
  + `name` (String): Tên người dùng
  + `weight` (double): Cân nặng (kg)
  + `height` (double): Chiều cao (mét)
- **Phương thức xử lý logic:** `calculateBMI()` (Chứa thuật toán tính toán BMI và rẽ nhánh điều kiện để phân loại tình trạng cơ thể).

### 2. Sơ đồ thuật toán
*(Sơ đồ Activity Diagram mô tả luồng điều kiện phân loại BMI)*
<img width="480" height="731" alt="image" src="https://github.com/user-attachments/assets/0d2bf802-fa3b-463f-ba61-9d294a514cc6" />




*Thành viên:* Phong - 23010247

### 1. Đối tượng đảm nhận: WorkoutSession
- *Mô tả:* Quản lý một buổi tập cụ thể của người dùng, lưu trữ danh sách các bài tập đã thực hiện và tổng hợp toàn bộ lượng calo tiêu thụ.
- *Các thuộc tính chính:* 
  + sessionId (String): Mã định danh buổi tập
  + date (DateTime): Thời gian diễn ra buổi tập
  + exercises (List): Danh sách các đối tượng bài tập
- *Phương thức xử lý logic:* calculateTotalCalories() (Sử dụng vòng lặp duyệt qua danh sách các đối tượng Exercise và gọi hàm liên quan để cộng dồn tổng lượng calo).

### 2. Sơ đồ thuật toán
(Sơ đồ Sequence Diagram mô tả quá trình gọi hàm và tương tác giữa các đối tượng để tính tổng calo)
<img width="724" height="650" alt="Phong" src="https://github.com/user-attachments/assets/f0df1325-bfe9-4fa0-b86b-c5184552e501" />


### 3. Link Commit Code
- https://github.com/dodorafust/nhom_pnp/commit/461c18decf7cacb268c0473ba6c1630b4b909138
