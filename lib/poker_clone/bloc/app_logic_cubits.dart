import 'package:flutter_bloc/flutter_bloc.dart';

class CardVisibilityCubit extends Cubit<List<bool>> {
  CardVisibilityCubit() : super([false, false, false, false]);
  void toggleVisibility(List<bool> status) => emit(status);
  void resetVisibility() => emit([false, false, false, false]);
}

class StartGameCubit extends Cubit<bool> {
  StartGameCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class WinGameCubit extends Cubit<bool> {
  WinGameCubit() : super(false);
  void toggleState(bool status) {
    Future.delayed(Duration(seconds: 1), () {
      emit(status);
    });
  }
}

enum BetState { fold, call, raise, recheck }

class UserCall {
  String user;
  BetState bet;
  int price;
  List<int> cardIndex;
  UserCall(
      {required this.user,
      required this.bet,
      required this.price,
      required this.cardIndex});
}

class SetUserBetCubit extends Cubit<BetState> {
  SetUserBetCubit() : super(BetState.call);
  void toggleState(BetState betState) => emit(betState);
}

class UserCallListCubit extends Cubit<List<UserCall>> {
  UserCallListCubit() : super([]);
  void setUserCall(UserCall userCall) => emit([...state, userCall]);
  void resetState() => emit([]);
}

class ShowUserCallOptionsCubit extends Cubit<bool> {
  ShowUserCallOptionsCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class ShowRaisedPricesCubit extends Cubit<bool> {
  ShowRaisedPricesCubit() : super(false);
  void toggleState(bool status) => emit(status);
}

class FirstPlayerRecheckStatusCubit extends Cubit<bool> {
  FirstPlayerRecheckStatusCubit() : super(false);
  void toggleState() => emit(true);
  void resetState() => emit(false);
}

class TotalBidPriceCubit extends Cubit<int> {
  TotalBidPriceCubit() : super(0);
  void addBid(int price) {
    emit(state + price);
  }
}

enum Rounds { nextLevel, showThreeCards, firstPlayer, none }

class TurnRoundCubit extends Cubit<Rounds> {
  TurnRoundCubit() : super(Rounds.none);
  void movieRound() {
    Future.delayed(Duration(seconds: 1), () => emit(Rounds.nextLevel))
        .then((value) => Future.delayed(
            Duration(seconds: 1), () => emit(Rounds.showThreeCards)))
        .then((value) => Future.delayed(
            Duration(seconds: 1), () => emit(Rounds.firstPlayer)))
        .then((value) =>
            Future.delayed(Duration(seconds: 1), () => emit(Rounds.none)));

    emit(Rounds.none);
  }
}

class RoundCountCubit extends Cubit<int> {
  RoundCountCubit() : super(0);
  void addRound() => emit(state + 1);
}
