import 'package:intl/intl.dart';

String formatCurrency(String amount) {
  // Convert the string to a double to handle numbers
  double parsedAmount = double.tryParse(amount) ?? 0.0;

  // Use intl package to format the currency
  final formatCurrency = NumberFormat.currency(locale: 'en_US', symbol: '');

  // Format the parsed amount as a currency string with commas
  return formatCurrency.format(parsedAmount);
}
