import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart'; //import './widgets/user_transactions.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

//void main() => runApp(MyApp());
void main() {
  // WidgetsFlutterBinding.ensureInitialized();//must be initialized before setting deviceOrientation,
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  //   ]); // ===> For non_LandScape Mode!
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber, //colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.amber),
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white),
          ),
          appBarTheme: AppBarTheme(
            // toolbarTextStyle: ThemeData.light().textTheme.copyWith(
            //       headline6: TextStyle(
            //         fontFamily: 'OpenSans',
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ).bodyText2,
            titleTextStyle: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).headline6,
            //textTheme: ThemeData.light().textTheme.copyWith(
            //   headline6: TextStyle(
            //     fontFamily: 'OpenSans',
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),===>"Deprecated"
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //Stateless ==> Stateful:to manage the switch 'NewTransaction' State, from previous file:user_transactions.dart
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
  ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);

  }

  @override 
  dispose() { //to clean up unecessary lifecyclelisteners(avoid memory leaks) when app is getting paused
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList(); //only transactions that are younger than 7days are included(kept) in "_recentTransactions"
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(), // As a kind of unique ID
        date: chosenDate,
        title: txTitle,
        amount: txAmount);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) /*(bCtx)*/ {
        return NewTransaction(_addNewTransaction);
        // return GestureDetector(
        //   onTap: () {},
        //   child: NewTransaction(_addNewTransaction),
        //   behavior: HitTestBehavior.opaque,
        //   );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent( //Builder Method
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch /*.adaptive*/ (
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6, // (full height - appbar height - status topbar height)* 60%
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ]; //(to simplify code)& makes it more Readable!! ];
  }

  List<Widget> _buildPortraitContent( //Builder Method
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3, // (full height - appbar height - status topbar height)* 30%
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); //one connexion to MediaQuery class and re_use it wherever it needs.
    final isLandscape = mediaQuery.orientation ==Orientation.landscape; // recalculated for every build Run.
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7, // (full height - appbar height - status topbar height)* 70%
        child: TransactionList(_userTransactions, _deleteTransaction)); // we can't wrapp it with "Expanded" because of 'ListView'
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        //adds Scroll fonctionality
        child: Column(// takes the full availabe height that he can get & the width based on what its children needs
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape) //new Feature!==> in list/array if statement
              ..._buildPortraitContent(mediaQuery, appBar,
                  txListWidget), // "...":Spread operator avoid nested list which is not accepted by flutter in children[].
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        //Uses the 'accent color' if available & fallback to primarycolor if not
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
