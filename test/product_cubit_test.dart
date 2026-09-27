// Unit tests for ProductCubit
import 'package:flutter_test/flutter_test.dart';
import 'package:product_store/features/products/presentation/cubit/product_cubit.dart';
import 'package:product_store/features/products/presentation/cubit/product_state.dart';
import 'package:product_store/features/products/data/repositories/product_repository.dart';
import 'package:product_store/features/products/data/repositories/favourites_repository.dart';
import 'package:product_store/core/errors/app_exception.dart';
import 'package:product_store/features/products/data/models/product_model.dart';

// Simple fake implementations for repositories
class FakeProductRepository implements ProductRepository {
  final List<Product> productsToReturn;
  final bool shouldThrow;
  FakeProductRepository({required this.productsToReturn, this.shouldThrow = false});

  @override
  Future<List<Product>> getProducts({int limit = 10, int skip = 0}) async {
    if (shouldThrow) throw const AppException('Failed');
    return productsToReturn;
  }

  @override
  Future<List<Product>> searchProducts(String query, {int limit = 10, int skip = 0}) async {
    if (shouldThrow) throw const AppException('Failed');
    return productsToReturn.where((p) => p.title.contains(query)).toList();
  }
}

class FakeFavoritesRepository implements FavoritesRepository {
  Set<int> favouriteIds;
  FakeFavoritesRepository({Set<int>? initial}) : favouriteIds = initial ?? {};
  @override
  Set<int> getFavouriteIds() => favouriteIds;

  @override
  Future<void> saveFavouriteIds(Set<int> ids) async {
    favouriteIds = ids;
  }
}

void main() {
  group('ProductCubit', () {
    test('initial state is ProductInitial', () {
      final cubit = ProductCubit(
        productRepository: FakeProductRepository(productsToReturn: []),
        favoritesRepository: FakeFavoritesRepository(),
      );
      expect(cubit.state, isA<ProductInitial>());
    });

    test('emits loaded state on successful getProducts', () async {
      final product = Product(
        id: 1,
        title: 'Test',
        description: 'desc',
        price: 10,
        discountPercentage: 0,
        rating: 0,
        stock: 0,
        brand: '',
        category: '',
        thumbnail: '',
        images: [],
      );
      final cubit = ProductCubit(
        productRepository: FakeProductRepository(productsToReturn: [product]),
        favoritesRepository: FakeFavoritesRepository(initial: {1}),
      );

      await cubit.getProducts();
      final state = cubit.state;
      expect(state, isA<ProductsLoaded>());
      final loaded = state as ProductsLoaded;
      expect(loaded.products, contains(product));
      expect(loaded.favouriteIds.contains(1), isTrue);
    });

    test('emits error state when repository throws', () async {
      final cubit = ProductCubit(
        productRepository: FakeProductRepository(productsToReturn: [], shouldThrow: true),
        favoritesRepository: FakeFavoritesRepository(),
      );
      await cubit.getProducts();
      expect(cubit.state, isA<ProductsError>());
    });

    test('toggleFavourite updates favouriteIds', () async {
      final product = Product(
        id: 1,
        title: 'Test',
        description: 'desc',
        price: 10,
        discountPercentage: 0,
        rating: 0,
        stock: 0,
        brand: '',
        category: '',
        thumbnail: '',
        images: [],
      );
      final cubit = ProductCubit(
        productRepository: FakeProductRepository(productsToReturn: [product]),
        favoritesRepository: FakeFavoritesRepository(initial: {}),
      );

      await cubit.getProducts();
      var loaded = cubit.state as ProductsLoaded;
      expect(loaded.favouriteIds.contains(1), isFalse);

      await cubit.toggleFavourite(1);
      loaded = cubit.state as ProductsLoaded;
      expect(loaded.favouriteIds.contains(1), isTrue);
    });
  });
}
