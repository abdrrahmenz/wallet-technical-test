// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      language: json['language'] == null
          ? null
          : Language.fromJson(json['language'] as Map<String, dynamic>),
      theme: $enumDecodeNullable(_$AppThemeEnumMap, json['theme'],
              unknownValue: AppTheme.light) ??
          AppTheme.light,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      if (instance.language case final value?) 'language': value,
      if (_$AppThemeEnumMap[instance.theme] case final value?) 'theme': value,
    };

const _$AppThemeEnumMap = {
  AppTheme.light: 'light',
  AppTheme.dark: 'dark',
};
