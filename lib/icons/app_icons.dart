import 'package:flutter/material.dart';

/// A curated, single source of truth for commonly used icons.
///
/// Re-exporting [IconData] constants keeps icon usage consistent across the
/// product and simplifies swapping icon themes later.
abstract final class AppIcons {
  AppIcons._();

  // Navigation
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData search = Icons.search;
  static const IconData menu = Icons.menu;
  static const IconData more = Icons.more_vert;
  static const IconData settings = Icons.settings_outlined;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData chevronDown = Icons.keyboard_arrow_down;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData close = Icons.close;

  // Status
  static const IconData success = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info;
  static const IconData help = Icons.help_outline;

  // Actions
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData save = Icons.save_outlined;
  static const IconData share = Icons.share_outlined;
  static const IconData download = Icons.download_outlined;
  static const IconData upload = Icons.upload_outlined;
  static const IconData refresh = Icons.refresh;
  static const IconData favorite = Icons.favorite_border;
  static const IconData favoriteFilled = Icons.favorite;
  static const IconData bookmark = Icons.bookmark_border;
  static const IconData lock = Icons.lock_outline;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData filter = Icons.filter_list;
  static const IconData sort = Icons.sort;
  static const IconData send = Icons.send;
  static const IconData call = Icons.call;
  static const IconData camera = Icons.camera_alt_outlined;
  static const IconData photo = Icons.photo_outlined;
  static const IconData mic = Icons.mic_none;
  static const IconData video = Icons.videocam_outlined;
  static const IconData play = Icons.play_circle_outline;
  static const IconData pause = Icons.pause_circle_outline;
  static const IconData star = Icons.star;
  static const IconData starBorder = Icons.star_border;

  // User / profile
  static const IconData person = Icons.person_outline;
  static const IconData group = Icons.group_outlined;
  static const IconData logout = Icons.logout;
  static const IconData login = Icons.login;
  static const IconData profile = Icons.account_circle_outlined;

  // Business / content
  static const IconData chart = Icons.bar_chart;
  static const IconData chartPie = Icons.pie_chart_outline;
  static const IconData cart = Icons.shopping_cart_outlined;
  static const IconData store = Icons.storefront_outlined;
  static const IconData calendar = Icons.calendar_month_outlined;
  static const IconData clock = Icons.schedule;
  static const IconData location = Icons.place_outlined;
  static const IconData mail = Icons.mail_outline;
  static const IconData phone = Icons.phone;
  static const IconData email = Icons.email_outlined;
  static const IconData attach = Icons.attach_file;
  static const IconData link = Icons.link;
  static const IconData lockClosed = Icons.lock;
  static const IconData shield = Icons.shield_outlined;
  static const IconData notification = Icons.notifications_none;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData wifi = Icons.wifi;
  static const IconData wifiOff = Icons.wifi_off;
  static const IconData battery = Icons.battery_5_bar;
  static const IconData bolt = Icons.bolt;
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData dragHandle = Icons.drag_handle;
  static const IconData arrowUp = Icons.arrow_upward;
  static const IconData arrowDown = Icons.arrow_downward;
  static const IconData trendingUp = Icons.trending_up;
  static const IconData trendingDown = Icons.trending_down;
  static const IconData language = Icons.language;
  static const IconData darkMode = Icons.dark_mode_outlined;
  static const IconData lightMode = Icons.light_mode_outlined;
  static const IconData device = Icons.devices_other;
  static const IconData list = Icons.list;
  static const IconData gridView = Icons.grid_view_outlined;
  static const IconData receipt = Icons.receipt_long_outlined;
  static const IconData card = Icons.credit_card;
  static const IconData wallet = Icons.account_balance_wallet_outlined;
  static const IconData education = Icons.school_outlined;
  static const IconData medical = Icons.medical_services_outlined;
  static const IconData analytics = Icons.insights;
  static const IconData people = Icons.people_outline;
}
