import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as fl show Clipboard;
import 'package:flutter/services.dart' show ClipboardData;

import '../widgets/feedback/snackbar.dart';

/// Clipboard and copy helpers.
abstract final class Clipboard {
  Clipboard._();

  /// Copies [text] to the clipboard and shows a confirmation snackbar.
  static Future<void> copy(BuildContext context, String text,
      {String? label}) async {
    await fl.Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    Snackbar.info(context, label ?? 'Copied to clipboard');
  }

  /// Copies [text] silently without any feedback.
  static Future<void> copySilent(String text) =>
      fl.Clipboard.setData(ClipboardData(text: text));

  /// Reads the current clipboard text.
  static Future<String?> read() async {
    final ClipboardData? data =
        await fl.Clipboard.getData(fl.Clipboard.kTextPlain);
    return data?.text;
  }

  /// Clears the clipboard.
  static Future<void> clear() async {
    await fl.Clipboard.setData(const ClipboardData(text: ''));
  }
}
