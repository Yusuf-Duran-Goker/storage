// lib/models/product_model.dart

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // id
    final rawId = json['id'];
    final id = (rawId is int)
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    // title, description, category
    final title = json['title']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';
    final category = json['category']?.toString() ?? '';

    // image from API or Firestore
    final imageField = json['image']?.toString();
    final imageUrlField = json['imageUrl']?.toString();
    final image = (imageField != null && imageField.isNotEmpty)
        ? imageField
        : (imageUrlField ?? '');

    // price
    final rawPrice = json['price'];
    final price = (rawPrice is num)
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;

    // rating field
    final dynamic ratingField = json['rating'];
    double rate;
    int count;
    if (ratingField is Map<String, dynamic>) {
      final rawRate = ratingField['rate'];
      final rawCount = ratingField['count'];
      rate = (rawRate is num)
          ? rawRate.toDouble()
          : double.tryParse(rawRate?.toString() ?? '') ?? 0.0;
      count = (rawCount is int)
          ? rawCount
          : int.tryParse(rawCount?.toString() ?? '') ?? 0;
    } else if (ratingField is num) {
      rate = ratingField.toDouble();
      count = 0;
    } else {
      rate = 0.0;
      count = 0;
    }

    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rate,
      ratingCount: count,
    );
  }
}