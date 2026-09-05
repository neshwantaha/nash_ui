import 'package:flutter/material.dart';

/// Font weight tokens used across the design system.
abstract final class AppFontWeight {
  AppFontWeight._();

  /// Light (300).
  static const FontWeight light = FontWeight.w300;

  /// Regular (400).
  static const FontWeight regular = FontWeight.w400;

  /// Medium (500).
  static const FontWeight medium = FontWeight.w500;

  /// Semi-bold (600).
  static const FontWeight semibold = FontWeight.w600;

  /// Bold (700).
  static const FontWeight bold = FontWeight.w700;

  /// Extra-bold (800).
  static const FontWeight extraBold = FontWeight.w800;

  /// Black (900).
  static const FontWeight black = FontWeight.w900;
}
