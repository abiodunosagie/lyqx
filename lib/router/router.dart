import 'package:go_router/go_router.dart';

import '../presentation/views/auth/signin_screen.dart';
import '../presentation/views/cart/cart.dart';
import '../presentation/views/home/home_screen.dart';
import '../presentation/views/product/product_detail_screen.dart';
import '../presentation/views/welcome_screen.dart';
import '../presentation/views/wishlist/wishlist.dart';

final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, stat) => SigninScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, stat) => HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => WishlistScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartScreen(),
    ),
  ],
);
