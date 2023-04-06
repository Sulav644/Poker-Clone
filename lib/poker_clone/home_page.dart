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
  final callLabelColor = Color.fromARGB(255, 117, 135, 150);
  late PlayingCard firstCard, secondCard, thirdCard, fourthCard, fifthCard;
  late int highestCall,
      firstPlayerCall,
      secondPlayerCall,
      thirdPlayerCall,
      fourthPlayerCall;
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
    firstCard = PlayingCard(Suit.clubs, CardValue.ace);
    secondCard = PlayingCard(Suit.clubs, CardValue.ace);
    thirdCard = PlayingCard(Suit.clubs, CardValue.ace);
    fourthCard = PlayingCard(Suit.clubs, CardValue.ace);
    fifthCard = PlayingCard(Suit.clubs, CardValue.ace);
    highestCall = 0;
    firstPlayerCall = 0;
    secondPlayerCall = 0;
    thirdPlayerCall = 0;
    fourthPlayerCall = 0;

    firstPlayerController = AnimationController(
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
        .animate(AnimProps.top, tween: Tween(begin: 60.0, end: 120.0))
        .parent
        .animatedBy(firstPlayerController);
  }

  void startFirstPlayerAnimation(BuildContext context) {
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
  }

  void resetAnimations() {
    firstPlayerController.reverse();
  }

  @override
  void dispose() {
    firstPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = new Random();
    final isWinGame = context.watch<WinGameCubit>().state;
    final cardVisibilty = context.watch<CardVisibilityCubit>().state;
    final showStartGameDialog = context.watch<StartGameCubit>().state;
    final userCallList = context.watch<ShowUserCallCubit>().state;
    final showUserCallOptions = context.watch<ShowUserCallOptionsCubit>().state;
    final showRaisedPrices = context.watch<ShowRaisedPricesCubit>().state;
    String getUserCallPrice(String title) => userCallList[
            userCallList.indexWhere((element) => element.user == title)]
        .price
        .toString();
    bool hasUserCalledWithCall(String title) => userCallList
        .where((element) => element.user == title && element.isCall == true)
        .isNotEmpty;
    bool hasUserCalledWithRaise(String title) => userCallList
        .where((element) => element.user == title && element.isRaised == true)
        .isNotEmpty;
    void setUserCall(
            {required String name,
            required bool isCalled,
            required bool isRaised,
            required int price}) =>
        context.read<ShowUserCallCubit>().setUserCall(UserCall(
            user: name, isCall: isCalled, isRaised: isRaised, price: price));

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
                          verticalBotWithCard(
                              leftForFirstCard: 0.112,
                              topForFirstCard: 0.028,
                              angleForFirstCard: -40,
                              leftForSecondCard: 0.106,
                              topForSecondCard: 0.035,
                              angleForSecondCard: -24,
                              leftForBot: 0.089,
                              topForBot: 0),
                          if (hasUserCalledWithCall('fourthPlayer') ||
                              hasUserCalledWithRaise('fourthPlayer'))
                            callLabel(
                                top: 0.15,
                                left: 0.04,
                                color: callLabelColor,
                                title: getUserCallPrice('fourthPlayer')),
                          if (hasUserCalledWithCall('fourthPlayer'))
                            callTag(
                                top: 0.08,
                                left: 0,
                                color: Colors.red,
                                title: 'CALL'),
                          if (hasUserCalledWithRaise('fourthPlayer'))
                            callTag(
                                top: 0.08,
                                left: 0,
                                color: Colors.red,
                                title: 'RAISE')
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
                    horizontalBotWithCard(
                        leftForFirstCard: 0.034,
                        topForFirstCard: 0.005,
                        leftForSecondCard: 0.042,
                        topForSecondCard: 0.01,
                        angleForFirstCard: 30,
                        angleForSecondCard: 50,
                        leftForBot: 0,
                        topForBot: 0.085),
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
                                            firstPlayerCall = 2000 +
                                                random.nextInt(2500 - 2000);
                                            highestCall = firstPlayerCall;
                                          });
                                          context
                                              .read<StartGameCubit>()
                                              .toggleState(true);
                                          context
                                              .read<WinGameCubit>()
                                              .toggleState(false);
                                          setUserCall(
                                              name: 'firstPlayer',
                                              isCalled: true,
                                              isRaised: false,
                                              price: firstPlayerCall);
                                          Future.delayed(Duration(seconds: 2))
                                              .then((value) => context
                                                  .read<
                                                      ShowUserCallOptionsCubit>()
                                                  .toggleState(true));
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
                        if (hasUserCalledWithCall('thirdPlayer') ||
                            hasUserCalledWithRaise('thirdPlayer'))
                          callLabel(
                              top: 0.2,
                              left: 0,
                              color: callLabelColor,
                              title: getUserCallPrice('thirdPlayer')),
                        if (hasUserCalledWithCall('thirdPlayer'))
                          callTag(
                              top: 0.09,
                              left: 0,
                              color: Colors.red,
                              title: 'CALL'),
                        if (hasUserCalledWithRaise('thirdPlayer'))
                          callTag(
                              top: 0.09,
                              left: 0,
                              color: Colors.red,
                              title: 'RAISE'),
                        callTag(
                            top: 0.09,
                            left: 0.32,
                            color: Colors.red,
                            title: 'HIGH'),
                        callLabel(
                            top: 0.2,
                            left: 0.35,
                            color: Color.fromARGB(255, 206, 152, 170),
                            title: '$highestCall'),
                        if (cardVisibilty[0])
                          AnimatedBuilder(
                            animation: thirdPlayerController,
                            builder: (context, child) {
                              return Positioned(
                                top: heightWithScreenRatio(context, 0.135),
                                left: thirdPlayerAnimation.value
                                    .get(AnimProps.left),
                                child: Transform.rotate(
                                  angle: 90 / 180 * pi,
                                  child: bottomCardWidget(context, thirdCard),
                                ),
                              );
                            },
                          ),
                        if (hasUserCalledWithCall('firstPlayer') ||
                            hasUserCalledWithRaise('firstPlayer'))
                          callLabel(
                              top: 0.2,
                              left: 0.68,
                              color: callLabelColor,
                              title: getUserCallPrice('firstPlayer')),
                        if (hasUserCalledWithCall('firstPlayer'))
                          callTag(
                              top: 0.09,
                              left: 0.68,
                              color: Colors.red,
                              title: 'CALL'),
                        if (hasUserCalledWithRaise('firstPlayer'))
                          callTag(
                              top: 0.09,
                              left: 0.68,
                              color: Colors.red,
                              title: 'RAISE')
                      ]);
                    }
                  }()),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PlayerIdentity(
                          context: context,
                          width: 0.09,
                          title: 'bot3',
                          bits: 0),
                      Spacing().verticalSpaceWithRatio(context, 0.01),
                      horizontalBotWithCard(
                          rightForFirstCard: 0.034,
                          topForFirstCard: 0.005,
                          rightForSecondCard: 0.042,
                          topForSecondCard: 0.01,
                          angleForFirstCard: 30,
                          angleForSecondCard: 50,
                          rightForBot: 0,
                          topForBot: 0.085),
                      Spacing().verticalSpaceWithRatio(context, 0.01),
                      PlayerIdentity(
                          context: context, width: 0.08, title: '', bits: 1)
                    ],
                  ),
                )
              ]),
              Container(
                height: heightWithScreenRatio(context, 0.2),
                child: Stack(
                  children: [
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
                    Positioned(
                      left: widthWithScreenRatio(context, 0.41),
                      bottom: heightWithScreenRatio(context, 0.01),
                      child: verticalBotWithCard(
                          leftForFirstCard: 0.072,
                          bottomForFirstCard: 0.006,
                          angleForFirstCard: -10,
                          leftForSecondCard: 0.084,
                          bottomForSecondCard: 0.006,
                          angleForSecondCard: 20,
                          leftForBot: 0.09,
                          bottomForBot: 0),
                    ),
                    if (showUserCallOptions)
                      Container(
                        width: widthWithScreenRatio(context, 1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: callOptions(
                                    color: Colors.red, title: 'FOLD'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      setUserCall(
                                          name: 'user',
                                          isCalled: true,
                                          isRaised: false,
                                          price: highestCall);
                                      context
                                          .read<ShowUserCallOptionsCubit>()
                                          .toggleState(false);
                                      Future.delayed(Duration(seconds: 1)).then(
                                        (value) => setUserCall(
                                            name: 'thirdPlayer',
                                            isCalled: true,
                                            isRaised: false,
                                            price: highestCall),
                                      );
                                      Future.delayed(Duration(seconds: 2)).then(
                                          (value) => setUserCall(
                                              name: 'fourthPlayer',
                                              isCalled: true,
                                              isRaised: false,
                                              price: highestCall));
                                    },
                                    child: callOptions(
                                        color: Colors.blue, title: 'CALL')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<ShowUserCallOptionsCubit>()
                                          .toggleState(false);
                                      context
                                          .read<ShowRaisedPricesCubit>()
                                          .toggleState(true);
                                    },
                                    child: callOptions(
                                        color: Colors.green, title: 'RAISE')),
                              ),
                            ]),
                      ),
                    if (hasUserCalledWithCall('user') ||
                        hasUserCalledWithRaise('user'))
                      callLabel(
                          top: 0.02,
                          left: 0.43,
                          color: callLabelColor,
                          title: getUserCallPrice('user')),
                    if (hasUserCalledWithCall('user'))
                      callTag(
                          top: 0.06,
                          left: 0.36,
                          color: Colors.red,
                          title: 'CALL'),
                    if (hasUserCalledWithRaise('user'))
                      callTag(
                          top: 0.06,
                          left: 0.36,
                          color: Colors.red,
                          title: 'RAISE'),
                    if (showRaisedPrices)
                      Container(
                        width: widthWithScreenRatio(context, 1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                  4,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              highestCall =
                                                  highestCall + index + 1;
                                              secondPlayerCall = highestCall;
                                            });
                                            print(highestCall);

                                            setUserCall(
                                                name: 'user',
                                                isCalled: false,
                                                isRaised: true,
                                                price: secondPlayerCall);
                                            context
                                                .read<ShowRaisedPricesCubit>()
                                                .toggleState(false);

                                            Future.delayed(Duration(seconds: 1))
                                                .then(
                                              (value) => setUserCall(
                                                  name: 'thirdPlayer',
                                                  isCalled: true,
                                                  isRaised: false,
                                                  price: secondPlayerCall),
                                            );
                                            Future.delayed(Duration(seconds: 2))
                                                .then((value) => setUserCall(
                                                    name: 'fourthPlayer',
                                                    isCalled: true,
                                                    isRaised: false,
                                                    price: secondPlayerCall));
                                          },
                                          child: callOptions(
                                              color: Colors.green,
                                              title:
                                                  '${firstPlayerCall + index + 1}'),
                                        ),
                                      ))
                            ]),
                      )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget callTag(
          {required double top,
          required double left,
          required Color color,
          required String title}) =>
      Positioned(
          top: heightWithScreenRatio(context, top),
          left: widthWithScreenRatio(context, left),
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ));

  Widget callOptions({required Color color, required String title}) =>
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
          {required double top,
          required double left,
          required Color color,
          required String title}) =>
      Positioned(
          top: heightWithScreenRatio(context, top),
          left: widthWithScreenRatio(context, left),
          child: Container(
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
              )));

  Widget horizontalBotWithCard({
    double? leftForFirstCard,
    double? topForFirstCard,
    double? leftForSecondCard,
    double? topForSecondCard,
    double? angleForFirstCard,
    double? angleForSecondCard,
    double? leftForBot,
    double? topForBot,
    double? rightForFirstCard,
    double? rightForSecondCard,
    double? rightForBot,
  }) =>
      rightForFirstCard != null
          ? Container(
              width: widthWithScreenRatio(context, 0.12),
              height: heightWithScreenRatio(context, 0.24),
              child: Stack(
                children: [
                  Positioned(
                    right: widthWithScreenRatio(context, 0.034),
                    top: widthWithScreenRatio(context, 0.005),
                    child: Transform.rotate(
                      angle: -30 / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
                      ),
                    ),
                  ),
                  Positioned(
                    right: widthWithScreenRatio(context, 0.042),
                    top: widthWithScreenRatio(context, 0.01),
                    child: Transform.rotate(
                      angle: -50 / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
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
              height: heightWithScreenRatio(context, 0.24),
              child: Stack(
                children: [
                  Positioned(
                    left: widthWithScreenRatio(context, leftForFirstCard!),
                    top: widthWithScreenRatio(context, topForFirstCard!),
                    child: Transform.rotate(
                      angle: angleForFirstCard! / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
                      ),
                    ),
                  ),
                  Positioned(
                    left: widthWithScreenRatio(context, leftForSecondCard!),
                    top: widthWithScreenRatio(context, topForSecondCard!),
                    child: Transform.rotate(
                      angle: angleForSecondCard! / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
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

  Widget verticalBotWithCard({
    double? leftForFirstCard,
    double? topForFirstCard,
    double? leftForSecondCard,
    double? topForSecondCard,
    double? angleForFirstCard,
    double? angleForSecondCard,
    double? leftForBot,
    double? topForBot,
    double? bottomForFirstCard,
    double? bottomForSecondCard,
    double? bottomForBot,
  }) =>
      bottomForFirstCard != null
          ? Container(
              width: widthWithScreenRatio(context, 0.16),
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
                          card: PlayingCard(Suit.clubs, CardValue.ace),
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
                          card: PlayingCard(Suit.clubs, CardValue.queen),
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
              width: widthWithScreenRatio(context, 0.16),
              height: heightWithScreenRatio(context, 0.235),
              child: Stack(
                children: [
                  Positioned(
                    left: widthWithScreenRatio(context, leftForFirstCard!),
                    top: widthWithScreenRatio(context, topForFirstCard!),
                    child: Transform.rotate(
                      angle: angleForFirstCard! / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
                      ),
                    ),
                  ),
                  Positioned(
                    left: widthWithScreenRatio(context, leftForSecondCard!),
                    top: widthWithScreenRatio(context, topForSecondCard!),
                    child: Transform.rotate(
                      angle: angleForSecondCard! / 180 * pi,
                      child: Image.asset(
                        'assets/images/card.png',
                        width: widthWithScreenRatio(context, 0.04),
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

class CardVisibilityCubit extends Cubit<List<bool>> {
  CardVisibilityCubit() : super([false, false, false, false]);
  void toggleVisibility(List<bool> status) => emit(status);
  void resetVisibility() => emit([false, false, false, false]);
}

class StartGameCubit extends Cubit<bool> {
  StartGameCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class WinGameCubit extends Cubit<bool> {
  WinGameCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class UserCall {
  String user;
  bool isCall;
  bool isRaised;
  int price;
  UserCall(
      {required this.user,
      required this.isCall,
      required this.isRaised,
      required this.price});
}

class ShowUserCallCubit extends Cubit<List<UserCall>> {
  ShowUserCallCubit() : super([]);
  void setUserCall(UserCall userCall) => emit([...state, userCall]);
}

class ShowUserCallOptionsCubit extends Cubit<bool> {
  ShowUserCallOptionsCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class ShowRaisedPricesCubit extends Cubit<bool> {
  ShowRaisedPricesCubit() : super(false);
  void toggleState(bool status) => emit(status);
}
