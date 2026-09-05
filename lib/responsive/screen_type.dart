/// Screen size categories used across the responsive framework.
enum AppScreenType {
  /// Phones and small handset devices (< 600dp).
  phone,

  /// Tablets and folded large phones (600dp – 1024dp).
  tablet,

  /// Desktop, laptop and large tablet (> 1024dp).
  desktop;

  /// Whether this screen type is a handset.
  bool get isPhone => this == AppScreenType.phone;

  /// Whether this screen type is a tablet.
  bool get isTablet => this == AppScreenType.tablet;

  /// Whether this screen type is a desktop.
  bool get isDesktop => this == AppScreenType.desktop;
}
