class ProductModel {
  final String id;
  final String name;
  final String category; // 'lacteo' o 'no-lacteo'
  final double price;
  final String imageUrl;
  final bool isOffer;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.isOffer,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      category: map['category'] ?? 'lacteo',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      isOffer: map['isOffer'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'isOffer': isOffer,
    };
  }
}