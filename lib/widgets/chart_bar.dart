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
    return Column(
      children: [
        FittedBox(child: Container(height: 20,child: Text('\$${spendedAmount.toStringAsFixed(0)}'))),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 50,
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
        const SizedBox(
          height: 4,
        ),
        Text(label),
      ],
    );
  }
}
