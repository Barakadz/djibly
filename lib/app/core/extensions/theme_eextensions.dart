import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ThemeExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}

extension TranslateExtensions on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this);
}
