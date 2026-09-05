import 'dart:async';

/// Response representation for [AppNetwork] requests.
class NetworkResponse<T> {
  const NetworkResponse({
    required this.statusCode,
    this.data,
    this.body,
    this.headers = const <String, String>{},
    this.isSuccess = true,
    this.error,
  });

  final int statusCode;
  final T? data;
  final String? body;
  final Map<String, String> headers;
  final bool isSuccess;
  final String? error;
}

abstract final class AppNetwork {
  AppNetwork._();

  static String baseUrl = '';
  static Duration defaultTimeout = const Duration(seconds: 30);
  static final Map<String, String> defaultHeaders = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static FutureOr<void> Function(
          String method, Uri uri, Map<String, String> headers, Object? body)?
      onRequest;
  static FutureOr<void> Function(NetworkResponse<dynamic> response)? onResponse;

  static void setBearerToken(String token) =>
      defaultHeaders['Authorization'] = 'Bearer $token';
  static void clearBearerToken() => defaultHeaders.remove('Authorization');

  static Future<NetworkResponse<T>> get<T>(String path,
          {Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) async =>
      NetworkResponse<T>(
        statusCode: 0,
        isSuccess: false,
        error: 'Unsupported platform',
      );

  static Future<NetworkResponse<T>> post<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) async =>
      NetworkResponse<T>(
        statusCode: 0,
        isSuccess: false,
        error: 'Unsupported platform',
      );

  static Future<NetworkResponse<T>> put<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) async =>
      NetworkResponse<T>(
        statusCode: 0,
        isSuccess: false,
        error: 'Unsupported platform',
      );

  static Future<NetworkResponse<T>> patch<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) async =>
      NetworkResponse<T>(
        statusCode: 0,
        isSuccess: false,
        error: 'Unsupported platform',
      );

  static Future<NetworkResponse<T>> delete<T>(String path,
          {Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) async =>
      NetworkResponse<T>(
        statusCode: 0,
        isSuccess: false,
        error: 'Unsupported platform',
      );
}
