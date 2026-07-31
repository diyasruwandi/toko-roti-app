import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../services/storage_service.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn || authController.token.value == null) {
      orders.clear();
      return;
    }

    isLoading.value = true;
    final fetchedOrders = await _orderService.getOrders(
      authController.token.value!,
    );
    orders.assignAll(fetchedOrders);
    isLoading.value = false;
  }

  Future<OrderModel?> checkoutOrder({
    required String customerName,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    final authController = Get.find<AuthController>();
    final cartController = Get.find<CartController>();

    if (!authController.isLoggedIn || authController.token.value == null) {
      Get.snackbar(
        'Perhatian',
        'Silakan login terlebih dahulu untuk membuat pesanan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Keranjang belanja Anda kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    final items = cartController.cartItems.map((item) {
      return {'product_id': item.product.id, 'qty': item.quantity};
    }).toList();

    isLoading.value = true;
    final result = await _orderService.createOrder(
      token: authController.token.value!,
      customerName: customerName,
      phone: phone,
      address: address,
      latitude: latitude,
      longitude: longitude,
      items: items,
    );
    isLoading.value = false;

    if (result.success) {
      // Simpan Struk ke Eksternal Storage (Kriteria Serkom 2: Eksternal Storage)
      final orderIdStr =
          result.order?.id.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final receiptContent =
          '''
================================
         TOKO ROTI SERKOM       
     STRUK PEMBELIAN ONLINE     
================================
No. Order : #$orderIdStr
Tanggal   : ${DateTime.now()}
Pelanggan : $customerName
No. HP    : $phone
Alamat    : $address

TOTAL BAYAR: Rp ${cartController.total.toStringAsFixed(0)}
================================
Terima Kasih Telah Berbelanja!
''';

      await StorageService.instance.saveReceiptToExternalStorage(
        orderId: orderIdStr,
        receiptContent: receiptContent,
      );

      // Clear cart items dari SQLite lokal
      await cartController.clearAll();
      // Refresh history order
      fetchOrders();
      return result.order;
    } else {
      Get.snackbar(
        'Gagal Checkout',
        result.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Mengubah Status Pesanan (Admin / Pemilik Toko)
  Future<bool> changeOrderStatus(int orderId, String newStatus) async {
    final authController = Get.find<AuthController>();
    if (authController.token.value == null) return false;

    isLoading.value = true;
    final success = await _orderService.updateOrderStatus(
      token: authController.token.value!,
      orderId: orderId,
      status: newStatus,
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar(
        'Sukses',
        'Status pesanan berhasil diubah menjadi $newStatus',
      );
      fetchOrders();
    } else {
      Get.snackbar('Gagal', 'Gagal memperbarui status pesanan');
    }
    return success;
  }
}
