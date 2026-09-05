# Templates

Full-screen, production-ready layouts built from the design-system widgets.
Drop one into a `Scaffold` body (or `Navigator` route) to ship a polished
screen in minutes.

## Auth

```dart
AuthTemplates.login(
  title: 'Welcome back',
  subtitle: 'Sign in to continue',
  onSubmit: (String email, String password) async {
    await signIn(email, password);
  },
  onForgotPassword: () => Navigator.push(...),
  onSignUp: () => Navigator.push(...),
);

AuthTemplates.signup(
  title: 'Create account',
  onSubmit: (String name, String email, String password) async {},
);

AuthTemplates.forgotPassword(
  title: 'Reset password',
  onSubmit: (String email) async {},
);
```

## Chat

```dart
ChatTemplate(
  title: 'Sarah',
  messages: const <ChatMessage>[
    ChatMessage(text: 'Hey!', time: DateTime(2026, 8, 3, 9, 0)),
    ChatMessage(text: 'Hi there', time: DateTime(2026, 8, 3, 9, 1), isMine: true),
  ],
  onSend: (String text) {},
);
```

## E-commerce

```dart
EcommerceTemplate(
  title: 'Store',
  products: const <Product>[
    Product(title: 'Headphones', price: r'$99', rating: 4.5),
  ],
  categories: const <String>['All', 'Audio'],
  onCategorySelected: (String c) {},
  onProductTap: (Product p) {},
);
```

## Finance

```dart
FinanceTemplate(
  title: 'Finance',
  balance: r'$12,400',
  transactions: const <Transaction>[
    Transaction(title: 'Salary', amount: r'+$2,000', time: 'Today', isCredit: true),
  ],
);
```

## Learning

```dart
LearningTemplate(
  title: 'Learning',
  courses: const <Course>[
    Course(title: 'Flutter Basics', subtitle: '40 lessons', progress: 0.5),
  ],
);
```

## Medical

```dart
MedicalTemplate(
  title: 'Health',
  appointments: const <Appointment>[
    Appointment(title: 'Dr. Smith', subtitle: 'Cardiology', time: '09:30'),
  ],
);
```

## Social

```dart
SocialTemplate(
  title: 'Feed',
  posts: const <SocialPost>[
    SocialPost(author: 'Ada', time: '2h', text: 'Hello world!'),
  ],
);
```

## Settings & profile

```dart
SettingsTemplate(
  title: 'Settings',
  groups: const <SettingsGroup>[
    SettingsGroup(
      title: 'Preferences',
      tiles: <NSettingsTile>[
        NSettingsTile(title: 'Dark mode', icon: Icons.dark_mode_outlined),
      ],
    ),
  ],
);

ProfileHeader(
  name: 'Ada Lovelace',
  bio: 'Software engineer',
  stats: const <ProfileStat>[
    ProfileStat(label: 'Posts', value: '120'),
  ],
);

DashboardHeader(title: 'Overview', subtitle: 'Welcome back', onAction: onRefresh);
```

## Admin & analytics

```dart
AdminTemplate(
  title: 'Admin',
  stats: const <Widget>[StatisticCard(title: 'Users', value: '1,234')],
  columns: const <String>['Name', 'Status'],
  rows: const <AdminRow>[AdminRow(cells: <Widget>[Text('Ada'), Text('Active')])],
);

AnalyticsTemplate(
  kpis: const <AnalyticsKpi>[AnalyticsKpi(label: 'Visitors', value: '8,420', delta: '+12%')],
  lineData: const <double>[1, 2, 3],
  lineLabels: const <String>['Mon', 'Tue', 'Wed'],
);
```
