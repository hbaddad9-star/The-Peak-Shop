// screens/cart_screen.dart
// Shopping cart with WhatsApp order integration (unique feature)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/shop_controller.dart';
import '../widgets/app_theme.dart';

class CartScreen extends StatefulWidget {
  final ShopController controller;
  final VoidCallback onCartUpdated;

  const CartScreen({
    super.key,
    required this.controller,
    required this.onCartUpdated,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // WhatsApp phone number for The Peak store
  static const String storePhone = '962790929607';

  Future<void> _sendWhatsAppOrder() async {
    final message = widget.controller.buildWhatsAppMessage();
    final encoded = Uri.encodeComponent(message);
    final url = 'https://wa.me/$storePhone?text=$encoded';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.controller.cartItems;

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: AppTheme.textSecondary.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some Gymshark gear!',
                    style: GoogleFonts.poppins(
                      color: AppTheme.textSecondary.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // ── Cart Items List ──────────────────────────────────────
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item.imageUrl.startsWith('assets/')
                                  ? Image.asset(
                                      item.imageUrl,
                                      width: 70, height: 70, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 70, height: 70, color: AppTheme.surface,
                                        child: const Icon(Icons.image_not_supported,
                                            color: AppTheme.textSecondary),
                                      ),
                                    )
                                  : Image.network(
                                      item.imageUrl,
                                      width: 70, height: 70, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 70, height: 70, color: AppTheme.surface,
                                        child: const Icon(Icons.image_not_supported,
                                            color: AppTheme.textSecondary),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.price.toStringAsFixed(2)} JD each',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Quantity Controls
                                  Row(
                                    children: [
                                      _qtyButton(
                                        icon: Icons.remove,
                                        onTap: () {
                                          setState(() {
                                            if (item.quantity == 1) {
                                              widget.controller
                                                  .removeFromCart(item.id);
                                            } else {
                                              item.quantity = item.quantity - 1;
                                            }
                                          });
                                          widget.onCartUpdated();
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(
                                          '${item.quantity}',
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      _qtyButton(
                                        icon: Icons.add,
                                        onTap: () {
                                          setState(() {
                                            item.quantity = item.quantity + 1;
                                          });
                                          widget.onCartUpdated();
                                        },
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${item.totalPrice.toStringAsFixed(2)} JD',
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.priceColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Remove button
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.controller.removeFromCart(item.id);
                                });
                                widget.onCartUpdated();
                              },
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.redAccent, size: 20),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Order Summary + WhatsApp Button ──────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total (${widget.controller.cartCount} items)',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${widget.controller.cartTotal.toStringAsFixed(2)} JD',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // WhatsApp Order Button — unique feature
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _sendWhatsAppOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: Text(
                            'Order via WhatsApp',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppTheme.accent, size: 16),
      ),
    );
  }
}
