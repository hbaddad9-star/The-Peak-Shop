// controllers/shop_controller.dart
// Controller class managing all data and business logic (MVC pattern)

import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/cart_item_model.dart';

class ShopController {
  static final ShopController _instance = ShopController._internal();
  factory ShopController() => _instance;
  ShopController._internal();

  // ─── Categories Data ───────────────────────────────────────────────────────
  final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'cat1',
      name: 'Training',
      iconPath: '🏋️',
      description: 'High-performance training wear for gym sessions',
    ),
    const CategoryModel(
      id: 'cat2',
      name: 'Running',
      iconPath: '🏃',
      description: 'Lightweight gear built for speed and comfort',
    ),
    const CategoryModel(
      id: 'cat3',
      name: 'Hoodies & Tops',
      iconPath: '👕',
      description: 'Casual and stylish Gymshark tops and hoodies',
    ),
    const CategoryModel(
      id: 'cat4',
      name: 'Shorts',
      iconPath: '🩳',
      description: 'Flexible training shorts for max mobility',
    ),
  ];

  // ─── Products Data (real store images) ────────────────────────────────────
  final List<ProductModel> products = [
    ProductModel(
      id: 'p1',
      name: 'Gymshark Vital T-Shirt — Red/Black',
      description:
          'الكلاسيك الأحمر من Gymshark — قماش Seamless مع تقنية moisture-wicking لجلسات الجيم الثقيلة. فيت ضيق يبرز العضلات مع راحة تامة. متوفر حصرياً عند The Peak.',
      price: 25.00,
      imageUrl: 'assets/images/tshirt_red.jpeg',
      categoryId: 'cat1',
      isNew: true,
    ),
    ProductModel(
      id: 'p2',
      name: 'Gymshark Vital T-Shirt — Black/Cyan',
      description:
          'تيشيرت Gymshark أسود مع لوغو السيان — الأكثر مبيعاً عند The Peak. قماش Seamless خفيف مع مرونة 4-Way Stretch. مثالي للتدريب والاستخدام اليومي.',
      price: 25.00,
      imageUrl: 'assets/images/tshirt_black_cyan.jpeg',
      categoryId: 'cat1',
      isNew: true,
    ),
    ProductModel(
      id: 'p3',
      name: 'Gymshark Legacy T-Shirt — Charcoal',
      description:
          'تيشيرت Gymshark رمادي غامق مع لوغو فضي — تصميم راقي يناسب الجيم والشارع. قماش مقاوم للرطوبة مع قصة Athletic Fit.',
      price: 23.00,
      imageUrl: 'assets/images/tshirt_grey.jpeg',
      categoryId: 'cat1',
    ),
    ProductModel(
      id: 'p4',
      name: 'Gymshark Tank Top — Washed Black',
      description:
          'تانك توب Gymshark بتصميم Washed مع رسمة Wings. قماش ناعم ومريح مثالي لليوم الثقيل في الجيم. يعطيك فيبز الجدية والأناقة بنفس الوقت.',
      price: 20.00,
      imageUrl: 'assets/images/tank_top.jpeg',
      categoryId: 'cat1',
      isNew: true,
    ),
    ProductModel(
      id: 'p5',
      name: 'Sport Shorts — Navy Blue',
      description:
          'شورت تدريب نيفي بلو من The Peak — قماش خفيف سريع الجفاف مع جيوب جانبية وخصر مطاطي. مثالي للجيم والركض واليوم كله.',
      price: 18.00,
      imageUrl: 'assets/images/shorts_navy.jpeg',
      categoryId: 'cat4',
      isNew: true,
    ),
  ];

  // ─── Cart ──────────────────────────────────────────────────────────────────
  final List<CartItemModel> cartItems = [];

  void addToCart(ProductModel product) {
    final existing = cartItems.where((item) => item.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity = existing.first.quantity + 1;
    } else {
      cartItems.add(CartItemModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
        isNew: product.isNew,
        quantity: 1,
      ));
    }
  }

  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.id == productId);
  }

  void clearCart() => cartItems.clear();

  int get cartCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // ─── Search & Filter ───────────────────────────────────────────────────────
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return products;
    final q = query.toLowerCase();
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  List<ProductModel> filterByCategory(String categoryId) {
    if (categoryId == 'all') return products;
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  CategoryModel getCategoryById(String id) {
    return categories.firstWhere(
      (c) => c.id == id,
      orElse: () => const CategoryModel(
          id: '', name: 'Unknown', iconPath: '📦', description: ''),
    );
  }

  // ─── WhatsApp Order Message Builder ───────────────────────────────────────
  String buildWhatsAppMessage() {
    if (cartItems.isEmpty) return '';
    final buffer = StringBuffer();
    buffer.writeln('🛒 *New Order — The Peak Shop*');
    buffer.writeln('─────────────────────');
    for (final item in cartItems) {
      buffer.writeln('• ${item.name}');
      buffer.writeln('  Qty: ${item.quantity} × ${item.price.toStringAsFixed(2)} JD');
      buffer.writeln('  Subtotal: ${item.totalPrice.toStringAsFixed(2)} JD');
      buffer.writeln();
    }
    buffer.writeln('─────────────────────');
    buffer.writeln('💰 *Total: ${cartTotal.toStringAsFixed(2)} JD*');
    buffer.writeln();
    buffer.writeln('Please confirm my order. Thank you!');
    return buffer.toString();
  }
}
