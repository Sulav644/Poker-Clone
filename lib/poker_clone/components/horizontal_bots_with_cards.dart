import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../core/utils.dart';

class HorizontalBotsWithCards extends StatelessWidget {
  final double? leftForFirstCard;
  final double? topForFirstCard;
  final double? leftForSecondCard;
  final double? topForSecondCard;
  final double? angleForFirstCard;
  final double? angleForSecondCard;
  final double? leftForBot;
  final double? topForBot;
  final double? rightForFirstCard;
  final double? rightForSecondCard;
  final double? rightForBot;
  final bool showTwoPlayerCards;
  final List<PlayingCardView> cardsList;
  const HorizontalBotsWithCards(
      {super.key,
      this.leftForFirstCard,
      this.topForFirstCard,
      this.leftForSecondCard,
      this.topForSecondCard,
      this.angleForFirstCard,
      this.angleForSecondCard,
      this.leftForBot,
      this.topForBot,
      this.rightForFirstCard,
      this.rightForSecondCard,
      this.rightForBot,
      required this.showTwoPlayerCards,
      required this.cardsList});

  @override
  Widget build(BuildContext context) {
    return rightForFirstCard != null
        ? Container(
            width: widthWithScreenRatio(context, 0.12),
            height: heightWithScreenRatio(context, 0.28),
            child: Stack(
              children: [
                Positioned(
                  right: widthWithScreenRatio(context, rightForFirstCard!),
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
                              card: cardsList[11].card,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: widthWithScreenRatio(context, rightForSecondCard!),
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
                              card: cardsList[12].card,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: widthWithScreenRatio(context, 0),
                  top: heightWithScreenRatio(context, 0.085),
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
          )
        : Container(
            width: widthWithScreenRatio(context, 0.12),
            height: heightWithScreenRatio(context, 0.28),
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
                              card: cardsList[9].card,
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
                              card: cardsList[10].card,
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
