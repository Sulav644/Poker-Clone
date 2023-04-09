import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/core/utils.dart';
import 'package:poker_clone/poker_clone/bloc/cards_distribution_cubit.dart';
import 'package:poker_clone/poker_clone/bloc/winner_cubit.dart';
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
  bool showThreeCards = false;
  bool showFourthCard = false;
  bool showFifthCard = false;
  bool hasCountedForFirstRound = false;
  bool isSelectedRandomCard = false;
  bool showTwoPlayerCards = false;
  List<PlayingCardView> cardsList = [];
  int round = 1;
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
    final roundCounts = context.watch<RoundCountCubit>().state;
    if (!isSelectedRandomCard) {
      for (var i = 0; i < 13; i++) {
        cardsList.add(context.read<CardsDistributionCubit>().selectCard());
        print(cardsList[i].card.value);
      }

      setState(() {
        isSelectedRandomCard = true;
      });
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

      setUserCall(
          name: 'firstPlayer',
          bet: betState,
          cardIndex: [0, 1],
          price: firstPlayerCall);

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
                context.read<TotalBidPriceCubit>().addBid(highestCall);
                return highestCall;
              } else if (betState == BetState.fold) {
                context.read<TotalBidPriceCubit>().addBid(0);
                return 0;
              } else if (betState == BetState.raise) {
                setState(() {
                  thirdPlayerCall =
                      highestCall + random.nextInt(3000 - highestCall);
                });

                context.read<TotalBidPriceCubit>().addBid(thirdPlayerCall);
                return thirdPlayerCall;
              } else {
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
              context.read<RoundCountCubit>().addRound();
              return highestCall;
            } else if (betState == BetState.fold) {
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(0);
              context.read<RoundCountCubit>().addRound();
              return 0;
            } else if (betState == BetState.raise) {
              setState(() {
                fourthPlayerCall =
                    highestCall + random.nextInt(3000 - highestCall);
              });
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(fourthPlayerCall);
              context.read<RoundCountCubit>().addRound();
              return fourthPlayerCall;
            } else {
              context.read<TurnRoundCubit>().movieRound();
              context.read<TotalBidPriceCubit>().addBid(0);
              context.read<RoundCountCubit>().addRound();
              return 0;
            }
          }())));
      setState(() {
        round++;
      });
    }

    void startFromUser(
        {required BetState bet, required int price, required int bid}) {
      setUserCall(name: 'user', bet: bet, cardIndex: [0, 1], price: price);

      context.read<TotalBidPriceCubit>().addBid(bid);
      context.read<ShowUserCallOptionsCubit>().toggleState(false);
    }

    final turnRoundState = context.watch<TurnRoundCubit>().state;

    context
        .read<SetUserBetCubit>()
        .toggleState(BetState.values[random.nextInt(4)]);

    if (turnRoundState == Rounds.nextLevel) {
      context.read<UserCallListCubit>().resetState();
    }
    if (turnRoundState == Rounds.showThreeCards) {
      switch (round) {
        case 2:
          setState(() {
            showThreeCards = true;
          });
          break;
        case 3:
          setState(() {
            showFourthCard = true;
          });
          break;
        case 4:
          setState(() {
            showFifthCard = true;
          });
          break;

        default:
      }
    }

    if (turnRoundState == Rounds.firstPlayer &&
        !hasCountedForFirstRound &&
        roundCounts != 4) {
      print(hasCountedForFirstRound);
      setState(() {
        hasCountedForFirstRound = true;
      });
      startFromFirstPlayer();
      print(hasCountedForFirstRound);
    }
    if (turnRoundState == Rounds.none) {
      setState(() {
        hasCountedForFirstRound = false;
      });
    }
    print(roundCounts);
    if (roundCounts == 4) {
      context.read<WinGameCubit>().toggleState(true);
    }
    if (isWinGame) {
      setState(() {
        showTwoPlayerCards = true;
      });
      context.read<WinnerCubit>().selectWinner(cardsList);
    }

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
                              leftForFirstCard:
                                  !showTwoPlayerCards ? 0.115 : 0.09,
                              topForFirstCard:
                                  !showTwoPlayerCards ? 0.03 : 0.035,
                              angleForFirstCard: -20,
                              leftForSecondCard:
                                  !showTwoPlayerCards ? 0.08 : 0.045,
                              topForSecondCard:
                                  !showTwoPlayerCards ? 0.03 : 0.028,
                              angleForSecondCard: -160,
                              leftForBot: 0.089,
                              topForBot: 0,
                              showTwoPlayerCards: showTwoPlayerCards),
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
                        leftForFirstCard: !showTwoPlayerCards ? 0.034 : 0.03,
                        topForFirstCard: !showTwoPlayerCards ? 0.005 : 0.002,
                        leftForSecondCard: !showTwoPlayerCards ? 0.042 : 0.034,
                        topForSecondCard: !showTwoPlayerCards ? 0.01 : 0.045,
                        angleForFirstCard: 60,
                        angleForSecondCard: 100,
                        leftForBot: 0,
                        topForBot: 0.085,
                        showTwoPlayerCards: showTwoPlayerCards),
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
                    if (!showStartGameDialog) {
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
                                'Start the game?',
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
                                      if (showThreeCards)
                                        visibleCardAfterEachRound(
                                            card: cardsList[0].card),
                                      if (showThreeCards)
                                        visibleCardAfterEachRound(
                                            card: cardsList[1].card),
                                      if (showThreeCards)
                                        visibleCardAfterEachRound(
                                            card: cardsList[2].card),
                                      if (showFourthCard)
                                        visibleCardAfterEachRound(
                                            card: cardsList[3].card),
                                      if (showFifthCard)
                                        visibleCardAfterEachRound(
                                            card: cardsList[4].card),
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
                          rightForFirstCard:
                              !showTwoPlayerCards ? 0.036 : 0.028,
                          topForFirstCard: 0.001,
                          rightForSecondCard:
                              !showTwoPlayerCards ? 0.044 : 0.032,
                          topForSecondCard: 0.05,
                          angleForFirstCard: -80,
                          angleForSecondCard: -100,
                          rightForBot: 0,
                          topForBot: 0.085,
                          showTwoPlayerCards: showTwoPlayerCards),
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
                      left: widthWithScreenRatio(context, 0.42),
                      bottom: heightWithScreenRatio(context, 0.01),
                      child: verticalBotWithCard(
                          leftForFirstCard: 0.05,
                          bottomForFirstCard: 0.006,
                          angleForFirstCard: -10,
                          leftForSecondCard: 0.098,
                          bottomForSecondCard: 0.006,
                          angleForSecondCard: 20,
                          leftForBot: 0.09,
                          bottomForBot: 0,
                          showTwoPlayerCards: showTwoPlayerCards),
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

  Widget visibleCardAfterEachRound({required PlayingCard card}) => Container(
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
    required bool showTwoPlayerCards,
  }) =>
      rightForFirstCard != null
          ? Container(
              width: widthWithScreenRatio(context, 0.12),
              height: heightWithScreenRatio(context, 0.28),
              child: Stack(
                children: [
                  Positioned(
                    right: widthWithScreenRatio(context, rightForFirstCard),
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
    required bool showTwoPlayerCards,
  }) =>
      bottomForFirstCard != null
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
                          card: cardsList[7].card,
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
                          card: cardsList[8].card,
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
                                card: cardsList[6].card,
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
                                card: cardsList[6].card,
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
  void toggleState(bool status) {
    Future.delayed(Duration(seconds: 1), () {
      emit(status);
    });
  }
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
    emit(state + price);
  }
}

enum Rounds { nextLevel, showThreeCards, firstPlayer, none }

class TurnRoundCubit extends Cubit<Rounds> {
  TurnRoundCubit() : super(Rounds.none);
  void movieRound() {
    Future.delayed(Duration(seconds: 1), () => emit(Rounds.nextLevel))
        .then((value) => Future.delayed(
            Duration(seconds: 1), () => emit(Rounds.showThreeCards)))
        .then((value) => Future.delayed(
            Duration(seconds: 1), () => emit(Rounds.firstPlayer)))
        .then((value) =>
            Future.delayed(Duration(seconds: 1), () => emit(Rounds.none)));

    emit(Rounds.none);
  }
}

class RoundCountCubit extends Cubit<int> {
  RoundCountCubit() : super(0);
  void addRound() => emit(state + 1);
}
