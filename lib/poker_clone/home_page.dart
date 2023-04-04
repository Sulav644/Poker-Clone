import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/core/utils.dart';
import 'package:poker_clone/poker_clone/components/player_identity.dart';
import 'package:poker_clone/poker_clone/components/score_counter.dart';
import 'package:poker_clone/poker_clone/components/settings_widget.dart';

final heightOf2nd3rdRow = 0.04;
final heightOfLastEmptyRow = 0.05;
final cellColor = Color.fromARGB(255, 240, 238, 218);
final uniqueCellColor = Color.fromARGB(255, 206, 195, 185);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/table.jpg',
            width: screenWidth(context),
            height: screenHeight(context),
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScoreCounter(
                    context: context,
                  ),
                  Container(
                      width: widthWithScreenRatio(context, 0.3),
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          PlayerIdentity(
                              context: context,
                              width: 0.21,
                              title: 'bot2',
                              bits: 2),
                          Padding(
                            padding: EdgeInsets.only(
                                left: widthWithScreenRatio(context, 0.08)),
                            child: Stack(
                              children: [
                                cardWidget(
                                    context: context,
                                    padLeft: 0.01,
                                    padTop: 0.03,
                                    padRight: 0,
                                    width: 0.045,
                                    angle: -40),
                                botIcon(
                                    context: context, padLeft: 0, padRight: 0),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SettingsWidgets(),
                ],
              ),
              Spacing().verticalSpaceWithRatio(context, 0.04),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerIdentity(
                        context: context, width: 0.09, title: 'bot1', bits: 0),
                    Spacing().verticalSpaceWithRatio(context, 0.05),
                    Stack(
                      children: [
                        cardWidget(
                            context: context,
                            padLeft: 0.04,
                            padTop: 0,
                            padRight: 0,
                            width: 0.045,
                            angle: 40),
                        botIcon(context: context, padLeft: 0, padRight: 0),
                      ],
                    ),
                    Spacing().verticalSpaceWithRatio(context, 0.05),
                    PlayerIdentity(
                        context: context, width: 0.08, title: '', bits: 3)
                  ],
                ),
                Container(
                  width: widthWithScreenRatio(context, 0.25),
                  height: widthWithScreenRatio(context, 0.2),
                  child: Stack(children: [
                    Positioned(
                        bottom: widthWithScreenRatio(context, 0.085),
                        right: widthWithScreenRatio(context, 0.09),
                        child: bottomCardWidget(
                            context, PlayingCard(Suit.spades, CardValue.ace))),
                    Positioned(
                      top: widthWithScreenRatio(context, 0.04),
                      right: widthWithScreenRatio(context, 0.15),
                      child: Transform.rotate(
                        angle: 90 / 180 * pi,
                        child: bottomCardWidget(
                            context, PlayingCard(Suit.spades, CardValue.four)),
                      ),
                    ),
                    Positioned(
                      top: widthWithScreenRatio(context, 0.085),
                      left: widthWithScreenRatio(context, 0.08),
                      child: bottomCardWidget(
                          context, PlayingCard(Suit.spades, CardValue.queen)),
                    ),
                    Positioned(
                      top: widthWithScreenRatio(context, 0.04),
                      right: widthWithScreenRatio(context, 0.025),
                      child: Transform.rotate(
                        angle: 90 / 180 * pi,
                        child: bottomCardWidget(
                            context, PlayingCard(Suit.spades, CardValue.seven)),
                      ),
                    ),
                  ]),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlayerIdentity(
                        context: context, width: 0.09, title: 'bot3', bits: 0),
                    Spacing().verticalSpaceWithRatio(context, 0.05),
                    Stack(
                      children: [
                        cardWidget(
                            context: context,
                            padLeft: 0.02,
                            padTop: 0,
                            padRight: 0,
                            width: 0.045,
                            angle: -40),
                        botIcon(context: context, padLeft: 0.05, padRight: 0),
                      ],
                    ),
                    Spacing().verticalSpaceWithRatio(context, 0.05),
                    PlayerIdentity(
                        context: context, width: 0.08, title: '', bits: 1)
                  ],
                )
              ]),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Container(
                          width: screenWidth(context),
                          height: widthWithScreenRatio(context, 0.11),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.clubs, CardValue.ace),
                              ),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.spades, CardValue.queen),
                              ),
                              bottomCardWidget(
                                  context,
                                  PlayingCard(
                                    Suit.spades,
                                    CardValue.ten,
                                  )),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.spades, CardValue.seven),
                              ),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.spades, CardValue.two),
                              ),
                              bottomCardWidget(
                                  context,
                                  PlayingCard(
                                    Suit.hearts,
                                    CardValue.ace,
                                  )),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.hearts, CardValue.queen),
                              ),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.hearts, CardValue.ten),
                              ),
                              bottomCardWidget(
                                  context,
                                  PlayingCard(
                                    Suit.hearts,
                                    CardValue.four,
                                  )),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.clubs, CardValue.eight),
                              ),
                              bottomCardWidget(
                                context,
                                PlayingCard(Suit.clubs, CardValue.seven),
                              ),
                              bottomCardWidget(
                                  context,
                                  PlayingCard(
                                    Suit.clubs,
                                    CardValue.six,
                                  )),
                              bottomCardWidget(
                                  context,
                                  PlayingCard(
                                    Suit.diamonds,
                                    CardValue.seven,
                                  )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: widthWithScreenRatio(context, 0.2),
                                height: widthWithScreenRatio(context, 0.11),
                                alignment: Alignment.bottomCenter,
                                child: PlayerIdentity(
                                    context: context,
                                    width: 0.2,
                                    title: 'user',
                                    bits: 0)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: widthWithScreenRatio(context, 0.04),
                                  top: widthWithScreenRatio(context, 0.045)),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: widthWithScreenRatio(context, 0.03),
                                child: Icon(
                                  Icons.person,
                                  size: widthWithScreenRatio(context, 0.04),
                                  color: Color.fromARGB(255, 141, 138, 138),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomCardWidgetTemp(BuildContext context, String image) => Container(
        width: widthWithScreenRatio(context, 0.0769),
        height: widthWithScreenRatio(context, 0.11),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
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
      Padding(
        padding: EdgeInsets.only(
            left: widthWithScreenRatio(context, padLeft),
            top: widthWithScreenRatio(context, padTop),
            right: widthWithScreenRatio(context, padRight)),
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
      Padding(
        padding: EdgeInsets.only(
            left: widthWithScreenRatio(context, padLeft),
            right: widthWithScreenRatio(context, padRight)),
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
