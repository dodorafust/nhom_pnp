
abstract class BaseEntity<T> {
  final T id;
  final String name;
  final String description;

  const BaseEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  // Phương thức chung trả về thông tin cơ bản của mọi đối tượng
  String getBasicInfo() {
    return '[$id] $name - $description';
  }

  // Phương thức trừu tượng buộc các lớp con phải định nghĩa chi tiết riêng
  String getDetailInfo();

  // Generic Method với tham số kiểu <U> độc lập
  String formatExtraNote<U>(U extraInfo) {
    return '$name | Ghi chú thêm: $extraInfo';
  }
}

// 2. Generic Class giới hạn kiểu dữ liệu (Bounded Type) bằng từ khóa extends
class EntityCollection<E extends BaseEntity> {
  final List<E> items;

  EntityCollection({required this.items});

  int get totalCount => items.length;
}