import 'package:intl/intl.dart';

class CurrencyConvert {
  static String toVND(int amount) {
    final formatter = NumberFormat.currency(locale: "vi_VN");
    return formatter.format(amount);
  }
}
