import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/database_helper.dart';

/// Controller Keranjang dengan Sinkronisasi SQLite (Kriteria Serkom 3 & 4)
class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromSQLite();
  }

  /// READ: Load data dari database SQLite lokal HP saat aplikasi dibuka
  Future<void> loadCartFromSQLite() async {
    try {
      isLoading.value = true;
      final items = await DatabaseHelper.instance.getCartItems();
      if (items.isNotEmpty) {
        cartItems.assignAll(items);
      }
    } catch (e) {
      print('Error loading cart from SQLite: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get total => subtotal;

  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// CREATE: Tambah Produk ke Memory & SQLite Database
  Future<void> addProduct(ProductModel product, {int quantity = 1}) async {
    // 1. Update State di Memory terlebih dahulu (agar UI langsung update)
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: quantity));
    }

    // 2. Simpan secara Asynchronous ke Database SQLite
    try {
      final newItem = CartItemModel(product: product, quantity: quantity);
      await DatabaseHelper.instance.insertCartItem(newItem);
    } catch (e) {
      print('Gagal menyimpan ke SQLite: $e');
    }

    Get.snackbar(
      'Ditambahkan',
      '$quantity x ${product.name} masuk ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  /// UPDATE: Tambah Jumlah
  Future<void> increaseQty(int index) async {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index].quantity++;
      cartItems.refresh();

      final item = cartItems[index];
      try {
        await DatabaseHelper.instance.updateCartQuantity(
          item.product.id,
          item.quantity,
        );
      } catch (e) {
        print('Error update qty SQLite: $e');
      }
    }
  }

  /// UPDATE: Kurangi Jumlah
  Future<void> decreaseQty(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      if (item.quantity > 1) {
        item.quantity--;
        cartItems.refresh();
        try {
          await DatabaseHelper.instance.updateCartQuantity(
            item.product.id,
            item.quantity,
          );
        } catch (e) {
          print('Error decrease qty SQLite: $e');
        }
      } else {
        await removeItem(index);
      }
    }
  }

  /// DELETE: Hapus 1 Item
  Future<void> removeItem(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final removedItem = cartItems.removeAt(index);
      cartItems.refresh();

      try {
        await DatabaseHelper.instance.deleteCartItem(removedItem.product.id);
      } catch (e) {
        print('Error remove item SQLite: $e');
      }

      Get.snackbar(
        'Dihapus',
        '${removedItem.product.name} dihapus dari keranjang',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  /// DELETE ALL: Clear Keranjang
  Future<void> clearAll() async {
    cartItems.clear();
    try {
      await DatabaseHelper.instance.clearCart();
    } catch (e) {
      print('Error clear cart SQLite: $e');
    }
  }
}
