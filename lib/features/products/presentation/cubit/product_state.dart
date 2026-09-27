import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

@immutable
sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductsLoading extends ProductState {
  const ProductsLoading();
}

final class ProductsLoaded extends ProductState {
  final List<Product> products;
  final Set<int> favouriteIds;
  final String searchQuery;
  final bool isLast;
  final bool isLoadingMore;

  const ProductsLoaded({
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

  @override
  List<Object?> get props => [
    products,
    favouriteIds,
    searchQuery,
    isLast,
    isLoadingMore,
  ];
}

final class ProductsError extends ProductState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
