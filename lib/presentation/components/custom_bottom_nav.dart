// lib/presentation/components/custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lyqx/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDarkMode ? AppColors.borderDarkSubtle : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor:
              isDarkMode ? AppColors.primaryLight : AppColors.primary,
          unselectedItemColor: isDarkMode
              ? AppColors.textDarkSecondary
              : AppColors.textLightSecondary,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          onTap: (index) {
            // Always navigate regardless of current index
            // This ensures navigation works even if we tap the current tab
            if (index == 0) {
              context.go('/home');
            } else if (index == 1) {
              context.go('/wishlist');
            } else if (index == 2) {
              context.go('/cart');
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? (isDarkMode
                          ? AppColors.primaryLight.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 0 ? Iconsax.home_15 : Iconsax.home,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? (isDarkMode
                          ? AppColors.primaryLight.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 1 ? Iconsax.heart5 : Iconsax.heart,
                  size: 24,
                ),
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentIndex == 2
                      ? (isDarkMode
                          ? AppColors.primaryLight.withOpacity(0.1)
                          : AppColors.primary.withOpacity(0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  currentIndex == 2
                      ? Iconsax.shopping_bag5
                      : Iconsax.shopping_bag,
                  size: 24,
                ),
              ),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}
