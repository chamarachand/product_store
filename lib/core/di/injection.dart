import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:product_store/core/services/api_client.dart';
import 'package:product_store/core/services/local_storage_service.dart';
import 'package:product_store/features/products/data/repositories/favourites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/products/data/repositories/product_repository.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpDependecies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localStorageService: getIt<LocalStorageService>(),
    ),
  );

  // Cubits / Blocs
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(
      productRepository: getIt<ProductRepository>(),
      favoritesRepository: getIt<FavoritesRepository>(),
    ),
  );
}
