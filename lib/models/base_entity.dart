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

  String getBasicInfo() {
    return '[$id] $name - $description';
  }

  String getDetailInfo();

  String formatExtraNote<U>(U extraInfo) {
    return '$name • $extraInfo';
  }
}

class EntityCollection<E extends BaseEntity> {
  final List<E> items;

  const EntityCollection({required this.items});

  int get totalCount => items.length;
}