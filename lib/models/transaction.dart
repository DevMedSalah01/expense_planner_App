//Not A WIDGET!
import 'package:flutter/foundation.dart'; // to expose @required

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {@required this.id,
      @required this.date,
      @required this.title,
      @required this.amount});
}
