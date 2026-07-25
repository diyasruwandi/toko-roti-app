import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 0;
  int selectedNavIndex = 0;

  final List<String> categories = ['Semua', 'Roti', 'Kue', 'Donat', 'Promo'];

  // Data dummy - nanti diganti hasil fetch dari API (GET /api/products)
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Butter Croissant',
      'price': 25000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAgQikvxnAaysAHn2pMmjlz46JU0tiMJo7G_D9oQFUVDq_EjRrqv8UvxEt7KRPRhpTJwnzuzkl7cJezdw_3VLTzI00tGFziN44dwkxKyDEg3TIH6R8Gw0MWTKX-2iEWJft33V8jJb32AXMK8F31vcfOIBcWoy720OCLomtpA6WlPEslNWYrVdzHAVlx5-2MsFrTiqyhan2qDhdZurC004fiAf8U_z5K0kpLHPlGF3laErtLKnkL8T8b7yNiuNJVYv2mbFW2hkVQN2Ii',
    },
    {
      'name': 'Classic Brioche',
      'price': 35000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDt2-eyHUwqOtvtG3Bp81rh-zPceIzJEwocmv_Qp2qCVmSGckQqD4lmY72J5eGVq_kSVUq0BCEGxP4vW7DVj7SDc_xtODOoBg6IDJk8f67YbyGn4c-L9cYjGQ9LyV_RdcphY_UiegNCZMktcxTdV76U7vqppG1GapdToXgA8JkrQa0IC9tiMPbd1ysmPY7Uuu44PAxxKnJyNolqLg0sS5Iy5YJSc8jaovqNZpkf9L8IezyoAikKJVIBY0s5GA8f6Z_tw35tRvujp6DJ',
    },
    {
      'name': 'Pain au Chocolat',
      'price': 28000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBoBRACIDPnGanKx-u1e8IZ1A0p0W8tleZPXMKUeiNOBYgzQ_vlEttNIEu2N3WEy3FNQKAqm7QMLi_bLFQjqkye5rLCvA4isX_bVbwYfNOKLPD8XMcH1-wJKNHWrlVeR5m7pbY4bp1-dXAqvtGoqNZJY2KT6Hv7nzUVVD2wdWtFOCIfZ_ErjATzl98dxq2QCMJ9xijT04iAYlcvu8bBRLX1uthtT6G2ndetclD89ZF8-Bsg28hqjg71qY8itMWWlIz_0GhDBOXv57Rk',
    },
    {
      'name': 'Cinnamon Roll',
      'price': 22000,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuA5PHrAgxGM-QhiYtVWwJ9iEjNXhxNFdQMTJH-7b8-miyUYSTokK6hwl0I3u7LWOD45dL-gNk7VLcQmA3W4EgkhEbDhbbEpNmJ36Bp5QMeuu58XktZWcpCtWNUKDGUEJNfCX77ca1P6_99DAx4OgZUhg-cIh227iJrM_fvea7dj9GVTLW7F_sG5aPGn-VpZOsloXIuY-nGWiHiQ5doNFZUnP9qSpjhhce3nbU5SZnESlYqzhsU_wdMCgcocBxZtdUsJYNMtUt4VmA_g',
    },
  ];

  // Palet warna dari config Stitch
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFFFF8F5);
  static const Color secondaryContainer = Color(0xFFE7E2DA);
  static const Color onSecondaryContainer = Color(0xFF67645E);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E2);

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void onAddToCart(Map<String, dynamic> product) {
    // TODO: cek login dulu, kalau belum login arahkan ke Login
    // TODO: kalau sudah login, panggil Get.find<CartController>().addItem(product)
    Get.snackbar(
      'Ditambahkan',
      '${product['name']} masuk ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bakery_dining,
                              color: primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo,',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                ),
                                const Text(
                                  'Aditya Wijaya', // TODO: ganti dari data user login
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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: surfaceContainerHigh,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBkevNnoe9nvV2y-dpbPST6NRw0_6Xro28AYK-_ws3qdPlcEdY-ssY0J_1o0cCH3FM3ELHeD6dJcAQt_Br6X2tXPp4O_E9Rxy7P6RnipfpNezC1-_OL78kTHB_0gzpW1PDlhq2MWE3-e8-ycrUz07kF4DVB9Czh303n9lwgx6chSBzJgClRfzrCxAJDej_60VI29z20mTdl12VuttfX8nBqQgF84V783r5dfmi2Zo39enpw8sMz5Oer_0-wC6YITiBl9wUggEKU-TOx',
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.person, color: primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Hero Banner
                      Container(
                        height: 180,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAncnxF1a0SPivfW1w7wgTeIu36r1f6-4R_X_LmOiuKasRtbBTNhN4pMRlbhfpuiOIey0PYaDpN2t8ntG86U-uWjz-Qs2HfFWt6ePwMQMjHT9I5u0v8dhtcqL5jnIOwAWvZSILugiYClK6W4DCezwqHDAvPV8eYehp7Q2cokpu9Ih1-nllYZp0SQAq8XnCKgLjSpDuLSZSTYMVp9QVEBpTJzE6wR4ZP24_bbNToN34YpIXRny5Ov9IRcYg_vZFsnv7rRosqopucgO_y',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                primary.withValues(alpha: 0.85),
                                primary.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'SPESIAL HARI INI',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Sourdough Klasik Crust & Co.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dibuat dengan ragi alami berusia 10 tahun.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Category chips
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final isSelected = selectedCategoryIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedCategoryIndex = index);
                                // TODO: filter produk sesuai kategori
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? primary
                                      : secondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : onSecondaryContainer,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Menu Populer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Get.toNamed('/products');
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Lihat Semua',
                                  style: TextStyle(color: primary),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Product grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.72,
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
                                borderRadius: BorderRadius.circular(16),
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
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      product['image'],
                                      height: 110,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        height: 110,
                                        color: secondaryContainer,
                                        child: const Icon(
                                          Icons.bakery_dining,
                                          color: primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
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
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: primary,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.shopping_cart,
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

                      const SizedBox(height: 24),

                      // Promo banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Langganan Mingguan?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dapatkan roti segar setiap pagi dengan diskon 15%.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pelajari Lebih Lanjut',
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.loyalty, color: primary),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // ruang buat bottom nav
                    ]),
                  ),
                ),
              ],
            ),

            // FAB - search
            Positioned(
              bottom: 96,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: primary,
                onPressed: () {
                  // TODO: navigasi ke search / product list
                },
                child: const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
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
        // 0: Home, 1: Product List, 2: Cart, 3: Profile
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
