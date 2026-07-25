import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController searchController = TextEditingController();
  int selectedFilterIndex = 0;
  int selectedNavIndex = 1; // "Produk" aktif

  final List<String> filters = [
    'Semua',
    'Croissant',
    'Sourdough',
    'Pastry',
    'Kopi',
    'Bebas Gluten',
  ];

  // Data dummy - nanti diganti hasil fetch GET /api/products
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Classic Croissant',
      'subtitle': 'Original French Butter',
      'price': 28000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB6o0biaZivR6Gh5FEXW9A5tYyy2xyBD4eD3EMmmhAkbBdd5RBUuR0TIQM-idXAONEC_eOvV53tYZtla5cqRl0iYn8HL3QRIR8Cs6p77ePkVa47-aFp52gvdi6M6TqVRx1XgEUeWFrarMQg3urqZX-VWelbJ1fAJUvuVGhupjezMHIs0U_X80moLe7yksZe7ijHrQ8abPxU1ulnpyu97SR0CRNGWZdd6zym7GFgilFBkCb1a-NR7LfFk1NhibhSlNbq0yXi7oSfYv9N',
    },
    {
      'name': 'Rustic Sourdough',
      'subtitle': 'Natural Fermentation',
      'price': 45000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB2RIOjAnzPjqZQmRm2UA8Xl0H8x910aAhBvH6rS4wCZWYQlm9_BY8RM8gEy7rG0l7AhGScPf6EgrPTpAffM83P7WEFFYart2rXjFw0cjCCfateCs1MknG65b3cakqgAQ-eaAI72Uw0QgU9ks9-dp2I0L26Yx0uo_X-HgdJyWvte_QAOCX5EQBPeIBP-hUy2LkjPzCrEBnIiFSTTSLyuf2mhP_c6gUrDVgODHlBXjJXa9QYUVbPjlcmCsEjYnmuag3kFHZtyQSsquGo',
    },
    {
      'name': 'Pain Au Chocolat',
      'subtitle': 'Belgian Dark Choco',
      'price': 32000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDRWnPxeqrn87_efGqqYo4Fs-WfpjjsBLwiicIdep2uOZd-8HjNR6sjeiz9XJqe-Rf289Ge2gsBOzaeNbAOO8TH7EapwM7Ic9_eRKujrWBU3V74maFVBsW24HDc_d3l0GNc3-7jE8AyDXCWWj8EorYoJ6EFYSxIt3uXEVBfZgn---psUpoED9qsmu8xBqawXdX9FxGS6-gyVVU_socGugJGIPVhgiyM4_l-nqBKjkVw1xL98oPiDFnUJ30qJHFpgoTKzeP875_EMkfl',
    },
    {
      'name': 'Almond Croissant',
      'subtitle': 'Twice Baked',
      'price': 35000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAoZ-OaUCJk0xAHD2yuz_ibOLSHEIjZYzXR2BZTu-VyIOOlqykwqbXh4QdxCftZnNeVP5LT2BtW3ebjf7JYylMue5knhzuKhXjTfn4WOdMl5bfXg2POP5YVVL8b6Z5lYHUXRdYTIao4jglpAhz0SUUkklhhG21WpLxFZR6034QJpg1V-xOLRBN7gzBRuaXkkugQMg3liq0u60W51xQ0jY7mMK5iOS59BawAl-XQ6UIR98wmtWLhdrbjcFYjZfucwjIoBL_7TZS5BUmL',
    },
    {
      'name': 'Cinnamon Roll',
      'subtitle': 'Cream Cheese Glaze',
      'price': 30000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCA7HjEjqI95NPftOff_SBpFjV2lB0UBQRX40dSMTxXBHJfemanydFngAljzjpMLFaL0l67BuVjgFCR5E9Ybj0szx35mC1hX9p0jJRXWdLLbv9uny-iY59FwzEdyA6IXIX6LIbC5CUp-OCfDS2DBY1gTpguv9P3Q-XeMR8tTpDZPKd9WmDJbxFCc_4BS7Aw9CaPBoEWtzJkt2gK9DfvOAES7lLgLZv93E140p4uufFNdmTewxhLTqVirfDcmHMaeirHcw9ikKCSwqLN',
    },
    {
      'name': 'Herbs Focaccia',
      'subtitle': 'Rosemary & Tomato',
      'price': 42000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBlIrnzrr6wpu04nQ_4wwmX6ZdD_efpzQpkKNKhJd-f-GLH3oSCWfOnmpkVLG8iqW7aiSAz2yF0dZCwKWR4miQTM4VQNq4GSTCgQv0osKOcy9dGa60qXGbo9CJZvn38EcWyizAh-gzvaAxMHkCR59HMGh9Sxn_WzQ56HfYCGcS3dK3HArzcP9dD9MyyPDtZsHsNPzAI4LhFMReLrYrDZ0bxj7lgqpx_sLOIvfKWwnKLkXAe4CkckjN9BWGl4snOj3baSp4w3H8G9f_7',
    },
  ];

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color secondaryContainer = Color(0xFFE7E2DA);
  static const Color onSecondaryContainer = Color(0xFF67645E);
  static const Color outline = Color(0xFF707975);

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void onAddToCart(Map<String, dynamic> product) {
    // TODO: cek login dulu; kalau belum, arahkan ke Login
    Get.snackbar(
      'Ditambahkan',
      '${product['name']} masuk ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryContainer.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBkJtY_6SeN2cidyAC1Mzcz8ynG5EtQRPEEHIdQOPMNglAeonZ4aiquQeT14gKdSvXwEk_9ZFpdxI8GIQ6Ya9OE-FQnLuxy_YDgkqixd_vjHG40O13xRzY_aiBs5NxaWgZl8KZJKOlmXtmZ5Bjz7vwCN0L_YqyaEa9zrT0s1mFmBzaoeOkOay2TOoHx5rUsq9zeSyAHXuz8bdlo9TZqW23ZWNrNdkslAksD1BsvIGlZSlOGsH_DyI6xqI0fVtsjw3G3Gytwmc0HN2tI',
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.person, color: primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari roti favoritmu...',
                    hintStyle: TextStyle(color: outline.withValues(alpha: 0.6)),
                    prefixIcon: Icon(Icons.search, color: outline),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) {
                    // TODO: filter produk berdasarkan pencarian
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedFilterIndex = index);
                      // TODO: filter produk sesuai kategori
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? primary : secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Product grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  100,
                ), // ruang bottom nav
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      // Get.toNamed('/product-detail', arguments: product);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: primaryContainer.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                  child: Image.network(
                                    product['image'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: secondaryContainer,
                                      child: const Icon(
                                        Icons.bakery_dining,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 16,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product['subtitle'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatRupiah(product['price']),
                                      style: const TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => onAddToCart(product),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
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
            ),
          ],
        ),
      ),

      // Bottom Navigation (sama seperti Home, "Produk" yang aktif)
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedNavIndex = index);
        // TODO: navigasi sesuai index
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.1)
              : Colors.transparent,
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
