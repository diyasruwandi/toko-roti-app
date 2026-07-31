import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/database_helper.dart';

class FavoriteController extends GetxController {
  static FavoriteController get to => Get.find<FavoriteController>();

  final RxList<ProductModel> favoriteProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  static const Color primary = Color(0xFF003229);
  static const Color primaryContainer = Color(0xFF0C4A3E);

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final list = await DatabaseHelper.instance.getFavorites();
      favoriteProducts.assignAll(list);
    } catch (e) {
      print('Error loadFavorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(int productId) {
    return favoriteProducts.any((p) => p.id == productId);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    try {
      final exists = isFavorite(product.id);
      if (exists) {
        await DatabaseHelper.instance.deleteFavorite(product.id);
        favoriteProducts.removeWhere((p) => p.id == product.id);
        Get.snackbar(
          'Favorit',
          '${product.name} dihapus dari produk favorit',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        await DatabaseHelper.instance.insertFavorite(product);
        favoriteProducts.add(product);
        Get.snackbar(
          'Favorit',
          '${product.name} ditambahkan ke produk favorit',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryContainer,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal memperbarui status favorit: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
