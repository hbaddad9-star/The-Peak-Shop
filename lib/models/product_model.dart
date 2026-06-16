// models/product_model.dart
// Model class representing a Gymshark product
// OOP Concept 1: Encapsulation — private data accessed via getters

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool isNew;
  int _quantity; // encapsulated private field

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.isNew = false,
    int quantity = 0,
  }) : _quantity = quantity;

  // Getter — encapsulation
  int get quantity => _quantity;

  // Setter with validation — encapsulation
  set quantity(int value) {
    if (value >= 0) _quantity = value;
  }

  double get totalPrice => price * _quantity;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price)';
  }
}
