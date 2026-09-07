class NoInternetException implements Exception {
  final String message;
  const NoInternetException([this.message = 'No internet connection']);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'A server error occurred']);

  @override
  String toString() => message;
}
