// to hold our textFields
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addnewTxHandler;

  NewTransaction(this.addnewTxHandler){
    print('Constructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('createState NewTransaction Widget');
    return _NewTransactionState() ;
  }
}

class _NewTransactionState extends State<NewTransaction> {
  // String titleInput;
  // String amountInput;
  final _titleController = TextEditingController();// alternative for 'OnChanged' to avoid any kind of errors
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print('Constructor NewTransaction State');
  }

  @override //:we add initState on our own,so to make it clear that's not a mistake but deliberatly added)
  void initState() {//:often used for fetching some initial data you need in app/widget of app
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {//used less often,to refetch some data in State, u know coming from parent widget 
    print('didUpdateWidgt()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {// for cleaning up data!(like listeners or life connections...)
    print('dispose()');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty){
      return;
    }//to avoid errors when nothing entered
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; //stops the function execution
    }

    widget.addnewTxHandler(//'widget.':to get access to properties&methods of our connected widgetClass inside Stateclass
      enteredTitle,
      enteredAmount,
      _selectedDate
    );

    Navigator.of(context).pop(); // access to'context'related to our widgetClass given by '.of(context)'
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() { // to tell flutter that stateful widget updated& should rebuild again
        _selectedDate = pickedDate;
      });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.only(
            top: 10, 
            left: 10, 
            right: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
              //onChanged: (val) {titleInput=val;} , //fires for every key strokes
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              //onChanged: (val) => amountInput=val,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(), //because with anaymous function, we have to manually trigger our Function
            ),
            //SizedBox(height: 20),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'PickedDate: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _presentDatePicker,
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Transaction'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: _submitData, //no ananymous function used, so we just have to pass its reference
              //() {
              // print(titleController.text);
              // print(amountController.text);}
            ),
          ]),
        ),
      ),
    );
  }
}
