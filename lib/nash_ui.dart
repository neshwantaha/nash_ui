/// Nash UI — a modern, scalable, production-ready Flutter design system.
///
/// Import this single library to access the full catalog of design tokens,
/// theme engine, animations, layouts and widgets.
///
/// This barrel re-exports [flutter/material.dart], [flutter/cupertino.dart]
/// and [flutter/services.dart] with conflicting symbols automatically replaced
/// by Nash's modern components:
///
/// ## Icons
///
/// All Material icons are available through [Icons]:
/// ```dart
/// import 'package:nash_ui/nash_ui.dart';
///
/// Icon(Icons.home)            // ✅ Material icon
/// Icon(Icons.star)            // ✅ Material icon
/// Icon(Icons.favorite)        // ✅ Material icon
/// Icon(Icons.settings)        // ✅ Material icon
/// Icon(CupertinoIcons.heart)  // ✅ Cupertino / iOS icon
/// ```
///
/// ## Components
/// ```dart
/// Card(...)              // Nash Card ✅
/// TextField(...)         // Nash TextField ✅
/// AppBar(...)            // Nash AppBar ✅
/// Dialog(...)            // Nash Dialog ✅
/// Scaffold(...)          // Flutter Scaffold ✅
/// ```
library;

// Re-export Flutter so consumers only need one import.
// Names that conflict with Nash classes are hidden here so Nash's modern versions win.

// Expose CupertinoIcons (iOS-style icons) alongside Material Icons.
export 'package:flutter/cupertino.dart' show CupertinoIcons;

export 'package:flutter/material.dart'
    hide
        AnimatedContainer, // Nash AnimatedContainer
        AppBar, // Nash AppBar
        Badge, // Nash Badge
        Banner, // Nash Banner
        BottomSheet, // Nash BottomSheet
        Card, // Nash Card
        Checkbox, // Nash Checkbox
        Chip, // Nash Chip
        DataColumn, // Nash DataColumn
        DataRow, // Nash DataRow
        DataTable, // Nash DataTable
        Dialog, // Nash Dialog
        Draggable, // Nash Draggable
        ExpansionTile, // Nash ExpansionTile
        Form, // Nash Form
        FormState, // Nash FormState (State<Form>)
        IconButton, // Nash IconButton
        ListTile, // Nash ListTile
        NavigationRail, // Nash NavigationRail
        Notification, // Nash Notification
        PageRoute, // Nash PageRoute transitions
        PopupMenuItem, // Nash PopupMenuItem
        Radio, // Nash Radio
        RangeSlider, // Nash RangeSlider
        SegmentedButton, // Nash SegmentedButton
        Slider, // Nash Slider
        Stepper, // Nash Stepper
        StepState, // Nash StepState
        Switch, // Nash Switch
        Tab, // Nash Tab
        TabBar, // Nash TabBar
        TextButton, // Nash TextButton
        TextField, // Nash TextField
        Theme, // Nash Theme with .light() / .dark()
        Tooltip, // Nash Tooltip
        showBottomSheet, // Nash showBottomSheet
        showDatePicker, // Nash showDatePicker
        showDateRangePicker, // Nash showDateRangePicker
        showDialog; // Nash showDialog
export 'package:flutter/services.dart'
    hide Clipboard; // Nash has its own Clipboard service wrapper

export 'widgets/widgets.dart';
