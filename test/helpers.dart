import 'package:intl/date_symbol_data_local.dart';

/// Initializes `en_US` date symbols so `intl` `DateFormat` calls work in tests.
Future<void> initDateFormats() => initializeDateFormatting('en_US');
