import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';

final cardListFirst = [
  ...List.generate(
      13,
      (index) => PlayingCardView(
          card: PlayingCard(Suit.clubs, CardValue.values[index]))),
  ...List.generate(
      13,
      (index) => PlayingCardView(
          card: PlayingCard(Suit.diamonds, CardValue.values[index]))),
  ...List.generate(
      13,
      (index) => PlayingCardView(
          card: PlayingCard(Suit.hearts, CardValue.values[index]))),
  ...List.generate(
      13,
      (index) => PlayingCardView(
          card: PlayingCard(Suit.spades, CardValue.values[index]))),
];

class CardsDistributionCubit extends Cubit<List<PlayingCardView>> {
  CardsDistributionCubit() : super(cardListFirst);
  PlayingCardView selectCard() {
    final random = new Random();
    PlayingCardView selectedCard;
    List<PlayingCardView> filteredList = [];
    final cardIndex = random.nextInt(state.length);
    selectedCard = state[cardIndex];
    for (var element in state) {
      if (element != selectedCard) {
        filteredList.add(element);
      }
    }
    emit([...filteredList]);
    return selectedCard;
  }
}
