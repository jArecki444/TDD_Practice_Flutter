/// ServerException is when the response doesn't have a 200 OK , then failures are  ServerExceptions became failures because the Repository will catch the Exceptions and return them using the Either type as Failures.
/// For this reason, Failure types usually exactly map to Exception types.
class ServerException implements Exception {}

class CacheException implements Exception {}
