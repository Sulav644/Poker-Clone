import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/core/utils.dart';
import 'package:poker_clone/poker_clone/components/player_identity.dart';
import 'package:poker_clone/poker_clone/components/score_counter.dart';
import 'package:poker_clone/poker_clone/components/settings_widget.dart';
import 'package:simple_animations/timeline_tween/timeline_tween.dart';
import 'package:supercharged/supercharged.dart';

final heightOf2nd3rdRow = 0.04;
final heightOfLastEmptyRow = 0.05;
final cellColor = Color.fromARGB(255, 240, 238, 218);
final uniqueCellColor = Color.fromARGB(255, 206, 195, 185);

enum AnimProps { top, left }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PlayingCard firstPlayerCard, secondPlayerCard, thirdPlayerCard;
  late AnimationController firstPlayerController,
      secondPlayerController,
      thirdPlayerController,
      userController;

  late Animation<TimelineValue<AnimProps>> firstPlayerAnimation,
      secondPlayerAnimation,
      thirdPlayerAnimation,
      userAnimation;
  List<bool> visibileStates = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    firstPlayerCard = PlayingCard(Suit.clubs, CardValue.ace);
    secondPlayerCard = PlayingCard(Suit.clubs, CardValue.ace);
    thirdPlayerCard = PlayingCard(Suit.clubs, CardValue.ace);
    firstPlayerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    secondPlayerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    thirdPlayerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    userController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    initAnimation();
  }

  void initAnimation() {
    firstPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left, tween: Tween(begin: 60.0, end: 120.0))
        .parent
        .animatedBy(firstPlayerController);
    secondPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top, tween: Tween(begin: 60.0, end: 120.0))
        .parent
        .animatedBy(secondPlayerController);
    thirdPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left, tween: Tween(begin: 60.0, end: 120.0))
        .parent
        .animatedBy(thirdPlayerController);
    userAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top, tween: Tween(begin: 60.0, end: 120.0))
        .parent
        .animatedBy(userController);
  }

  void startFirstPlayerAnimation(BuildContext context) {
    context
        .read<CardVisibilityCubit>()
        .toggleVisibility([true, false, false, false]);
    firstPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.009),
                end: widthWithScreenRatio(context, 0.29)))
        .parent
        .animatedBy(firstPlayerController);
    firstPlayerController
        .forward()
        .then((value) => startSecondPlayerAnimation(context));
  }

  void startSecondPlayerAnimation(BuildContext context) {
    context
        .read<CardVisibilityCubit>()
        .toggleVisibility([true, true, false, false]);
    secondPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top,
            tween: Tween(
                begin: heightWithScreenRatio(context, 0.35),
                end: heightWithScreenRatio(context, 0.23)))
        .parent
        .animatedBy(secondPlayerController);
    secondPlayerController
        .forward()
        .then((value) => startThirdPlayerAnimation(context));
  }

  void startThirdPlayerAnimation(BuildContext context) {
    context
        .read<CardVisibilityCubit>()
        .toggleVisibility([true, true, true, false]);
    thirdPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.02),
                end: widthWithScreenRatio(context, 0.289)))
        .parent
        .animatedBy(thirdPlayerController);
    thirdPlayerController.forward();
  }

  void startUserAnimation(BuildContext context) {
    userAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top,
            tween: Tween(
                begin: heightWithScreenRatio(context, 0.4),
                end: heightWithScreenRatio(context, 0.22)))
        .parent
        .animatedBy(userController);
    userController.forward().then(
        (value) => Future.delayed(Duration(milliseconds: 900)).then((value) {
              context.read<CardVisibilityCubit>().resetVisibility();
              resetAnimations();
              context.read<WinGameCubit>().toggleState(true);
            }));
  }

  void moveCardsToFirstPlayerAnimation(BuildContext context) {
    firstPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.29),
                end: widthWithScreenRatio(context, 0.01)))
        .parent
        .animatedBy(firstPlayerController);

    secondPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.2),
                end: widthWithScreenRatio(context, 0.1)))
        .parent
        .animatedBy(secondPlayerController);

    thirdPlayerAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.left,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.02),
                end: widthWithScreenRatio(context, 0.29)))
        .parent
        .animatedBy(thirdPlayerController);
    thirdPlayerController.forward();

    userAnimation = TimelineTween<AnimProps>()
        // opacity
        .addScene(
          begin: 0.milliseconds,
          end: 1000.milliseconds,
          curve: Curves.ease,
        )
        .animate(AnimProps.top,
            tween: Tween(
                begin: widthWithScreenRatio(context, 0.2),
                end: widthWithScreenRatio(context, 0.1)))
        .parent
        .animatedBy(userController);
    userController.forward();
  }

  void resetAnimations() {
    firstPlayerController.reverse();
    secondPlayerController.reverse();
    thirdPlayerController.reverse();
    userController.reverse();
  }

  @override
  void dispose() {
    firstPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsList = context.watch<CardsSelectCubit>().state;
    final random = new Random();
    final isWinGame = context.watch<WinGameCubit>().state;
    final cardVisibilty = context.watch<CardVisibilityCubit>().state;
    final selectedCard = context.watch<SelectedCardCubit>().state;
    final showStartGameDialog = context.watch<StartGameCubit>().state;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Container(
                            width: widthWithScreenRatio(context, 0.16),
                            height: heightWithScreenRatio(context, 0.22),
                            child: Stack(
                              children: [
                                for (var i = 0.044; i > 0.02; i -= 0.006)
                                  Positioned(
                                    left: widthWithScreenRatio(context, 0.092),
                                    top: widthWithScreenRatio(context, i),
                                    child: Transform.rotate(
                                      angle: -80 / 180 * pi,
                                      child: Image.asset(
                                        'assets/images/card.png',
                                        width:
                                            widthWithScreenRatio(context, 0.04),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  left: widthWithScreenRatio(context, 0.089),
                                  top: heightWithScreenRatio(context, 0),
                                  child: Container(
                                    width: widthWithScreenRatio(context, 0.056),
                                    height:
                                        widthWithScreenRatio(context, 0.056),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/bot.png',
                                      width:
                                          widthWithScreenRatio(context, 0.04),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SettingsWidgets(),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerIdentity(
                        context: context, width: 0.09, title: 'bot1', bits: 0),
                    Spacing().verticalSpaceWithRatio(context, 0.01),
                    Container(
                      width: widthWithScreenRatio(context, 0.12),
                      height: heightWithScreenRatio(context, 0.24),
                      child: Stack(
                        children: [
                          for (var i = 0.035; i > 0.01; i -= 0.006)
                            Positioned(
                              left: widthWithScreenRatio(context, 0.034),
                              top: widthWithScreenRatio(context, i),
                              child: Transform.rotate(
                                angle: 40 / 180 * pi,
                                child: Image.asset(
                                  'assets/images/card.png',
                                  width: widthWithScreenRatio(context, 0.04),
                                ),
                              ),
                            ),
                          Positioned(
                            left: widthWithScreenRatio(context, 0),
                            top: heightWithScreenRatio(context, 0.06),
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
                    ),
                    Spacing().verticalSpaceWithRatio(context, 0.01),
                    PlayerIdentity(
                        context: context, width: 0.08, title: '', bits: 3)
                  ],
                ),
                Container(
                  width: widthWithScreenRatio(context, 0.75),
                  height: heightWithScreenRatio(context, 0.53),
                  alignment: Alignment.center,
                  child: (() {
                    if (!showStartGameDialog || isWinGame) {
                      return Container(
                        width: widthWithScreenRatio(context, 0.45),
                        height: heightWithScreenRatio(context, 0.3),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 221, 210, 108),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isWinGame
                                    ? 'Continue the game?'
                                    : 'Start the game?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 39, 12, 2),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacing().verticalSpaceWithRatio(context, 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                        splashColor: Colors.green,
                                        onTap: () {
                                          setState(() {
                                            firstPlayerCard = cardsList[random
                                                    .nextInt(cardsList.length)]
                                                .card;
                                            secondPlayerCard = cardsList[random
                                                    .nextInt(cardsList.length)]
                                                .card;
                                            thirdPlayerCard = cardsList[random
                                                    .nextInt(cardsList.length)]
                                                .card;
                                          });
                                          context
                                              .read<StartGameCubit>()
                                              .toggleState(true);
                                          context
                                              .read<WinGameCubit>()
                                              .toggleState(false);
                                          startFirstPlayerAnimation(context);
                                        },
                                        child: startGameOption(
                                            'YES', Colors.green)),
                                  ),
                                  Spacing()
                                      .horizontalSpaceWithRatio(context, 0.015),
                                  startGameOption('NO', Colors.red)
                                ],
                              ),
                            ]),
                      );
                    } else {
                      return Stack(children: [
                        if (cardVisibilty[2])
                          AnimatedBuilder(
                            animation: thirdPlayerController,
                            builder: (context, child) {
                              return Positioned(
                                top: heightWithScreenRatio(context, 0.135),
                                left: thirdPlayerAnimation.value
                                    .get(AnimProps.left),
                                child: Transform.rotate(
                                  angle: 90 / 180 * pi,
                                  child: bottomCardWidget(
                                      context, thirdPlayerCard),
                                ),
                              );
                            },
                          ),
                        if (cardVisibilty[1])
                          AnimatedBuilder(
                            animation: secondPlayerController,
                            builder: (context, child) {
                              return Positioned(
                                bottom: secondPlayerAnimation.value
                                    .get(AnimProps.top),
                                left: widthWithScreenRatio(context, 0.334),
                                child:
                                    bottomCardWidget(context, secondPlayerCard),
                              );
                            },
                          ),
                        if (cardVisibilty[0])
                          AnimatedBuilder(
                            animation: firstPlayerController,
                            builder: (context, child) {
                              return Positioned(
                                top: heightWithScreenRatio(context, 0.135),
                                right: firstPlayerAnimation.value
                                    .get(AnimProps.left),
                                child: Transform.rotate(
                                  angle: 90 / 180 * pi,
                                  child: bottomCardWidget(
                                      context, firstPlayerCard),
                                ),
                              );
                            },
                          ),
                        if (cardVisibilty[3])
                          AnimatedBuilder(
                            animation: userController,
                            builder: (context, child) {
                              return Positioned(
                                  top: userAnimation.value.get(AnimProps.top),
                                  right: widthWithScreenRatio(context, 0.34),
                                  child: bottomCardWidget(
                                      context, selectedCard.card));
                            },
                          ),
                      ]);
                    }
                  }()),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PlayerIdentity(
                        context: context, width: 0.09, title: 'bot3', bits: 0),
                    Spacing().verticalSpaceWithRatio(context, 0.01),
                    Container(
                      width: widthWithScreenRatio(context, 0.12),
                      height: heightWithScreenRatio(context, 0.24),
                      child: Stack(
                        children: [
                          for (var i = 0.035; i > 0.01; i -= 0.006)
                            Positioned(
                              left: widthWithScreenRatio(context, 0.03),
                              top: widthWithScreenRatio(context, i),
                              child: Transform.rotate(
                                angle: -40 / 180 * pi,
                                child: Image.asset(
                                  'assets/images/card.png',
                                  width: widthWithScreenRatio(context, 0.04),
                                ),
                              ),
                            ),
                          Positioned(
                            right: widthWithScreenRatio(context, 0),
                            top: heightWithScreenRatio(context, 0.06),
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
                    ),
                    Spacing().verticalSpaceWithRatio(context, 0.01),
                    PlayerIdentity(
                        context: context, width: 0.08, title: '', bits: 1)
                  ],
                )
              ]),
              Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: screenWidth(context),
                    height: widthWithScreenRatio(context, 0.11),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...cardsList.map(
                          (e) => GestureDetector(
                            onTap: () {
                              context.read<SelectedCardCubit>().selectCard(e);
                              context.read<CardsSelectCubit>().removeCard(e);
                              context
                                  .read<CardVisibilityCubit>()
                                  .toggleVisibility([true, true, true, true]);
                              startUserAnimation(context);
                            },
                            child: bottomCardWidget(
                              context,
                              e.card,
                            ),
                          ),
                        ),
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
                            left: widthWithScreenRatio(context, 0.054),
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
              )
            ],
          ),
        ],
      ),
    );
  }

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

final cardListForSelection = [
  PlayingCardView(
    card: PlayingCard(Suit.clubs, CardValue.ace),
  ),
  PlayingCardView(
    card: PlayingCard(Suit.spades, CardValue.queen),
  ),
  PlayingCardView(
      card: PlayingCard(
    Suit.spades,
    CardValue.ten,
  )),
  PlayingCardView(
    card: PlayingCard(Suit.spades, CardValue.seven),
  ),
  PlayingCardView(
    card: PlayingCard(Suit.spades, CardValue.two),
  ),
  PlayingCardView(
      card: PlayingCard(
    Suit.hearts,
    CardValue.ace,
  )),
  PlayingCardView(
    card: PlayingCard(Suit.hearts, CardValue.queen),
  ),
  PlayingCardView(
    card: PlayingCard(Suit.hearts, CardValue.ten),
  ),
  PlayingCardView(
      card: PlayingCard(
    Suit.hearts,
    CardValue.four,
  )),
  PlayingCardView(
    card: PlayingCard(Suit.clubs, CardValue.eight),
  ),
  PlayingCardView(
    card: PlayingCard(Suit.clubs, CardValue.seven),
  ),
  PlayingCardView(
      card: PlayingCard(
    Suit.clubs,
    CardValue.six,
  )),
  PlayingCardView(
      card: PlayingCard(
    Suit.diamonds,
    CardValue.seven,
  )),
];

class CardsSelectCubit extends Cubit<List<PlayingCardView>> {
  CardsSelectCubit() : super(cardListForSelection);
  void removeCard(PlayingCardView cardView) {
    final cardList = [];
    for (var element in state) {
      if (element != cardView) {
        cardList.add(element);
      }
    }
    emit([...cardList]);
  }

  void resetCard() => emit(cardListForSelection);
}

class CardVisibilityCubit extends Cubit<List<bool>> {
  CardVisibilityCubit() : super([false, false, false, false]);
  void toggleVisibility(List<bool> status) => emit(status);
  void resetVisibility() => emit([false, false, false, false]);
}

class SelectedCardCubit extends Cubit<PlayingCardView> {
  SelectedCardCubit()
      : super(PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)));
  void selectCard(PlayingCardView cardView) => emit(cardView);
}

class StartGameCubit extends Cubit<bool> {
  StartGameCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class WinGameCubit extends Cubit<bool> {
  WinGameCubit() : super(false);
  void toggleState(bool status) => emit(status);
}
