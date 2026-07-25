import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Warna diambil dari config Stitch
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixedDim = Color(0xFF99D2C2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulasi pindah ke halaman berikutnya setelah 3.5 detik
    Timer(const Duration(milliseconds: 3500), () {
      // nanti diganti Get.offAll(() => LoginScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryContainer,
      body: Stack(
        children: [
          // Decorative floating icons (opsional, bisa dihapus kalau ribet)
          Positioned(
            top: 80,  
            left: 40,
            child: Icon(
              Icons.bakery_dining,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            bottom: 160,
            right: 40,
            child: Icon(
              Icons.grass,
              size: 100,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            top: 250,
            right: 80,
            child: Icon(
              Icons.cake,
              size: 60,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuD4Vbv8bDOFTZu72jbf938W6GR9jZPFFFGAT2d4m8d9Uwj7FBy3wNrX7Yq6eGPtiqUwojaPBb3ycEd_8P5iZgSM82Qjqcv0L2LFrYs6-PEFTLkPZWIBh_znQiJiDngrK68qmAgNdgOTZFI3tFADkZ_KbB5bFLTwBq0-KPullvjwRzqdZsAxwpmvAXCSarkWk9kufSAkk-bRb87CFK6Lm2_8tC5Bcetg4kmr7A_L8XMWQvPVTQ3-40ZbWKi-1ymle4M9NE7R0acRSXFu',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.bakery_dining,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Brand name
                Text(
                  'CRUST & CO.',
                  style: TextStyle(
                    color: onPrimary.withValues(alpha: 0.9),
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ARTISANAL BAKERY',
                  style: TextStyle(
                    color: primaryFixedDim.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),

          // Bottom loading indicator
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 2,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Container(color: Colors.white.withValues(alpha: 0.1)),
                            Align(
                              alignment: Alignment(
                                -1 + (_controller.value * 2.8), // efek geser
                                0,
                              ),
                              child: Container(
                                width: 48,
                                height: 2,
                                color: primaryFixedDim,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'MENYIAPKAN ADONAN...',
                  style: TextStyle(
                    color: primaryFixedDim.withValues(alpha: 0.4),
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
