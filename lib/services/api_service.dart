class ApiConfig {
  // Ganti sesuai environment kamu:
  // - Emulator Android: http://10.0.2.2:8000/api
  // - HP fisik (WiFi sama dengan laptop): http://[IP-LOKAL-LAPTOP]:8000/api
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String baseUrl = 'https://backend-toko-roti.vercel.app/api';

  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String resetPassword = '$baseUrl/reset-password';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';
  static const String products = '$baseUrl/products';
  static const String orders = '$baseUrl/orders';
}
