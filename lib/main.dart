import 'dart:io';

import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18),
            button: const TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
              .bodyText2,
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
              .headline6,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: '1',
    //   title: 'New Shirt',
    //   price: 20.32,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: '2',
    //   title: 'Bike Installment',
    //   price: 300,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      price: txAmount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddingNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                onPressed: () =>  _startAddingNewTransaction(context),
                child: const Icon(CupertinoIcons.add),
              )
            ],
          ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () => _startAddingNewTransaction(context),
                  icon: const Icon(Icons.add))
            ],
          ) as PreferredSizeWidget;
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final listWidget = Container(
      height: (media.size.height -
              appBar.preferredSize.height -
              media.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, deleteTx: _deleteTransaction),
    );

    final pageBody =  SafeArea(child:  SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text('Switch',style: Theme.of(context).textTheme.headline6,),
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    }),
              ],
            ),
          if (!isLandscape)
            Container(
              height: (media.size.height -
                      appBar.preferredSize.height -
                      media.padding.top) *
                  0.3,
              child: Chart(recentTransactions: _recentTransaction),
            ),
          if (!isLandscape) listWidget,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (media.size.height -
                            appBar.preferredSize.height -
                            media.padding.top) *
                        0.7,
                    child: Chart(recentTransactions: _recentTransaction),
                  )
                : listWidget,
          //TransactionList(_userTransactions,_deleteTransaction),
        ],
      ),
    ),);
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddingNewTransaction(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
