import 'package:product_store/core/services/local_storage_service.dart';

abstract class FavoritesRepository {
  Set<int> getFavouriteIds();

  Future<void> saveFavouriteIds(Set<int> favouriteIds);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageService localStorageService;

  FavoritesRepositoryImpl({required this.localStorageService});

  @override
  Set<int> getFavouriteIds() {
    return localStorageService.getFavouriteIds();
  }

  @override
  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    await localStorageService.saveFavouriteIds(favouriteIds);
  }
}
