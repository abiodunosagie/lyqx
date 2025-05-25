import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyqx/di/di.dart';
import 'package:lyqx/router/router.dart';
import 'package:lyqx/viewmodel/auth_cubit.dart';
import 'package:lyqx/viewmodel/cart_cubit.dart';
import 'package:lyqx/viewmodel/product_cubit.dart';
import 'package:lyqx/viewmodel/wishlist_cubit.dart';

void main() async {
  configureDependencies();
  final authCubit = getIt<AuthCubit>();
  await authCubit.loadSavedUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductCubit>()..getProducts()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
