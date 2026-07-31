import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../routes/app_pages.dart';
import '../../services/pdf_receipt_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int selectedNavIndex = 3; // Profil/riwayat dianggap bagian profil
  final OrderController orderController = Get.find<OrderController>();

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color tertiaryFixed = Color(0xFFFFDCBB);
  static const Color onTertiaryFixed = Color(0xFF2B1701);

  String formatRupiah(num price) {
    return 'Rp ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  void initState() {
    super.initState();
    orderController.fetchOrders();
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: primary),
                        onPressed: () => Get.back(),
                        tooltip: 'Kembali',
                      ),
                      const SizedBox(width: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/images/logoroti22.png',
                          width: 26,
                          height: 26,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.bakery_dining,
                            color: primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Crust & Co.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                color: primary,
                onRefresh: () => orderController.fetchOrders(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      Obx(() {
                        if (orderController.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(color: primary),
                            ),
                          );
                        }

                        if (orderController.orders.isEmpty) {
                          return _buildEmptyState();
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderController.orders.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final order = orderController.orders[index];
                            final isPending =
                                order.status.toLowerCase() == 'pending';

                            return Container(
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
                                    color: primaryContainer.withValues(
                                      alpha: 0.06,
                                    ),
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
                                            'ORDER ${order.orderCode}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              letterSpacing: 1,
                                              color: onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            order.formattedDate,
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
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: primary.withValues(alpha: 0.1),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      order.itemsSummary,
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
                                      Text(
                                        'Total Pembayaran',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        formatRupiah(order.totalPrice),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            PdfReceiptService.instance
                                                .previewPdf(context, order);
                                          },
                                          icon: const Icon(
                                            Icons.picture_as_pdf,
                                            size: 16,
                                          ),
                                          label: const Text(
                                            'Preview Struk PDF',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: primary,
                                            side: const BorderSide(
                                              color: primary,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final file = await PdfReceiptService
                                                .instance
                                                .downloadAndSavePdf(order);
                                            if (file != null) {
                                              Get.snackbar(
                                                'PDF Tersimpan',
                                                'Struk PDF berhasil diunduh ke: ${file.path}',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    primaryContainer,
                                                colorText: Colors.white,
                                                duration: const Duration(
                                                  seconds: 4,
                                                ),
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Gagal',
                                                'Gagal mengunduh file PDF',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.download,
                                            size: 16,
                                          ),
                                          label: const Text(
                                            'Download PDF',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: primary.withValues(alpha: 0.08)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedNavIndex,
          onTap: (index) {
            if (index == selectedNavIndex) return;
            switch (index) {
              case 0:
                Get.offAllNamed(Routes.home);
                break;
              case 1:
                Get.offAllNamed(Routes.productList);
                break;
              case 2:
                Get.toNamed(Routes.cart);
                break;
              case 3:
                Get.offAllNamed(Routes.profile);
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primary,
          unselectedItemColor: onSurfaceVariant,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Produk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Keranjang',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada riwayat pesanan',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pesanan Anda akan muncul di sini setelah Anda melakukan transaksi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
