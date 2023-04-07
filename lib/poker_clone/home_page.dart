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
    final userCallList = context.watch<UserCallListCubit>().state;
    final showUserCallOptions = context.watch<ShowUserCallOptionsCubit>().state;
    final showRaisedPrices = context.watch<ShowRaisedPricesCubit>().state;
    final betState = context.watch<SetUserBetCubit>().state;
    final totalBid = context.watch<TotalBidPriceCubit>().state;
    final hasFirstPlayerRecheck =
        context.watch<FirstPlayerRecheckStatusCubit>().state;
    final isGeneratedRandomCard =
        context.watch<IsGeneratedRandomCardCubit>().state;
    if (!isGeneratedRandomCard) {
      List<int> cardsList = [];
      for (var i = 0; i < 13; i++) {
        final randomCard = random.nextInt(13);
        cardsList.add(randomCard);
      }
      context.read<RandomCardsGeneratorCubit>().generateRandomCards(cardsList);
      context.read<IsGeneratedRandomCardCubit>().toggleState();
    }
    void setUserCall(
            {required String name,
            required BetState bet,
            required int price,
            required List<int> cardIndex}) =>
        context.read<UserCallListCubit>().setUserCall(
            UserCall(user: name, bet: bet, cardIndex: cardIndex, price: price));

    void startFromFirstPlayer() {
      if (betState == BetState.call) {
        setState(() {
          firstPlayerCall = 2000 + random.nextInt(2500 - 2000);
        });
      } else if (betState == BetState.fold) {
        setState(() {
          firstPlayerCall = 0;
        });
      } else if (betState == BetState.raise) {
        setState(() {
          firstPlayerCall = 2000 + random.nextInt(2500 - 2000);
        });
      } else {
        setState(() {
          firstPlayerCall = 0;
        });
      }
      if (firstPlayerCall != 0) {
        highestCall = firstPlayerCall;
      } else {
        highestCall = 2344;
      }
      context.read<TotalBidPriceCubit>().addBid(firstPlayerCall);
      context.read<StartGameCubit>().toggleState(true);
      context.read<WinGameCubit>().toggleState(false);

      print(betState);
      setUserCall(
          name: 'firstPlayer',
          bet: betState,
          cardIndex: [0, 1],
          price: firstPlayerCall);
      context.read<TurnRoundCubit>().movieRound();
      if (betState == BetState.recheck)
        context.read<FirstPlayerRecheckStatusCubit>().toggleState();
      Future.delayed(Duration(seconds: 2)).then((value) =>
          context.read<ShowUserCallOptionsCubit>().toggleState(true));
    }

    void startFromThirdPlayer() {
      context.read<SetUserBetCubit>().toggleState(
          BetState.values[random.nextInt(hasFirstPlayerRecheck ? 4 : 3)]);
      Future.delayed(Duration(seconds: 1)).then(
        (value) => setUserCall(
            name: 'thirdPlayer',
            bet: betState,
            cardIndex: [0, 1],
            price: (() {
              if (betState == BetState.call) {
                context.read<TurnRoundCubit>().movieRound();
                context.read<TotalBidPriceCubit>().addBid(highestCall);
                return highestCall;
              } else if (betState == BetState.fold) {
                context.read<TurnRoundCubit>().movieRound();
                context.read<TotalBidPriceCubit>().addBid(0);
                return 0;
              } else if (betState == BetState.raise) {
                context.read<TurnRoundCubit>().movieRound();
                setState(() {
                  thirdPlayerCall =
                      highestCall + random.nextInt(3000 - highestCall);
                });

                context.read<TotalBidPriceCubit>().addBid(thirdPlayerCall);
                return thirdPlayerCall;
              } else {
                context.read<TurnRoundCubit>().movieRound();
                context.read<TotalBidPriceCubit>().addBid(0);
                return 0;
              }
            }())),
      );
    }

    void startFromFourthPlayer() {
      context.read<SetUserBetCubit>().toggleState(
          BetState.values[random.nextInt(hasFirstPlayerRecheck ? 4 : 3)]);
      Future.delayed(Duration(seconds: 2)).then((value) => setUserCall(
          name: 'fourthPlayer',
          bet: betState,
          cardIndex: [0, 1],
          price: (() {
            if (betState == BetState.call) {
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(highestCall);
              return highestCall;
            } else if (betState == BetState.fold) {
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(0);
              return 0;
            } else if (betState == BetState.raise) {
              context.read<TurnRoundCubit>().movieRound();
              setState(() {
                fourthPlayerCall =
                    highestCall + random.nextInt(3000 - highestCall);
              });

              context.read<TotalBidPriceCubit>().addBid(fourthPlayerCall);
              return fourthPlayerCall;
            } else {
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(0);
              return 0;
            }
          }())));
    }

    void startFromUser(
        {required BetState bet, required int price, required int bid}) {
      setUserCall(name: 'user', bet: bet, cardIndex: [0, 1], price: price);
      context.read<TurnRoundCubit>().movieRound();
      context.read<TotalBidPriceCubit>().addBid(bid);
      context.read<ShowUserCallOptionsCubit>().toggleState(false);
    }

    final turnRoundState = context.watch<TurnRoundCubit>().state;

    print(turnRoundState);

    context
        .read<SetUserBetCubit>()
        .toggleState(BetState.values[random.nextInt(4)]);
    String getUserCallPrice(String title) => userCallList[
            userCallList.indexWhere((element) => element.user == title)]
        .price
        .toString();
    bool hasUserCalled(String title) =>
        userCallList.where((element) => element.user == title).isNotEmpty;
    BetState userBetState(String title) => userCallList[
            userCallList.indexWhere((element) => element.user == title)]
        .bet;

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
                          Column(children: [
                            Spacing().verticalSpaceWithRatio(context, 0.08),
                            if (hasUserCalled('fourthPlayer') &&
                                userBetState('fourthPlayer') == BetState.call)
                              callTag(color: Colors.red, title: 'CALL'),
                            if (hasUserCalled('fourthPlayer') &&
                                userBetState('fourthPlayer') == BetState.raise)
                              callTag(color: Colors.red, title: 'RAISE'),
                            if (hasUserCalled('fourthPlayer') &&
                                userBetState('fourthPlayer') == BetState.fold)
                              callTag(color: Colors.red, title: 'FOLD'),
                            if (hasUserCalled('fourthPlayer') &&
                                userBetState('fourthPlayer') ==
                                    BetState.recheck)
                              callTag(color: Colors.red, title: 'RECHECk'),
                            Spacing().verticalSpaceWithRatio(context, 0.02),
                            if (hasUserCalled('fourthPlayer') &&
                                userBetState('fourthPlayer') != BetState.fold &&
                                userBetState('fourthPlayer') !=
                                    BetState.recheck)
                              callLabel(
                                  color: callLabelColor,
                                  title: getUserCallPrice('fourthPlayer')),
                          ]),
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
                                        onTap: () => startFromFirstPlayer(),
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
                      return Column(
                        children: [
                          Spacing().verticalSpaceWithRatio(context, 0.05),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: widthWithScreenRatio(context, 0.1),
                                  height: heightWithScreenRatio(context, 0.4),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (hasUserCalled('thirdPlayer') &&
                                            userBetState('thirdPlayer') ==
                                                BetState.call)
                                          callTag(
                                              color: Colors.red, title: 'CALL'),
                                        if (hasUserCalled('thirdPlayer') &&
                                            userBetState('thirdPlayer') ==
                                                BetState.raise)
                                          callTag(
                                              color: Colors.red,
                                              title: 'RAISE'),
                                        if (hasUserCalled('thirdPlayer') &&
                                            userBetState('thirdPlayer') ==
                                                BetState.fold)
                                          callTag(
                                              color: Colors.red, title: 'FOLD'),
                                        if (hasUserCalled('thirdPlayer') &&
                                            userBetState('thirdPlayer') ==
                                                BetState.recheck)
                                          callTag(
                                              color: Colors.red,
                                              title: 'RECHECK'),
                                        Spacing().verticalSpaceWithRatio(
                                            context, 0.02),
                                        if (hasUserCalled('thirdPlayer') &&
                                            userBetState('thirdPlayer') !=
                                                BetState.fold &&
                                            userBetState('thirdPlayer') !=
                                                BetState.recheck)
                                          callLabel(
                                              color: callLabelColor,
                                              title: getUserCallPrice(
                                                  'thirdPlayer')),
                                      ]),
                                ),
                                Column(children: [
                                  callTag(color: Colors.red, title: 'HIGH'),
                                  Spacing()
                                      .verticalSpaceWithRatio(context, 0.02),
                                  callLabel(
                                      color: Color.fromARGB(255, 206, 152, 170),
                                      title: '$totalBid'),
                                  if (cardVisibilty[0])
                                    AnimatedBuilder(
                                      animation: thirdPlayerController,
                                      builder: (context, child) {
                                        return Positioned(
                                          top: heightWithScreenRatio(
                                              context, 0.135),
                                          left: thirdPlayerAnimation.value
                                              .get(AnimProps.left),
                                          child: Transform.rotate(
                                            angle: 90 / 180 * pi,
                                            child: bottomCardWidget(
                                                context, thirdCard),
                                          ),
                                        );
                                      },
                                    ),
                                  Spacing()
                                      .verticalSpaceWithRatio(context, 0.04),
                                  Row(
                                    children: [
                                      if (turnRoundState > 3)
                                        Container(
                                          width: widthWithScreenRatio(
                                              context, 0.06),
                                          alignment: Alignment.center,
                                          child: PlayingCardView(
                                              card: PlayingCard(
                                                  Suit.clubs, CardValue.ace)),
                                        ),
                                      if (turnRoundState > 3)
                                        Container(
                                          width: widthWithScreenRatio(
                                              context, 0.06),
                                          alignment: Alignment.center,
                                          child: PlayingCardView(
                                              card: PlayingCard(
                                                  Suit.spades, CardValue.five)),
                                        ),
                                      if (turnRoundState > 3)
                                        Container(
                                          width: widthWithScreenRatio(
                                              context, 0.06),
                                          alignment: Alignment.center,
                                          child: PlayingCardView(
                                              card: PlayingCard(Suit.diamonds,
                                                  CardValue.queen)),
                                        ),
                                    ],
                                  ),
                                ]),
                                Container(
                                  width: widthWithScreenRatio(context, 0.1),
                                  height: heightWithScreenRatio(context, 0.4),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (hasUserCalled('firstPlayer') &&
                                            userBetState('firstPlayer') ==
                                                BetState.call)
                                          callTag(
                                              color: Colors.red, title: 'CALL'),
                                        if (hasUserCalled('firstPlayer') &&
                                            userBetState('firstPlayer') ==
                                                BetState.raise)
                                          callTag(
                                              color: Colors.red,
                                              title: 'RAISE'),
                                        if (hasUserCalled('firstPlayer') &&
                                            userBetState('firstPlayer') ==
                                                BetState.fold)
                                          callTag(
                                              color: Colors.red, title: 'FOLD'),
                                        if (hasUserCalled('firstPlayer') &&
                                            userBetState('firstPlayer') ==
                                                BetState.recheck)
                                          callTag(
                                              color: Colors.red,
                                              title: 'RECHECK'),
                                        Spacing().verticalSpaceWithRatio(
                                            context, 0.02),
                                        if (hasUserCalled('firstPlayer') &&
                                            userBetState('firstPlayer') !=
                                                BetState.fold &&
                                            userBetState('firstPlayer') !=
                                                BetState.recheck)
                                          callLabel(
                                              color: callLabelColor,
                                              title: getUserCallPrice(
                                                  'firstPlayer')),
                                      ]),
                                )
                              ]),
                        ],
                      );
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
                                child: GestureDetector(
                                  onTap: () {
                                    startFromUser(
                                        bet: BetState.fold, price: 0, bid: 0);
                                    startFromThirdPlayer();
                                    startFromFourthPlayer();
                                  },
                                  child: callOptions(
                                      color: Colors.red, title: 'FOLD'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      startFromUser(
                                          bet: BetState.call,
                                          price: highestCall,
                                          bid: highestCall);
                                      startFromThirdPlayer();
                                      startFromFourthPlayer();
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      startFromUser(
                                          bet: BetState.recheck,
                                          price: 0,
                                          bid: 0);
                                      startFromThirdPlayer();
                                      startFromFourthPlayer();
                                    },
                                    child: callOptions(
                                        color: Colors.green, title: 'RECHECK')),
                              )
                            ]),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: widthWithScreenRatio(context, 0.22),
                          ),
                          child: Column(children: [
                            if (hasUserCalled('user') &&
                                userBetState('user') == BetState.call)
                              callTag(color: Colors.red, title: 'CALL'),
                            if (hasUserCalled('user') &&
                                userBetState('user') == BetState.raise)
                              callTag(color: Colors.red, title: 'RAISE'),
                            if (hasUserCalled('user') &&
                                userBetState('user') == BetState.fold)
                              callTag(color: Colors.red, title: 'FOLD'),
                            if (hasUserCalled('user') &&
                                userBetState('user') == BetState.recheck)
                              callTag(color: Colors.red, title: 'RECHECK'),
                            Spacing().verticalSpaceWithRatio(context, 0.02),
                            if (hasUserCalled('user') &&
                                userBetState('user') != BetState.fold &&
                                userBetState('user') != BetState.recheck)
                              callLabel(
                                  color: callLabelColor,
                                  title: getUserCallPrice('user')),
                          ]),
                        ),
                      ],
                    ),
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
                                              if (highestCall != 0) {
                                                highestCall =
                                                    highestCall + index + 1;
                                              } else {
                                                highestCall = 2344 + index + 1;
                                              }
                                            });
                                            print(highestCall);

                                            startFromUser(
                                                bet: BetState.raise,
                                                price: highestCall,
                                                bid: highestCall);
                                            context
                                                .read<ShowRaisedPricesCubit>()
                                                .toggleState(false);
                                            startFromThirdPlayer();
                                            startFromFourthPlayer();
                                          },
                                          child: callOptions(
                                              color: Colors.green,
                                              title: highestCall != 0
                                                  ? '${highestCall + index + 1}'
                                                  : '${2344 + index + 1}'),
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

  Widget callLabel({required Color color, required String title}) => Container(
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

enum BetState { fold, call, raise, recheck }

class UserCall {
  String user;
  BetState bet;
  int price;
  List<int> cardIndex;
  UserCall(
      {required this.user,
      required this.bet,
      required this.price,
      required this.cardIndex});
}

class SetUserBetCubit extends Cubit<BetState> {
  SetUserBetCubit() : super(BetState.call);
  void toggleState(BetState betState) => emit(betState);
}

class UserCallListCubit extends Cubit<List<UserCall>> {
  UserCallListCubit() : super([]);
  void setUserCall(UserCall userCall) => emit([...state, userCall]);
  void resetState() => emit([]);
}

class ShowUserCallOptionsCubit extends Cubit<bool> {
  ShowUserCallOptionsCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class ShowRaisedPricesCubit extends Cubit<bool> {
  ShowRaisedPricesCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class FirstPlayerRecheckStatusCubit extends Cubit<bool> {
  FirstPlayerRecheckStatusCubit() : super(false);
  void toggleState() => emit(true);
  void resetState() => emit(false);
}

class TotalBidPriceCubit extends Cubit<int> {
  TotalBidPriceCubit() : super(0);
  void addBid(int price) {
    print(price);
    emit(state + price);
    print(state);
  }
}

class IsGeneratedRandomCardCubit extends Cubit<bool> {
  IsGeneratedRandomCardCubit() : super(false);
  void toggleState() => emit(true);
}

class RandomCardsGeneratorCubit extends Cubit<List<int>> {
  RandomCardsGeneratorCubit() : super([]);
  void generateRandomCards(List<int> cardsList) => emit([...cardsList]);
}

class TurnRoundCubit extends Cubit<int> {
  TurnRoundCubit() : super(0);
  void movieRound() => emit(state + 1);
  void resetRound() => emit(0);
}
