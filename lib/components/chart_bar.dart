import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percent;

  const ChartBar(
      {required this.label, required this.percent, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            '${value.toStringAsFixed(2)}',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 60,
          width: 12,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                heightFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
