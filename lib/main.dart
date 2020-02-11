import 'package:expenses_tracker/widgets/chart.dart';

import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';

import 'package:expenses_tracker/widgets/transaction_list.dart';

import 'package:flutter/material.dart';

void main() {
  //this method ensure only to use portrait mode
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
//    runApp(MyApp());
//  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensePage(),
      title: "Expenses Tracker",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        accentColor: Colors.green,
        fontFamily: "Mont",
        textTheme: TextTheme(
          title: TextStyle(
            fontFamily: "SigmarOne",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              fontFamily: "Oswald",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.itemDate.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txName, double txPrice, DateTime txDate) {
    final newTx = Transaction(
        itemName: txName,
        itemPrice: txPrice,
        itemDate: txDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  //this function helps to delete transactions
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _showAddTransaction(BuildContext bCtx) {
    showModalBottomSheet(
        context: bCtx,
        builder: (ctx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Expenses Tracker"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            _showAddTransaction(context);
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Show chart"),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscape)
              Container(
                  height: MediaQuery.of(context).size.height * 0.3 -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  child: Chart(_recentTransactions)),
            if (!isLandscape)
              Container(
                  height: MediaQuery.of(context).size.height * 0.7 -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top,
                  child:
                      TransactionList(_userTransactions, _deleteTransaction)),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.7 -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: Chart(_recentTransactions))
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.7 -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: TransactionList(
                          _userTransactions, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showAddTransaction(context);
        },
      ),
    );
  }
}
