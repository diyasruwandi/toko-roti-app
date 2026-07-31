import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service Storage Aplikasi Mobile (Kriteria Serkom 1: Internal Storage & Kriteria Serkom 2: Eksternal Storage)
class StorageService {
  static final StorageService instance = StorageService._init();
  StorageService._init();

  // 1. MENDESAIN INTERNAL STORAGE (SHARED PREFERENCES)

  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';

  /// Menyimpan Token Login ke Internal Storage
  Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyToken, token);
  }

  /// Membaca Token Login dari Internal Storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Menghapus Token (Logout) dari Internal Storage
  Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyToken);
  }

  /// Menyimpan Data User Json ke Internal Storage
  Future<bool> saveUserData(String userJson) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUser, userJson);
  }

  /// Membaca Data User Json dari Internal Storage
  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  // 2. MENDESAIN EKSTERNAL STORAGE (FILE HANDLING)

  /// Menyimpan Struk / Nota Transaksi ke Eksternal Storage HP
  Future<File?> saveReceiptToExternalStorage({
    required String orderId,
    required String receiptContent,
  }) async {
    try {
      Directory? externalDir;

      if (Platform.isAndroid) {
        // Ambil direktori eksternal penyimpan file publik HP Android
        externalDir = await getExternalStorageDirectory();
      } else {
        externalDir = await getApplicationDocumentsDirectory();
      }

      if (externalDir != null) {
        final filePath = '${externalDir.path}/Struk_Order_$orderId.txt';
        final file = File(filePath);
        return await file.writeAsString(receiptContent);
      }
      return null;
    } catch (e) {
      print('Gagal menyimpan file ke Eksternal Storage: $e');
      return null;
    }
  }

  /// Membaca File Struk dari Eksternal Storage HP
  Future<String?> readExternalReceipt(String orderId) async {
    try {
      Directory? externalDir;
      if (Platform.isAndroid) {
        externalDir = await getExternalStorageDirectory();
      } else {
        externalDir = await getApplicationDocumentsDirectory();
      }

      if (externalDir != null) {
        final filePath = '${externalDir.path}/Struk_Order_$orderId.txt';
        final file = File(filePath);
        if (await file.exists()) {
          return await file.readAsString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
