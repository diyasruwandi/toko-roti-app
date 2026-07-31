import 'product_model.dart';

/// Model Layer untuk Keranjang SQLite (Kriteria Serkom 4: Database Mobile Dengan Model Layer)
class CartItemModel {
  final int? dbId; // Primary Key di SQLite lokal
  final ProductModel product;
  int quantity;

  CartItemModel({this.dbId, required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  // Konversi dari Map SQLite ke Object CartItemModel dengan Safe Parsing
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    final int productId = map['product_id'] is int
        ? map['product_id'] as int
        : int.tryParse(map['product_id']?.toString() ?? '0') ?? 0;

    final double price = map['price'] is num
        ? (map['price'] as num).toDouble()
        : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0;

    final int stock = map['stock'] is int
        ? map['stock'] as int
        : int.tryParse(map['stock']?.toString() ?? '10') ?? 10;

    final int qty = map['quantity'] is int
        ? map['quantity'] as int
        : int.tryParse(map['quantity']?.toString() ?? '1') ?? 1;

    return CartItemModel(
      dbId: map['db_id'] is int ? map['db_id'] as int : null,
      product: ProductModel(
        id: productId,
        name: map['name']?.toString() ?? '',
        description: map['description']?.toString(),
        price: price,
        image: map['image']?.toString(),
        stock: stock,
      ),
      quantity: qty,
    );
  }

  // Konversi dari Object CartItemModel ke Map SQLite
  Map<String, dynamic> toMap() {
    return {
      if (dbId != null) 'db_id': dbId,
      'product_id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'image': product.image,
      'stock': product.stock,
      'quantity': quantity,
    };
  }
}
