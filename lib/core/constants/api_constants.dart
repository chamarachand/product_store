class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String productsEndpoint = '/products';
  static const String searchEndpoint = '/products/search';

  static Uri getProductsUri({int limit = 30, int skip = 0}) {
    return Uri.parse('$baseUrl$productsEndpoint?limit=$limit&skip=$skip');
  }

  static Uri getSearchProductsUri(
    String query, {
    int limit = 30,
    int skip = 0,
  }) {
    return Uri.parse(
      '$baseUrl$searchEndpoint?q=${Uri.encodeComponent(query)}&limit=$limit&skip=$skip',
    );
  }
}
