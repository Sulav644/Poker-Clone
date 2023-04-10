import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/poker_clone/bloc/components/card_values.dart';

enum Winner { firstPlayer, secondPlayer, thirdPlayer, fourthPlayer, none }

class CardAndCount {
  CardValue cardValue;
  int count;
  CardAndCount({required this.cardValue, required this.count});
}

class WinnerCubit extends Cubit<List<PlayingCardView>> {
  WinnerCubit() : super([]);
  void selectWinner(List<PlayingCardView> totalCardsList) {
    List<PlayingCardView> fiveMainCards = [];
    List<PlayingCardView> firstPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.queen)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.jack)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> secondPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.seven)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.eight)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.nine)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> thirdPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> fourthPlayerCards = [];

    for (var i = 0; i < 5; i++) {
      fiveMainCards.add(totalCardsList[i]);
    }

    fourthPlayerCards =
        addCardsInList(fourthPlayerCards, totalCardsList, 11, 12);

    int count = suitCount(thirdPlayerCards, Suit.clubs);
    int countTwo = suitCount(thirdPlayerCards, Suit.diamonds);
    int countThree = suitCount(thirdPlayerCards, Suit.hearts);
    int countFour = suitCount(thirdPlayerCards, Suit.spades);
    if (count == 5 || countTwo == 5 || countThree == 5 || countFour == 5) {
      bool hasCard = cardTypeCount(firstPlayerCards, CardValue.ace);
      bool hasCardTwo = cardTypeCount(firstPlayerCards, CardValue.king);
      bool hasCardThree = cardTypeCount(firstPlayerCards, CardValue.queen);
      bool hasCardFour = cardTypeCount(firstPlayerCards, CardValue.jack);
      bool hasCardFive = cardTypeCount(firstPlayerCards, CardValue.ten);
      int sequenceOne = sequenceOrderCount(secondPlayerCards, cardValuesOne);
      int sequenceTwo = sequenceOrderCount(secondPlayerCards, cardValuesTwo);
      int sequenceThree =
          sequenceOrderCount(secondPlayerCards, cardValuesThree);
      int sequenceFour = sequenceOrderCount(secondPlayerCards, cardValuesFour);
      int sequenceFive = sequenceOrderCount(secondPlayerCards, cardValuesFive);
      int sequenceSix = sequenceOrderCount(secondPlayerCards, cardValuesSix);
      int sequenceSeven =
          sequenceOrderCount(secondPlayerCards, cardValuesSeven);
      if (hasCard && hasCardTwo && hasCardThree && hasCardFour && hasCardFive) {
        print('royal flush');
      }
      if (sequenceOne == 5 ||
          sequenceTwo == 5 ||
          sequenceThree == 5 ||
          sequenceFour == 5 ||
          sequenceFive == 5 ||
          sequenceSix == 5 ||
          sequenceSeven == 5) {
        print('straight flush');
      }
      print('flush');
    } else {
      List<CardAndCount> list = checkRepeatCards(thirdPlayerCards);
      for (var element in list) {
        print('list ${element.cardValue} ${element.count}');
      }
    }
  }

  List<PlayingCardView> addCardsInList(List<PlayingCardView> playercardsList,
      List<PlayingCardView> totalCardsList, int start, int end) {
    for (var i = start; i < end + 1; i++) {
      playercardsList.add(totalCardsList[i]);
    }
    for (var i = 0; i < 5; i++) {
      playercardsList.add(totalCardsList[i]);
    }

    return playercardsList;
  }

  int suitCount(List<PlayingCardView> playerCards, Suit suit) {
    int suitCount = 0;
    for (var element in playerCards) {
      if (element.card.suit == suit) {
        suitCount++;
      }
    }
    return suitCount;
  }

  bool cardTypeCount(List<PlayingCardView> playerCards, CardValue value) {
    bool hasCard = false;

    for (var element in playerCards) {
      if (element.card.value == value) {
        hasCard = true;
      }
    }
    return hasCard;
  }

  int sequenceOrderCount(
      List<PlayingCardView> playerCards, List<CardValue> cardList) {
    int sequenceCount = 0;
    for (var element in cardList) {
      for (var i = 0; i < playerCards.length; i++) {
        if (playerCards[i].card.value == element) {
          sequenceCount++;
        }
      }
    }

    return sequenceCount;
  }

  List<CardAndCount> checkRepeatCards(List<PlayingCardView> playingCards) {
    print('four kind');
    List<CardAndCount> cardAndCount = [];

    List<PlayingCardView> filteredList = [];
    emit(playingCards);

    for (var element in state) {
      int count = 0;
      filteredList.length = 0;

      for (var i = 0; i < state.length; i++) {
        if (element.card.value == state[i].card.value) {
          count++;
        }
      }
      for (var newElement in state) {
        if (element.card.value != newElement.card.value) {
          filteredList.add(newElement);
        }
      }

      emit([...filteredList]);

      if (count > 1) {
        print('${element.card.suit} ${element.card.value}');
        print('count $count');
        cardAndCount
            .add(CardAndCount(cardValue: element.card.value, count: count));
      }
    }
    return cardAndCount;
  }
}
