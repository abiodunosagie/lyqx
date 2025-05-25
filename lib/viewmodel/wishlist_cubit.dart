import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/product_model.dart';

class WishlistCubit extends Cubit<List<Product>> {
  WishlistCubit() : super([]) {
    loadWishlist();
  }

  void addToWishlist(Product product) async {
    final currentState = List<Product>.from(state);
    if (!currentState.any((p) => p.id == product.id)) {
      currentState.add(product);
      emit(currentState);
      _saveWishlist(currentState);
    }
  }

  void removeFromWishlist(Product product) async {
    final currentState = List<Product>.from(state);
    currentState.removeWhere((p) => p.id == product.id);
    emit(currentState);
    _saveWishlist(currentState);
  }

  bool isInWishlist(int productId) {
    return state.any((product) => product.id == productId);
  }

  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wishlistString = prefs.getString('wishlist') ?? '[]';
      final wishlistJson = jsonDecode(wishlistString) as List;

      final products = wishlistJson.map<Product>((item) {
        Map<String, dynamic> ratingMap = {};
        if (item['rating'] != null) {
          ratingMap = item['rating'] is String
              ? jsonDecode(item['rating'])
              : item['rating'];
        }

        return Product(
          id: item['id'],
          title: item['title'],
          price: (item['price'] as num).toDouble(),
          image: item['image'],
          category: item['category'],
          description: item['description'],
          rating: ratingMap.isNotEmpty
              ? Rating(
                  rate: (ratingMap['rate'] as num).toDouble(),
                  count: ratingMap['count'],
                )
              : null,
        );
      }).toList();

      emit(products);
    } catch (e) {
      // Handle error loading wishlist
      print('Error loading wishlist: $e');
      emit([]);
    }
  }

  Future<void> _saveWishlist(List<Product> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = products
          .map((product) => {
                'id': product.id,
                'title': product.title,
                'price': product.price,
                'image': product.image,
                'category': product.category,
                'description': product.description,
                'rating': product.rating != null
                    ? {
                        'rate': product.rating!.rate,
                        'count': product.rating!.count
                      }
                    : null,
              })
          .toList();

      await prefs.setString('wishlist', jsonEncode(productsJson));
    } catch (e) {
      // Handle error saving wishlist
      print('Error saving wishlist: $e');
    }
  }
}
