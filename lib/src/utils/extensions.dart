import 'package:intl/intl.dart';

extension DateParsing on String {
  String toDate() {
    final date = DateFormat('MMMM dd, yyyy').format(
      DateTime.parse(this),
    );

    return date;
  }
}
