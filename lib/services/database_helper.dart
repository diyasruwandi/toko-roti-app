import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

/// Service Kelas Database SQLite (Kriteria Serkom 3: Mendesain Sqlite Database Pada Aplikasi Berbasis Mobile)
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDB('toko_roti.db');
    return _database!;
  }

  // Inisialisasi Database SQLite Lokal HP / Web / Desktop
  Future<Database> _initDB(String filePath) async {
    String path;
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      path = filePath;
    } else {
      if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Membuat Skema Tabel SQLite (Model Layer Schema)
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cart_items (
        db_id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        image TEXT,
        stock INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorite_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        image TEXT,
        stock INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS cart_items');
      await db.execute('DROP TABLE IF EXISTS favorite_products');
      await _createDB(db, newVersion);
    }
  }

  // OPERASI CRUD TABEL KERANJANG (SQLite)
  /// CREATE: Tambah Item ke SQLite
  Future<int> insertCartItem(CartItemModel item) async {
    try {
      final db = await instance.database;
      final existing = await db.query(
        'cart_items',
        where: 'product_id = ?',
        whereArgs: [item.product.id],
      );

      if (existing.isNotEmpty) {
        final currentQty = existing.first['quantity'] is int
            ? existing.first['quantity'] as int
            : int.tryParse(existing.first['quantity'].toString()) ?? 1;
        final newQty = currentQty + item.quantity;
        return await updateCartQuantity(item.product.id, newQty);
      } else {
        return await db.insert('cart_items', item.toMap());
      }
    } catch (e) {
      print('SQLite insertCartItem Error: $e');
      return -1;
    }
  }

  /// READ: Ambil Semua Item Keranjang dari SQLite
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final db = await instance.database;
      final result = await db.query('cart_items');
      return result.map((json) => CartItemModel.fromMap(json)).toList();
    } catch (e) {
      print('SQLite getCartItems Error: $e');
      return [];
    }
  }

  /// UPDATE: Ubah Jumlah Item di SQLite
  Future<int> updateCartQuantity(int productId, int quantity) async {
    try {
      final db = await instance.database;
      return await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      print('SQLite updateCartQuantity Error: $e');
      return -1;
    }
  }

  /// DELETE: Hapus 1 Item dari SQLite
  Future<int> deleteCartItem(int productId) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'cart_items',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      print('SQLite deleteCartItem Error: $e');
      return -1;
    }
  }

  /// DELETE ALL: Kosongkan Keranjang SQLite
  Future<int> clearCart() async {
    try {
      final db = await instance.database;
      return await db.delete('cart_items');
    } catch (e) {
      print('SQLite clearCart Error: $e');
      return -1;
    }
  }

  // OPERASI CRUD TABEL FAVORIT (SQLite)

  Future<int> insertFavorite(ProductModel product) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'favorite_products',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<List<ProductModel>> getFavorites() async {
    try {
      final db = await instance.database;
      final result = await db.query('favorite_products');
      return result.map((map) => ProductModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> deleteFavorite(int productId) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'favorite_products',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<bool> isFavorite(int productId) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'favorite_products',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
