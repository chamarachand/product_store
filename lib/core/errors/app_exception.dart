class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Unable to connect to the server. Please check your internet connection.',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode,
  ]);
}

class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
