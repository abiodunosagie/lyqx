import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx/presentation/components/app_text.dart';
import 'package:lyqx/viewmodel/cart_cubit.dart';
import 'package:lyqx/viewmodel/wishlist_cubit.dart';

import '../../../data/model/product_model.dart';
import '../../../viewmodel/product_cubit.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Initialize favorite status from wishlist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlistCubit = context.read<WishlistCubit>();
      final isInWishlist = wishlistCubit.isInWishlist(widget.productId);

      if (isFavorite != isInWishlist) {
        setState(() {
          isFavorite = isInWishlist;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = context.read<ProductCubit>().state.firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => Product(
            id: 0,
            title: 'Not Found',
            price: 0,
            image: '',
          ),
        );

    // Format the category name to look better (capitalize each word)
    String formattedCategory = '';
    if (product.category != null && product.category!.isNotEmpty) {
      formattedCategory = product.category!.split(' ').map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }).join(' ');
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Main content - scrollable
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: Colors.grey[50],
                  elevation: 0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  leadingWidth: 60,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black54),
                    onPressed: () => context.go('/home'),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black54,
                        size: 28,
                      ),
                      onPressed: () {
                        final wishlistCubit = context.read<WishlistCubit>();
                        final newValue = !isFavorite;

                        setState(() {
                          isFavorite = newValue;
                        });

                        if (newValue) {
                          wishlistCubit.addToWishlist(product);
                        } else {
                          wishlistCubit.removeFromWishlist(product);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // Product image
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Product details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title - using AppText component
                        AppText(
                          product.title,
                          preset: TextPreset.displaySmall,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),

                        const SizedBox(height: 8),

                        // Category - using AppText component and showing actual API category
                        AppText(
                          formattedCategory.isNotEmpty
                              ? '$formattedCategory Category'
                              : '',
                          preset: TextPreset.bodyMedium,
                          color: Colors.grey[600],
                        ),

                        const SizedBox(height: 16),

                        // Rating with Reviews
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            AppText(
                              product.rating != null
                                  ? product.rating!.rate.toString()
                                  : '',
                              preset: TextPreset.titleMedium,
                              fontWeight: FontWeight.bold,
                            ),
                            if (product.rating != null) ...[
                              const SizedBox(width: 6),
                              AppText(
                                '(${product.rating!.count} Reviews)',
                                preset: TextPreset.bodyMedium,
                                color: Colors.grey[500],
                              ),
                            ],
                          ],
                        ),

                        // Description (if available)
                        if (product.description != null &&
                            product.description!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          AppText(
                            'Description',
                            preset: TextPreset.titleMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            product.description!,
                            preset: TextPreset.bodyMedium,
                            color: Colors.grey[700],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar - fixed
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE8B0),
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      'Price',
                      preset: TextPreset.bodyMedium,
                      color: Colors.grey[800],
                    ),
                    AppText(
                      '\$${product.price.toStringAsFixed(2)}',
                      preset: TextPreset.headingMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ],
                ),

                // Add to cart button
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Add to cart functionality
                      context.read<CartCubit>().addToCart(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text('Added to cart'),
                              ),
                              TextButton(
                                onPressed: () => context.go('/cart'),
                                child: const Text(
                                  'VIEW CART',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          backgroundColor: Colors.green[700],
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const AppText(
                      'Add to cart',
                      preset: TextPreset.labelLarge,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
