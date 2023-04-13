import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../core/utils.dart';

class VerticalBotsWithCards extends StatelessWidget {
  final double? leftForFirstCard;
  final double? topForFirstCard;
  final double? leftForSecondCard;
  final double? topForSecondCard;
  final double? angleForFirstCard;
  final double? angleForSecondCard;
  final double? leftForBot;
  final double? topForBot;
  final double? bottomForFirstCard;
  final double? bottomForSecondCard;
  final double? bottomForBot;
  final bool showTwoPlayerCards;
  final List<PlayingCardView> cardsList;
  const VerticalBotsWithCards(
      {super.key,
      this.leftForFirstCard,
      this.topForFirstCard,
      this.leftForSecondCard,
      this.topForSecondCard,
      this.angleForFirstCard,
      this.angleForSecondCard,
      this.leftForBot,
      this.topForBot,
      this.bottomForFirstCard,
      this.bottomForSecondCard,
      this.bottomForBot,
      required this.showTwoPlayerCards,
      required this.cardsList});

  @override
  Widget build(BuildContext context) {
    return bottomForFirstCard != null
        ? Container(
            width: widthWithScreenRatio(context, 0.17),
            height: heightWithScreenRatio(context, 0.235),
            child: Stack(
              children: [
                Positioned(
                  left: widthWithScreenRatio(context, leftForFirstCard!),
                  bottom: widthWithScreenRatio(context, bottomForFirstCard!),
                  child: Transform.rotate(
                    angle: angleForFirstCard! / 180 * pi,
                    child: Container(
                      width: widthWithScreenRatio(context, 0.08),
                      height: widthWithScreenRatio(context, 0.08),
                      alignment: Alignment.center,
                      child: PlayingCardView(
                        card: cardsList[5].card,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: widthWithScreenRatio(context, leftForSecondCard!),
                  bottom: widthWithScreenRatio(context, bottomForSecondCard!),
                  child: Transform.rotate(
                    angle: angleForSecondCard! / 180 * pi,
                    child: Container(
                      width: widthWithScreenRatio(context, 0.08),
                      height: widthWithScreenRatio(context, 0.08),
                      alignment: Alignment.center,
                      child: PlayingCardView(
                        card: cardsList[6].card,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: widthWithScreenRatio(context, leftForBot!),
                  bottom: heightWithScreenRatio(context, bottomForBot!),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 160, 157, 157),
                      size: widthWithScreenRatio(context, 0.05),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: widthWithScreenRatio(context, 0.17),
            height: heightWithScreenRatio(context, 0.235),
            child: Stack(
              children: [
                Positioned(
                  left: widthWithScreenRatio(context, leftForFirstCard!),
                  top: widthWithScreenRatio(context, topForFirstCard!),
                  child: Transform.rotate(
                    angle: angleForFirstCard! / 180 * pi,
                    child: !showTwoPlayerCards
                        ? Image.asset(
                            'assets/images/card.png',
                            width: widthWithScreenRatio(context, 0.04),
                          )
                        : Container(
                            width: widthWithScreenRatio(context, 0.08),
                            height: widthWithScreenRatio(context, 0.08),
                            alignment: Alignment.center,
                            child: PlayingCardView(
                              card: cardsList[7].card,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  left: widthWithScreenRatio(context, leftForSecondCard!),
                  top: widthWithScreenRatio(context, topForSecondCard!),
                  child: Transform.rotate(
                    angle: angleForSecondCard! / 180 * pi,
                    child: !showTwoPlayerCards
                        ? Image.asset(
                            'assets/images/card.png',
                            width: widthWithScreenRatio(context, 0.04),
                          )
                        : Container(
                            width: widthWithScreenRatio(context, 0.08),
                            height: widthWithScreenRatio(context, 0.08),
                            alignment: Alignment.center,
                            child: PlayingCardView(
                              card: cardsList[8].card,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  left: widthWithScreenRatio(context, leftForBot!),
                  top: heightWithScreenRatio(context, topForBot!),
                  child: Container(
                    width: widthWithScreenRatio(context, 0.056),
                    height: widthWithScreenRatio(context, 0.056),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/bot.png',
                      width: widthWithScreenRatio(context, 0.04),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
