import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lyqx/app.dart';
import 'package:lyqx/di/di.dart';
import 'package:lyqx/router/router.dart';
import 'package:lyqx/theme/app_theme.dart';
import 'package:lyqx/viewmodel/auth_cubit.dart';
import 'package:lyqx/viewmodel/cart_cubit.dart';
import 'package:lyqx/viewmodel/product_cubit.dart';
import 'package:lyqx/viewmodel/theme_cubit.dart';
import 'package:lyqx/viewmodel/wishlist_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  final authCubit = getIt<AuthCubit>();
  await authCubit.loadSavedUser();

  runApp(const App());
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
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'LYQX Shopping App',
            routerConfig: router,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
