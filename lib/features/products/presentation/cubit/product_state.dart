import 'package:flutter/material.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

@immutable
sealed class ProductState {}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final Set<int> favouriteIds;
  final String searchQuery;

  ProductsLoaded({
    required this.products,
    this.favouriteIds = const {},
    this.searchQuery = '',
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    List<Product>? displayProducts,
    Set<int>? favouriteIds,
    String? searchQuery,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsError extends ProductState {
  final String message;

  ProductsError(this.message);
}
