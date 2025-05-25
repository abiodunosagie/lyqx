import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lyqx/data/model/product_model.dart';
import 'package:lyqx/theme/app_colors.dart';
import 'package:lyqx/viewmodel/auth_cubit.dart';
import 'package:lyqx/viewmodel/product_cubit.dart';
import 'package:lyqx/viewmodel/wishlist_cubit.dart';

import '../../components/app_text.dart';
import '../../components/custom_bottom_nav.dart';
import '../../components/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track favorite status
  final Map<int, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    context.read<ProductCubit>().getProducts();

    // Load saved user data if exists
    context.read<AuthCubit>().loadSavedUser();

    // Initialize favorites from wishlist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlist = context.read<WishlistCubit>().state;
      for (var product in wishlist) {
        _favorites[product.id] = true;
      }
      if (wishlist.isNotEmpty) {
        setState(() {});
      }
    });
  }

  void _toggleFavorite(int productId) {
    final product = context.read<ProductCubit>().state.firstWhere(
          (p) => p.id == productId,
          orElse: () => Product(
            id: 0,
            title: 'Not Found',
            price: 0,
            image: '',
          ),
        );

    if (product.id != 0) {
      final wishlistCubit = context.read<WishlistCubit>();
      final isInWishlist = wishlistCubit.isInWishlist(productId);

      setState(() {
        _favorites[productId] = !isInWishlist;
      });

      if (isInWishlist) {
        wishlistCubit.removeFromWishlist(product);
      } else {
        wishlistCubit.addToWishlist(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDarkMode
                        ? AppColors.darkBrandGradient
                        : AppColors.brandGradient,
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Iconsax.user,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                Spacing.horizontalSM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.labelLarge(
                        'Welcome back',
                        color: isDarkMode
                            ? AppColors.textDarkMediumEmphasis
                            : AppColors.textLightSecondary,
                      ),
                      AppText.titleMedium(
                        authState.isLoggedIn ? authState.username : 'Guest',
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textDarkHighEmphasis
                            : AppColors.textLightPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          // Auth Button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              return Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.backgroundDarkSurface2
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.borderDarkSubtle
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    if (authState.isLoggedIn) {
                      _showLogoutDialog(context);
                    } else {
                      context.go('/signin');
                    }
                  },
                  icon: Icon(
                    authState.isLoggedIn ? Iconsax.logout : Iconsax.login,
                    color: authState.isLoggedIn
                        ? (isDarkMode
                            ? AppColors.errorDarkMode
                            : AppColors.error)
                        : (isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primary),
                    size: 20,
                  ),
                ),
              );
            },
          ),
          Spacing.horizontalS,
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product List
            Expanded(
              child: BlocBuilder<ProductCubit, List<Product>>(
                builder: (context, products) {
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.backgroundDarkSurface2
                                  : Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(
                              color: isDarkMode
                                  ? AppColors.primaryLight
                                  : AppColors.primary,
                              strokeWidth: 3,
                            ),
                          ),
                          Spacing.verticalM,
                          AppText.titleMedium(
                            'Loading amazing products...',
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(context, product, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: AppText.titleLarge(
            'Logout',
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? AppColors.textDarkHighEmphasis
                : AppColors.textLightPrimary,
          ),
          content: AppText.bodyMedium(
            'Are you sure you want to logout?',
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.textLightSecondary,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText.labelMedium(
                'Cancel',
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLightSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthCubit>().logout();
                context.go('/signin');
              },
              child: AppText.labelMedium(
                'Logout',
                color: isDarkMode ? AppColors.errorDarkMode : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, int index) {
    final bool isFavorite = _favorites[product.id] ?? false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Format the title if it's too long
    final String title = product.title.length > 25
        ? '${product.title.substring(0, 25)}...'
        : product.title;

    // Get category text (capitalize for better presentation)
    String categoryText = 'Unknown Category';
    if (product.category != null && product.category!.isNotEmpty) {
      categoryText = product.category!.split(' ').map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }).join(' ');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDarkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDarkMode ? AppColors.borderDarkSubtle : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('/product/${product.id}');
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Product Image with Enhanced Styling
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: isDarkMode
                        ? AppColors.backgroundDarkSurface2
                        : Colors.grey[50],
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.borderDarkInput
                          : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.backgroundDarkSurface3
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: isDarkMode
                                  ? AppColors.primaryLight
                                  : AppColors.primary,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.backgroundDarkSurface3
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            Iconsax.image,
                            color: isDarkMode
                                ? AppColors.textDarkLowEmphasis
                                : Colors.grey[400],
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 16.0),

                // Product Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AppText.titleMedium(
                        title,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.textDarkHighEmphasis
                            : AppColors.textLightPrimary,
                      ),
                      const SizedBox(height: 4.0),

                      // Category
                      AppText.bodyMedium(
                        categoryText,
                        color: isDarkMode
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                      const SizedBox(height: 8.0),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18.0,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 4.0),
                          AppText.bodyMedium(
                            product.rating != null
                                ? product.rating!.rate.toString()
                                : 'N/A',
                            color: isDarkMode
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                          const SizedBox(width: 8.0),
                          if (product.rating != null)
                            AppText.caption(
                              '(${product.rating!.count})',
                              color: isDarkMode
                                  ? AppColors.textDarkLowEmphasis
                                  : AppColors.textLightSecondary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6.0),

                      // Price
                      AppText.titleMedium(
                        '\$${product.price.toStringAsFixed(2)}',
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? AppColors.primaryLight
                            : AppColors.primary,
                      ),
                    ],
                  ),
                ),

                // Enhanced Favorite Button
                Container(
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? (isDarkMode
                            ? AppColors.errorDarkModeBackground
                            : Colors.red.shade50)
                        : (isDarkMode
                            ? AppColors.backgroundDarkSurface2
                            : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isFavorite
                          ? (isDarkMode
                              ? AppColors.errorDarkMode.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3))
                          : (isDarkMode
                              ? AppColors.borderDarkSubtle
                              : Colors.grey[300]!),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Iconsax.heart5 : Iconsax.heart,
                      color: isFavorite
                          ? (isDarkMode ? AppColors.errorDarkMode : Colors.red)
                          : (isDarkMode
                              ? AppColors.textDarkSecondary
                              : Colors.grey[400]),
                      size: 22.0,
                    ),
                    onPressed: () => _toggleFavorite(product.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
