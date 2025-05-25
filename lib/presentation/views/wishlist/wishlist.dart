import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx/data/model/product_model.dart';
import 'package:lyqx/presentation/components/app_text.dart';
import 'package:lyqx/presentation/components/spacing.dart';
import 'package:lyqx/theme/app_colors.dart';
import 'package:lyqx/viewmodel/wishlist_cubit.dart';

import '../../components/custom_bottom_nav.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: AppText.titleLarge('My Wishlist'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<WishlistCubit, List<Product>>(
        builder: (context, wishlist) {
          if (wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  Spacing.verticalM,
                  AppText.titleMedium(
                    'Your wishlist is empty',
                    color: Colors.grey[600],
                  ),
                  Spacing.verticalS,
                  AppText.bodyMedium(
                    'Add items to your wishlist by tapping the heart icon',
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
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const AppText(
                      'Browse Products',
                      preset: TextPreset.labelMedium,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final product = wishlist[index];
              return _buildWishlistItem(context, product);
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Product product) {
    // Format category
    String categoryText = 'Unknown Category';
    if (product.category != null && product.category!.isNotEmpty) {
      categoryText = product.category!.split(' ').map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }).join(' ');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product image
            GestureDetector(
              onTap: () => context.go('/product/${product.id}'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.titleMedium(
                    product.title.length > 25
                        ? '${product.title.substring(0, 25)}...'
                        : product.title,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  AppText.bodyMedium(
                    categoryText,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      AppText.bodyMedium(
                        product.rating != null
                            ? product.rating!.rate.toString()
                            : '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText.titleMedium(
                    '\$${product.price.toStringAsFixed(2)}',
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            // Remove from wishlist button
            IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () {
                context.read<WishlistCubit>().removeFromWishlist(product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
