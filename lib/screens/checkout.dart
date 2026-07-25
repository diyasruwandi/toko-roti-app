import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  double? latitude;
  double? longitude;
  bool isFetchingLocation = false;
  bool isSubmitting = false;

  // Data dummy ringkasan - nanti diambil dari CartController
  final int subtotal = 124000;
  final int shippingFee = 15000;
  final int memberDiscount = 10000;
  int get total => subtotal + shippingFee - memberDiscount;

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color outlineVariant = Color(0xFFBFC9C4);
  static const Color tertiaryFixed = Color(0xFFFFDCBB);
  static const Color onTertiaryFixedVariant = Color(0xFF5C4225);

  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    setState(() => isFetchingLocation = true);

    try {
      // Cek service lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Lokasi Nonaktif',
          'Silakan aktifkan layanan lokasi di HP Anda',
        );
        setState(() => isFetchingLocation = false);
        return;
      }

      // Cek & minta izin
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Izin Ditolak', 'Aplikasi butuh akses lokasi');
          setState(() => isFetchingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Izin Ditolak Permanen',
          'Aktifkan izin lokasi lewat pengaturan aplikasi',
        );
        setState(() => isFetchingLocation = false);
        return;
      }

      // Ambil posisi
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        isFetchingLocation = false;
      });

      Get.snackbar(
        'Berhasil',
        'Lokasi berhasil diambil',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      setState(() => isFetchingLocation = false);
      Get.snackbar('Gagal', 'Tidak bisa mengambil lokasi: $e');
    }
  }

  void confirmOrder() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      Get.snackbar('Perhatian', 'Lengkapi semua data pengiriman');
      return;
    }
    if (latitude == null || longitude == null) {
      Get.snackbar('Perhatian', 'Silakan ambil lokasi terlebih dahulu');
      return;
    }

    setState(() => isSubmitting = true);

    // TODO: sambungkan ke OrderService -> POST /api/orders
    // body: { customer_name, phone, address, latitude, longitude, items }
    // Setelah sukses -> Get.offNamed('/order-success');
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
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: primary),
                  ),
                  const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.shopping_basket, color: primaryContainer),
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
                    // Section: Informasi Pengiriman
                    const Text(
                      'Informasi Pengiriman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildUnderlineField(
                      label: 'Nama Lengkap',
                      controller: nameController,
                      hint: 'Masukkan nama lengkap Anda',
                    ),
                    const SizedBox(height: 16),
                    _buildUnderlineField(
                      label: 'Nomor Telepon',
                      controller: phoneController,
                      hint: '+62 812 3456 7890',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildUnderlineField(
                      label: 'Alamat Lengkap',
                      controller: addressController,
                      hint: 'Jl. Baker Street No. 221B, Jakarta Selatan',
                      maxLines: 3,
                    ),

                    const SizedBox(height: 24),

                    // Section: Pin Lokasi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pin Lokasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: isFetchingLocation
                              ? null
                              : getCurrentLocation,
                          icon: isFetchingLocation
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primary,
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  size: 18,
                                  color: primary,
                                ),
                          label: Text(
                            isFetchingLocation
                                ? 'Mengambil...'
                                : 'Gunakan Lokasi Saat Ini',
                            style: const TextStyle(
                              color: primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location preview card
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: primaryContainer.withValues(alpha: 0.06),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: latitude != null && longitude != null
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    color: primary.withValues(alpha: 0.05),
                                    child: const Center(
                                      child: Icon(
                                        Icons.map_outlined,
                                        size: 48,
                                        color: primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Lat: ${latitude!.toStringAsFixed(5)}, Lng: ${longitude!.toStringAsFixed(5)}',
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_off_outlined,
                                    color: onSurfaceVariant.withValues(
                                      alpha: 0.4,
                                    ),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Lokasi belum diambil',
                                    style: TextStyle(
                                      color: onSurfaceVariant.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Section: Ringkasan Pesanan
                    Container(
                      padding: const EdgeInsets.all(20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ringkasan Pesanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Subtotal (3 Items)',
                            formatRupiah(subtotal),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Biaya Pengiriman',
                            formatRupiah(shippingFee),
                          ),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            'Diskon Member',
                            '- ${formatRupiah(memberDiscount)}',
                            valueColor: primary,
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Bayar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                              Text(
                                formatRupiah(total),
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

                    const SizedBox(height: 16),

                    // Info note
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: tertiaryFixed.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: tertiaryFixed.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: onTertiaryFixedVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Estimasi pengiriman 20-30 menit ke lokasi Anda.',
                              style: TextStyle(
                                color: onTertiaryFixedVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
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

      // Bottom action bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSubmitting ? null : confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              label: isSubmitting
                  ? const Text('Memproses...')
                  : const Text(
                      'Konfirmasi Pesanan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.chevron_right, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: outlineVariant, width: 2)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: onSurfaceVariant.withValues(alpha: 0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: onSurfaceVariant, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: valueColor ?? onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
