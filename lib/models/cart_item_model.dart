// models/cart_item_model.dart
// OOP Concept 2: Inheritance — CartItemModel extends ProductModel

import 'product_model.dart';

class CartItemModel extends ProductModel {
  final DateTime addedAt;

  CartItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.categoryId,
    super.isNew,
    required int quantity,
  })  : addedAt = DateTime.now(),
        super(quantity: quantity);

  // Overriding toString — polymorphism
  @override
  String toString() {
    return 'CartItem(name: $name, qty: $quantity, total: ${totalPrice.toStringAsFixed(2)} JD)';
  }
}
