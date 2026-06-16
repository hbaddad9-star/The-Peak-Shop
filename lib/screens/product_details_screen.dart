// screens/product_details_screen.dart
// Detailed view of a single product — data passed via navigation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/shop_controller.dart';
import '../models/product_model.dart';
import '../widgets/app_theme.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  final ShopController controller;
  final VoidCallback onCartUpdated;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.controller,
    required this.onCartUpdated,
  });

  Widget _buildImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(url, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder());
    }
    return Image.network(url, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder());
  }

  Widget _placeholder() => Container(
        color: AppTheme.surface,
        child: const Center(
          child: Icon(Icons.image_not_supported, color: AppTheme.textSecondary, size: 60),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final category = controller.getCategoryById(product.categoryId);

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppTheme.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImage(product.imageUrl),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '${category.iconPath} ${category.name}',
                      style: GoogleFonts.poppins(
                        color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary, fontSize: 22,
                      fontWeight: FontWeight.w700, height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (product.isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.newBadge,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '✨ New Arrival',
                        style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 11, fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.surface),
                  const SizedBox(height: 16),

                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary, fontSize: 14, height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price',
                              style: GoogleFonts.poppins(
                                  color: AppTheme.textSecondary, fontSize: 12)),
                          Text(
                            '${product.price.toStringAsFixed(2)} JD',
                            style: GoogleFonts.poppins(
                              color: AppTheme.priceColor, fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.addToCart(product);
                        onCartUpdated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            backgroundColor: AppTheme.accent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
