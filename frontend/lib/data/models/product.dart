import '../../core/image_mapper.dart';

class Product {
  final String id;
  final String brand;
  final String name;
  final String subtitle;
  final String category;
  final String description;
  final List<String> images;
  final num price;
  final int stock;
  final bool productIsNew;
  final String? stripeId;
  final List<dynamic> reviews;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.images,
    required this.price,
    required this.stock,
    this.productIsNew = false,
    this.stripeId,
    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Get images from JSON and map them to local assets
    final List<String> rawImages = List<String>.from(json['images'] ?? []);
    final List<String> mappedImages = ImageMapper.mapListToAssets(rawImages);

    return Product(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      brand: json['brand'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      images: mappedImages,
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      productIsNew: json['productIsNew'] ?? false,
      stripeId: json['stripeId'],
      reviews: json['reviews'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'description': description,
      'images': images,
      'price': price,
      'stock': stock,
      'productIsNew': productIsNew,
      'stripeId': stripeId,
      'reviews': reviews,
    };
  }
}
