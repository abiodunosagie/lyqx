import 'package:injectable/injectable.dart';

import '../model/product_model.dart';
import '../service/api_service.dart';

@lazySingleton
class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<Product>> fetchProducts() async {
    final productsJson = await apiService.getProducts();
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
}
