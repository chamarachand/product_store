class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String? brand;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
  final int weight;
  final String availabilityStatus;
  final String warrantyInformation;
  final String shippingInformation;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand,
    required this.thumbnail,
    required this.images,
    this.tags = const [],
    this.weight = 0,
    this.availabilityStatus = '',
    this.warrantyInformation = '',
    this.shippingInformation = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      brand: json['brand'] as String?,
      thumbnail: json['thumbnail'] as String? ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
      warrantyInformation: json['warrantyInformation'] as String? ?? '',
      shippingInformation: json['shippingInformation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'thumbnail': thumbnail,
      'images': images,
      'tags': tags,
      'weight': weight,
      'availabilityStatus': availabilityStatus,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProductResponse {
  final List<Product> products;

  const ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'] as List<dynamic>? ?? [];
    final products = rawProducts
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();

    return ProductResponse(products: products);
  }
}
