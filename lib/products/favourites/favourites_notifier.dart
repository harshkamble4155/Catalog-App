import 'package:catalog_app/products/data/product_notifier.dart';
import 'package:catalog_app/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<Set<int>> {
  final ProductService _repo;
  FavoritesNotifier(this._repo) : super({}) {
    _load();
  }

  Future<void> _load() async {
    final ids = await _repo.getFavoriteIds();
    state = ids;
  }

  Future<void> toggle(int id) async {
    final next = {...state};
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    state = next;
    await _repo.saveFavoriteIds(state);
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
      return FavoritesNotifier(ref.read(repositoryProvider));
    });
