import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../../core/utils.dart';
import '../../bloc/app_logic_cubits.dart';
import '../../bloc/winner_cubit.dart';
import '../helper_widgets.dart';
import '../horizontal_bots_with_cards.dart';
import '../player_identity.dart';

class BodySection extends StatelessWidget {
  final bool showTwoPlayerCards;
  final bool showStartGameDialog;
  final bool shownWinner;
  final List<PlayingCardView> cardsList;
  final WinnerTypeAndIndex winnerTypeAndIndex;
  final bool hasStartedOnce;
  final bool isFirstPlayerFold;
  final bool showThreeCards;
  final bool showFourthCard;
  final bool showFifthCard;
  final int totalBid;
  final VoidCallback onClick;
  const BodySection(
      {super.key,
      required this.showTwoPlayerCards,
      required this.cardsList,
      required this.showStartGameDialog,
      required this.shownWinner,
      required this.winnerTypeAndIndex,
      required this.hasStartedOnce,
      required this.isFirstPlayerFold,
      required this.showThreeCards,
      required this.showFourthCard,
      required this.showFifthCard,
      required this.totalBid,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    final showStartGameDialog = context.watch<StartGameCubit>().state;
    const callLabelColor = Color.fromARGB(255, 117, 135, 150);
    final userCallList = context.watch<UserCallListCubit>().state;
    bool hasUserCalled(String title) =>
        userCallList.where((element) => element.user == title).isNotEmpty;
    BetState userBetState(String title) => userCallList[
            userCallList.indexWhere((element) => element.user == title)]
        .bet;
    String getUserCallPrice(String title) => userCallList[
            userCallList.indexWhere((element) => element.user == title)]
        .price
        .toString();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlayerIdentity(context: context, width: 0.09, title: 'bot1', bits: 0),
          Spacing().verticalSpaceWithRatio(context, 0.01),
          HorizontalBotsWithCards(
            leftForFirstCard: !showTwoPlayerCards ? 0.034 : 0.03,
            topForFirstCard: !showTwoPlayerCards ? 0.015 : 0.002,
            leftForSecondCard: !showTwoPlayerCards ? 0.04 : 0.03,
            topForSecondCard: !showTwoPlayerCards ? 0.05 : 0.045,
            angleForFirstCard: !showTwoPlayerCards ? 60 : 80,
            angleForSecondCard: 100,
            leftForBot: 0,
            topForBot: 0.085,
            showTwoPlayerCards: showTwoPlayerCards,
            cardsList: cardsList,
          ),
          Spacing().verticalSpaceWithRatio(context, 0.01),
          PlayerIdentity(context: context, width: 0.08, title: '', bits: 3)
        ],
      ),
      Container(
        width: widthWithScreenRatio(context, 0.75),
        height: heightWithScreenRatio(context, 0.53),
        alignment: Alignment.center,
        child: (() {
          if (!showStartGameDialog || shownWinner) {
            return Container(
              width: widthWithScreenRatio(context, 0.48),
              height: heightWithScreenRatio(context, 0.36),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 221, 210, 108),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      !shownWinner
                          ? 'Start the game?'
                          : '${(() {
                              if (winnerTypeAndIndex.winnerIndex ==
                                  Winner.firstPlayer) {
                                return 'Bot3';
                              } else if (winnerTypeAndIndex.winnerIndex ==
                                  Winner.secondPlayer) {
                                return 'You';
                              } else if (winnerTypeAndIndex.winnerIndex ==
                                  Winner.thirdPlayer) {
                                return 'Bot1';
                              } else {
                                return 'Bot2';
                              }
                            }())}'
                              ' won with \$$totalBid '
                              '${(() {
                              if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.royalFlush) {
                                return 'Royal Flush';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.straightFlush) {
                                return 'Straight Flush';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.fourOfAKind) {
                                return 'Four of a kind';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.fullHouse) {
                                return 'Full House';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.flush) {
                                return 'Flush';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.straight) {
                                return 'Straight';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.threeOfAKind) {
                                return 'Three of a kind';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.twoPairs) {
                                return 'Two Pairs';
                              } else if (winnerTypeAndIndex.winnerType ==
                                  WinnerRanks.onePair) {
                                return 'One Pair';
                              } else {
                                return 'High Card';
                              }
                            }())}'
                              '. Do you want to continue ?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                              onTap: () => onClick(),
                              child: HelperWidgets()
                                  .startGameOption('YES', Colors.green)),
                        ),
                        Spacing().horizontalSpaceWithRatio(context, 0.015),
                        HelperWidgets().startGameOption('NO', Colors.red)
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
                      SizedBox(
                        width: widthWithScreenRatio(context, 0.1),
                        height: heightWithScreenRatio(context, 0.4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasUserCalled('thirdPlayer') &&
                                  userBetState('thirdPlayer') == BetState.call)
                                HelperWidgets()
                                    .callTag(color: Colors.red, title: 'CALL'),
                              if (hasUserCalled('thirdPlayer') &&
                                  userBetState('thirdPlayer') == BetState.raise)
                                HelperWidgets()
                                    .callTag(color: Colors.red, title: 'RAISE'),
                              if (hasUserCalled('thirdPlayer') &&
                                  userBetState('thirdPlayer') == BetState.fold)
                                HelperWidgets().callTag(
                                    color: Colors.red, title: 'RECHECK'),
                              if (hasUserCalled('thirdPlayer') &&
                                  userBetState('thirdPlayer') ==
                                      BetState.recheck)
                                HelperWidgets().callTag(
                                    color: Colors.red, title: 'RECHECK'),
                              Spacing().verticalSpaceWithRatio(context, 0.02),
                              if (hasUserCalled('thirdPlayer') &&
                                  userBetState('thirdPlayer') !=
                                      BetState.fold &&
                                  userBetState('thirdPlayer') !=
                                      BetState.recheck)
                                HelperWidgets().callLabel(
                                    context: context,
                                    color: callLabelColor,
                                    title: getUserCallPrice('thirdPlayer')),
                            ]),
                      ),
                      Column(children: [
                        HelperWidgets()
                            .callTag(color: Colors.red, title: 'SUM'),
                        Spacing().verticalSpaceWithRatio(context, 0.02),
                        HelperWidgets().callLabel(
                            context: context,
                            color: const Color.fromARGB(255, 206, 152, 170),
                            title: '$totalBid'),
                        Spacing().verticalSpaceWithRatio(context, 0.04),
                        Row(
                          children: [
                            if (showThreeCards)
                              HelperWidgets().visibleCardAfterEachRound(
                                  context: context, card: cardsList[0].card),
                            if (showThreeCards)
                              HelperWidgets().visibleCardAfterEachRound(
                                  context: context, card: cardsList[1].card),
                            if (showThreeCards)
                              HelperWidgets().visibleCardAfterEachRound(
                                  context: context, card: cardsList[2].card),
                            if (showFourthCard)
                              HelperWidgets().visibleCardAfterEachRound(
                                  context: context, card: cardsList[3].card),
                            if (showFifthCard)
                              HelperWidgets().visibleCardAfterEachRound(
                                  context: context, card: cardsList[4].card),
                          ],
                        ),
                      ]),
                      SizedBox(
                        width: widthWithScreenRatio(context, 0.1),
                        height: heightWithScreenRatio(context, 0.4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (hasUserCalled('firstPlayer') &&
                                  userBetState('firstPlayer') == BetState.call)
                                HelperWidgets()
                                    .callTag(color: Colors.red, title: 'CALL'),
                              if (hasUserCalled('firstPlayer') &&
                                  userBetState('firstPlayer') == BetState.raise)
                                HelperWidgets()
                                    .callTag(color: Colors.red, title: 'RAISE'),
                              if (hasUserCalled('firstPlayer') &&
                                  userBetState('firstPlayer') == BetState.fold)
                                HelperWidgets()
                                    .callTag(color: Colors.red, title: 'FOLD'),
                              if (hasUserCalled('firstPlayer') &&
                                  userBetState('firstPlayer') ==
                                      BetState.recheck)
                                HelperWidgets().callTag(
                                    color: Colors.red, title: 'RECHECK'),
                              Spacing().verticalSpaceWithRatio(context, 0.02),
                              if (hasUserCalled('firstPlayer') &&
                                  userBetState('firstPlayer') !=
                                      BetState.fold &&
                                  userBetState('firstPlayer') !=
                                      BetState.recheck)
                                HelperWidgets().callLabel(
                                    context: context,
                                    color: callLabelColor,
                                    title: getUserCallPrice('firstPlayer')),
                            ]),
                      )
                    ]),
              ],
            );
          }
        }()),
      ),
      Container(
        child: !isFirstPlayerFold
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PlayerIdentity(
                      context: context, width: 0.09, title: 'bot3', bits: 0),
                  Spacing().verticalSpaceWithRatio(context, 0.01),
                  HorizontalBotsWithCards(
                    rightForFirstCard: !showTwoPlayerCards ? 0.042 : 0.028,
                    topForFirstCard: !showTwoPlayerCards ? 0.015 : 0.001,
                    rightForSecondCard: !showTwoPlayerCards ? 0.044 : 0.032,
                    topForSecondCard: !showTwoPlayerCards ? 0.052 : 0.04,
                    angleForFirstCard: !showTwoPlayerCards ? -65 : -80,
                    angleForSecondCard: -100,
                    rightForBot: 0,
                    topForBot: 0.085,
                    showTwoPlayerCards: showTwoPlayerCards,
                    cardsList: cardsList,
                  ),
                  Spacing().verticalSpaceWithRatio(context, 0.01),
                  PlayerIdentity(
                      context: context, width: 0.08, title: '', bits: 1)
                ],
              )
            : Container(
                width: widthWithScreenRatio(context, 0.12),
              ),
      )
    ]);
  }
}
