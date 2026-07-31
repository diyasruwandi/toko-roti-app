import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/product_model.dart';
import '../../routes/app_pages.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  late Map<String, dynamic> product;
  late int stock;
  late ProductModel currentProductModel;
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is ProductModel) {
      currentProductModel = args;
      product = {
        'id': args.id,
        'name': args.name,
        'price': args.price.toInt(),
        'rating': 4.9,
        'reviewCount': 120,
        'image': args.image ?? '',
        'description':
            args.description ?? 'Roti berkualitas dari bahan pilihan terbaik.',
      };
      stock = args.stock > 0 ? args.stock : 10;
    } else if (args is Map<String, dynamic>) {
      product = args;
      stock = args['stock'] ?? 8;
      currentProductModel = ProductModel(
        id: args['id'] is int ? args['id'] : int.tryParse(args['id'].toString()) ?? 1,
        name: args['name']?.toString() ?? '',
        description: args['description']?.toString(),
        price: double.tryParse(args['price']?.toString() ?? '0') ?? 0.0,
        image: args['image']?.toString(),
        stock: stock,
      );
    } else {
      product = {
        'id': 1,
        'name': 'Roti Pilihan',
        'price': 25000,
        'rating': 4.8,
        'reviewCount': 50,
        'image': '',
        'description': 'Roti lezat buatan sendiri dengan kehangatan khas oven.',
      };
      stock = 8;
      currentProductModel = ProductModel(
        id: 1,
        name: 'Roti Pilihan',
        price: 25000,
        stock: 8,
        description: 'Roti lezat buatan sendiri dengan kehangatan khas oven.',
      );
    }
  }

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
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E2);
  static const Color tertiaryContainer = Color(0xFFE6C09A);

  String formatRupiah(num price) {
    return 'Rp ${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  num get totalPrice => quantity * (product['price'] as num);

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
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      Get.snackbar(
        'Perhatian',
        'Silakan login terlebih dahulu untuk menambahkan produk ke keranjang',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
      Get.toNamed(Routes.login);
      return;
    }

    final cartController = Get.find<CartController>();
    ProductModel model;
    final args = Get.arguments;
    if (args is ProductModel) {
      model = args;
    } else {
      model = ProductModel(
        id: product['id'] is int ? product['id'] : 0,
        name: product['name']?.toString() ?? 'Roti',
        description: product['description']?.toString(),
        price: (product['price'] as num).toDouble(),
        image: product['image']?.toString(),
        stock: stock,
      );
    }

    cartController.addProduct(model, quantity: quantity);
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
                        const Spacer(),
                        Obx(() {
                          final isFav = favoriteController.isFavorite(currentProductModel.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : primary,
                              size: 24,
                            ),
                            onPressed: () => favoriteController.toggleFavorite(currentProductModel),
                            tooltip: 'Favorit (SQLite)',
                          );
                        }),
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
