class RecipeModel {
  final String id;
  final String title;
  final List<String> ingredients;
  final String time;

  RecipeModel({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.time,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map, String docId) {
    return RecipeModel(
      id: docId,
      title: map['title'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      time: map['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'time': time,
    };
  }
}