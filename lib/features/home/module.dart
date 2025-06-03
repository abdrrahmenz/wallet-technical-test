import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import 'home.dart';

class HomeModule implements BaseModule {
  @override
  Future inject(GetIt getIt) async {
    // Data

    // Domain

    // Presentation
     getIt.registerLazySingleton(() => BottomNavBloc());
    
  }

  @override
  Map<String, Route> routes(RouteSettings settings) {
    return {
      MainPage.routeName: MaterialPageRoute(
        builder: (_) => const MainPage(),
        settings: settings,
      ),
    };
  }
}
