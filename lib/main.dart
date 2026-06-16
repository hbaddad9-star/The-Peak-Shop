

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controllers/shop_controller.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ThePeakApp());
}

class ThePeakApp extends StatelessWidget {
  const ThePeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Peak Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainShell(),
    );
  }
}

// ── Main Shell: Handles BottomNav + Drawer ─────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final ShopController _controller = ShopController();

  // Screen titles for AppBar
  final List<String> _titles = [
    'THE PEAK',
    'Products',
    'Cart',
    'About',
  ];

  void _refreshUI() => setState(() {});

  void _navigateToProducts() => setState(() => _currentIndex = 1);

  @override
  Widget build(BuildContext context) {
    // Build screens dynamically to pass callbacks
    final List<Widget> screens = [
      HomeScreen(
        controller: _controller,
        onCartUpdated: _refreshUI,
        navigateToProducts: _navigateToProducts,
      ),
      ProductsScreen(
        controller: _controller,
        onCartUpdated: _refreshUI,
      ),
      CartScreen(
        controller: _controller,
        onCartUpdated: _refreshUI,
      ),
      const AboutScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primary,

      // ── App Bar ────────────────────────────────────────────────────────
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex != 2)
            Stack(
              children: [
                IconButton(
                  onPressed: () => setState(() => _currentIndex = 2),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (_controller.cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_controller.cartCount}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),

      // ── Drawer ────────────────────────────────────────────────────────
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.surface),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('THE PEAK',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: 2,
                      )),
                  Text('Official Gymshark Retailer',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      )),
                ],
              ),
            ),
            _drawerItem(Icons.home_outlined, 'Home', 0),
            _drawerItem(Icons.grid_view_rounded, 'Products', 1),
            _drawerItem(Icons.shopping_cart_outlined, 'Cart', 2),
            _drawerItem(Icons.info_outline, 'About', 3),
            const Divider(color: AppTheme.surface),
            ListTile(
              leading: const Icon(Icons.category_outlined,
                  color: AppTheme.textSecondary),
              title: Text(
                'Categories',
                style: GoogleFonts.poppins(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _controller.categories
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${c.iconPath} ${c.name}',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textSecondary.withValues(alpha: 0.7),
                                fontSize: 12,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Body ──────────────────────────────────────────────────────────
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (_controller.cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${_controller.cartCount}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? AppTheme.accent : AppTheme.textSecondary),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
