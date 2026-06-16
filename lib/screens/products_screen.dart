// screens/products_screen.dart
// Products list with search and category filter

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/shop_controller.dart';
import '../models/product_model.dart';
import '../widgets/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  final ShopController controller;
  final VoidCallback onCartUpdated;

  const ProductsScreen({
    super.key,
    required this.controller,
    required this.onCartUpdated,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = 'all';
  List<ProductModel> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _displayedProducts = widget.controller.products;
  }

  void _applyFilters() {
    setState(() {
      List<ProductModel> result =
          widget.controller.filterByCategory(_selectedCategoryId);
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        result = result
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q))
            .toList();
      }
      _displayedProducts = result;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Search Bar ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),

        // ── Category Filter Chips ─────────────────────────────────────────
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip('all', 'All'),
              ...widget.controller.categories.map(
                (cat) => _buildFilterChip(cat.id, '${cat.iconPath} ${cat.name}'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── Results Count ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${_displayedProducts.length} products',
              style: GoogleFonts.poppins(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Products Grid ─────────────────────────────────────────────────
        Expanded(
          child: _displayedProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off,
                          color: AppTheme.textSecondary, size: 60),
                      const SizedBox(height: 12),
                      Text(
                        'No products found',
                        style: GoogleFonts.poppins(
                            color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = _displayedProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(
                              product: product,
                              controller: widget.controller,
                              onCartUpdated: widget.onCartUpdated,
                            ),
                          ),
                        );
                      },
                      onAddToCart: () {
                        widget.controller.addToCart(product);
                        widget.onCartUpdated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart!'),
                            backgroundColor: AppTheme.accent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String id, String label) {
    final isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedCategoryId = id);
        _applyFilters();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.surface,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.black : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
