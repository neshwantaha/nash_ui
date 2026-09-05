import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

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

  static Uri _resolveUri(String path, [Map<String, dynamic>? queryParams]) {
    String fullUrl = path;
    if (!path.startsWith('http://') && !path.startsWith('https://')) {
      final base = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      fullUrl = '$base${path.startsWith('/') ? path : '/$path'}';
    }
    final uri = Uri.parse(fullUrl);
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: <String, String>{
        ...uri.queryParameters,
        ...queryParams.map((k, v) => MapEntry(k, v.toString())),
      });
    }
    return uri;
  }

  static Future<NetworkResponse<T>> _execute<T>({
    required String method,
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    Object? body,
    Duration? timeout,
  }) async {
    try {
      final uri = _resolveUri(path, queryParams);
      final mergedHeaders = <String, String>{
        ...defaultHeaders,
        if (headers != null) ...headers,
      };
      if (onRequest != null) await onRequest!(method, uri, mergedHeaders, body);

      final completer = Completer<NetworkResponse<T>>();
      final xhr = web.XMLHttpRequest()
        ..open(method, uri.toString())
        ..timeout = (timeout ?? defaultTimeout).inMilliseconds;
      // ignore: unnecessary_lambdas — tear-offs of JS interop extension type members are disallowed.
      mergedHeaders.forEach((key, value) {
        xhr.setRequestHeader(key, value);
      });

      xhr
        ..addEventListener(
          'load',
          ((web.Event _) {
            if (completer.isCompleted) return;
            final responseBody = xhr.responseText;
            final rawHeaders = xhr.getAllResponseHeaders();
            final responseHeaders = <String, String>{};
            for (final line in rawHeaders.split('\n')) {
              final parts = line.split(':');
              if (parts.length >= 2) {
                responseHeaders[parts[0].trim()] =
                    parts.sublist(1).join(':').trim();
              }
            }

            T? parsedData;
            if (responseBody.isNotEmpty) {
              try {
                final decoded = jsonDecode(responseBody);
                if (decoded is T) parsedData = decoded;
              } catch (_) {}
            }

            final statusCode = xhr.status;
            final isSuccess = statusCode >= 200 && statusCode < 300;
            final result = NetworkResponse<T>(
              statusCode: statusCode,
              data: parsedData,
              body: responseBody,
              headers: responseHeaders,
              isSuccess: isSuccess,
              error: isSuccess ? null : 'HTTP $statusCode: $responseBody',
            );
            if (onResponse != null) onResponse!(result);
            completer.complete(result);
          }).toJS,
        )
        ..addEventListener(
          'error',
          ((web.Event _) {
            if (completer.isCompleted) return;
            completer.complete(NetworkResponse<T>(
              statusCode: 0,
              isSuccess: false,
              error: 'Network error or CORS violation',
            ));
          }).toJS,
        )
        ..addEventListener(
          'timeout',
          ((web.Event _) {
            if (completer.isCompleted) return;
            completer.complete(NetworkResponse<T>(
              statusCode: 0,
              isSuccess: false,
              error: 'Request timed out',
            ));
          }).toJS,
        );

      if (body != null) {
        final payload = body is String ? body : jsonEncode(body);
        xhr.send(payload.toJS);
      } else {
        xhr.send();
      }

      return await completer.future;
    } catch (e) {
      return NetworkResponse<T>(statusCode: 0, isSuccess: false, error: '$e');
    }
  }

  static Future<NetworkResponse<T>> get<T>(String path,
          {Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) =>
      _execute<T>(
          method: 'GET',
          path: path,
          headers: headers,
          queryParams: queryParams,
          timeout: timeout);

  static Future<NetworkResponse<T>> post<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) =>
      _execute<T>(
          method: 'POST',
          path: path,
          body: body,
          headers: headers,
          queryParams: queryParams,
          timeout: timeout);

  static Future<NetworkResponse<T>> put<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) =>
      _execute<T>(
          method: 'PUT',
          path: path,
          body: body,
          headers: headers,
          queryParams: queryParams,
          timeout: timeout);

  static Future<NetworkResponse<T>> patch<T>(String path,
          {Object? body,
          Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) =>
      _execute<T>(
          method: 'PATCH',
          path: path,
          body: body,
          headers: headers,
          queryParams: queryParams,
          timeout: timeout);

  static Future<NetworkResponse<T>> delete<T>(String path,
          {Map<String, String>? headers,
          Map<String, dynamic>? queryParams,
          Duration? timeout}) =>
      _execute<T>(
          method: 'DELETE',
          path: path,
          headers: headers,
          queryParams: queryParams,
          timeout: timeout);
}
