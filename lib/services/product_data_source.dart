import 'package:hive/hive.dart';

class ProductLocalDataSource {
  static const String boxName = 'products_cache_box';
  static const String productsKey = 'products_json';
  static const String favoritesKey = 'favorite_ids';

  Future<Box> _openBox() async => Hive.isBoxOpen(boxName) ? Hive.box(boxName) : await Hive.openBox(boxName);

  Future<void> cacheProductsJson(String json) async {
    final box = await _openBox();
    await box.put(productsKey, json);
  }

  Future<String?> getCachedProductsJson() async {
    final box = await _openBox();
    return box.get(productsKey) as String?;
  }

  Future<Set<int>> getFavoriteIds() async {
    final box = await _openBox();
    final list = (box.get(favoritesKey) as List?)?.cast<int>() ?? <int>[];
    return list.toSet();
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    final box = await _openBox();
    await box.put(favoritesKey, ids.toList());
  }
}
