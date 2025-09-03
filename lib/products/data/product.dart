import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final String thumbnail;
  final List<String> images;
  final String brand;
  final String category;
  final num rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.brand,
    required this.category,
    required this.rating,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: map['price'] as num? ?? 0,
      thumbnail: map['thumbnail'] as String? ?? '',
      images: (map['images'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      brand: map['brand'] as String? ?? '',
      category: map['category'] as String? ?? '',
      rating: (map['rating'] as num?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'thumbnail': thumbnail,
        'images': images,
        'brand': brand,
        'category': category,
        'rating': rating,
      };

  static List<Product> listFromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    final items = (map['products'] as List?) ?? const [];
    return items.map((e) => Product.fromMap(e as Map<String, dynamic>)).toList();
  }
}
