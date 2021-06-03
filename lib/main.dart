import 'dart:math';
import 'dart:ui';

import 'package:daily_expenses/components/chart.dart';
import 'package:daily_expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';

import 'components/transaction_list.dart';
import 'model/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Montserrat',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Montserrat-ExtraBold',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  //mostrar transações dos ultimos 7 dias

  List<Transaction> get _recentTransactions {
    return _transactions
        .where((tr) => tr.date.isAfter(
              DateTime.now().subtract(
                Duration(days: 7),
              ),
            ))
        .toList();

    //retorna verdadeiro caso a data atual esteja 7 dias a frente.
  }

  addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextInt(1000000),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  _removeTransaction(int id) {
    setState(() {
      _transactions.removeWhere(
        (tr) => tr.id == id,
      );
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return TransactionForm(addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Expenses'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(parent: ScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.all(12),
              child: Text(
                'Lista de Transações',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Chart(_recentTransactions),
                TransactionList(
                  transactions: _transactions,
                  onRemove: _removeTransaction,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.lightBlue,
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
