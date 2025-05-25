import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repositories/product_repository.dart';
import '../data/model/product_model.dart';

@injectable // 👈 important annotation
class ProductCubit extends Cubit<List<Product>> {
  final ProductRepository repo;

  ProductCubit(this.repo) : super([]);

  void getProducts() async => emit(await repo.fetchProducts());
}
