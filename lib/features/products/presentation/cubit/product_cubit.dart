import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_store/core/errors/app_exception.dart';
import 'package:product_store/features/products/data/repositories/favourites_repository.dart';
import 'package:product_store/features/products/data/repositories/product_repository.dart';
import 'package:product_store/features/products/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;
  final FavoritesRepository favoritesRepository;

  ProductCubit({
    required this.productRepository,
    required this.favoritesRepository,
  }) : super(ProductInitial());

  Future<void> loadProducts() async {
    final currentQuery = state is ProductsLoaded
        ? (state as ProductsLoaded).searchQuery
        : '';

    emit(ProductsLoading());

    try {
      final products = await productRepository.getProducts();
      final savedFavourites = favoritesRepository.getFavouriteIds();

      emit(
        ProductsLoaded(
          products: products,
          searchQuery: currentQuery,
          favouriteIds: savedFavourites,
        ),
      );
    } on AppException catch (e) {
      emit(ProductsError(e.message));
    } catch (e) {
      emit(ProductsError("Something went wrong. Please try again."));
    }
  }

  Future<void> searchProducts(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      await loadProducts();
      return;
    }

    emit(ProductsLoading());

    try {
      final products = await productRepository.searchProducts(trimmedQuery);
      if (products.isEmpty) {
        emit(ProductsLoaded(products: [], searchQuery: trimmedQuery));
      } else {
        emit(ProductsLoaded(products: products, searchQuery: trimmedQuery));
      }
    } on AppException catch (e) {
      emit(ProductsError(e.message));
    } catch (e) {
      emit(ProductsError("Something went wrong. Please try again."));
    }
  }

  Future<void> toggleFavourite(int productId) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      final favouriteIds = Set<int>.from(currentState.favouriteIds);

      if (favouriteIds.contains(productId)) {
        favouriteIds.remove(productId);
      } else {
        favouriteIds.add(productId);
      }

      emit(currentState.copyWith(favouriteIds: favouriteIds));

      await favoritesRepository.saveFavouriteIds(favouriteIds);
    }
  }
}
