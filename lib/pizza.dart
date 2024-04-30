class Pizza {
  final String id;
  final String name;
  final double price;
  final String base;
  final List<String> ingredients;
  final String image;

  Pizza({
    required this.id,
    required this.name,
    required this.price,
    required this.base,
    required this.ingredients,
    required this.image,
  });

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      base: json['base'],
      ingredients: List<String>.from(json['ingredients']),
      image: json['image'],
    );
  }
}
