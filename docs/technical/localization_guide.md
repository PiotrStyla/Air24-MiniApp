# Flight Compensation App - Localization Guide

## Overview

The Flight Compensation app supports multiple languages using Flutter's built-in localization system with `flutter_localizations` and `intl`. Currently, the app supports:

- English (en) - Default
- Polish (pl)
- Portuguese (pt)

## Architecture

### Key Components

1. **ARB Files**: Located in `lib/l10n/` directory:
   - `app_en.arb` - English (default)
   - `app_pl.arb` - Polish
   - `app_pt.arb` - Portuguese

2. **Configuration**: The `l10n.yaml` file in the project root configures the localization generation.

3. **LocalizationService**: A singleton service that manages language preferences and switching between languages.

4. **Integration**: The app uses `AppLocalizations.of(context)` to access localized strings.

## Usage Guidelines

### Accessing Localized Strings

Always use the following pattern to access localized strings:

```dart
final localizations = AppLocalizations.of(context)!;
Text(localizations.someStringKey);
```

### String with Parameters

For strings with parameters, use the generated methods:

```dart
// In ARB file:
// "greeting": "Hello, {name}",
// "@greeting": {
//   "placeholders": {
//     "name": {
//       "type": "String"
//     }
//   }
// }

Text(localizations.greeting('John'));
```

### Context-Specific Localizations

For widgets that need localized strings but don't have direct access to the build context, use a Builder widget:

```dart
Builder(builder: (context) {
  final localizations = AppLocalizations.of(context)!;
  return Text(localizations.someText);
});
```

## Adding New Translations

1. **Identify Text**: Identify all hardcoded text in the UI that needs translation.

2. **Add to English ARB**: Add the string to `app_en.arb` with a descriptive key and comment.

3. **Add to Other ARBs**: Add translations to all other ARB files (`app_pl.arb`, `app_pt.arb`, etc.).

4. **Regenerate**: Run `flutter gen-l10n` to regenerate the localization classes.

5. **Test**: Use the localization tests to verify your translations.

## Adding a New Language

1. **Create ARB File**: Create a new ARB file in the `lib/l10n/` directory (e.g., `app_de.arb` for German).

2. **Copy Structure**: Copy the structure from `app_en.arb` but translate all values.

3. **Update Service**: Add the new locale to the `LocalizationService.supportedLocales` list.

4. **Test**: Add tests for the new language in `localization_test.dart`.

## Best Practices

1. **Use Descriptive Keys**: Choose clear, descriptive keys for translations.

2. **Include Context**: Add descriptive comments to explain the context of each string.

3. **Maintain Consistency**: Use consistent terminology across the app.

4. **Test All Languages**: Regularly test all supported languages to ensure a consistent experience.

5. **Consider Cultural Differences**: Be aware of cultural differences that might affect translations.

6. **Handle Dynamic Text**: Allow for text expansion/contraction in different languages.

## Error Handling

Error messages should be localized too. The app uses specific keys for different error types:

- `networkError`: For network connection issues
- `formSubmissionError`: For form submission errors
- `generalError`: For general error cases
- `loginRequiredForClaim`: When user tries to submit a claim without being logged in

## Testing

Use the provided localization tests in `test/localization_test.dart` to verify your translations.

Run tests with:
```
flutter test test/localization_test.dart
```
