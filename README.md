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

## Báo cáo Bài tập: Thiết kế Wireframe và Xây dựng UI
**Dự án:** App quản lý tập luyện cá nhân[cite: 7]
**Nhóm thực hiện:** Phát, Phong, Nam[cite: 7]

### Yêu cầu 1: Vẽ Wireframe và Luồng công việc (Flow of work)
- **Công cụ sử dụng:** Figma.
- **Mô tả:** Nhóm đã thiết kế wireframe chi tiết cho các màn hình của ứng dụng. Luồng công việc (Flow of work) được thể hiện rõ ràng thông qua tính năng liên kết (Prototype), cho phép xem trước cách ứng dụng chuyển hướng khi tương tác.
- **Minh chứng:** [Chèn link Figma public hoặc chèn trực tiếp ảnh chụp wireframe của nhóm vào đây]

### Yêu cầu 2: Quyết định số màn hình và Bottom Navigation Bar
- Ứng dụng được thiết kế bao gồm **3 màn hình chính**.
- Nhóm sử dụng **Bottom Navigation Bar** làm thanh điều hướng gốc (chứa trong `main.dart`) để chuyển đổi qua lại giữa 3 màn hình này, cụ thể:
  1. Tab 1: **Bài tập** (Icon: list)
  2. Tab 2: **Buổi tập** (Icon: fitness_center)
  3. Tab 3: **Hồ sơ** (Icon: person)

### Yêu cầu 3: Phân công phát triển màn hình
Dựa trên kiến trúc UI đã chốt, mỗi sinh viên đảm nhận phát triển một màn hình độc lập (được tách thành các file giao diện riêng biệt trong thư mục `screens`):
- **Nam:** Phụ trách phát triển **Tab 1 - Màn hình Bài tập** (`exercise_screen.dart`). 
- **Phong:** Phụ trách phát triển **Tab 2 - Màn hình Buổi tập** (`workout_screen.dart`).
- **Phát:** Phụ trách phát triển **Tab 3 - Màn hình Hồ sơ** (`profile_screen.dart`).

### Yêu cầu 4: Commit code vào repo chung
- Các thành viên đã hoàn thành việc code giao diện được giao và thực hiện đẩy (push) mã nguồn lên kho lưu trữ chung của nhóm.
- Cấu trúc thư mục được tổ chức hợp lý, tách biệt giữa file điều hướng chính (`main.dart`), các giao diện màn hình (`screens/`) và mô hình dữ liệu (`models/`).
- **Link thư mục Code chính:** [Dán link dẫn tới thư mục chứa code giao diện trên GitHub vào đây]
- **Link lịch sử Commit:** [Dán link trang Commit History của repo để minh chứng quá trình làm việc của 3 thành viên]
