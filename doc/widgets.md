# Widgets

This catalog summarizes the reusable widgets in the design system. Every widget
accepts Material 3 defaults from `NTheme` and can be styled via tokens.

## Buttons

```dart
PrimaryButton(label: 'Primary', onPressed: onTap);
SecondaryButton(label: 'Secondary', onPressed: onTap);
OutlineButton(label: 'Outline', onPressed: onTap);
NashTextButton(label: 'Text', onPressed: onTap);
NashIconButton(icon: Icons.favorite, onPressed: onTap);
FloatingButton(icon: Icons.add, onPressed: onTap);
LoadingButton(label: 'Save', loading: isLoading, onPressed: onTap);
```

Common options: `icon`, `expanded`, `width`, `height`, `loading`, `gradient`.

## Inputs

```dart
NashTextField(label: 'Email', hint: 'you@example.com', validator: Validators.isEmail);
PasswordField(label: 'Password');
EmailField(label: 'Email');
NumberField(label: 'Quantity', min: 0, max: 10);
PhoneField(label: 'Phone');
SearchField(hint: 'Search');
OtpField(length: 6, onCompleted: onSubmit);
NashDropdown<String>(
  items: const <DropdownMenuItem<String>>[
    DropdownMenuItem(value: 'a', label: 'Option A'),
    DropdownMenuItem(value: 'b', label: 'Option B'),
  ],
  value: 'a',
  onChanged: (String? v) {},
);
DateField(label: 'Birthday');
MultiSelect<String>(items: ...);
```

Inputs are built on `FormField` semantics, so they work inside `Form` with
`GlobalKey<FormState>` validation.

## Selection

```dart
NashCheckbox(label: 'Agree', value: true, onChanged: (v) {});
NashSwitch(label: 'Notifications', value: true, onChanged: (v) {});
NashRadio<String>(value: 'a', groupValue: 'a', label: 'Option A', onChanged: (v) {});
NashChip(label: 'Tag', selected: true, onSelected: (v) {});
NashSegmentedButton<String>(segments: [...], selected: ...);
```

## Cards

```dart
NashCard(child: const Text('Content'));
GradientCard(child: const Text('Gradient'));
StatisticCard(title: 'Revenue', value: r'$12,400', icon: Icons.payments);
DashboardCard(title: ..., value: ..., trend: '+12%');
ProductCard(title: 'Headphones', price: r'$99', rating: 4.5, onTap: onTap);
UserCard(name: 'Ada Lovelace', subtitle: 'Engineer');
MedicalCard(doctor: ..., specialty: ...);
LearningCard(course: ..., progress: 0.5);
```

## Media

```dart
NashAvatar(name: 'Ada Lovelace', radius: 24);
NashImage(url: url, placeholder: ..., errorWidget: ...);
NashNetworkImage(url: url);          // cached network image
NashNetworkImage(url: url);         // framed network image
VideoPlaceholder(label: 'Video');
```

## Feedback

```dart
NashSnackbar.info(context, 'Saved!');
NashSnackbar.success(context, 'Saved!');
NashSnackbar.error(context, 'Something went wrong');
NashToast.show(context, message: 'Copied', duration: AppDuration.normal);
NashBanner(message: 'New version available', type: AppFeedbackType.info);
NashTooltip(message: 'Settings', child: ...);
InfoHint(message: 'Why we ask for this');
```

## Navigation

```dart
NashAppBar(title: 'Dashboard', actions: [NashIconButton(icon: Icons.search)]);
NashNavigationRail(selectedIndex: 0, onDestinationSelected: onTap, destinations: [...]);
NashSidebar(selectedIndex: 0, onSelected: onTap, sections: [...]);
BottomNavBar(currentIndex: 0, onTap: onTap, items: [...]);
NavDrawer(children: [NavDrawerSection(title: 'Menu', children: [...])]);
NashTabBar(tabs: [...], controller: tabController);
Breadcrumb(items: const ['Home', 'Settings'], onTap: onTap);
```

## Dialogs

```dart
// Prebuilt helpers
showNAlertDialog(context: context, title: 'Notice', message: '...');
showNConfirmDialog(context: context, title: 'Delete?', onConfirm: onDelete);
showNInputDialog(context: context, title: 'Name', ...);
showNashDialog(context: context, child: NashDialog(title: 'Custom', content: ...));

// Raw themed dialog + bottom sheet widgets
NashDialog(title: 'Custom', content: ..., actions: [...]);
NashBottomSheet(title: 'Options', children: [...]);
ActionSheet(items: const [ActionSheetItem(icon: Icons.edit, label: 'Edit')]);
```

## Charts

```dart
LineChart(values: const [1, 3, 2, 5], labels: const ['Mon', 'Tue', 'Wed', 'Thu']);
BarChart(values: const [12, 25, 8], labels: const ['A', 'B', 'C']);
PieChart(segments: const [NPieSegment(label: 'A', value: 30)]);
NDonutChart(segments: const [NPieSegment(label: 'A', value: 30)]);
Sparkline(values: const [1, 3, 2, 5]);
```

## Loading & indicators

```dart
NashLoader(label: 'Loading...');
CircularProgress(value: 0.6);
LinearProgress(value: 0.6, height: 8);
Skeleton(width: 200, height: 20);
Shimmer(child: ...);
SkeletonList(itemCount: 4);
SkeletonGrid(itemCount: 6, columns: 2);
NashBadge(label: '3', color: AppColors.error);
NashRating(value: 4.5, onChanged: (v) {});
NashTag(label: 'Beta', color: AppColors.primary);
```

## Lists

```dart
NListTile(title: 'Settings', leading: const Icon(Icons.settings), onTap: onTap);
ListGroup(title: 'General', children: [...]);   // expandable group
NSettingsTile(title: 'Dark mode', trailing: NashSwitch(value: true));
SelectionTile<String>(value: 'a', title: 'Option');
NStatTile(label: 'Revenue', value: r'$1,240');
NDataTable(columns: [...], rows: [...]);
NExpansionTile(title: 'Details', children: [...]);
```

## Misc

```dart
NashCalendar(initialMonth: DateTime.now(), initialSelected: DateTime.now());
NashStepper(steps: ['1', '2', '3'], currentStep: 1);
NashTimeline(items: const [NashTimelineItem(title: 'Done', subtitle: '...')]);
NashSection(title: 'Account', child: ...);
```

## UX screens

```dart
EmptyState(title: 'Nothing here', message: '...', icon: Icons.inbox_outlined);
ErrorState(title: 'Oops', message: '...', onRetry: onRetry);
OfflineState(title: 'Offline', message: '...', onRetry: onRetry);
SuccessState(title: 'All set', message: '...', onDone: onDone);
PermissionState(title: 'Allow access', message: '...', onGrant: onGrant);
MaintenanceState(title: 'Under maintenance', message: '...');
UpdateState(title: 'Update available', message: '...', onUpdate: onUpdate);
NotFoundState(title: '404', message: '...', onHome: onHome);
LoadingScreen(title: 'Loading', message: '...');
```

## Forms

```dart
FormSection(title: 'Profile', children: [...]);   // optional collapsible
NashFormField(label: 'Name', error: errorText, child: NashTextField(...));
```
