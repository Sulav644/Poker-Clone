import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../../core/utils.dart';
import '../../bloc/app_logic_cubits.dart';
import '../helper_widgets.dart';
import '../player_identity.dart';
import '../vertical_bots_with_cards.dart';

class FooterSection extends StatelessWidget {
  final bool isUserFold;
  final bool showTwoPlayerCards;
  final List<PlayingCardView> cardsList;
  final bool showUserCallOptions;
  final bool showRaisedPrices;
  final VoidCallback onClickFold;
  final VoidCallback onClickCall;
  final VoidCallback onClickRecheck;
  final Widget raiseOptions;
  const FooterSection(
      {super.key,
      required this.isUserFold,
      required this.showTwoPlayerCards,
      required this.cardsList,
      required this.showUserCallOptions,
      required this.showRaisedPrices,
      required this.onClickFold,
      required this.onClickCall,
      required this.onClickRecheck,
      required this.raiseOptions});

  @override
  Widget build(BuildContext context) {
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
    return SizedBox(
      height: heightWithScreenRatio(context, 0.2),
      child: Stack(
        children: [
          if (!isUserFold)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: widthWithScreenRatio(context, 0.2),
                    height: widthWithScreenRatio(context, 0.11),
                    alignment: Alignment.bottomCenter,
                    child: PlayerIdentity(
                        context: context, width: 0.2, title: 'user', bits: 0)),
              ],
            ),
          if (!isUserFold)
            Positioned(
              left: widthWithScreenRatio(context, 0.43),
              bottom: heightWithScreenRatio(context, 0.01),
              child: VerticalBotsWithCards(
                leftForFirstCard: 0.05,
                bottomForFirstCard: 0.006,
                angleForFirstCard: -10,
                leftForSecondCard: 0.098,
                bottomForSecondCard: 0.006,
                angleForSecondCard: 20,
                leftForBot: 0.09,
                bottomForBot: 0,
                showTwoPlayerCards: showTwoPlayerCards,
                cardsList: cardsList,
              ),
            ),
          if (showUserCallOptions)
            SizedBox(
              width: widthWithScreenRatio(context, 1),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => onClickFold(),
                    child: HelperWidgets().callOptions(
                        context: context, color: Colors.red, title: 'FOLD'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => onClickCall(),
                      child: HelperWidgets().callOptions(
                          context: context, color: Colors.blue, title: 'CALL')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        context
                            .read<ShowUserCallOptionsCubit>()
                            .toggleState(false);
                        context.read<ShowRaisedPricesCubit>().toggleState(true);
                      },
                      child: HelperWidgets().callOptions(
                          context: context,
                          color: Colors.green,
                          title: 'RAISE')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => onClickRecheck(),
                      child: HelperWidgets().callOptions(
                          context: context,
                          color: Colors.green,
                          title: 'RECHECK')),
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
                    HelperWidgets().callTag(color: Colors.red, title: 'CALL'),
                  if (hasUserCalled('user') &&
                      userBetState('user') == BetState.raise)
                    HelperWidgets().callTag(color: Colors.red, title: 'RAISE'),
                  if (hasUserCalled('user') &&
                      userBetState('user') == BetState.fold)
                    HelperWidgets().callTag(color: Colors.red, title: 'FOLD'),
                  if (hasUserCalled('user') &&
                      userBetState('user') == BetState.recheck)
                    HelperWidgets()
                        .callTag(color: Colors.red, title: 'RECHECK'),
                  Spacing().verticalSpaceWithRatio(context, 0.02),
                  if (hasUserCalled('user') &&
                      userBetState('user') != BetState.fold &&
                      userBetState('user') != BetState.recheck)
                    HelperWidgets().callLabel(
                        context: context,
                        color: callLabelColor,
                        title: getUserCallPrice('user')),
                ]),
              ),
            ],
          ),
          if (showRaisedPrices)
            SizedBox(
              width: widthWithScreenRatio(context, 1),
              child: raiseOptions,
            )
        ],
      ),
    );
  }
}
