import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import 'settings.dart';

class SettingsModule implements BaseModule {
  @override
  Future inject(GetIt getIt) async {
    // Data
    getIt
      ..registerLazySingleton<SettingsLocalSource>(
        () => SettingsLocalSourceImpl(getIt()),
      )
      ..registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(localSource: getIt()),
      );

    // Domain
    getIt
      ..registerLazySingleton(() => GetLanguageSettingUseCase(getIt()))
      ..registerLazySingleton(() => GetThemeSettingUseCase(getIt()))
      ..registerLazySingleton(() => SaveLanguageSettingUseCase(getIt()))
      ..registerLazySingleton(() => SaveThemeSettingUseCase(getIt()))
      ..registerLazySingleton(GetSupportedLanguageUseCase.new)
      ..registerLazySingleton(RecordErrorUseCase.new);

    // Presentation
    getIt
      ..registerFactory(
        () => LanguageBloc(
          getLanguageSetting: getIt(),
          saveLanguageSetting: getIt(),
          getSupportedLanguage: getIt(),
        ),
      )
      ..registerFactory(
        () => ThemeBloc(
          getThemeSetting: getIt(),
          saveThemeSetting: getIt(),
        ),
      );
  }

  @override
  Map<String, Route> routes(RouteSettings settings) {
    return {};
  }
}
