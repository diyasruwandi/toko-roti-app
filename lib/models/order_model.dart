import 'product_model.dart';

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is int) return val;
  return int.tryParse(val.toString()) ?? 0;
}

class OrderItemModel {
  final int id;
  final int productId;
  final int qty;
  final double subtotal;
  final ProductModel? product;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.qty,
    required this.subtotal,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: _parseInt(json['id']),
      productId: _parseInt(json['product_id']),
      qty: _parseInt(json['qty']),
      subtotal: _parseDouble(json['subtotal']),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }
}

class OrderModel {
  final int id;
  final int userId;
  final String customerName;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final double totalPrice;
  final String status;
  final String? createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalPrice,
    required this.status,
    this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['order_items'] ?? json['items'] ?? [];
    List<OrderItemModel> itemList = (rawItems as List)
        .map((item) => OrderItemModel.fromJson(item))
        .toList();

    return OrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      customerName: json['customer_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      totalPrice: _parseDouble(json['total_price']),
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString(),
      items: itemList,
    );
  }

  String get orderCode => '#CC-${id.toString().padLeft(4, '0')}';

  String get formattedDate {
    if (createdAt == null) return 'Hari ini';
    try {
      final dt = DateTime.parse(createdAt!).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return createdAt!;
    }
  }

  String get itemsSummary {
    if (items.isEmpty) return 'Pesanan Roti';
    return items
        .map((e) {
          final pName = e.product?.name ?? 'Produk';
          return '$pName (${e.qty})';
        })
        .join(', ');
  }
}
