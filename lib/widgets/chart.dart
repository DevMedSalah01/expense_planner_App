//Planning the Chart Widget about recent tx per WEEK

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions; // For the last 7 days

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index),);
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day ==weekDay.day && // cdts to check that are we looking at Tx that happens on the right weekDay.
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum); --for debug console--

      return {
        //pieces of informations that i need to get from Map
        'day': DateFormat.E().format(weekDay).substring(0, 1), //'day': 'T',
        'amount': totalSum, //'amount': 9.99
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(/*initialValue*/ 0.0,(/*previousValue*/ sum, /*element*/ item) {// the reduce function in J.S
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(groupedTransactionValues); for debug console
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(//Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],// Label
                data['amount'],// SpendingAmount
                totalSpending ==0.0 ? 0.0 : (data['amount'] as double) / totalSpending,// SpendingPercentage of totalSpending,
              ),
            ); //Text('${data['day']}: ${data['amount']}');
          }).toList(),
        ),
      ),
    );
  }
}
