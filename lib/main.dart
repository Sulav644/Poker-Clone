import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poker_clone/poker_clone/bloc/cards_distribution_cubit.dart';
import 'package:poker_clone/poker_clone/bloc/winner_cubit.dart';
import 'package:poker_clone/poker_clone/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CardVisibilityCubit()),
          BlocProvider(create: (context) => StartGameCubit()),
          BlocProvider(create: (context) => WinGameCubit()),
          BlocProvider(create: (context) => UserCallListCubit()),
          BlocProvider(create: (context) => ShowUserCallOptionsCubit()),
          BlocProvider(create: (context) => ShowRaisedPricesCubit()),
          BlocProvider(create: (context) => SetUserBetCubit()),
          BlocProvider(create: (context) => FirstPlayerRecheckStatusCubit()),
          BlocProvider(create: (context) => TotalBidPriceCubit()),
          BlocProvider(create: (context) => TurnRoundCubit()),
          BlocProvider(create: (context) => CardsDistributionCubit()),
          BlocProvider(create: (context) => RoundCountCubit()),
          BlocProvider(create: (context) => WinnerCubit()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        ));
  }
}
