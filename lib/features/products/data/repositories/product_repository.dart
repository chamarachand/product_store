import 'dart:convert';

import 'package:product_store/core/constants/api_constants.dart';
import 'package:product_store/core/constants/app_constants.dart';
import 'package:product_store/core/errors/app_exception.dart';
import 'package:product_store/core/services/api_client.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 30, int skip = 0});
  Future<List<Product>> searchProducts(
    String query, {
    int limit = AppConstants.paginationLimit,
    int skip = 0,
  });
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final uri = ApiConstants.getProductsUri(limit: limit, skip: skip);
      final response = await apiClient.get(uri);
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final productResponse = ProductResponse.fromJson(data);
      return productResponse.products;
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    int limit = AppConstants.paginationLimit,
    int skip = 0,
  }) async {
    try {
      final uri = ApiConstants.getSearchProductsUri(
        query,
        limit: limit,
        skip: skip,
      );

      final response = await apiClient.get(uri);
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final productResponse = ProductResponse.fromJson(data);
      return productResponse.products;
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
