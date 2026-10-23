// File: lib/models/base_entity.dart

abstract class BaseEntity<T> {
  final T id;
  final String name;
  final String description;

  const BaseEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  // Phương thức chung trả về thông tin cơ bản
  String getBasicInfo() {
    return '[$id] $name - $description';
  }

  // Phương thức trừu tượng buộc lớp con định nghĩa chi tiết riêng
  String getDetailInfo();

  // Generic Method với tham số kiểu <U> độc lập
  String formatExtraNote<U>(U extraInfo) {
    return '$name • Ghi chú: $extraInfo';
  }
}

// Generic Class quản lý danh sách thực thể (Bounded Type)
class EntityCollection<E extends BaseEntity> {
  final List<E> items;

  const EntityCollection({required this.items});

  int get totalCount => items.length;
}