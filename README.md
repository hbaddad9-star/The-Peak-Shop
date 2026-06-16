# 🛍️ The Peak Shop — Flutter Final Project

**Developer:** Hamza Baddad  
**University:** Middle East University (MEU)  
**Course:** Mobile Application Development (Flutter)  
**Instructor:** Mahmoud Masoud  

---

## 📱 App Overview

**The Peak Shop** is a Flutter-based mobile application for an official Gymshark sportswear retailer based in Jordan. The app allows users to browse authentic Gymshark products, filter by category, search for items, and place orders directly via WhatsApp.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🏠 Home Screen | Hero banner, category showcase, new arrivals grid |
| 📦 Products Screen | Full product list with search + category filter |
| 🔍 Product Details | Full details view with image, description, price |
| 🛒 Cart Screen | Add/remove items, adjust quantity, view total |
| 📲 WhatsApp Order | Unique feature — sends formatted order via WhatsApp |
| ℹ️ About Screen | Store info, contact details, Instagram link |
| 🗂️ Drawer | Navigation drawer with categories overview |
| 🔢 Cart Badge | Live count badge on Bottom Navigation Bar |

---

## 🗂️ Project Structure (MVC)

```
lib/
├── main.dart                    # App entry point + MainShell (BottomNav + Drawer)
├── models/
│   ├── product_model.dart       # ProductModel (Encapsulation)
│   ├── category_model.dart      # CategoryModel
│   └── cart_item_model.dart     # CartItemModel extends ProductModel (Inheritance)
├── controllers/
│   └── shop_controller.dart     # Data management, cart logic, search/filter
├── screens/
│   ├── home_screen.dart         # Screen 1: Home
│   ├── products_screen.dart     # Screen 2: Products List
│   ├── product_details_screen.dart  # Screen 3: Product Details
│   ├── cart_screen.dart         # Screen 4: Cart + WhatsApp Order
│   └── about_screen.dart        # Screen 5: About
└── widgets/
    ├── app_theme.dart           # Centralized theme & colors
    └── product_card.dart        # Reusable product card widget
```

---

## 🧱 OOP Concepts Used

### 1. Encapsulation — `ProductModel`
```dart
class ProductModel {
  int _quantity; // private field

  int get quantity => _quantity; // getter
  set quantity(int value) {     // validated setter
    if (value >= 0) _quantity = value;
  }
}
```

### 2. Inheritance — `CartItemModel`
```dart
class CartItemModel extends ProductModel {
  final DateTime addedAt;

  @override
  String toString() { /* polymorphism */ }
}
```

---

## 📦 Packages Used

| Package | Version | Purpose |
|---|---|---|
| `google_fonts` | ^6.1.0 | Custom Poppins typography |
| `url_launcher` | ^6.2.4 | WhatsApp & Instagram deep links |

---

## 🧭 Navigation

- **Bottom Navigation Bar** with 4 tabs: Home, Products, Cart, About
- **Drawer** with all routes + category list
- **Data passing** via constructor: `ProductDetailsScreen(product: product)`

---

## 🔎 Search & Filter

- **Search:** Real-time filtering by product name & description
- **Category Filter:** Horizontal chip row — All / Training / Running / Hoodies / Shorts
- Both filters work together simultaneously

---

## 📲 Unique Feature — WhatsApp Order Integration

When the user taps "Order via WhatsApp" in the Cart screen, the app builds a formatted order message and opens WhatsApp directly with the store's number pre-filled.

```dart
Future<void> _sendWhatsAppOrder() async {
  final message = controller.buildWhatsAppMessage();
  final url = 'https://wa.me/$storePhone?text=${Uri.encodeComponent(message)}';
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
```

---

## 🚀 How to Run

```bash
git clone https://github.com/YOUR_USERNAME/the_peak_shop.git
cd the_peak_shop
flutter pub get
flutter run
```

---

## 📸 Screenshots

> *(Add screenshots after running the app)*

| Home | Products | Product Details | Cart |
|---|---|---|---|
| ![Home](screenshots/home.png) | ![Products](screenshots/products.png) | ![Details](screenshots/details.png) | ![Cart](screenshots/cart.png) |

---

## 📝 Git Commit Strategy

| Commit | Description |
|---|---|
| 1️⃣ | Initial project setup + pubspec.yaml configuration |
| 2️⃣ | Models + Controller (ProductModel, CategoryModel, CartItemModel, ShopController) |
| 3️⃣ | Screens implementation (Home, Products, Details, Cart) |
| 4️⃣ | Theme, widgets, About screen, Drawer + final polishing |

---

*Built with ❤️ using Flutter & Dart | The Peak Shop — Zarqa, Jordan*
