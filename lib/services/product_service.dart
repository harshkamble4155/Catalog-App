import 'dart:convert';

import 'package:catalog_app/products/data/product.dart';
import 'package:catalog_app/services/product_data_source.dart';
import 'package:dio/dio.dart';

class ProductService {
  final ProductLocalDataSource _dataSource;
  final Dio _dio = Dio(
    BaseOptions(connectTimeout: const Duration(seconds: 30)),
  );
  static const String baseUrl = "https://dummyjson.com";

  ProductService(this._dataSource);

  Future<List<Product>> fetchProducts({
    int limit = 20,
    int skip = 0,
    String? query,
  }) async {
    String path = (query == null || query.isEmpty)
        ? "/products"
        : "/products/search";
    final params = {
      'limit': limit,
      'skip': skip,
      if (query != null && query.isNotEmpty) 'q': query,
    };
    try {
      final res = await _dio.get("$baseUrl$path", queryParameters: params);
      final data = res.data;
      if ((query == null || query.isEmpty) && skip == 0) {
        await _dataSource.cacheProductsJson(json.encode(data));
      }
      final items = (data['products'] as List?) ?? const [];
      return items
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      final cached = await _dataSource.getCachedProductsJson();
      if (cached != null) {
        return Product.listFromJson(cached);
      }
      rethrow;
    }
  }

  Future<Set<int>> getFavoriteIds() => _dataSource.getFavoriteIds();
  Future<void> saveFavoriteIds(Set<int> ids) =>
      _dataSource.saveFavoriteIds(ids);
}
