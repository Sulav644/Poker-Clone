import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../core/utils.dart';

class HelperWidgets {
  Widget visibleCardAfterEachRound({
    required BuildContext context,
    required PlayingCard card,
  }) =>
      Container(
        width: widthWithScreenRatio(context, 0.06),
        alignment: Alignment.center,
        child: PlayingCardView(card: card),
      );

  Widget callTag({required Color color, required String title}) => Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      );

  Widget callOptions(
          {required BuildContext context,
          required Color color,
          required String title}) =>
      Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(heightWithScreenRatio(context, 0.02)),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ));

  Widget callLabel(
          {required BuildContext context,
          required Color color,
          required String title}) =>
      Container(
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: heightWithScreenRatio(
                  context,
                  0.01,
                ),
                horizontal: widthWithScreenRatio(context, 0.01)),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ));

  Widget startGameOption(String title, Color color) => Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black, offset: Offset(-1.5, 1.5))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );

  Widget bottomCardWidget(BuildContext context, PlayingCard card) => Container(
        width: widthWithScreenRatio(context, 0.0766),
        height: widthWithScreenRatio(context, 0.12),
        alignment: Alignment.center,
        child: PlayingCardView(
          card: card,
        ),
      );

  Widget cardWidget(
          {required BuildContext context,
          required double padLeft,
          required double padTop,
          required double padRight,
          required double width,
          required double angle}) =>
      Positioned(
        left: widthWithScreenRatio(context, padLeft),
        top: widthWithScreenRatio(context, padTop),
        right: widthWithScreenRatio(context, padRight),
        child: Transform.rotate(
          angle: angle / 180 * pi,
          child: Image.asset(
            'assets/images/card.png',
            width: widthWithScreenRatio(context, width),
          ),
        ),
      );

  Widget botIcon(
          {required BuildContext context,
          required double padLeft,
          required double padRight}) =>
      Positioned(
        left: widthWithScreenRatio(context, padLeft),
        right: widthWithScreenRatio(context, padRight),
        child: Container(
          width: widthWithScreenRatio(context, 0.058),
          height: widthWithScreenRatio(context, 0.058),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(100)),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(widthWithScreenRatio(context, 0.008)),
            child: Image.asset(
              'assets/images/bot.png',
              width: widthWithScreenRatio(context, 0.045),
            ),
          ),
        ),
      );
}
