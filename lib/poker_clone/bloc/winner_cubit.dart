import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:poker_clone/poker_clone/bloc/components/card_values.dart';

enum Winner { firstPlayer, secondPlayer, thirdPlayer, fourthPlayer, none }

enum WinnerRanks {
  royalFlush,
  straightFlush,
  fourOfAKind,
  fullHouse,
  flush,
  straight,
  threeOfAKind,
  twoPairs,
  onePair,
  highCard,
}

final winnerRanks = [
  WinnerRanks.royalFlush,
  WinnerRanks.straightFlush,
  WinnerRanks.fourOfAKind,
  WinnerRanks.fullHouse,
  WinnerRanks.flush,
  WinnerRanks.straight,
  WinnerRanks.threeOfAKind,
  WinnerRanks.twoPairs,
  WinnerRanks.onePair,
  WinnerRanks.highCard,
];

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

class CardTypeCountWithIndex {
  bool hasCard;
  int index;
  CardTypeCountWithIndex({required this.hasCard, required this.index});
}

class SuitCountWithIndex {
  int count;
  List<int> index;
  SuitCountWithIndex({required this.count, required this.index});
}

final royalFlushList = [
  CardValue.ace,
  CardValue.king,
  CardValue.queen,
  CardValue.jack,
  CardValue.ten
];

class WinnerTypeAndIndex {
  WinnerRanks winnerType;
  Winner winnerIndex;
  WinnerTypeAndIndex({required this.winnerType, required this.winnerIndex});
}

class WinnerCubit extends Cubit<List<PlayingCardView>> {
  WinnerCubit() : super([]);
  WinnerTypeAndIndex selectWinner(List<PlayingCardView> totalCardsList,
      bool isBotOneFold, bool isUserFold) {
    List<PlayingCardView> fiveMainCards = [];

    List<CardHandsAndValues> cardsHandsAndValuesList = [];
    List<PlayingCardView> highCards = [
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.ace)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.nine)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.two)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.three)),
      PlayingCardView(card: PlayingCard(Suit.diamonds, CardValue.jack)),
      PlayingCardView(card: PlayingCard(Suit.spades, CardValue.five)),
      PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.king)),
    ];
    List<PlayingCardView> firstPlayerCards = [];
    List<PlayingCardView> secondPlayerCards = [];

    List<PlayingCardView> thirdPlayerCards = [];

    List<PlayingCardView> fourthPlayerCards = [];

    for (var i = 0; i < 5; i++) {
      fiveMainCards.add(totalCardsList[i]);
    }
    print('fiveCards ${fiveMainCards.length}');

    print('firstPlayerCard ${firstPlayerCards.length}');
    print('secondPlayerCard ${secondPlayerCards.length}');
    print('thirdPlayerCard ${thirdPlayerCards.length}');
    print('fourthPlayerCard ${fourthPlayerCards.length}');
    firstPlayerCards = addCardsInList(firstPlayerCards, totalCardsList, 11, 12);
    secondPlayerCards = addCardsInList(secondPlayerCards, totalCardsList, 5, 6);
    thirdPlayerCards = addCardsInList(thirdPlayerCards, totalCardsList, 9, 10);
    fourthPlayerCards = addCardsInList(fourthPlayerCards, totalCardsList, 7, 8);
    cardsHandsAndValuesList.add(
        checkTheHandRanksOfCard(!isBotOneFold ? firstPlayerCards : highCards));

    cardsHandsAndValuesList.add(
        checkTheHandRanksOfCard(!isUserFold ? secondPlayerCards : highCards));

    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(thirdPlayerCards));
    cardsHandsAndValuesList.add(checkTheHandRanksOfCard(fourthPlayerCards));
    print('isBotOneFold $isBotOneFold');
    print('isUserFold $isUserFold');

    print('length ${cardsHandsAndValuesList.length}');

    for (var element in cardsHandsAndValuesList) {
      for (var newElement in element.cardAndCount) {
        print(
            'cardRank ${element.winnerRanks} ${cardsHandsAndValuesList.indexOf(element)}');
        print('handRank ${element.handRank}');
        print('cardHands ${newElement.cardValue}');
        print('cardCounts ${newElement.count}');

        print('cardRanks ${newElement.rank}');
      }
    }
    for (var element in cardsHandsAndValuesList) {
      print('handRanks ${element.handRank}');
    }

    WinnerTypeAndIndex winner = winnerTypeAndIndex(cardsHandsAndValuesList);
    print('winnerType ${winner.winnerType} ${winner.winnerIndex}');
    return winner;
  }

  WinnerTypeAndIndex winnerTypeAndIndex(
      List<CardHandsAndValues> cardsHandsAndValuesList) {
    WinnerTypeAndIndex winnerTypeAndIndex = WinnerTypeAndIndex(
        winnerType: WinnerRanks.flush, winnerIndex: Winner.firstPlayer);
    int initialWinnerRank = 10;

    for (var element in cardsHandsAndValuesList) {
      if (initialWinnerRank > winnerRanks.indexOf(element.winnerRanks)) {
        initialWinnerRank = winnerRanks.indexOf(element.winnerRanks);
      }
    }

    print('winnerRankCount $initialWinnerRank');
    int winnerGroupIndex = 0;
    for (var element in cardsHandsAndValuesList) {
      if (element.handRank == initialWinnerRank) {
        winnerGroupIndex = cardsHandsAndValuesList.indexOf(element);
      }
    }
    print('winnerGroupIndex $winnerGroupIndex');
    winnerTypeAndIndex = WinnerTypeAndIndex(
        winnerType: winnerRanks[initialWinnerRank],
        winnerIndex: Winner.values[winnerGroupIndex]);

    return winnerTypeAndIndex;
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
    List<SuitCountWithIndex> counts = checkForSameSuit(playerCard);
    if (counts[0].count > 4 ||
        counts[1].count > 4 ||
        counts[2].count > 4 ||
        counts[3].count > 4) {
      print(
          'countIndex ${counts[0].count} ${counts[1].count} ${counts[2].count} ${counts[3].count}');
      print(
          'countIndex ${counts[0].index} ${counts[1].index} ${counts[2].index} ${counts[3].index}');
      List<CardTypeCountWithIndex> hasCardOfTypes =
          checkForRoyalFlush(playerCard);
      print(
          'cardIndex ${hasCardOfTypes[0].hasCard} ${hasCardOfTypes[1].hasCard} ${hasCardOfTypes[2].hasCard} ${hasCardOfTypes[3].hasCard} ${hasCardOfTypes[4].hasCard}');
      print(
          'cardIndex ${hasCardOfTypes[0].index} ${hasCardOfTypes[1].index} ${hasCardOfTypes[2].index} ${hasCardOfTypes[3].index} ${hasCardOfTypes[4].index}');
      List<int> sequencesOfCard = checkForStraightFlush(playerCard);
      int checkIfIndexMatches(
          {required int hasCardOfTypeIndex, required int suitGroupIndex}) {
        int isMatch = 0;
        for (var element in counts[suitGroupIndex].index) {
          if (hasCardOfTypes[hasCardOfTypeIndex].index == element) {
            isMatch++;
            print('index $element');
          }
        }

        print('isMatch $isMatch');
        return isMatch;
      }

      int suitGroupIndex = 0;
      if (counts[0].count > 4) {
        suitGroupIndex = 0;
      } else if (counts[1].count > 4) {
        suitGroupIndex = 1;
      } else if (counts[2].count > 4) {
        suitGroupIndex = 2;
      } else if (counts[3].count > 4) {
        suitGroupIndex = 3;
      }

      print(
          'checkMatches ${checkIfIndexMatches(hasCardOfTypeIndex: 4, suitGroupIndex: suitGroupIndex)}');
      if ((hasCardOfTypes[0].hasCard &&
              checkIfIndexMatches(
                      hasCardOfTypeIndex: 0, suitGroupIndex: suitGroupIndex) ==
                  1) &&
          (hasCardOfTypes[1].hasCard &&
              checkIfIndexMatches(
                      hasCardOfTypeIndex: 1, suitGroupIndex: suitGroupIndex) ==
                  1) &&
          (hasCardOfTypes[2].hasCard &&
              checkIfIndexMatches(
                      hasCardOfTypeIndex: 2, suitGroupIndex: suitGroupIndex) ==
                  1) &&
          (hasCardOfTypes[3].hasCard &&
              checkIfIndexMatches(
                      hasCardOfTypeIndex: 3, suitGroupIndex: suitGroupIndex) ==
                  1) &&
          (hasCardOfTypes[4].hasCard &&
              checkIfIndexMatches(
                      hasCardOfTypeIndex: 4, suitGroupIndex: suitGroupIndex) ==
                  1)) {
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
                count: 1,
                rank: cardRanks.indexOf(cardValuesThreeToSeven[index])),
          ),
        );
      } else {
        cardsHandsAndValues = CardHandsAndValues(
          winnerRanks: WinnerRanks.highCard,
          handRank: 9,
          cardAndCount: List.generate(
            playerCard.length,
            (index) => CardAndCount(
                cardValue: playerCard[index].card.value,
                count: 1,
                rank: cardRanks.indexOf(playerCard[index].card.value)),
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

  List<CardTypeCountWithIndex> checkForRoyalFlush(
      List<PlayingCardView> playerCard) {
    CardTypeCountWithIndex hasAceCard =
        cardTypeCount(playerCard, CardValue.ace);
    CardTypeCountWithIndex hasKingCard =
        cardTypeCount(playerCard, CardValue.king);
    CardTypeCountWithIndex hasQueenCard =
        cardTypeCount(playerCard, CardValue.queen);
    CardTypeCountWithIndex hasJackCard =
        cardTypeCount(playerCard, CardValue.jack);
    CardTypeCountWithIndex hasTenCard =
        cardTypeCount(playerCard, CardValue.ten);
    return [hasAceCard, hasKingCard, hasQueenCard, hasJackCard, hasTenCard];
  }

  List<SuitCountWithIndex> checkForSameSuit(List<PlayingCardView> playerCards) {
    SuitCountWithIndex count = suitCount(playerCards, Suit.clubs);
    SuitCountWithIndex countTwo = suitCount(playerCards, Suit.diamonds);
    SuitCountWithIndex countThree = suitCount(playerCards, Suit.hearts);
    SuitCountWithIndex countFour = suitCount(playerCards, Suit.spades);
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

  SuitCountWithIndex suitCount(List<PlayingCardView> playerCards, Suit suit) {
    SuitCountWithIndex suitCountWithIndex =
        SuitCountWithIndex(count: 0, index: []);
    int suitCount = 0;
    List<int> index = [];
    for (var element in playerCards) {
      if (element.card.suit == suit) {
        suitCount++;
        index.add(playerCards.indexOf(element));
      }
    }
    suitCountWithIndex = SuitCountWithIndex(count: suitCount, index: index);
    return suitCountWithIndex;
  }

  CardTypeCountWithIndex cardTypeCount(
      List<PlayingCardView> playerCards, CardValue value) {
    CardTypeCountWithIndex cardTypeCountWithIndex =
        CardTypeCountWithIndex(hasCard: false, index: 0);
    for (var element in playerCards) {
      if (element.card.value == value) {
        cardTypeCountWithIndex = CardTypeCountWithIndex(
            hasCard: true, index: playerCards.indexOf(element));
      }
    }
    return cardTypeCountWithIndex;
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
