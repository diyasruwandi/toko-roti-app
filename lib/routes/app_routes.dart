import 'package:get/get.dart';
import 'package:toko_roti_app/screens/splash.dart';
import 'package:toko_roti_app/screens/auth/login.dart';
import 'package:toko_roti_app/screens/auth/register.dart';
import 'package:toko_roti_app/screens/forgot_password.dart';
import 'package:toko_roti_app/screens/home.dart';
import 'package:toko_roti_app/screens/product/list_product.dart';
import 'package:toko_roti_app/screens/product/detail_product.dart';
import 'package:toko_roti_app/screens/cart.dart';
import 'package:toko_roti_app/screens/checkout.dart';
import 'package:toko_roti_app/screens/order/success_layout.dart';
import 'package:toko_roti_app/screens/order/history_layout.dart';
import 'package:toko_roti_app/screens/profile.dart';
import 'package:toko_roti_app/screens/favorite.dart';
import 'app_pages.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.register, page: () => const RegisterScreen()),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(name: Routes.productList, page: () => const ProductListScreen()),
    GetPage(
      name: Routes.productDetail,
      page: () => const ProductDetailScreen(),
    ),
    GetPage(name: Routes.cart, page: () => const CartScreen()),
    GetPage(name: Routes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: Routes.orderSuccess, page: () => const OrderSuccessScreen()),
    GetPage(name: Routes.orderHistory, page: () => const OrderHistoryScreen()),
    GetPage(name: Routes.profile, page: () => const ProfileScreen()),
    GetPage(name: Routes.favorites, page: () => const FavoriteScreen()),
  ];
}
