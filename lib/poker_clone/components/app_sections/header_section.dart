import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../../core/utils.dart';
import '../../bloc/app_logic_cubits.dart';
import '../helper_widgets.dart';
import '../player_identity.dart';
import '../score_counter.dart';
import '../settings_widget.dart';
import '../vertical_bots_with_cards.dart';

class HeaderSection extends StatelessWidget {
  final bool showTwoPlayerCards;
  final List<PlayingCardView> cardsList;
  const HeaderSection(
      {super.key, required this.showTwoPlayerCards, required this.cardsList});

  @override
  Widget build(BuildContext context) {
    final callLabelColor = Color.fromARGB(255, 117, 135, 150);
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
    return Row(
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
                    context: context, width: 0.21, title: 'bot2', bits: 2),
                VerticalBotsWithCards(
                  leftForFirstCard: !showTwoPlayerCards ? 0.115 : 0.1,
                  topForFirstCard: !showTwoPlayerCards ? 0.034 : 0.028,
                  angleForFirstCard: -15,
                  leftForSecondCard: !showTwoPlayerCards ? 0.078 : 0.052,
                  topForSecondCard: !showTwoPlayerCards ? 0.03 : 0.028,
                  angleForSecondCard: -170,
                  leftForBot: 0.09,
                  topForBot: 0,
                  showTwoPlayerCards: showTwoPlayerCards,
                  cardsList: cardsList,
                ),
                Column(children: [
                  Spacing().verticalSpaceWithRatio(context, 0.08),
                  if (hasUserCalled('fourthPlayer') &&
                      userBetState('fourthPlayer') == BetState.call)
                    HelperWidgets().callTag(color: Colors.red, title: 'CALL'),
                  if (hasUserCalled('fourthPlayer') &&
                      userBetState('fourthPlayer') == BetState.raise)
                    HelperWidgets().callTag(color: Colors.red, title: 'RAISE'),
                  if (hasUserCalled('fourthPlayer') &&
                      userBetState('fourthPlayer') == BetState.fold)
                    HelperWidgets()
                        .callTag(color: Colors.red, title: 'RECHECK'),
                  if (hasUserCalled('fourthPlayer') &&
                      userBetState('fourthPlayer') == BetState.recheck)
                    HelperWidgets()
                        .callTag(color: Colors.red, title: 'RECHECk'),
                  Spacing().verticalSpaceWithRatio(context, 0.02),
                  if (hasUserCalled('fourthPlayer') &&
                      userBetState('fourthPlayer') != BetState.fold &&
                      userBetState('fourthPlayer') != BetState.recheck)
                    HelperWidgets().callLabel(
                        context: context,
                        color: callLabelColor,
                        title: getUserCallPrice('fourthPlayer')),
                ]),
              ],
            )),
        SettingsWidgets(),
      ],
    );
  }
}
