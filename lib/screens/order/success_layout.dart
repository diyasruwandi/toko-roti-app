import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:math';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Data dummy - nanti diganti data order asli hasil response POST /api/orders
  final String orderId = '#CC-82910';
  final String estimatedTime = '25 - 35 Menit';
  final int totalPayment = 128500;

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color outlineVariant = Color(0xFFBFC9C4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.3,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.05,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bakery_dining, color: primary, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Crust & Co.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEFE6E2),
                    ),
                    child: const Icon(Icons.person, color: primary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Animated checkmark
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: primaryContainer,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryContainer.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 56,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Pesanan Berhasil Dibuat!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sesaat lagi aroma roti segar akan menghampiri Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: onSurfaceVariant, fontSize: 14),
                    ),

                    const SizedBox(height: 28),

                    // Order summary card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: outlineVariant.withValues(alpha: 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryContainer.withValues(alpha: 0.06),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSummaryItem(
                            label: 'ID PESANAN',
                            value: orderId,
                            withDivider: true,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryItem(
                            icon: Icons.schedule,
                            label: 'Estimasi Kedatangan',
                            value: estimatedTime,
                            withDivider: true,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pembayaran',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                formatRupiah(totalPayment),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Featured image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 160,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB1Bb446LZXpngnbUopun06LAfsyxlCDw859zc9QTUeF5IqXTfnVKoMqZS69ZGnvjZeXcT62TxMvQEtXFro0f6JH6fcNFUHxL3qU-Tluu-gQJ-zXc3veBF77gL2qlu9WtJAsafOc0a-3lStgevr97_XE-WrDFHZVNOQJXW7qP-yD6k7MuFs7DBkHhLMTYpYTxKCr5FILz8wdCnvvyPPhhaXV3uJ-zcd985PbOQlaAMtY7wa-TshbKCrRdfBi0q2tXFFy2vFDDkLFFYk',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: const Color(0xFFEFE6E2),
                            child: const Icon(
                              Icons.bakery_dining,
                              size: 40,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Get.offNamed('/order-history');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        label: const Text(
                          'Lihat Pesanan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Get.offAllNamed('/home');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primary,
                          side: BorderSide(
                            color: primary.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.home, size: 18),
                        label: const Text(
                          'Kembali ke Beranda',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    IconData? icon,
    required String label,
    required String value,
    bool withDivider = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: onSurfaceVariant),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: onSurfaceVariant,
                    fontSize: 13,
                    letterSpacing: icon == null ? 1 : 0,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
        ),
        if (withDivider) ...[
          const SizedBox(height: 12),
          Divider(color: outlineVariant.withValues(alpha: 0.15), height: 1),
        ],
      ],
    );
  }
}
