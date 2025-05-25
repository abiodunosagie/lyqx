// lib/presentation/views/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx/data/model/cart_item.dart';
import 'package:lyqx/presentation/components/app_text.dart';
import 'package:lyqx/presentation/components/spacing.dart';
import 'package:lyqx/viewmodel/cart_cubit.dart';

import '../../components/custom_bottom_nav.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? Theme.of(context).scaffoldBackgroundColor
        : Colors.grey[50];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: AppText.titleLarge(
          'Shopping Cart',
          color: Colors.black87,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          BlocBuilder<CartCubit, List<CartItem>>(
            builder: (context, cartItems) {
              if (cartItems.isEmpty) return const SizedBox();

              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  _showClearCartDialog(context);
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              // Cart items list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return _buildCartItem(context, cartItems[index]);
                  },
                ),
              ),

              // Order summary
              _buildOrderSummary(context, cartItems),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          Spacing.verticalM,
          AppText.titleLarge(
            'Your cart is empty',
            color: Colors.grey[700],
          ),
          Spacing.verticalS,
          AppText.bodyMedium(
            'Looks like you haven\'t added\nany items to your cart yet',
            color: Colors.grey[500],
            textAlign: TextAlign.center,
          ),
          Spacing.verticalL,
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const AppText(
              'Start Shopping',
              preset: TextPreset.labelMedium,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            GestureDetector(
              onTap: () => context.go('/product/${item.product.id}'),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMedium(
                    item.product.title.length > 35
                        ? '${item.product.title.substring(0, 35)}...'
                        : item.product.title,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText.bodyMedium(
                    '\$${item.product.price.toStringAsFixed(2)}',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 12),

                  // Quantity controls
                  Row(
                    children: [
                      // Remove item
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CartCubit>()
                              .removeFromCart(item.product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red[700],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Decrement button
                            InkWell(
                              onTap: () {
                                context
                                    .read<CartCubit>()
                                    .decrementQuantity(item.product.id);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: const Icon(Icons.remove, size: 16),
                              ),
                            ),

                            // Quantity display
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              color: Colors.grey[100],
                              child: AppText.bodyMedium(
                                item.quantity.toString(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Increment button
                            InkWell(
                              onTap: () {
                                context
                                    .read<CartCubit>()
                                    .incrementQuantity(item.product.id);
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                child: const Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, List<CartItem> cartItems) {
    final cartCubit = context.read<CartCubit>();
    final subtotal = cartCubit.totalPrice;
    const shipping = 5.99;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMedium(
            'Order Summary',
            fontWeight: FontWeight.bold,
          ),
          Spacing.verticalM,

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bodyMedium(
                'Subtotal',
                color: Colors.grey[600],
              ),
              AppText.bodyMedium(
                '\$${subtotal.toStringAsFixed(2)}',
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          Spacing.verticalS,

          // Shipping
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bodyMedium(
                'Shipping',
                color: Colors.grey[600],
              ),
              AppText.bodyMedium(
                '\$${shipping.toStringAsFixed(2)}',
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.titleMedium(
                'Total',
                fontWeight: FontWeight.bold,
              ),
              AppText.titleMedium(
                '\$${total.toStringAsFixed(2)}',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          Spacing.verticalM,

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                _showCheckoutSuccessDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const AppText(
                'Proceed to Checkout',
                preset: TextPreset.labelLarge,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Clear Cart',
          preset: TextPreset.titleLarge,
          fontWeight: FontWeight.bold,
        ),
        content: const AppText(
          'Are you sure you want to remove all items from your cart?',
          preset: TextPreset.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const AppText(
              'Cancel',
              preset: TextPreset.labelMedium,
              color: Colors.grey,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.of(context).pop();
            },
            child: const AppText(
              'Clear Cart',
              preset: TextPreset.labelMedium,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Order Placed Successfully!',
          preset: TextPreset.titleLarge,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[700],
                size: 60,
              ),
            ),
            Spacing.verticalM,
            const AppText(
              'Your order has been placed successfully. You will receive a confirmation soon.',
              preset: TextPreset.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                context.read<CartCubit>().clearCart();
                Navigator.of(context).pop();
                context.go('/home');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const AppText(
                'Continue Shopping',
                preset: TextPreset.labelMedium,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
