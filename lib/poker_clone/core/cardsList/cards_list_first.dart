import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

final cardListFirst = [
  for (var i = 0; i < 13; i++)
    {PlayingCardView(card: PlayingCard(Suit.clubs, CardValue.values[i]))}
];
