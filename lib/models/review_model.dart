class ReviewModel {
  final String id;
  final String userName;
  final int stars;
  final String message;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.stars,
    required this.message,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, String docId) {
    return ReviewModel(
      id: docId,
      userName: map['userName'] ?? 'Anónimo',
      stars: map['stars'] ?? 5,
      message: map['message'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'stars': stars,
      'message': message,
    };
  }
}