import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> usertransactionsHandler;
  final Function deletetxhandler;

  TransactionList(this.usertransactionsHandler, this.deletetxhandler);
  @override
  Widget build(BuildContext context) {
    return usertransactionsHandler.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  // empty box that we don't see on the screen to seperate
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView/*.builder*/( // A scrollable List by defaullt WITH infinite height as /*Column*/
              // itemBuilder: (ctx, index) {
              // return 
            children: usertransactionsHandler
                .map((tx) => TransactionItem( //:ALWAYS!! Specify the key at the direct child= topmost subtreewidget in list of items 
                      key: ValueKey(/*unique non-changing key*/tx.id),  /*UniqueKey():bad idea it generates dynamic.diff keys all the time*/
                      transactionHandler: tx, 
                      deletetxhandler: deletetxhandler
                    ))
                .toList(),

               // itemCount: usertransactionsHandler.length, //The itemBuilder callback will be called only with indices greater than or equal to zero and less than itemCount.
               //children: usertransactionsHandler.map((tx) => ).toList(),
          );
  }
}

