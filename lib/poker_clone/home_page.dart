import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/core/utils.dart';
import 'package:poker_clone/poker_clone/bloc/cards_distribution_cubit.dart';
import 'package:poker_clone/poker_clone/bloc/winner_cubit.dart';
import 'package:poker_clone/poker_clone/components/app_sections/body_section.dart';
import 'package:poker_clone/poker_clone/components/app_sections/footer_section.dart';
import 'package:poker_clone/poker_clone/components/app_sections/header_section.dart';
import 'package:poker_clone/poker_clone/components/player_identity.dart';
import 'package:poker_clone/poker_clone/components/score_counter.dart';
import 'package:poker_clone/poker_clone/components/settings_widget.dart';
import 'package:restart_app/restart_app.dart';
import 'package:simple_animations/timeline_tween/timeline_tween.dart';
import 'package:supercharged/supercharged.dart';

import 'bloc/app_logic_cubits.dart';
import 'components/helper_widgets.dart';
import 'components/horizontal_bots_with_cards.dart';
import 'components/vertical_bots_with_cards.dart';

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
  bool isFirstPlayerFold = false;
  bool isUserFold = false;
  bool isThirdPlayerFold = false;
  bool isFourthPlayerFold = false;
  bool shownWinner = false;
  bool hasWinnerTypeAndIndexFinalized = false;
  bool hasStartedOnce = false;
  WinnerTypeAndIndex winnerTypeAndIndex = WinnerTypeAndIndex(
      winnerType: WinnerRanks.flush, winnerIndex: Winner.none);
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
                setState(() {
                  isThirdPlayerFold = true;
                });
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

    void startFromFirstPlayer() {
      if (betState == BetState.call) {
        setState(() {
          firstPlayerCall = 2000 + random.nextInt(2500 - 2000);
        });
      } else if (betState == BetState.fold) {
        setState(() {
          isFirstPlayerFold = true;
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
      if (isUserFold) {
        startFromThirdPlayer();
        startFromFourthPlayer();
      } else {
        Future.delayed(Duration(seconds: 2)).then((value) =>
            context.read<ShowUserCallOptionsCubit>().toggleState(true));
      }
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
      setState(() {
        hasCountedForFirstRound = true;
      });
      if (isFirstPlayerFold && isUserFold) {
        startFromThirdPlayer();
        startFromFourthPlayer();
      } else if (isFirstPlayerFold) {
        context.read<ShowUserCallOptionsCubit>().toggleState(true);
      } else {
        startFromFirstPlayer();
      }
    }
    if (turnRoundState == Rounds.none) {
      setState(() {
        hasCountedForFirstRound = false;
      });
    }

    if (roundCounts == 4) {
      context.read<WinGameCubit>().toggleState(true);
    }
    if (isWinGame) {
      setState(() {
        showTwoPlayerCards = true;
      });
      if (!shownWinner) {
        setState(() {
          winnerTypeAndIndex = context
              .read<WinnerCubit>()
              .selectWinner(cardsList, isFirstPlayerFold, isUserFold);
        });
      }
    }
    if (winnerTypeAndIndex.winnerIndex != Winner.none &&
        !hasWinnerTypeAndIndexFinalized) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          shownWinner = true;
          hasWinnerTypeAndIndexFinalized = true;
        });
      });
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
              HeaderSection(
                  showTwoPlayerCards: showTwoPlayerCards, cardsList: cardsList),
              BodySection(
                showTwoPlayerCards: showTwoPlayerCards,
                cardsList: cardsList,
                showStartGameDialog: showStartGameDialog,
                shownWinner: shownWinner,
                winnerTypeAndIndex: winnerTypeAndIndex,
                hasStartedOnce: hasStartedOnce,
                isFirstPlayerFold: isFirstPlayerFold,
                showThreeCards: showThreeCards,
                showFourthCard: showFourthCard,
                showFifthCard: showFifthCard,
                totalBid: totalBid,
                onClick: () {
                  if (hasStartedOnce) {
                    Phoenix.rebirth(context);
                  } else {
                    startFromFirstPlayer();
                    setState(() {
                      hasStartedOnce = true;
                    });
                  }
                },
              ),
              FooterSection(
                  isUserFold: isUserFold,
                  showTwoPlayerCards: showTwoPlayerCards,
                  cardsList: cardsList,
                  showUserCallOptions: showUserCallOptions,
                  showRaisedPrices: showRaisedPrices,
                  onClickFold: () {
                    setState(() {
                      isUserFold = true;
                    });
                    startFromUser(bet: BetState.fold, price: 0, bid: 0);
                    startFromThirdPlayer();
                    startFromFourthPlayer();
                  },
                  onClickCall: () {
                    startFromUser(
                        bet: BetState.call,
                        price: highestCall,
                        bid: highestCall);
                    startFromThirdPlayer();
                    startFromFourthPlayer();
                  },
                  onClickRecheck: () {
                    startFromUser(bet: BetState.recheck, price: 0, bid: 0);
                    startFromThirdPlayer();
                    startFromFourthPlayer();
                  },
                  raiseOptions: Row(
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
                                          highestCall = highestCall + index + 1;
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
                                    child: HelperWidgets().callOptions(
                                        context: context,
                                        color: Colors.green,
                                        title: highestCall != 0
                                            ? '${highestCall + index + 1}'
                                            : '${2344 + index + 1}'),
                                  ),
                                ))
                      ])),
            ],
          ),
        ],
      ),
    );
  }
}
