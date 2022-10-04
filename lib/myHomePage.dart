import 'dart:io' show Platform;
import 'dart:math';
import 'package:dispesas/components/chart.dart';
import 'package:dispesas/components/transaction_form.dart';
import 'package:dispesas/components/transaction_list.dart';
import 'package:dispesas/components/transaction_user.dart';
import 'package:dispesas/modules/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  __addTransaction(String title, double value, DateTime date) {
    final newTrasaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transaction.add(newTrasaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(__addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, VoidCallback fn) {
    if (TargetPlatform.iOS == true) {
      return GestureDetector(onTap: fn, child: Icon(icon));
    } else {
      return IconButton(icon: Icon(icon), onPressed: fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          (_showChart ? Icons.list : Icons.pie_chart),
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Icons.add,
        () {
          _openTransactionFormModal(context);
        },
      ),
    ];
    if (TargetPlatform.iOS == true) {
      appBar = CupertinoNavigationBar(
        middle: Text("Dispesas Pesssoais"),
        trailing: Row(
          children: actions,
        ),
      );
    } else {
      appBar = AppBar(
        title: Text(
          'Dispesas Pessoais',
          style: TextStyle(
            fontSize: 20 * MediaQuery.of(context).textScaleFactor,
          ),
        ),
        actions: actions,
      );
    }

    final availblelHeigth = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_showChart || !isLandscape)
            Container(
              height: MediaQuery.of(context).size.height *
                  (isLandscape ? 0.7 : 0.3),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
              height: availblelHeigth * (isLandscape ? 1 : 0.7),
              child: TransactionList(_transaction, _deleteTransaction),
            ),
        ],
      ),
    );

    return TargetPlatform.iOS == true
        ? CupertinoPageScaffold(
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _openTransactionFormModal(context);
              },
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
