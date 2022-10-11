import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //const NewTransaction({Key? key}) : super(key: key);
  final Function addTX;
  const NewTransaction(this.addTX, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime? _selectedDay;

  void _submittedData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDay == null) {
      return;
    }
    widget.addTX(_titleController.text, double.parse(_amountController.text),
        _selectedDay);
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDay = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  controller: _titleController,
                  onSubmitted: (_) => _submittedData(),
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text('Price'),
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submittedData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(_selectedDay == null
                              ? 'No Date Chosen'
                              : 'Selected Date: ${DateFormat.yMd().format(_selectedDay!)}')),
                      Platform.isIOS
                          ? CupertinoButton(
                              onPressed: _datePicker,
                              child: Text(
                                'Pick Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          : TextButton(
                              onPressed: _datePicker,
                              child: Text(
                                'Pick Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _submittedData,
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Theme.of(context).textTheme.button!.color
                      // TextStyle(color: Theme.of(context).textTheme)
                      ),
                  child: const Text(
                    'Add Transaction',
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
