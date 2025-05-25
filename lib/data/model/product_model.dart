// lib/data/model/product_model.dart

class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String? category;
  final String? description;
  final Rating? rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.category,
    this.description,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: (json["price"] as num).toDouble(),
        image: json["image"],
        category: json["category"],
        description: json["description"],
        rating: json["rating"] != null ? Rating.fromJson(json["rating"]) : null,
      );

  // Add the toJson method
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "image": image,
        "category": category,
        "description": description,
        "rating": rating?.toJson(),
      };
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: (json["rate"] as num).toDouble(),
        count: json["count"],
      );

  // Add the toJson method
  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
