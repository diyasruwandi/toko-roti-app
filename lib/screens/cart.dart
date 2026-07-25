import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Data dummy - nanti diganti data dari CartController (GetX)
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Almond Croissant',
      'subtitle': 'Buttery & Flaky',
      'price': 35000,
      'qty': 1,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBOcai3-9cNX-19Nh3JBbhlkad2RA0CMv8-e638-UOOOhScsztOuN9BTn5DJaZfz-e19oJaHASJ0NmYfmEQ29OQ0aH6Kv5h7rdbGjs3c3IjoY_Ib1dOgbdt10CuWiTCYniDHJzY_D_jeZAlC0H96qBGaV37Z_3hes4JzR20oC6e6VyNZX8VZ5JKVgi0ajJH625prLk0HLpi0T0pXoI8HNboULYmCiKXxacP0Iv5mjYYTyoI-XzLvQesNpSWK6t4RrtZrUMnphpGWnzq',
    },
    {
      'name': 'Artisan Sourdough',
      'subtitle': 'Ragi Alami 24 Jam',
      'price': 55000,
      'qty': 1,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDOvmwioAzGhb55N6ghtjv-Dym6bW_A33QKFIZOyk3PBAZVKsqQyk-NpOJ3PBIzjdYLWYJwFuq4LN8tyn5X0nmpDPfkMRpHwfsTlBzcjXwMsyvGaaUJi8XzvCrqRgP7Ed9Ku1-LFZT6PZi0zeYEx3LGy7RXkEAr1zGNVoIh2q8xAPSHt-yBZTQbsesRIZX5sjFIulf71nl-ed95bW46fnAn5e0SXYBKoxU5TCNnGEqv4f9crpY4D7Tocm-HPfm2omGjuLXWEF9Fz89m',
    },
    {
      'name': 'Oat Milk Latte',
      'subtitle': 'Double Shot Espresso',
      'price': 42000,
      'qty': 2,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBTiHk-4Z-HZudZ9O9XctQXx-CDxA_dygOgBSBYIokoXeVBBQypZ_C5aRsfvH7_psD67t8DSyA9f1yaiyS2WnGhNIc7YeqJwjbRs_1eSeBa9Psct1DOv-aDWs52argUBvq1qfUfClEWsQdZmCyqros-J0kWM0r89_7Hhy-RI72oEeOV98yDODeu_B6pgapybPbyIF6-fXhU7i9ksbbjsm5dQvCxqsndigGV2Qjpb_I0w5sAbtLa6imZffJiCECVMNO8pbXS0uhztaBC',
    },
  ];

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surfaceContainer = Color(0xFFF5ECE7);
  static const Color error = Color(0xFFBA1A1A);

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  int get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item['price'] as int) * (item['qty'] as int),
  );

  int get total => subtotal; // biaya pengiriman gratis

  void increaseQty(int index) {
    setState(() => cartItems[index]['qty']++);
  }

  void decreaseQty(int index) {
    setState(() {
      if (cartItems[index]['qty'] > 1) {
        cartItems[index]['qty']--;
      }
    });
  }

  void removeItem(int index) {
    final removedName = cartItems[index]['name'];
    setState(() => cartItems.removeAt(index));
    Get.snackbar(
      'Dihapus',
      '$removedName dihapus dari keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void clearAll() {
    setState(() => cartItems.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
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
                      color: surfaceContainer,
                    ),
                    child: const Icon(Icons.person, color: primary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: cartItems.isEmpty
                  ? _buildEmptyCart()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 220),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Keranjang Belanja',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                  Text(
                                    'Anda memiliki ${cartItems.length} item dalam pesanan.',
                                    style: TextStyle(
                                      color: onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: clearAll,
                                child: const Text(
                                  'Hapus Semua',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Cart items with swipe-to-delete
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Dismissible(
                                key: Key(item['name'] + index.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: error,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (_) => removeItem(index),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
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
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item['image'],
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(
                                            width: 80,
                                            height: 80,
                                            color: surfaceContainer,
                                            child: const Icon(
                                              Icons.bakery_dining,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              item['subtitle'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: onSurfaceVariant,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  formatRupiah(item['price']),
                                                  style: const TextStyle(
                                                    color: primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: surfaceContainer,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                        iconSize: 18,
                                                        icon: const Icon(
                                                          Icons.remove,
                                                          color: primary,
                                                        ),
                                                        onPressed: () =>
                                                            decreaseQty(index),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                            ),
                                                        child: Text(
                                                          '${item['qty']}',
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                        iconSize: 18,
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: primary,
                                                        ),
                                                        onPressed: () =>
                                                            increaseQty(index),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Promo code button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: primary.withValues(alpha: 0.3),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.sell, color: primary),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Gunakan kode promo',
                                      style: TextStyle(
                                        color: onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.chevron_right, color: primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(color: onSurfaceVariant),
                          ),
                          Text(
                            formatRupiah(subtotal),
                            style: TextStyle(color: onSurfaceVariant),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Biaya Pengiriman',
                            style: TextStyle(color: onSurfaceVariant),
                          ),
                          const Text(
                            'GRATIS',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatRupiah(total),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Get.toNamed('/checkout');
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
                            'Lanjut ke Pembayaran',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang belanja kosong',
            style: TextStyle(color: onSurfaceVariant, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
