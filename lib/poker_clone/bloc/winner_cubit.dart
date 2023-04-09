import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/poker_clone/bloc/components/card_values.dart';

enum Winner { firstPlayer, secondPlayer, thirdPlayer, fourthPlayer, none }

class WinnerCubit extends Cubit<List<PlayingCardView>> {
  WinnerCubit() : super([]);
  void selectWinner(List<PlayingCardView> totalCardsList) {
    List<PlayingCardView> fiveMainCards = [];
    List<PlayingCardView> firstPlayerCards = [];
    List<PlayingCardView> secondPlayerCards = [];
    List<PlayingCardView> thirdPlayerCards = [];
    List<PlayingCardView> fourthPlayerCards = [];

    for (var i = 0; i < 5; i++) {
      fiveMainCards.add(totalCardsList[i]);
    }

    firstPlayerCards = addCardsInList(firstPlayerCards, totalCardsList, 5, 6);
    secondPlayerCards = addCardsInList(secondPlayerCards, totalCardsList, 7, 8);
    thirdPlayerCards = addCardsInList(thirdPlayerCards, totalCardsList, 9, 10);
    fourthPlayerCards =
        addCardsInList(fourthPlayerCards, totalCardsList, 11, 12);
    List<int> list = checkRepeated(firstPlayerCards);
    List<int> listTwo = checkRepeated(secondPlayerCards);
    List<int> listThree = checkRepeated(thirdPlayerCards);
    List<int> listFour = checkRepeated(fourthPlayerCards);
    print('firstPlayer $list');
    print('secondPlayer $listTwo');
    print('thirdPlayer $listThree');
    print('fourthPlayer $listFour');
    int count = suitCount(firstPlayerCards, Suit.clubs);
    int countTwo = suitCount(firstPlayerCards, Suit.diamonds);
    int countThree = suitCount(firstPlayerCards, Suit.hearts);
    int countFour = suitCount(firstPlayerCards, Suit.spades);
    bool hasCard = cardTypeCount(firstPlayerCards, CardValue.ace);
    bool hasCardTwo = cardTypeCount(firstPlayerCards, CardValue.king);
    bool hasCardThree = cardTypeCount(firstPlayerCards, CardValue.queen);
    bool hasCardFour = cardTypeCount(firstPlayerCards, CardValue.jack);
    bool hasCardFive = cardTypeCount(firstPlayerCards, CardValue.ten);
    int sequenceOne = sequenceOrderCount(firstPlayerCards, cardValuesOne);
    int sequenceTwo = sequenceOrderCount(firstPlayerCards, cardValuesTwo);
    int sequenceThree = sequenceOrderCount(firstPlayerCards, cardValuesThree);
    int sequenceFour = sequenceOrderCount(firstPlayerCards, cardValuesFour);
    int sequenceFive = sequenceOrderCount(firstPlayerCards, cardValuesFive);
    int sequenceSix = sequenceOrderCount(firstPlayerCards, cardValuesSix);
    int sequenceSeven = sequenceOrderCount(firstPlayerCards, cardValuesSeven);
    int sequenceEight = sequenceOrderCount(firstPlayerCards, cardValuesEight);
    int sequenceNine = sequenceOrderCount(firstPlayerCards, cardValuesNine);
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

    for (var i = 0; i < 5; i++) {
      if (playerCards[i].card.value == cardList[i]) {
        sequenceCount++;
      }
    }
    return sequenceCount;
  }

  List<int> checkRepeated(List<PlayingCardView> cardsList) {
    print('check repeated');
    List<int> repeatList = [];
    int cardCount = 0;
    emit([...cardsList]);
    for (var element in state) {
      cardCount = 0;
      PlayingCardView card = element;
      for (var i = 0; i < state.length; i++) {
        if (card.card.value == state[i].card.value) {
          cardCount++;
        }
      }

      List<PlayingCardView> filteredList = [];
      for (var newElement in state) {
        if (newElement.card.value != element.card.value) {
          filteredList.add(newElement);
        }
      }
      print(cardCount);
      print('${element.card.suit} ${element.card.value}');
      emit([...filteredList]);
      if (cardCount > 1) {
        repeatList.add(cardCount);
      }
    }
    return repeatList;
  }
}
