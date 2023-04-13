import 'package:flutter/material.dart';
import '../../core/utils.dart';

const heightOf2nd3rdRow = 0.04;
const heightOfLastEmptyRow = 0.05;
const cellColor = Color.fromARGB(255, 240, 238, 218);
const uniqueCellColor = Color.fromARGB(255, 206, 195, 185);

class ScoreCounter extends StatelessWidget {
  final BuildContext context;

  const ScoreCounter({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        tableHeader(context, '', 0.04, 0.07, 0, 0, cellColor),
        tableHeader(context, 'bot3', 0.06, 0.07, 0, 0, cellColor),
        tableHeader(context, 'bot2', 0.06, 0.07, 0, 0, cellColor),
        tableHeader(context, 'bot1', 0.06, 0.07, 0, 0, cellColor),
        tableHeader(context, 'user', 0.06, 0.07, 0, 0, uniqueCellColor),
        tableHeader(context, '\u2211', 0.06, 0.07, 0, 0, cellColor),
      ]),
      Row(children: [
        tableHeader(context, 'TS', 0.04, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(
            context, '', 0.06, heightOf2nd3rdRow, 0, 0, uniqueCellColor),
        tableHeader(context, '', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
      ]),
      Row(children: [
        tableHeader(context, 'R1', 0.04, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '2', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(context, '2', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
        tableHeader(
            context, '', 0.06, heightOf2nd3rdRow, 0, 0, uniqueCellColor),
        tableHeader(context, '4', 0.06, heightOf2nd3rdRow, 0, 0, cellColor),
      ]),
      Row(children: [
        tableHeader(context, '', 0.04, heightOfLastEmptyRow, 10, 0, cellColor),
        tableHeader(context, '', 0.06, heightOfLastEmptyRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOfLastEmptyRow, 0, 0, cellColor),
        tableHeader(context, '', 0.06, heightOfLastEmptyRow, 0, 0, cellColor),
        tableHeader(
            context, '', 0.06, heightOfLastEmptyRow, 0, 0, uniqueCellColor),
        tableHeader(context, '', 0.06, heightOfLastEmptyRow, 0, 10, cellColor),
      ])
    ]);
  }

  Widget tableHeader(
          BuildContext context,
          String title,
          double width,
          double height,
          double bottomLeftRadius,
          double bottomRightRadius,
          Color color) =>
      Container(
          width: widthWithScreenRatio(context, width),
          height: heightWithScreenRatio(context, height),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  bottomRight: Radius.circular(bottomRightRadius))),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.brown,
                fontWeight: title.contains('TS') ||
                        int.tryParse(title)?.isFinite == true
                    ? FontWeight.normal
                    : FontWeight.bold,
                fontSize:
                    title.contains('TS') || title.contains('R1') ? 10 : 12),
          ));
}
