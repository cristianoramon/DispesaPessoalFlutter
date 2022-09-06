import 'dart:math';

import 'package:dispesas/components/transaction_form.dart';
import 'package:dispesas/components/transaction_list.dart';
import 'package:dispesas/modules/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TransactionUser extends StatefulWidget {
  @override
  State<TransactionUser> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TransactionUser> {
  final _transaction = [
    Transaction(
      id: 't1',
      title: 'Novo sapato',
      value: 310.10,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Novo sapato2',
      value: 310.10,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Novo sapato4',
      value: 110.10,
      date: DateTime.now().add(Duration(days: 1)),
    ),
  ];

  __addTransaction(String title, double value) {
    final newTrasaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transaction.add(newTrasaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionForm(__addTransaction),
        TransactionList(_transaction),
      ],
    );
  }
}
