// screens/home_screen.dart
// Home screen — banner, categories, featured products

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/shop_controller.dart';
import '../widgets/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final ShopController controller;
  final VoidCallback onCartUpdated;
  final VoidCallback navigateToProducts;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.onCartUpdated,
    required this.navigateToProducts,
  });

  @override
  Widget build(BuildContext context) {
    final featured = controller.products.where((p) => p.isNew).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Banner ──────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accent.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'THE PEAK',
                        style: GoogleFonts.poppins(
                          color: AppTheme.accent,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                      Text(
                        'Official Gymshark Retailer',
                        style: GoogleFonts.poppins(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: navigateToProducts,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'Shop Now',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Categories ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Categories',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final cat = controller.categories[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 90,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.accent.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat.iconPath, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text(
                        cat.name,
                        style: GoogleFonts.poppins(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── New Arrivals ─────────────────────────────────────────────────
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Arrivals',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: navigateToProducts,
                  child: Text(
                    'See All',
                    style: GoogleFonts.poppins(
                      color: AppTheme.accent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final product = featured[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsScreen(
                        product: product,
                        controller: controller,
                        onCartUpdated: onCartUpdated,
                      ),
                    ),
                  );
                },
                onAddToCart: () {
                  controller.addToCart(product);
                  onCartUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart!'),
                      backgroundColor: AppTheme.accent,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
