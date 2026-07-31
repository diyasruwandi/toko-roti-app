import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../routes/app_pages.dart';
import 'cart_controller.dart';
import 'order_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rxn<String> token = Rxn<String>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => token.value != null;

  @override
  void onInit() {
    super.onInit();
    loadTokenFromStorage();
  }

  // Dipanggil sekali di Splash Screen buat cek status login
  Future<void> loadTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    if (savedToken != null) {
      token.value = savedToken;
      // Ambil ulang data user biar selalu fresh
      final user = await _authService.getProfile(savedToken);
      if (user != null) {
        String? phone = user.phone;
        if (phone == null || phone.isEmpty) {
          phone =
              prefs.getString(
                'user_phone_${user.email.trim().toLowerCase()}',
              ) ??
              prefs.getString('last_registered_phone') ??
              prefs.getString('user_phone');
        }
        currentUser.value = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: phone,
        );
        if (Get.isRegistered<OrderController>()) {
          Get.find<OrderController>().fetchOrders();
        }
      } else {
        // Token sudah expired/invalid -> hapus
        await _clearToken();
      }
    }
  }

  Future<void> _saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    token.value = newToken;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    token.value = null;
    currentUser.value = null;
    _clearCart();
    if (Get.isRegistered<OrderController>()) {
      Get.find<OrderController>().fetchOrders();
    }
  }

  void _clearCart() {
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().clearAll();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    final result = await _authService.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    isLoading.value = false;

    if (result.success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_phone_${email.trim().toLowerCase()}', phone);
      await prefs.setString('last_registered_phone', phone);
      await prefs.setString('user_phone', phone);

      // Bersihkan keranjang belanja dari sesi pengguna sebelumnya
      _clearCart();

      // Sengaja TIDAK simpan token di sini, biar user harus login manual
      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat, silakan login',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Gagal',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true;
    final result = await _authService.login(email: email, password: password);
    isLoading.value = false;

    if (result.success && result.token != null) {
      await _saveToken(result.token!);
      final user = result.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        String? phone = user.phone;
        if (phone == null || phone.isEmpty) {
          phone =
              prefs.getString('user_phone_${email.trim().toLowerCase()}') ??
              prefs.getString('last_registered_phone') ??
              prefs.getString('user_phone');
        }
        currentUser.value = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: phone,
        );
      }

      // Bersihkan keranjang & ambil riwayat pesanan user baru
      _clearCart();
      if (Get.isRegistered<OrderController>()) {
        Get.find<OrderController>().fetchOrders();
      }

      return true;
    } else {
      Get.snackbar(
        'Login Gagal',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    final result = await _authService.resetPassword(
      email: email,
      password: password,
    );
    isLoading.value = false;

    if (result.success) {
      Get.snackbar(
        'Berhasil',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } else {
      Get.snackbar(
        'Gagal Reset Password',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> logout() async {
    if (token.value != null) {
      await _authService.logout(token.value!);
    }
    await _clearToken();
    Get.offAllNamed(Routes.login);
  }
}
