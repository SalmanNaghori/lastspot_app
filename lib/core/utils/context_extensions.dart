import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Quick access to AppLocalizations
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
