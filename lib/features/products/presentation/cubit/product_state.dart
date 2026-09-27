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
  final bool isLast;
  final bool isLoadingMore;

  ProductsLoaded({
    required this.products,
    this.favouriteIds = const {},
    this.searchQuery = '',
    this.isLast = false,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    Set<int>? favouriteIds,
    String? searchQuery,
    bool? isLast,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      favouriteIds: favouriteIds ?? this.favouriteIds,
      searchQuery: searchQuery ?? this.searchQuery,
      isLast: isLast ?? this.isLast,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductsError extends ProductState {
  final String message;

  ProductsError(this.message);
}
