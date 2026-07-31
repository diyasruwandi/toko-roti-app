import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedProducts = await _productService.fetchProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data produk: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
