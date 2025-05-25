// lib/viewmodel/cart_cubit.dart
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/cart_item.dart';
import '../data/model/product_model.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    loadCart();
  }

  // Add product to cart
  void addToCart(Product product) {
    final currentState = List<CartItem>.from(state);

    // Check if product already exists in cart
    final existingItemIndex =
        currentState.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      // Increment quantity if already in cart
      currentState[existingItemIndex].quantity++;
    } else {
      // Add new item if not in cart
      currentState.add(CartItem(product: product));
    }

    emit(currentState);
    _saveCart(currentState);
  }

  // Remove item from cart
  void removeFromCart(int productId) {
    final currentState = List<CartItem>.from(state);
    currentState.removeWhere((item) => item.product.id == productId);
    emit(currentState);
    _saveCart(currentState);
  }

  // Update item quantity
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final currentState = List<CartItem>.from(state);
    final itemIndex =
        currentState.indexWhere((item) => item.product.id == productId);

    if (itemIndex >= 0) {
      currentState[itemIndex].quantity = quantity;
      emit(currentState);
      _saveCart(currentState);
    }
  }

  // Increment item quantity
  void incrementQuantity(int productId) {
    final currentState = List<CartItem>.from(state);
    final itemIndex =
        currentState.indexWhere((item) => item.product.id == productId);

    if (itemIndex >= 0) {
      currentState[itemIndex].quantity++;
      emit(currentState);
      _saveCart(currentState);
    }
  }

  // Decrement item quantity
  void decrementQuantity(int productId) {
    final currentState = List<CartItem>.from(state);
    final itemIndex =
        currentState.indexWhere((item) => item.product.id == productId);

    if (itemIndex >= 0) {
      if (currentState[itemIndex].quantity > 1) {
        currentState[itemIndex].quantity--;
        emit(currentState);
        _saveCart(currentState);
      } else {
        removeFromCart(productId);
      }
    }
  }

  // Clear the entire cart
  void clearCart() {
    emit([]);
    _saveCart([]);
  }

  // Get total number of items in cart
  int get itemCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total price of all items in cart
  double get totalPrice {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Check if product is in cart
  bool isInCart(int productId) {
    return state.any((item) => item.product.id == productId);
  }

  // Load cart from SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart') ?? '[]';
      final cartJson = jsonDecode(cartString) as List;

      final cartItems =
          cartJson.map<CartItem>((item) => CartItem.fromJson(item)).toList();
      emit(cartItems);
    } catch (e) {
      print('Error loading cart: $e');
      emit([]);
    }
  }

  // Save cart to SharedPreferences
  Future<void> _saveCart(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = cartItems
          .map((item) => {
                'product': item.product.toJson(),
                'quantity': item.quantity,
              })
          .toList();

      await prefs.setString('cart', jsonEncode(cartJson));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }
}
