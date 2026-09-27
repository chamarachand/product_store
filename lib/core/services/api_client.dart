import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:product_store/core/errors/app_exception.dart';

import 'dart:async';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> get(
    Uri uri, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    print(uri);
    try {
      final response = await _client.get(uri).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw ServerException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException(
        'Connection timed out. Please check your internet speed.',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
