import 'dart:async';

import 'package:catalog_app/products/data/product.dart';
import 'package:catalog_app/services/product_data_source.dart';
import 'package:catalog_app/products/favourites/favourites_notifier.dart';
import 'package:catalog_app/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productNotifier = StateNotifierProvider<ProductNotifier, ProductState>((
  ref,
) {
  return ProductNotifier(ref.read(repositoryProvider));
});

class ProductState {
  final bool isLoading;
  final List<Product> items;
  final bool hasMore;
  final String query;
  final String? error;

  const ProductState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.query = '',
    this.error,
  });

  ProductState copyWith({
    List<Product>? items,
    bool? isLoading,
    bool? hasMore,
    String? query,
    String? error,
  }) {
    return ProductState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      error: error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  static const int _pageSize = 20;
  int _skip = 0;
  final ProductService _productService;
  Timer? _timer;

  ProductNotifier(this._productService) : super(ProductState()) {
    refreshData();
  }

  Future<void> refreshData() async {
    _skip = 0;
    try {
      state = state.copyWith(
        items: [],
        hasMore: true,
        isLoading: true,
        error: null,
      );
      final list = await _productService.fetchProducts(
        limit: _pageSize,
        skip: _skip,
        query: state.query,
      );
      state = state.copyWith(
        items: list,
        isLoading: false,
        hasMore: list.length == _pageSize,
      );
      _skip += list.length;
    } catch (e) {
      state = state.copyWith(items: [], isLoading: false, error: e.toString());
    }
  }

  void loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _productService.fetchProducts(
        limit: _pageSize,
        skip: _skip,
      );
      final combinedList = [...state.items, ...list];
      state = state.copyWith(
        items: combinedList,
        isLoading: false,
        hasMore: list.length == _pageSize,
      );
      _skip += list.length;
    } catch (e) {
      state = state.copyWith(items: [], isLoading: false, error: e.toString());
    }
  }

  void updateQuery(String q) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(query: q);
      refreshData();
    });
  }
}

final localProvider = Provider((ref) => ProductLocalDataSource());
final repositoryProvider = Provider(
  (ref) => ProductService(ref.read(localProvider)),
);

final isFavoriteProvider = Provider.family<bool, int>((ref, id) {
  final ids = ref.watch(favoritesNotifierProvider);
  return ids.contains(id);
});
