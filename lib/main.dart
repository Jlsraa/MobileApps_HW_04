import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/user_page/bloc/apibloc_bloc.dart';
import 'package:money_track/user_page/bloc/picture_bloc.dart';

import 'user_page/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<PictureBloc>(
              create: (context) => PictureBloc(),
            ),
            BlocProvider<ApiblocBloc>(
              create: (context) => ApiblocBloc(),
            )
          ],
          child: Profile(),
        ),
      ),
    );
  }
}
