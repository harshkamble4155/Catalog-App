import 'package:catalog_app/products/data/product.dart';
import 'package:catalog_app/products/data/product_notifier.dart';
import 'package:catalog_app/products/favourites/favourites_notifier.dart';
import 'package:catalog_app/screens/product_card.dart';
import 'package:catalog_app/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productNotifier.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifier);
    final favs = ref.watch(favoritesNotifierProvider);
    List<Product> visibleItems = state.items;
    visibleItems = visibleItems.where((e) => favs.contains(e.id)).toList();
    return Scaffold(
      appBar: AppBar(title: Text("Favourites")),
      body: RefreshIndicator(
        onRefresh: () => ref.read(productNotifier.notifier).refreshData(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: visibleItems.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= visibleItems.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final product = visibleItems[index];
            return ProductCard(
              product: product,
              isFavorite: favs.contains(product.id),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              ),
              onFavToggle: () => ref
                  .read(favoritesNotifierProvider.notifier)
                  .toggle(product.id),
            );
          },
        ),
      ),
    );
  }
}
