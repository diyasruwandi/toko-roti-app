import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  final int stock = 8;

  // Data dummy - nanti diganti data asli dari argument navigasi / API
  final Map<String, dynamic> product = {
    'name': 'Authentic 24-Hour Fermented Sourdough',
    'price': 65000,
    'rating': 4.9,
    'reviewCount': 120,
    'image':
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA5GPLCSrOdC4fL7Ajv5ftLyAkZXXVTM1OCH1G8rddoqn7HS8xbl1kZFY7h_z2VrbS90d0A7Zt8gp8Gd6kbj-88kzUcax2272uIxzCyiLNmdJMduUTVWt0OFmydbJgJiZH--dJqlj4PhWKLlTYcr9_ht65xaPnrQzKyYPvhrCZy7yZe7KviYgjMw14VxXIXCsSiUWjlDll-rFJuQlUji0EpQoKyYp8Y5nzcyyLhlO9XgKIZmQ9hMrfSkGN_mfnIAWgevrTxL9--QLXn',
    'description':
        "Rasakan kemewahan tekstur roti sourdough kami yang difermentasi selama 24 jam penuh secara natural. Dibuat menggunakan teknik artisanal tradisional dengan 'starter' yang telah dipelihara selama 5 tahun, menghasilkan kerak yang renyah (crusty) dan bagian dalam yang sangat lembut (airy) dengan aroma asam yang seimbang.",
  };

  final List<Map<String, dynamic>> complements = [
    {
      'name': 'Salted Butter',
      'price': 12000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBlF9GwNlxOLlVJguMHHEs_2d6mngF3RIAMjRuKZo69ML-SlcHREfERYKea0afFgHocf0U37hxwxkcdl8wjnq36xu1-xNLRTPkoYxrsFFCTy15XLFr2QyNPgoDVzbM-0C2JS2XPmwpRbRIz856JlZys-VQDjLU1iOe2PtDOd6AxR0Vc3uukJsjhvDi3V8nInO4gwByJKcOIE9AwlBz66QwQ96p193vfRo33b_WpyAaQzBp1SzYBfQnijpnYrulGfa08oWJ7xWUITSz_',
    },
    {
      'name': 'Raspberry Jam',
      'price': 15000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBtZg9o2gcjqoIIn6kN4XIgtgyOBfUs0uqmJtVkG7Px4VwXz2aXZ4NruYtFIARidUPZeCYHowSSMYc8A4xxQKWEn3xtjDbEN5Y1gnhm5czHyb9kcATXb7clkzuTbSYmDVnnfCyEfGPcpQMGg1_F-YQdHC5KccHLWQ9fhlQ6SxkBqRCkfjGjiVaiccJiuPmV92N5uaZW9fWybRiICQ2Q10ze5xLFh48nhaB5JiktWLYf7Z9oE2G-sdfi2xy8JdBDRnNUGd6MZbxIGoIW',
    },
  ];

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E2);
  static const Color tertiaryContainer = Color(0xFFE6C09A);

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  int get totalPrice => quantity * (product['price'] as int);

  void increaseQty() {
    if (quantity < stock) {
      setState(() => quantity++);
    }
  }

  void decreaseQty() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  void addToCart() {
    // TODO: cek login dulu, kalau belum login arahkan ke Login
    // TODO: Get.find<CartController>().addItem(product, quantity);
    Get.snackbar(
      'Ditambahkan',
      '$quantity x ${product['name']} masuk ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back, color: primary),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.bakery_dining,
                          color: primary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Crust & Co.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero image
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    product['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: surfaceContainerHigh,
                      child: const Icon(
                        Icons.bakery_dining,
                        size: 60,
                        color: primary,
                      ),
                    ),
                  ),
                ),

                // Content card
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category chips
                        Row(
                          children: [
                            _buildTagChip('Artisan'),
                            const SizedBox(width: 8),
                            _buildTagChip('Best Seller'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Title & price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              formatRupiah(product['price']),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rating & info
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: tertiaryContainer,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product['rating']} (${product['reviewCount']}+ Ulasan)',
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.schedule,
                              color: onSurfaceVariant,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Hanya Pagi',
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Divider(color: primary.withValues(alpha: 0.1)),
                        const SizedBox(height: 20),

                        // Description
                        const Text(
                          'Deskripsi Produk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureRow('100% Bahan Organik Premium'),
                        const SizedBox(height: 6),
                        _buildFeatureRow('Tanpa Pengawet & Ragi Instan'),

                        const SizedBox(height: 24),

                        // Quantity selector
                        const Text(
                          'Jumlah',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: decreaseQty,
                                    icon: const Icon(
                                      Icons.remove,
                                      color: primary,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    child: Text(
                                      '$quantity',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: increaseQty,
                                    icon: const Icon(
                                      Icons.add,
                                      color: primary,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Sisa stok: $stock pcs',
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Complementary products
                        const Text(
                          'Pelengkap Sempurna',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: complements.map((item) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: primary.withValues(alpha: 0.05),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          item['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(
                                            color: surfaceContainerHigh,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: primary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      formatRupiah(item['price']),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom action bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            color: onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          formatRupiah(totalPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_cart, size: 20),
                        label: const Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tertiaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: primary,
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: onSurfaceVariant, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
