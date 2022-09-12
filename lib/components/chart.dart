import 'package:dispesas/components/chart_bar.dart';
import 'package:dispesas/modules/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get grouppedTransaction {
    List<Map<String, Object>> lstMap = [];

    print(this.recentTransaction.length);

    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (i == 2) {
          print(DateFormat.E().format(weekDay)[0]);
          print('Vlr  ${recentTransaction[i].value}');
        }

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      //print(DateFormat.E().format(weekDay)[0]);

      //print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValue {
    return grouppedTransaction.fold(0.0, (sum, tr) {
      return sum + double.parse(tr['value'].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: grouppedTransaction.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: double.parse(tr['value'].toString()),
                percentage: _weekTotalValue == 0
                    ? 0
                    : double.parse(tr['value'].toString()) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
