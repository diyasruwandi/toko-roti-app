import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../routes/app_pages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedNavIndex = 3; // Profil aktif
  String? currentAvatarUrl;

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFFFF8F5);
  static const Color surfaceContainerHighest = Color(0xFFE9E1DC);
  static const Color error = Color(0xFFBA1A1A);
  static const Color outline = Color(0xFF707975);

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    final prefs = await SharedPreferences.getInstance();
    String? savedAvatar;
    if (user != null && user.email.isNotEmpty) {
      savedAvatar = prefs.getString(
        'user_avatar_${user.email.trim().toLowerCase()}',
      );
    }
    savedAvatar ??= prefs.getString('user_avatar');

    setState(() {
      currentAvatarUrl = savedAvatar;
    });
  }

  Future<void> _saveAvatar(String newUrl) async {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    final prefs = await SharedPreferences.getInstance();
    if (user != null && user.email.isNotEmpty) {
      await prefs.setString(
        'user_avatar_${user.email.trim().toLowerCase()}',
        newUrl,
      );
    }
    await prefs.setString('user_avatar', newUrl);

    setState(() {
      currentAvatarUrl = newUrl;
    });

    Get.snackbar(
      'Berhasil',
      'Foto profil berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryContainer,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

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
              Get.find<AuthController>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: error)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(String? url, {double iconSize = 48}) {
    if (url == null || url.trim().isEmpty) {
      return Container(
        color: surfaceContainerHighest,
        child: Icon(Icons.person, size: iconSize, color: primary),
      );
    }

    final isNetworkUrl =
        url.startsWith('http://') || url.startsWith('https://');

    if (isNetworkUrl) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(
          color: surfaceContainerHighest,
          child: Icon(Icons.person, size: iconSize, color: primary),
        ),
      );
    } else {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: surfaceContainerHighest,
            child: Icon(Icons.person, size: iconSize, color: primary),
          ),
        );
      } else {
        return Container(
          color: surfaceContainerHighest,
          child: Icon(Icons.person, size: iconSize, color: primary),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (image != null) {
        Get.back();
        await _saveAvatar(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showAvatarPickerModal() {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      Get.snackbar(
        'Akses Dibatasi',
        'Silakan Login terlebih dahulu untuk mengubah foto profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryContainer,
        colorText: Colors.white,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ubah Foto Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pilih foto dari Galeri HP Anda atau ambil foto baru dengan Kamera.',
                style: TextStyle(fontSize: 13, color: onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              // Opsi 1: Galeri & Kamera HP
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Galeri HP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Kamera'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: const BorderSide(color: primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
  }

  void _showEditProfileDialog() {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      Get.snackbar(
        'Akses Dibatasi',
        'Silakan Login terlebih dahulu untuk mengedit profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryContainer,
        colorText: Colors.white,
      );
      return;
    }
    final user = authController.currentUser.value;
    final nameEditController = TextEditingController(text: user?.name ?? '');
    final phoneEditController = TextEditingController(text: user?.phone ?? '');

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameEditController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.person, color: primary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneEditController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                prefixIcon: Icon(Icons.phone, color: primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (user != null) {
                final newName = nameEditController.text.trim();
                final newPhone = phoneEditController.text.trim();
                final prefs = await SharedPreferences.getInstance();
                if (user.email.isNotEmpty) {
                  await prefs.setString(
                    'user_phone_${user.email.trim().toLowerCase()}',
                    newPhone,
                  );
                }
                await prefs.setString('user_phone', newPhone);

                authController.currentUser.value = UserModel(
                  id: user.id,
                  name: newName.isNotEmpty ? newName : user.name,
                  email: user.email,
                  phone: newPhone,
                );
              }
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Profil berhasil diperbarui',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: primaryContainer,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showSettingsModal() {
    bool pushNotif = true;
    bool soundEffects = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pengaturan Aplikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeTrackColor: primary,
                    title: const Text('Notifikasi Promo & Pesanan'),
                    subtitle: const Text(
                      'Dapatkan info roti hangat dan promo diskon',
                    ),
                    value: pushNotif,
                    onChanged: (val) => setModalState(() => pushNotif = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeTrackColor: primary,
                    title: const Text('Efek Suara'),
                    subtitle: const Text(
                      'Suara animasi saat memasukkan roti ke keranjang',
                    ),
                    value: soundEffects,
                    onChanged: (val) => setModalState(() => soundEffects = val),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.language, color: primary),
                    title: const Text('Bahasa Aplikasi'),
                    trailing: const Text(
                      'Bahasa Indonesia (ID)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Get.snackbar(
                        'Bahasa',
                        'Aplikasi saat ini menggunakan Bahasa Indonesia',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showStoreLocationsModal() {
    final stores = [
      {
        'name': 'Crust & Co. Flagship Sudirman',
        'address': 'Jl. Jend. Sudirman No. 45, Jakarta Pusat',
        'hours': '07:00 - 21:00 WIB',
        'phone': '(021) 555-0192',
      },
      {
        'name': 'Crust & Co. Senopati Bakery',
        'address': 'Jl. Senopati No. 88, Kebayoran Baru, Jakarta Selatan',
        'hours': '08:00 - 22:00 WIB',
        'phone': '(021) 555-0844',
      },
      {
        'name': 'Crust & Co. PIK Avenue',
        'address': 'Pantai Indah Kapuk Ave Lt. Ground, Jakarta Utara',
        'hours': '09:00 - 21:30 WIB',
        'phone': '(021) 555-0371',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.storefront, color: primary, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Lokasi Toko Roti',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: stores.length,
                  separatorBuilder: (_, __) => const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                store['address']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Buka: ${store['hours']!}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
                    children: [
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Avatar + edit button
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _showAvatarPickerModal,
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryContainer.withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _buildAvatarImage(
                                currentAvatarUrl,
                                iconSize: 48,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showAvatarPickerModal,
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
                    Obx(() {
                      final user = Get.find<AuthController>().currentUser.value;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: _showEditProfileDialog,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user?.name ?? 'Pengguna Tamu',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: primary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: primary,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'Tamu',
                            style: TextStyle(
                              color: onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          if (user?.phone != null && user!.phone!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                user.phone!,
                                style: TextStyle(
                                  color: onSurfaceVariant,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),

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
                              Get.toNamed(Routes.orderHistory);
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildMenuItem(
                            icon: Icons.favorite,
                            label: 'Produk Favorit Saya',
                            onTap: () {
                              Get.toNamed(Routes.favorites);
                            },
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildMenuItem(
                            icon: Icons.settings,
                            label: 'Pengaturan',
                            onTap: _showSettingsModal,
                          ),
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          _buildMenuItem(
                            icon: Icons.location_on,
                            label: 'Lokasi Toko',
                            onTap: _showStoreLocationsModal,
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
                          border: Border.all(
                            color: error.withValues(alpha: 0.2),
                          ),
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
        switch (index) {
          case 0:
            Get.offAllNamed(Routes.home);
            break;
          case 1:
            Get.toNamed(Routes.productList);
            break;
          case 2:
            Get.toNamed(Routes.cart);
            break;
          case 3:
            break; // sudah di Profil
        }
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
