import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/poker_clone/bloc/components/card_values.dart';

enum Winner { firstPlayer, secondPlayer, thirdPlayer, fourthPlayer, none }

enum WinnerRanks {
  royalFlush,
  straightFlush,

  flush,
  straight,
  fullHouse,
  fourOfAKind,
  twoPairs,
  onePair,
  threePairs,
  threeOfAKind
}

final cardRanks = [
  CardValue.two,
  CardValue.ace,
  CardValue.king,
  CardValue.queen,
  CardValue.jack,
  CardValue.ten,
  CardValue.nine,
  CardValue.eight,
  CardValue.seven,
  CardValue.six,
  CardValue.five,
  CardValue.four,
  CardValue.three
];

class CardHandsAndValues {
  WinnerRanks winnerRanks;
  int handRank;
  List<CardAndCount> cardAndCount;

  CardHandsAndValues({
    required this.winnerRanks,
    required this.handRank,
    required this.cardAndCount,
  });
}

class CardAndCount {
  CardValue cardValue;
  int count;

  int rank;
  CardAndCount(
      {required this.cardValue, required this.count, required this.rank});
}

final royalFlushList = [
  CardValue.ace,
  CardValue.king,
  CardValue.queen,
  CardValue.jack,
  CardValue.ten
];

class WinnerCubit extends Cubit<List<PlayingCardView>> {
  WinnerCubit() : super([]);
  void selectWinner(List<PlayingCardView> totalCardsList) {
    List<PlayingCardView> fiveMainCards = [];

    List<CardHandsAndValues> cardsHandsAndValuesList = [];
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
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> fifthPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> sixthPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.king)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> seventhPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> eightPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.nine)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> ninePlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.three)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.four)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.five)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.seven)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.seven)),
    ];
    List<PlayingCardView> tenPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.jack)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.nine)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ten)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> elevenPlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.five)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.four)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.eight)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.seven)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> twelvePlayerCards = [
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.hearts, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.six)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.eight)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.seven)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.three)),
    ];
    List<PlayingCardView> fourthPlayerCards = [];

    for (var i = 0; i < 5; i++) {
      fiveMainCards.add(totalCardsList[i]);
    }

    fourthPlayerCards =
        addCardsInList(fourthPlayerCards, totalCardsList, 11, 12);

    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(ninePlayerCards));
    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(tenPlayerCards));
    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(elevenPlayerCards));
    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(twelvePlayerCards));
    print('length ${cardsHandsAndValuesList.length}');

    for (var element in cardsHandsAndValuesList) {
      for (var newElement in element.cardAndCount) {
        print('cardRank ${element.winnerRanks}');
        print('handRank ${element.handRank}');
        print('cardHands ${newElement.cardValue}');
        print('cardCounts ${newElement.count}');

        print('cardRanks ${newElement.rank}');
      }
    }
    for (var element in cardsHandsAndValuesList) {
      print('handRanks ${element.handRank}');
    }
    int initialValue = 10;
    for (var element in cardsHandsAndValuesList) {
      for (var newElement in cardsHandsAndValuesList) {
        if (initialValue > newElement.handRank) {
          initialValue = newElement.handRank;
        }
      }
    }
    print('handRankFinal $initialValue');

    for (var element in cardsHandsAndValuesList) {
      if (element.handRank == initialValue) {
        print('rank ${element.winnerRanks}');
      }
    }
  }

  CardHandsAndValues checkTheHandRanksOfCard(List<PlayingCardView> playerCard) {
    CardHandsAndValues cardsHandsAndValues = CardHandsAndValues(
        winnerRanks: WinnerRanks.royalFlush,
        handRank: 0,
        cardAndCount: List.generate(
            royalFlushList.length,
            (index) => CardAndCount(
                cardValue: royalFlushList[index],
                count: 1,
                rank: cardRanks.indexOf(royalFlushList[index]))));
    List<int> counts = checkForSameSuit(playerCard);
    if (counts[0] > 4 || counts[1] > 4 || counts[2] > 4 || counts[3] > 4) {
      List<bool> hasCardOfTypes = checkForRoyalFlush(playerCard);
      List<int> sequencesOfCard = checkForStraightFlush(playerCard);

      if (hasCardOfTypes[0] &&
          hasCardOfTypes[1] &&
          hasCardOfTypes[2] &&
          hasCardOfTypes[3] &&
          hasCardOfTypes[4]) {
        print('royal flush');
        cardsHandsAndValues = CardHandsAndValues(
            winnerRanks: WinnerRanks.royalFlush,
            handRank: 0,
            cardAndCount: List.generate(
                royalFlushList.length,
                (index) => CardAndCount(
                    cardValue: royalFlushList[index],
                    count: 1,
                    rank: cardRanks.indexOf(royalFlushList[index]))));
      } else if (sequencesOfCard[0] == 5 ||
          sequencesOfCard[1] == 5 ||
          sequencesOfCard[2] == 5 ||
          sequencesOfCard[3] == 5 ||
          sequencesOfCard[4] == 5 ||
          sequencesOfCard[5] == 5 ||
          sequencesOfCard[6] == 5) {
        print('straight flush');
        cardsHandsAndValues = CardHandsAndValues(
            winnerRanks: WinnerRanks.straightFlush,
            handRank: 1,
            cardAndCount: List.generate(
                cardValuesThreeToSeven.length,
                (index) => CardAndCount(
                    cardValue: cardValuesThreeToSeven[index],
                    count: 1,
                    rank: cardRanks.indexOf(cardValuesThreeToSeven[index]))));
      } else {
        cardsHandsAndValues = CardHandsAndValues(
            winnerRanks: WinnerRanks.flush,
            handRank: 4,
            cardAndCount: List.generate(
                playerCard.length,
                (index) => CardAndCount(
                    cardValue: playerCard[index].card.value,
                    count: 1,
                    rank: cardRanks.indexOf(playerCard[index].card.value))));
      }
      print('flush');
      return cardsHandsAndValues;
    } else {
      List<CardAndCount> fullHouse = checkRepeatCards(playerCard, 3, 2);
      List<CardAndCount> fourOfAKind = checkRepeatCards(playerCard, 4, 4);
      List<CardAndCount> twoPairs = checkRepeatCards(playerCard, 2, 2);
      List<CardAndCount> threeOfAKind = checkRepeatCards(playerCard, 3, 3);

      List<int> straight = checkForStraightFlush(playerCard);
      print('fullHouse ${fullHouse.length}');
      print('fourOfAKind ${fourOfAKind.length}');
      if (fullHouse.length == 2 &&
          fullHouse.fold(0,
                  (previousValue, element) => previousValue + element.count) ==
              5) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.fullHouse,
          handRank: 3,
          cardAndCount: List.generate(
            fullHouse.length,
            (index) => CardAndCount(
                cardValue: fullHouse[index].cardValue,
                count: fullHouse[index].count,
                rank: cardRanks.indexOf(fullHouse[index].cardValue)),
          ),
        );
      } else if (fourOfAKind.length == 1) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.fourOfAKind,
          handRank: 2,
          cardAndCount: List.generate(
            fourOfAKind.length,
            (index) => CardAndCount(
                cardValue: fourOfAKind[index].cardValue,
                count: fourOfAKind[index].count,
                rank: cardRanks.indexOf(fourOfAKind[index].cardValue)),
          ),
        );
      } else if (twoPairs.length == 2) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.twoPairs,
          handRank: 7,
          cardAndCount: List.generate(
            twoPairs.length,
            (index) => CardAndCount(
                cardValue: twoPairs[index].cardValue,
                count: twoPairs[index].count,
                rank: cardRanks.indexOf(twoPairs[index].cardValue)),
          ),
        );
      } else if (twoPairs.length == 1) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.onePair,
          handRank: 8,
          cardAndCount: List.generate(
            twoPairs.length,
            (index) => CardAndCount(
                cardValue: twoPairs[index].cardValue,
                count: twoPairs[index].count,
                rank: cardRanks.indexOf(twoPairs[index].cardValue)),
          ),
        );
      } else if (threeOfAKind.length == 1) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.threeOfAKind,
          handRank: 6,
          cardAndCount: List.generate(
            threeOfAKind.length,
            (index) => CardAndCount(
                cardValue: threeOfAKind[index].cardValue,
                count: threeOfAKind[index].count,
                rank: cardRanks.indexOf(threeOfAKind[index].cardValue)),
          ),
        );
      } else if (straight[0] == 5 ||
          straight[1] == 5 ||
          straight[2] == 5 ||
          straight[3] == 5 ||
          straight[4] == 5 ||
          straight[5] == 5 ||
          straight[6] == 5) {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.straight,
          handRank: 5,
          cardAndCount: List.generate(
            cardValuesThreeToSeven.length,
            (index) => CardAndCount(
                cardValue: cardValuesThreeToSeven[index],
                count: cardValuesThreeToSeven.length,
                rank: cardRanks.indexOf(cardValuesThreeToSeven[index])),
          ),
        );
      }

      for (var element in fullHouse) {
        print('list ${element.cardValue} ${element.count}');
      }
      return cardsHandsAndValues;
    }
  }

  List<int> checkForStraightFlush(List<PlayingCardView> playerCard) {
    int sequenceOne = sequenceOrderCount(playerCard, cardValuesThreeToSeven);
    int sequenceTwo = sequenceOrderCount(playerCard, cardValuesFourToEight);
    int sequenceThree = sequenceOrderCount(playerCard, cardValuesFiveToNine);
    int sequenceFour = sequenceOrderCount(playerCard, cardValuesSixToTen);
    int sequenceFive = sequenceOrderCount(playerCard, cardValuesSevenToJack);
    int sequenceSix = sequenceOrderCount(playerCard, cardValuesEightToQueen);
    int sequenceSeven = sequenceOrderCount(playerCard, cardValuesNineToKing);
    return [
      sequenceOne,
      sequenceTwo,
      sequenceThree,
      sequenceFour,
      sequenceFive,
      sequenceSix,
      sequenceSeven
    ];
  }

  List<bool> checkForRoyalFlush(List<PlayingCardView> playerCard) {
    bool hasAceCard = cardTypeCount(playerCard, CardValue.ace);
    bool hasKingCard = cardTypeCount(playerCard, CardValue.king);
    bool hasQueenCard = cardTypeCount(playerCard, CardValue.queen);
    bool hasJackCard = cardTypeCount(playerCard, CardValue.jack);
    bool hasTenCard = cardTypeCount(playerCard, CardValue.ten);
    return [hasAceCard, hasKingCard, hasQueenCard, hasJackCard, hasTenCard];
  }

  List<int> checkForSameSuit(List<PlayingCardView> playerCards) {
    int count = suitCount(playerCards, Suit.clubs);
    int countTwo = suitCount(playerCards, Suit.diamonds);
    int countThree = suitCount(playerCards, Suit.hearts);
    int countFour = suitCount(playerCards, Suit.spades);
    return [count, countTwo, countThree, countFour];
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

  List<CardAndCount> checkRepeatCards(List<PlayingCardView> playingCards,
      int compareWithFirstValue, int compareWithSecondValue) {
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

      if (count == compareWithFirstValue || count == compareWithSecondValue) {
        print('${element.card.suit} ${element.card.value}');
        print('count $count');
        cardAndCount.add(CardAndCount(
            cardValue: element.card.value,
            count: count,
            rank: cardRanks.indexOf(element.card.value)));
      }
    }
    return cardAndCount;
  }
}
