// screens/about_screen.dart
// About / Profile screen for The Peak Shop

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openInstagram() async {
    const url = 'https://www.instagram.com/thepeak.jo?igsh=MWV3Yzl0OXBoeG0xbg==';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── Store Logo / Header ──────────────────────────────────────────
          ClipOval(
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'THE PEAK',
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 4,
            ),
          ),
          Text(
            'Official Gymshark Retailer — Jordan',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 32),

          // ── About Card ───────────────────────────────────────────────────
          _infoCard(
            title: 'About The Store',
            content:
                'The Peak is Jordan\'s premier Gymshark retailer, bringing the world\'s best performance sportswear directly to athletes in the region. We offer authentic Gymshark products with fast local delivery.',
          ),

          const SizedBox(height: 16),

          // ── Developer Card ───────────────────────────────────────────────
          _infoCard(
            title: 'App Developer',
            content: 'Hamza Baddad\nSoftware Engineering\nMiddle East University (MEU)',
          ),

          const SizedBox(height: 16),

          // ── Contact Info ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: GoogleFonts.poppins(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                _contactRow(Icons.location_on_outlined, 'Amman, Jordan'),
                const SizedBox(height: 10),
                _contactRow(Icons.phone_outlined, '+962 790929607'),
                const SizedBox(height: 10),
                _contactRow(Icons.email_outlined, 'hbaddad@gmail.com'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Instagram Button ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openInstagram,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE1306C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              label: Text(
                'Follow on Instagram',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── App Version ───────────────────────────────────────────────────
          Text(
            'Version 1.0.0 • Built with Flutter',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppTheme.accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 18),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: AppTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
