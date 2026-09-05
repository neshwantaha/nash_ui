import 'dart:convert';
import 'dart:typed_data';

/// A pluggable key-value storage interface.
///
/// Implement this to back [Storage] with `shared_preferences`,
/// `hive`, secure storage, or anything else.
abstract interface class StorageBackend {
  /// Returns the stored value for [key] or `null`.
  String? read(String key);

  /// Stores [value] under [key].
  void write(String key, String value);

  /// Removes the value for [key].
  void remove(String key);

  /// Removes all stored values.
  void clear();
}

/// A thread-safe in-memory backend used by default.
class MemoryBackend implements StorageBackend {
  final Map<String, String> _data = <String, String>{};

  @override
  String? read(String key) => _data[key];

  @override
  void write(String key, String value) {
    _data[key] = value;
  }

  @override
  void remove(String key) {
    _data.remove(key);
  }

  @override
  void clear() {
    _data.clear();
  }
}

/// A typed key-value store with JSON, number and bool helpers.
///
/// ```dart
/// Storage.instance.writeString('token', value);
/// final String? token = Storage.instance.readString('token');
/// ```
abstract final class Storage {
  Storage._();

  /// The active backend. Swap this to use a real persistence layer.
  static StorageBackend backend = MemoryBackend();

  /// Reads a string value.
  static String? readString(String key) => backend.read(key);

  /// Writes a string value.
  static void writeString(String key, String value) =>
      backend.write(key, value);

  /// Reads an int value.
  static int? readInt(String key) {
    final String? raw = backend.read(key);
    return raw == null ? null : int.tryParse(raw);
  }

  /// Writes an int value.
  static void writeInt(String key, int value) => backend.write(key, '$value');

  /// Reads a double value.
  static double? readDouble(String key) {
    final String? raw = backend.read(key);
    return raw == null ? null : double.tryParse(raw);
  }

  /// Writes a double value.
  static void writeDouble(String key, double value) =>
      backend.write(key, '$value');

  /// Reads a bool value.
  static bool? readBool(String key) {
    final String? raw = backend.read(key);
    return raw == null ? null : raw == 'true';
  }

  /// Writes a bool value.
  static void writeBool(String key, {required bool value}) =>
      backend.write(key, value ? 'true' : 'false');

  /// Reads a decoded JSON value, or `null`.
  static Object? readJson(String key) {
    final String? raw = backend.read(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      return null;
    }
  }

  /// Encodes and stores [value] as JSON.
  static void writeJson(String key, Object? value) =>
      backend.write(key, jsonEncode(value));

  /// Reads a UTF-8 byte list.
  static Uint8List? readBytes(String key) {
    final String? raw = backend.read(key);
    if (raw == null) return null;
    try {
      return base64Decode(raw);
    } on FormatException {
      return null;
    }
  }

  /// Stores a byte list (base64 encoded).
  static void writeBytes(String key, List<int> bytes) =>
      backend.write(key, base64Encode(bytes));

  /// Removes a key.
  static void remove(String key) => backend.remove(key);

  /// Clears all data.
  static void clear() => backend.clear();
}
