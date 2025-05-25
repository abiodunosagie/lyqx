import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../api_config.dart';

@lazySingleton
class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  Future<List<dynamic>> getProducts() async {
    final response = await _dio.get("/products");
    return response.data;
  }

  Future<Response> login(Map<String, dynamic> data) async {
    return await _dio.post("/auth/login", data: data);
  }
}
