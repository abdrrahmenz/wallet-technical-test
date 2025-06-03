import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

abstract class SettingsRepository {

  Future<Either<Failure, AppTheme>> getThemeSetting();

  Future<Either<Failure, Language>> getLanguageSetting();

  Future<Either<Failure, bool>> saveThemeSetting(AppTheme theme);

  Future<Either<Failure, bool>> saveLanguageSetting(Language language);


}
