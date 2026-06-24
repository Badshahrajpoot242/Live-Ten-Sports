class CategoryModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final int order;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.order,
    required this.isActive,
  });

  factory CategoryModel.fromMap(Map<dynamic, dynamic> map) {
    return CategoryModel(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      imageUrl: map['image_url'] ?? '',
      description: map['description'] ?? '',
      order: (map['order'] ?? 0) as int,
      isActive: map['is_active'] == true,
    );
  }
}
