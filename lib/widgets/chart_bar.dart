import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendedAmount;
  final double spendedPercentage;

  const ChartBar(
      {Key? key,
      required this.label,
      required this.spendedAmount,
      required this.spendedPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Column(
      children: [
        FittedBox(child: Container(height: constraints.maxHeight*0.15,child: Text('\$${spendedAmount.toStringAsFixed(0)}'))),
         SizedBox(
          height: constraints.maxHeight*0.05,
        ),
        Container(
          height: constraints.maxHeight*0.6,
          width: 10,
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                color: const Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              heightFactor: spendedPercentage,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ]),
        ),
         SizedBox(
          height: constraints.maxHeight*0.05,
        ),
        Container(height: constraints.maxHeight*0.15,child: FittedBox(child: Text(label),),),
      ],
    );
    });
  }
}
