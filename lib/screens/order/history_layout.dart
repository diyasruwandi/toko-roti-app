import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int selectedNavIndex = 3; // Profil/riwayat masih dianggap bagian profil

  // Data dummy - nanti diganti hasil fetch GET /api/orders
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': '#CC-9281',
      'date': 'Hari ini, 10:45',
      'status': 'pending',
      'items':
          'Sourdough Country (1), Croissant Almond (2), Iced Oat Latte (1)',
      'total': 148000,
    },
    {
      'orderId': '#CC-8842',
      'date': '12 Okt 2023, 08:30',
      'status': 'selesai',
      'items': 'Pain au Chocolat (2), Earl Grey Scone (1), Hot Americano (1)',
      'total': 112500,
    },
    {
      'orderId': '#CC-8519',
      'date': '05 Okt 2023, 14:15',
      'status': 'selesai',
      'items': 'Whole Grain Loaf (1), Avocado Toast (1), Cold Brew (1)',
      'total': 95000,
    },
  ];

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color tertiaryFixed = Color(0xFFFFDCBB);
  static const Color onTertiaryFixed = Color(0xFF2B1701);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E2);
  static const Color outlineVariant = Color(0xFFBFC9C4);

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
                      color: surfaceContainerHigh,
                    ),
                    child: const Icon(Icons.person, color: primary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Pesanan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1B18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lacak dan lihat kembali momen roti favorit Anda.',
                      style: TextStyle(color: onSurfaceVariant, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Order list
                    if (orders.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final isPending = order['status'] == 'pending';

                          return GestureDetector(
                            onTap: () {
                              // TODO: navigasi ke detail order kalau diperlukan
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: isPending
                                    ? Border.all(
                                        color: primary.withValues(alpha: 0.05),
                                      )
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryContainer.withValues(alpha: 0.06),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ORDER ${order['orderId']}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              letterSpacing: 1,
                                              color: onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            order['date'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isPending
                                              ? tertiaryFixed
                                              : primaryContainer.withValues(
                                                  alpha: 0.15,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isPending
                                                  ? Icons.schedule
                                                  : Icons.check_circle,
                                              size: 13,
                                              color: isPending
                                                  ? onTertiaryFixed
                                                  : primary,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isPending ? 'Pending' : 'Selesai',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isPending
                                                    ? onTertiaryFixed
                                                    : primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: primary.withValues(alpha: 0.1),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      order['items'],
                                      style: TextStyle(
                                        color: onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              color: onSurfaceVariant,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            formatRupiah(order['total']),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),

                    // Bento grid: promo + loyalty points
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -10,
                                right: -10,
                                child: Icon(
                                  Icons.bakery_dining,
                                  size: 80,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ingin pesan lagi?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Sourdough Country favorit Anda sedang tersedia hangat dari oven.',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      // TODO: pesan ulang -> tambah item ke cart
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primaryContainer,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Pesan Ulang',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: outlineVariant,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.loyalty,
                                color: primary,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Poin Loyalitas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '450',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                ),
                              ),
                              Text(
                                'TUKARKAN DI PESANAN BERIKUTNYA',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1,
                                  color: onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: primaryContainer.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Beranda', 0),
                _buildNavItem(Icons.storefront, 'Produk', 1),
                _buildNavItem(Icons.shopping_cart, 'Keranjang', 2),
                _buildNavItem(Icons.person, 'Profil', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada riwayat pesanan',
            style: TextStyle(color: onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedNavIndex = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primary : onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primary : onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
