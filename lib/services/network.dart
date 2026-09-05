// Platform-adaptive HTTP network client.
// Automatically uses `dart:io` on mobile/desktop and `package:web` on Web/Wasm.
export 'network_stub.dart'
    if (dart.library.io) 'network_io.dart'
    if (dart.library.js_interop) 'network_web.dart';
