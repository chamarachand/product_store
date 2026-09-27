import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const String _favouritesKey = 'favourite_product_ids';

  Set<int> getFavouriteIds() {
    final favList = _prefs.getStringList(_favouritesKey);
    if (favList == null || favList.isEmpty) return {};

    return favList.map((id) => int.tryParse(id)).whereType<int>().toSet();
  }

  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    final stringList = favouriteIds.map((id) => id.toString()).toList();
    await _prefs.setStringList(_favouritesKey, stringList);
  }
}
