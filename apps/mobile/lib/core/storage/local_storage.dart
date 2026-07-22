/// Future local persistence contract. Phase 1 intentionally has no implementation.
abstract interface class LocalStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}
