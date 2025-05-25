// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lyqx/data/repositories/auth_repository.dart' as _i666;
import 'package:lyqx/data/repositories/product_repository.dart' as _i1050;
import 'package:lyqx/data/service/api_service.dart' as _i483;
import 'package:lyqx/viewmodel/auth_cubit.dart' as _i135;
import 'package:lyqx/viewmodel/product_cubit.dart' as _i62;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i483.ApiService>(() => _i483.ApiService());
    gh.lazySingleton<_i1050.ProductRepository>(
        () => _i1050.ProductRepository(gh<_i483.ApiService>()));
    gh.factory<_i62.ProductCubit>(
        () => _i62.ProductCubit(gh<_i1050.ProductRepository>()));
    gh.lazySingleton<_i666.AuthRepository>(
        () => _i666.AuthRepository(gh<_i483.ApiService>()));
    gh.factory<_i135.AuthCubit>(
        () => _i135.AuthCubit(gh<_i666.AuthRepository>()));
    return this;
  }
}
