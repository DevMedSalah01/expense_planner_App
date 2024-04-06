import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget { // Extracted Card Widget(for single tx!!) from "transaction_list"
  const TransactionItem({ // root widget of ListView.Builder
    Key key,
    @required this.transactionHandler,
    @required this.deletetxhandler,
  }) : super(key: key);

  final /*List<>*/Transaction transactionHandler;
  final Function deletetxhandler;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const availableColors = [
      Colors.red, 
      Colors.black, 
      Colors.blue, 
      Colors.purple
    ];
   //No need to call "setState" because "initState"is called before build execution anyway.
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(// alternative for Card Widget
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child:
                  Text('${widget.transactionHandler/*[index]*/.amount}\DT'),
            ),
          ),
        ),
        title: Text(
          widget.transactionHandler/*[index]*/.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transactionHandler/*[index]*/.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460 
        ? FlatButton.icon(
          textColor: Theme.of(context).errorColor, 
          icon: const Icon(Icons.delete, size: 28.0), 
          label: const Text('Delete'),
          onPressed: () => widget.deletetxhandler(widget.transactionHandler/*[index]*/.id),
          )
        : IconButton(
          icon: const Icon(Icons.delete, size: 28.0),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.deletetxhandler(widget.transactionHandler/*[index]*/.id),
        ),
      ),
    );
  }
}
