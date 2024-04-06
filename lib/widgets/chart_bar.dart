import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double SpendingPerctOfTotal;

  const ChartBar(this.label, this.spendingAmount, this.SpendingPerctOfTotal); // const constructor if its args are marked "final"

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (/*context*/ ctx, constraints) => Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('${spendingAmount.toStringAsFixed(0)} \DT'),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ), // to add some spacing
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(// to place elements above each other, like 3D space
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(
                        220, 220, 220, 1), // for light grey Colour
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: SpendingPerctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05, //4,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }
}
