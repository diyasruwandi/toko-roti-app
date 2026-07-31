import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../models/user_model.dart';
import '../routes/app_pages.dart';
import 'package:intl/intl.dart';

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

  String selectedPaymentMethod = 'Bayar di Tempat (COD)';

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Bayar di Tempat (COD)',
      'subtitle': 'Bayar tunai secara langsung saat roti tiba di tujuan',
      'icon': Icons.payments_outlined,
    },
    {
      'name': 'QRIS / E-Wallet',
      'subtitle': 'Scan QRIS via GoPay, OVO, ShopeePay, DANA, LinkAja',
      'icon': Icons.qr_code_scanner,
    },
    {
      'name': 'Transfer Bank (Virtual Account)',
      'subtitle': 'BCA, Mandiri, BRI, BNI, Danamon (Otomatis terverifikasi)',
      'icon': Icons.account_balance,
    },
    {
      'name': 'Kartu Kredit / Debit',
      'subtitle': 'Visa, Mastercard, JCB',
      'icon': Icons.credit_card,
    },
  ];

  final MapController mapController = MapController();
  LatLng? selectedLatLng;

  // Hubungkan langsung ke CartController agar harga 100% Real
  final CartController cartController = Get.find<CartController>();

  double get subtotal => cartController.subtotal;
  double get shippingFee => 0.0;
  double get memberDiscount => 0.0;
  double get total => cartController.total;

  // Palet warna
  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);
  static const Color onSurfaceVariant = Color(0xFF404945);
  static const Color background = Color(0xFFF5F0E8);
  static const Color outlineVariant = Color(0xFFBFC9C4);
  static const Color tertiaryFixed = Color(0xFFFFDCBB);
  static const Color onTertiaryFixedVariant = Color(0xFF5C4225);

  String formatRupiah(num price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  void initState() {
    super.initState();
    _autoFillUserData();
  }

  Future<void> _autoFillUserData() async {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    final prefs = await SharedPreferences.getInstance();

    if (user != null) {
      if (user.name.isNotEmpty) {
        nameController.text = user.name;
      }
      String? phone = user.phone;
      if (phone == null || phone.trim().isEmpty) {
        phone =
            prefs.getString('user_phone_${user.email.trim().toLowerCase()}') ??
            prefs.getString('last_registered_phone') ??
            prefs.getString('user_phone');
      }
      if (phone != null && phone.trim().isNotEmpty) {
        phoneController.text = phone;
        // Update model in memory as well
        authController.currentUser.value = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: phone,
        );
      }
    } else {
      final lastPhone =
          prefs.getString('last_registered_phone') ??
          prefs.getString('user_phone');
      if (lastPhone != null && lastPhone.isNotEmpty) {
        phoneController.text = lastPhone;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<String?> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        List<String> parts = [];
        if (place.street != null && place.street!.isNotEmpty) {
          parts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          parts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          parts.add(place.locality!);
        }
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty) {
          parts.add(place.subAdministrativeArea!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          parts.add(place.administrativeArea!);
        }
        if (parts.isNotEmpty) {
          return parts.join(', ');
        }
      }
    } catch (_) {}

    // Fallback via Nominatim OpenStreetMap API
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng&zoom=18&addressdetails=1',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'TokoRotiApp/1.0'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'];
      }
    } catch (_) {}

    return null;
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

      // Ambil posisi dari GPS perangkat / emulator
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double targetLat = position.latitude;
      double targetLng = position.longitude;

      // Jika terdeteksi lokasi default Android Studio Emulator (California USA: lat > 30, lng < -100)
      if (targetLat > 30 && targetLng < -100) {
        // Otomatis disesuaikan ke Maguwoharjo, Sleman, DI Yogyakarta
        targetLat = -7.7600;
        targetLng = 110.4300;
      }

      final newLatLng = LatLng(targetLat, targetLng);

      setState(() {
        latitude = targetLat;
        longitude = targetLng;
        selectedLatLng = newLatLng;
      });

      // Geser posisi maps
      mapController.move(newLatLng, 16.0);

      // Konversi koordinat -> Alamat lengkap otomatis
      String? address = await _getAddressFromCoordinates(
        targetLat,
        targetLng,
      );

      if (address != null && address.isNotEmpty) {
        setState(() {
          addressController.text = address;
        });
      } else if (targetLat == -7.7600 && targetLng == 110.4300) {
        setState(() {
          addressController.text =
              'Jl. Ring Road Utara, Maguwoharjo, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta';
        });
      }

      setState(() => isFetchingLocation = false);

      Get.snackbar(
        'Lokasi Ditemukan',
        targetLat == -7.7600 && targetLng == 110.4300
            ? 'Lokasi disesuaikan ke Maguwoharjo, Yogyakarta'
            : 'Alamat lengkap dan koordinat telah terisi otomatis',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryContainer,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      setState(() => isFetchingLocation = false);
      Get.snackbar('Gagal', 'Tidak bisa mengambil lokasi: $e');
    }
  }

  Future<void> confirmOrder() async {
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

    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    final prefs = await SharedPreferences.getInstance();

    final inputPhone = phoneController.text.trim();
    if (inputPhone.isNotEmpty) {
      await prefs.setString('user_phone', inputPhone);
      await prefs.setString('last_registered_phone', inputPhone);
      if (user != null && user.email.isNotEmpty) {
        await prefs.setString(
          'user_phone_${user.email.trim().toLowerCase()}',
          inputPhone,
        );
        authController.currentUser.value = UserModel(
          id: user.id,
          name: nameController.text.trim().isNotEmpty
              ? nameController.text.trim()
              : user.name,
          email: user.email,
          phone: inputPhone,
        );
      }
    }

    setState(() => isSubmitting = true);

    final orderController = Get.find<OrderController>();
    final createdOrder = await orderController.checkoutOrder(
      customerName: nameController.text.trim(),
      phone: inputPhone,
      address: addressController.text.trim(),
      latitude: latitude!,
      longitude: longitude!,
    );

    setState(() => isSubmitting = false);

    if (createdOrder != null) {
      Get.offNamed(Routes.orderSuccess, arguments: createdOrder);
    }
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

                    // Interactive Maps Widget
                    _buildMapWidget(),

                    const SizedBox(height: 24),

                    // Section: Metode Pembayaran
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),

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
                        children: paymentMethods.asMap().entries.map((entry) {
                          final index = entry.key;
                          final method = entry.value;
                          final isSelected =
                              selectedPaymentMethod == method['name'];
                          return Column(
                            children: [
                              RadioListTile<String>(
                                value: method['name'] as String,
                                groupValue: selectedPaymentMethod,
                                activeColor: primary,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedPaymentMethod = val;
                                    });
                                  }
                                },
                                secondary: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryContainer.withValues(alpha: 0.1)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    method['icon'] as IconData,
                                    color: isSelected
                                        ? primary
                                        : onSurfaceVariant,
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  method['name'] as String,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 14,
                                    color: primary,
                                  ),
                                ),
                                subtitle: Text(
                                  method['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: onSurfaceVariant,
                                  ),
                                ),
                              ),
                              if (index < paymentMethods.length - 1)
                                const Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section: Ringkasan Pesanan
                    Obx(
                      () => Container(
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
                            _buildSummaryRow('Pembayaran', selectedPaymentMethod),
                            const Divider(height: 16),
                            // Daftar Roti yang dibeli
                            ...cartController.cartItems.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildSummaryRow(
                                  '${item.product.name} (x${item.quantity})',
                                  formatRupiah(item.totalPrice),
                                ),
                              ),
                            ),
                            const Divider(height: 16),
                            _buildSummaryRow(
                              'Subtotal (${cartController.itemCount} Items)',
                              formatRupiah(cartController.subtotal),
                            ),
                            const SizedBox(height: 8),
                            _buildSummaryRow(
                              'Biaya Pengiriman',
                              'Gratis',
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
                                  formatRupiah(cartController.total),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildMapWidget() {
    final initialCenter = selectedLatLng ?? const LatLng(-6.2088, 106.8456);

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: primaryContainer.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: selectedLatLng != null ? 16.0 : 13.0,
                onTap: (tapPosition, point) async {
                  setState(() {
                    selectedLatLng = point;
                    latitude = point.latitude;
                    longitude = point.longitude;
                  });
                  String? address = await _getAddressFromCoordinates(
                    point.latitude,
                    point.longitude,
                  );
                  if (address != null && address.isNotEmpty) {
                    setState(() {
                      addressController.text = address;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tokoroti.app',
                ),
                if (selectedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedLatLng!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (latitude != null && longitude != null)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pin_drop, size: 16, color: primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Lat: ${latitude!.toStringAsFixed(5)}, Lng: ${longitude!.toStringAsFixed(5)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
