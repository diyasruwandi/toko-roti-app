/// Model Layer untuk Produk (Kriteria Serkom 4: Database Mobile Dengan Model Layer)
class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.stock,
  });

  // Konversi dari JSON API ke Object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['image']?.toString(),
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
    );
  }

  // Konversi dari Map SQLite ke Object (Model Layer)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      image: map['image']?.toString(),
      stock: map['stock'] is int
          ? map['stock']
          : int.tryParse(map['stock']?.toString() ?? '0') ?? 0,
    );
  }

  // Konversi Object ke Map untuk disimpan di SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'stock': stock,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}
