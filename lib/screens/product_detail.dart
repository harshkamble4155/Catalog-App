import 'package:catalog_app/products/data/product.dart';
import 'package:catalog_app/products/data/product_notifier.dart';
import 'package:catalog_app/products/favourites/favourites_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends ConsumerWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(product.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () =>
                ref.read(favoritesNotifierProvider.notifier).toggle(product.id),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              product.images.isNotEmpty
                  ? product.images.first
                  : product.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  child: const Center(
                    child: Text(
                      "Not\nAvailable",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        product.brand.isNotEmpty ? product.brand : "NA",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(label: Text(product.category)),
                    const Spacer(),
                    Text('★ ${product.rating}'),
                  ],
                ),
                const SizedBox(height: 12),
                Text(product.description),
                const SizedBox(height: 16),
                Text(
                  'Price: ₹${product.price}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
