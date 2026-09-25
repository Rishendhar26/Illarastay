/// Storage abstraction for property and profile images.
///
/// A Supabase Storage implementation can replace this contract without
/// changing widgets or feature controllers.
abstract interface class StorageService {
  Future<String> uploadPropertyImage(
      {required String propertyId,
      required String fileName,
      required List<int> bytes});
  Future<String> uploadProfileImage(
      {required String userId,
      required String fileName,
      required List<int> bytes});
}

class StorageNotConfiguredException implements Exception {
  const StorageNotConfiguredException();

  @override
  String toString() => 'Storage is not configured for this environment.';
}
