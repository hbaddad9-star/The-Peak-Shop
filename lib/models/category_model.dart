// models/category_model.dart
// Model class representing a product category

class CategoryModel {
  final String id;
  final String name;
  final String iconPath;
  final String description;

  // Constructor
  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.description,
  });

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
