import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedNavIndex = 3; // Profil aktif

  // Data dummy - nanti diganti hasil fetch GET /api/profile
  final String userName = 'Aditya Pratama';
  final String userEmail = 'aditya.pratama@email.com';
  final String? avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAp58K084AR1WkoWyUKjJvfGCb2BpkHgyB0cDuvzD6jft79diz83I92zsur7JXxwkwZUauK4t36a6SIYnc8b5wuddcvaHgJj6ALB7ca5vV5ivbk6qjoBDyFCTpM8yucAppQeMhmSatf8je6L_6Dax_nmwcZOz266Ce5mo-vuC8vrR47sNwqP4gLudWbIN6QIhc6s906EEz9PfeKM85nXonKuMkb4Hc5V5V7WjbIlHQpyWiJrMXKs7sd0EoVRoCA7XywfK6kW0RZzAqf';

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFFFF8F5);
  static const Color surfaceContainerHighest = Color(0xFFE9E1DC);
  static const Color error = Color(0xFFBA1A1A);
  static const Color loyaltyGold = Color(0xFFD9B48F);
  static const Color outline = Color(0xFF707975);

  void handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Get.find<AuthController>().logout();
              // TODO: Get.offAllNamed('/login');
            },
            child: const Text('Logout', style: TextStyle(color: error)),
          ),
        ],
      ),
    );
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
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Avatar + edit button
                    Stack(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: primaryContainer.withValues(alpha: 0.08),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: avatarUrl != null
                                ? Image.network(
                                    avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      color: surfaceContainerHighest,
                                      child: const Icon(
                                        Icons.person,
                                        size: 48,
                                        color: primary,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: surfaceContainerHighest,
                                    child: const Icon(
                                      Icons.person,
                                      size: 48,
                                      color: primary,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: navigasi ke ganti foto profil
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userEmail,
                      style: TextStyle(color: onSurfaceVariant, fontSize: 14),
                    ),

                    const SizedBox(height: 12),

                    // Loyalty chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: loyaltyGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars, size: 16, color: primary),
                          SizedBox(width: 6),
                          Text(
                            'Loyalty Member',
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Menu list
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryContainer.withValues(alpha: 0.06),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.history,
                            label: 'Riwayat Pesanan',
                            onTap: () {
                              // Get.toNamed('/order-history');
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildMenuItem(
                            icon: Icons.settings,
                            label: 'Pengaturan',
                            onTap: () {
                              // TODO: navigasi ke halaman pengaturan
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildMenuItem(
                            icon: Icons.location_on,
                            label: 'Lokasi Toko',
                            onTap: () {
                              // TODO: navigasi ke halaman lokasi toko
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logout button
                    GestureDetector(
                      onTap: handleLogout,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: error.withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: primaryContainer.withValues(alpha: 0.06),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    color: error,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: error,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: error.withValues(alpha: 0.4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Footer
                    Text(
                      'VERSI 2.4.0 • DIBUAT DENGAN CINTA',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bakery_dining,
                          size: 36,
                          color: primary.withValues(alpha: 0.1),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.coffee,
                          size: 36,
                          color: primary.withValues(alpha: 0.1),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.breakfast_dining,
                          size: 36,
                          color: primary.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primary, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: outline),
          ],
        ),
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
