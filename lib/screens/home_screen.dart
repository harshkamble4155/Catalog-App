import 'package:catalog_app/products/data/product.dart';
import 'package:catalog_app/products/favourites/favourites_notifier.dart';
import 'package:catalog_app/screens/favourites_screen.dart';
import 'package:catalog_app/screens/product_card.dart';
import 'package:catalog_app/products/data/product_notifier.dart';
import 'package:catalog_app/screens/product_detail.dart';
import 'package:catalog_app/theme/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchCtrl = TextEditingController();

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
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifier);
    final favs = ref.watch(favoritesNotifierProvider);
    List<Product> visibleItems = state.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Catalog"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavouritesScreen()),
            ),
            icon: Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () => ref.read(themeNotifier.notifier).toggle(),
            icon:
                ref.read(themeNotifier.notifier).isDarkMode() == ThemeMode.dark
                ? Icon(Icons.light_mode)
                : Icon(Icons.dark_mode),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchCtrl.clear();
                          ref.read(productNotifier.notifier).updateQuery("");
                        },
                        icon: Icon(Icons.close),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (text) =>
                  ref.read(productNotifier.notifier).updateQuery(text),
            ),
          ),
        ),
      ),
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
