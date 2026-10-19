import '../base_import.dart';

/// App-wide standard form validators utilizing localized error strings.
///
/// Features:
/// - Guarantees consistent validation rules across all auth, profile, and spot forms.
/// - Returns localized error messages matching the active user locale (EN, HI, GU).
/// - No hardcoded error strings in widget files.
class AppValidators {
  AppValidators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  /// Validates email address format
  static FormFieldValidator<String> email(AppLocalizations loc) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return loc.emailRequired;
      }
      if (!_emailRegExp.hasMatch(text)) {
        return loc.invalidEmail;
      }
      return null;
    };
  }

  /// Validates password presence and minimum length (6 characters)
  static FormFieldValidator<String> password(AppLocalizations loc) {
    return (value) {
      if (value == null || value.isEmpty) {
        return loc.passwordRequired;
      }
      if (value.length < 6) {
        return loc.passwordLengthError;
      }
      return null;
    };
  }

  /// Validates password confirmation matches the primary password
  static FormFieldValidator<String> confirmPassword(
    AppLocalizations loc,
    String Function() getOriginalPassword,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return loc.passwordRequired;
      }
      if (value != getOriginalPassword()) {
        return loc.passwordsDoNotMatch;
      }
      return null;
    };
  }

  /// Validates full name presence
  static FormFieldValidator<String> fullName(AppLocalizations loc) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return loc.fullNameRequired;
      }
      return null;
    };
  }

  /// Validates generic required string field
  static FormFieldValidator<String> required(String errorMessage) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return errorMessage;
      }
      return null;
    };
  }

  /// Validates city selection
  static FormFieldValidator<String> city(AppLocalizations loc) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return loc.cityRequiredError;
      }
      return null;
    };
  }

  /// Validates numeric spot capacity (must be integer >= 1)
  static FormFieldValidator<String> spots(String errorMessage) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return errorMessage;
      }
      final parsed = int.tryParse(text);
      if (parsed == null || parsed <= 0) {
        return errorMessage;
      }
      return null;
    };
  }

  /// Validates numeric price (must be double >= 0)
  static FormFieldValidator<String> price(String errorMessage) {
    return (value) {
      final text = value?.trim();
      if (text == null || text.isEmpty) {
        return null; // Price may be optional (Free)
      }
      final parsed = double.tryParse(text);
      if (parsed == null || parsed < 0) {
        return errorMessage;
      }
      return null;
    };
  }
}
