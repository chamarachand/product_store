import 'package:product_store/core/services/local_storage_service.dart';

abstract class FavoritesRepository {
  Set<int> getFavouriteIds();

  Future<void> saveFavouriteIds(Set<int> favouriteIds);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageService _localStorageService;

  FavoritesRepositoryImpl({required this._localStorageService});

  @override
  Set<int> getFavouriteIds() {
    return _localStorageService.getFavouriteIds();
  }

  @override
  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    await _localStorageService.saveFavouriteIds(favouriteIds);
  }
}
