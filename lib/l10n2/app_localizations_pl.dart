// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get euCompensation => 'Kompensacja UE';

  @override
  String get scheduledLabel => 'Zaplanowany';

  @override
  String get minutes => 'minut';

  @override
  String get aircraftLabel => 'Samolot:';

  @override
  String get prefillCompensationForm => 'Wypełnij formularz automatycznie';

  @override
  String get confirmAndSend => 'Krok 2: Potwierdź i Wyślij';

  @override
  String get errorLoadingEmailDetails =>
      'Błąd: Nie można załadować szczegółów e-mail.';

  @override
  String get noEmailInfo =>
      'Nie można znaleźć informacji e-mail dla użytkownika lub linii lotniczej.';

  @override
  String get finalConfirmation => 'Ostateczne potwierdzenie';

  @override
  String get claimWillBeSentTo => 'Reklamacja zostanie wysłana do:';

  @override
  String get copyToYourEmail => 'Kopia zostanie wysłana na Twój e-mail:';

  @override
  String get previewEmail => 'Podgląd e-mail';

  @override
  String get confirmAndSendEmail => 'Potwierdź i wyślij e-mail';

  @override
  String get attachmentsInfoNextStep =>
      'You can add attachments (e.g., tickets, boarding passes) in the next step.';

  @override
  String get departureAirport => 'Lotnisko odlotu:';

  @override
  String get arrivalAirport => 'Lotnisko przylotu:';

  @override
  String get reasonForClaim => 'Powód reklamacji:';

  @override
  String get flightCancellationReason =>
      'Odwołanie lotu - wniosek o odszkodowanie na podstawie rozporządzenia UE 261 za odwołany lot';

  @override
  String get flightDelayReason =>
      'Opóźnienie lotu powyżej 3 godzin - wniosek o odszkodowanie na podstawie rozporządzenia UE 261 za znaczne opóźnienie';

  @override
  String get flightDiversionReason =>
      'Przekierowanie lotu - wniosek o odszkodowanie na podstawie rozporządzenia UE 261 za przekierowany lot';

  @override
  String get eu261CompensationReason =>
      'Wniosek o odszkodowanie na podstawie rozporządzenia UE 261 za zakłócenie lotu';

  @override
  String get attachments => 'Załączniki:';

  @override
  String get proceedToConfirmation => 'Przejdź do potwierdzenia';

  @override
  String emailAppOpenedMessage(String email) {
    return 'Aplikacja e-mail została otwarta. Prosimy o wysłanie e-maila w celu finalizacji reklamacji.';
  }

  @override
  String errorFailedToSubmitClaim(String error) {
    return 'Nie udało się wysłać zgłoszenia. Spróbuj ponownie.';
  }

  @override
  String get unknownError => 'Nieznany błąd';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get claimNotFound => 'Nie znaleziono roszczenia';

  @override
  String get claimNotFoundDesc =>
      'Żądane roszczenie nie zostało znalezione. Mogło zostać usunięte.';

  @override
  String get backToDashboard => 'Powrót do panelu głównego';

  @override
  String get reviewYourClaim => 'Krok 1: Przejrzyj swoją reklamację';

  @override
  String get reviewClaimDetails =>
      'Proszę przejrzeć szczegóły reklamacji przed kontynuacją.';

  @override
  String get flightNumber => 'Numer lotu:';

  @override
  String get flightDate => 'Data lotu:';

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Brak lotów spełniających filtr: $filter';
  }

  @override
  String get statusLabel => 'Status';

  @override
  String get flightStatusDelayed => 'Opóźniony';

  @override
  String get potentialCompensation => 'Potencjalne odszkodowanie:';

  @override
  String get claimDetails => 'Szczegóły roszczenia';

  @override
  String get refresh => 'Odśwież';

  @override
  String get errorLoadingClaim => 'Błąd ładowania roszczenia';

  @override
  String get euWideCompensationEligibleFlights =>
      'Loty kwalifikujące się do odszkodowania w UE';

  @override
  String get forceRefreshData => 'Wymuś odświeżenie danych';

  @override
  String get forcingFreshDataLoad => 'Wymuszanie ponownego ładowania danych...';

  @override
  String get loadingExternalData => 'Pobieranie danych o lotach...';

  @override
  String get loadingExternalDataDescription =>
      'Łączenie z bazami danych lotów. To może chwilę potrwać.';

  @override
  String lastHours(int hours) {
    return 'Ostatnie $hours godziny';
  }

  @override
  String get errorConnectionFailed =>
      'Błąd połączenia. Sprawdź swoje połączenie sieciowe.';

  @override
  String formSubmissionError(String error) {
    return 'Błąd podczas wysyłania formularza: $error. Sprawdź połączenie i spróbuj ponownie.';
  }

  @override
  String get compensationEmailSuccess =>
      'Compensation email sent successfully!';

  @override
  String get compensationEmailFailed => 'Failed to send compensation email';

  @override
  String errorSendingEmail(String error) {
    return 'Error sending email: $error';
  }

  @override
  String get apiConnectionIssue =>
      'Problem z połączeniem z API. Spróbuj ponownie.';

  @override
  String get noEligibleFlightsFound =>
      'Nie znaleziono kwalifikujących się lotów';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Nie znaleziono lotów z ostatnich $hours godzin.';
  }

  @override
  String get checkAgain => 'Sprawdź ponownie';

  @override
  String get filterByAirline => 'Filtruj według linii lotniczej';

  @override
  String get saveDocument => 'Zapisz Dokument';

  @override
  String get fieldName => 'Nazwa Pola';

  @override
  String get fieldValue => 'Wartość Pola';

  @override
  String get noFieldsExtracted => 'Nie wyodrębniono żadnych pól z dokumentu.';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get networkError => 'Błąd sieci';

  @override
  String get generalError => 'Błąd ogólny';

  @override
  String get loginRequiredForClaim =>
      'Wymagane logowanie, aby wysłać zgłoszenie';

  @override
  String get aspectRatio => 'Proporcje Obrazu';

  @override
  String get documentOcrResult => 'Wynik OCR';

  @override
  String get extractedFields => 'Wyodrębnione Pola';

  @override
  String get fullText => 'Pełny Tekst';

  @override
  String get extractedInformation => 'Wyodrębnione Informacje';

  @override
  String get rawOcrText => 'Surowy Tekst OCR';

  @override
  String get copyAllText => 'Kopiuj Cały Tekst';

  @override
  String get fillForm => 'Wypełnij Formularz';

  @override
  String get chooseUseInfo => 'Wybierz, jak chcesz użyć tych informacji:';

  @override
  String get fillPassengerFlight => 'Wypełnij informacje o pasażerze i locie';

  @override
  String get flightSearch => 'Wyszukiwanie Lotu';

  @override
  String get searchFlightNumber => 'Wyszukaj po numerze lotu';

  @override
  String get done => 'Gotowe';

  @override
  String get documentSaved => 'Dokument zapisany.';

  @override
  String get useExtractedData => 'Użyj Wyodrębnionych Danych';

  @override
  String get copyToClipboard => 'Skopiowano do schowka.';

  @override
  String get documentType => 'Typ Dokumentu';

  @override
  String get submitClaim => 'Złóż Roszczenie';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get resend => 'Resend';

  @override
  String get addDocument => 'Dodaj Dokument';

  @override
  String get claimSubmittedSuccessfully => 'Roszczenie złożone pomyślnie!';

  @override
  String get completeAllFields => 'Proszę wypełnić wszystkie pola.';

  @override
  String get supportingDocuments => 'Dokumenty Pomocnicze';

  @override
  String get cropDocument => 'Przytnij Dokument';

  @override
  String get crop => 'Przytnij';

  @override
  String get rotate => 'Obróć';

  @override
  String get airline => 'Linia lotnicza';

  @override
  String get email => 'Email';

  @override
  String get bookingReference => 'Numer Rezerwacji';

  @override
  String get additionalInformation => 'Dodatkowe Informacje';

  @override
  String get optional => '(Opcjonalnie)';

  @override
  String get thisFieldIsRequired => 'To pole jest wymagane.';

  @override
  String get pleaseEnterDepartureAirport => 'Wprowadź lotnisko wylotu';

  @override
  String get uploadDocuments => 'Prześlij Dokumenty';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Wstecz';

  @override
  String get save => 'Zapisz';

  @override
  String get languageSelection => 'Język';

  @override
  String get passengerName => 'Imię i Nazwisko Pasażera';

  @override
  String get passengerDetails => 'Dane Pasażera';

  @override
  String get appTitle => 'Odszkodowanie za Lot';

  @override
  String get welcomeMessage => 'Witamy w aplikacji!';

  @override
  String get home => 'Strona Główna';

  @override
  String get settings => 'Ustawienia';

  @override
  String get required => 'Wymagane';

  @override
  String get emailAddress => 'Adres e-mail';

  @override
  String get documentDeleteFailed => 'Nie udało się usunąć dokumentu';

  @override
  String get uploadNew => 'Prześlij nowy';

  @override
  String get continueAction => 'Kontynuuj';

  @override
  String get compensationClaimForm => 'Formularz Roszczenia o Odszkodowanie';

  @override
  String get flight => 'Lot';

  @override
  String get passengerInformation => 'Informacje o pasażerze';

  @override
  String get fullName => 'Pełne imię i nazwisko';

  @override
  String get downloadPdf => 'Pobierz PDF';

  @override
  String get filePreviewNotAvailable => 'Podgląd pliku niedostępny';

  @override
  String get noFileSelected => 'Nie wybrano pliku';

  @override
  String get preview => 'Podgląd';

  @override
  String get downloadStarting => 'Rozpoczynanie pobierania...';

  @override
  String get fileTypeLabel => 'Typ pliku:';

  @override
  String get failedToLoadImage => 'Nie udało się wczytać obrazu';

  @override
  String get deleteDocument => 'Usuń dokument';

  @override
  String get deleteDocumentConfirmation =>
      'Czy na pewno chcesz usunąć ten dokument?';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get documentDeletedSuccess => 'Dokument został pomyślnie usunięty';

  @override
  String get attachDocuments => 'Dołącz dokumenty';

  @override
  String get uploadingDocument => 'Przesyłanie dokumentu...';

  @override
  String get noDocuments => 'Nie masz żadnych dokumentów.';

  @override
  String get uploadFirstDocument => 'Prześlij pierwszy dokument';

  @override
  String get claimAttachment => 'Załącznik do roszczenia';

  @override
  String get other => 'inny';

  @override
  String get pdfPreviewMessage => 'Tutaj zostanie wyświetlony podgląd PDF.';

  @override
  String get tipsAndRemindersTitle => 'Wskazówki i przypomnienia';

  @override
  String get tipSecureData => 'Twoje dane są bezpieczne i zaszyfrowane.';

  @override
  String get tipCheckEligibility =>
      'Sprawdź kwalifikowalność według rozporządzenia UE 261/2004 przed złożeniem roszczenia.';

  @override
  String get tipDoubleCheckDetails =>
      'Dokładnie sprawdź wszystkie szczegóły przed złożeniem roszczenia.';

  @override
  String get documentUploadSuccess => 'Dokument został pomyślnie przesłany!';

  @override
  String get uploadFailed => 'Przesyłanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get reasonForClaimHint =>
      'Podaj szczegóły dotyczące tego, co stało się z twoim lotem';

  @override
  String get validatorReasonRequired => 'Powód roszczenia jest wymagany';

  @override
  String get tooltipReasonQuickClaim =>
      'Wyjaśnij szczegółowo powód swojego roszczenia';

  @override
  String get compensationAmountOptionalLabel =>
      'Kwota odszkodowania (opcjonalnie)';

  @override
  String get compensationAmountHint =>
      'Jeśli znasz kwotę, do której jesteś uprawniony, wprowadź ją tutaj';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Wprowadź kwotę, jeśli wiesz, do czego jesteś uprawniony';

  @override
  String get continueToReview => 'Przejdź do przeglądu';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Wprowadź 3-literowy kod IATA dla lotniska wylotu';

  @override
  String get arrivalAirportHintQuickClaim =>
      'np. JFK dla Nowego Jorku, CDG dla Paryża';

  @override
  String get validatorArrivalAirportRequired =>
      'Lotnisko przylotu jest wymagane';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Wprowadź 3-literowy kod IATA dla lotniska przylotu';

  @override
  String get reasonForClaimLabel => 'Powód roszczenia';

  @override
  String get hintTextReasonQuickClaim =>
      'Podaj powód roszczenia: opóźnienie, odwołanie, odmowa wejścia na pokład, itp.';

  @override
  String get flightNumberHintQuickClaim =>
      'Zwykle 2-literowy kod linii lotniczej i cyfry, np. LH1234';

  @override
  String get validatorFlightNumberRequired => 'Numer lotu jest wymagany';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Wprowadź numer lotu tak, jak widnieje na bilecie lub rezerwacji';

  @override
  String get tooltipFlightDateQuickClaim =>
      'Data planowanego odlotu twojego lotu';

  @override
  String get departureAirportHintQuickClaim =>
      'np. FRA dla Frankfurtu, LHR dla Londynu Heathrow';

  @override
  String get validatorDepartureAirportRequired =>
      'Lotnisko wylotu jest wymagane';

  @override
  String get underAppeal => 'W odwołaniu';

  @override
  String get unknown => 'Nieznany';

  @override
  String get errorMustBeLoggedIn =>
      'Aby wysłać zgłoszenie, musisz być zalogowany';

  @override
  String get dialogTitleError => 'Błąd';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get quickClaimTitle => 'Szybkie zgłoszenie';

  @override
  String get tooltipFaqHelp => 'Zobacz pomoc FAQ';

  @override
  String get quickClaimInfoBanner =>
      'Dla lotów objętych przepisami UE. Wprowadź podstawowe informacje do wstępnej weryfikacji.';

  @override
  String get createClaim => 'Utwórz zgłoszenie';

  @override
  String get submitted => 'Wysłane';

  @override
  String get inReview => 'W trakcie weryfikacji';

  @override
  String get actionRequired => 'Wymagana akcja';

  @override
  String get processing => 'Przetwarzanie';

  @override
  String get approved => 'Zatwierdzone';

  @override
  String get rejected => 'Odrzucone';

  @override
  String get paid => 'Wypłacone';

  @override
  String get emailStatusNotSent => 'Not sent';

  @override
  String get emailStatusSending => 'Sending';

  @override
  String get emailStatusSent => 'Sent';

  @override
  String get emailStatusFailed => 'Failed';

  @override
  String get emailStatusBounced => 'Bounced';

  @override
  String flightRouteDetails(String departure, String arrival) {
    return 'Lot $flightNumber: $departure - $arrival';
  }

  @override
  String get authenticationRequired => 'Wymagane uwierzytelnienie';

  @override
  String get errorLoadingClaims => 'Błąd ładowania zgłoszeń';

  @override
  String get loginToViewClaimsDashboard =>
      'Zaloguj się, aby zobaczyć swój pulpit zgłoszeń';

  @override
  String get logIn => 'Zaloguj się';

  @override
  String get noClaimsYet => 'Brak zgłoszeń';

  @override
  String get startCompensationClaimInstructions =>
      'Rozpocznij zgłoszenie odszkodowania, wybierając lot z sekcji Loty kwalifikujące się w UE';

  @override
  String get claimsDashboard => 'Panel zgłoszeń';

  @override
  String get refreshDashboard => 'Odśwież panel';

  @override
  String get claimsSummary => 'Podsumowanie zgłoszeń';

  @override
  String get totalClaims => 'Wszystkie zgłoszenia';

  @override
  String get totalCompensation => 'Łączna rekompensata';

  @override
  String get pendingAmount => 'Kwota oczekująca';

  @override
  String get receivedAmount => 'Received';

  @override
  String get noClaimsYetTitle => 'Brak Roszczeń';

  @override
  String get noRecentEvents => 'No recent events';

  @override
  String get pending => 'Oczekujące';

  @override
  String get viewClaimDetails => 'Wyświetl szczegóły zgłoszenia';

  @override
  String claimForFlight(String flightNumber, String status) {
    return 'Zgłoszenie dla lotu $flightNumber - $status';
  }

  @override
  String flightRouteDetailsWithNumber(
      String flightNumber,
      String departure,
      String arrival,
      String number,
      String airline,
      String departureAirport,
      String arrivalAirport,
      String date,
      String time) {
    return '$flightNumber: $departure to $arrival $airline';
  }

  @override
  String get configureNotificationsDescription =>
      'Skonfiguruj sposób otrzymywania aktualizacji dotyczących roszczeń';

  @override
  String get notificationSettingsComingSoon =>
      'Ustawienia powiadomień wkrótce!';

  @override
  String get changeApplicationLanguage => 'Zmień język aplikacji';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get tipsAndReminders => 'Wskazówki i Przypomnienia';

  @override
  String get tipProfileUpToDate => 'Utrzymuj swój profil aktualnym';

  @override
  String get tipInformationPrivate => 'Twoje informacje są prywatne';

  @override
  String get tipContactDetails => 'Dane kontaktowe';

  @override
  String get legalPrivacySectionTitle => 'Informacje prawne i prywatność';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get privacyPolicyDesc => 'Jak przetwarzamy Twoje dane';

  @override
  String get termsOfService => 'Regulamin';

  @override
  String get termsOfServiceDesc => 'Zasady korzystania z usługi';

  @override
  String get cookiePolicy => 'Polityka plików cookie';

  @override
  String get cookiePolicyDesc => 'Zastosowanie i kategorie plików cookie';

  @override
  String get legalNoticeImprint => 'Nota prawna / Impressum';

  @override
  String get legalNoticeImprintDesc => 'Operator i dane kontaktowe';

  @override
  String get accessibilityStatement => 'Oświadczenie o dostępności';

  @override
  String get accessibilityStatementDesc =>
      'Nasze zobowiązania w zakresie dostępności';

  @override
  String get manageCookiePreferences => 'Zarządzaj zgodami na pliki cookie';

  @override
  String get manageCookiePreferencesDesc =>
      'Zmień ustawienia analityczne i marketingowe dotyczące plików cookie';

  @override
  String get cookiePreferencesTitle => 'Cookie Preferences';

  @override
  String get cookiePreferencesIntro =>
      'We use cookies to improve your experience. Necessary cookies are always on.';

  @override
  String get analyticsLabel => 'Analytics';

  @override
  String get analyticsDesc => 'Helps us understand usage. Optional.';

  @override
  String get marketingLabel => 'Marketing';

  @override
  String get marketingDesc => 'Personalized content/ads. Optional.';

  @override
  String get savePreferences => 'Save preferences';

  @override
  String get tipAccessibilitySettings => 'Ustawienia dostępności';

  @override
  String get active => 'Aktywne';

  @override
  String get completed => 'Ukończone';

  @override
  String get events => 'Events';

  @override
  String get genericUser => 'Użytkownik';

  @override
  String get signOut => 'Wyloguj się';

  @override
  String errorSigningOut(String error) {
    return 'Błąd podczas wylogowywania: $error';
  }

  @override
  String get profileInformation => 'Informacje Profilowe';

  @override
  String get profileInfoCardTitle =>
      'Twój profil zawiera Twoje dane osobowe i kontaktowe. Są one wykorzystywane do przetwarzania Twoich roszczeń o odszkodowanie za lot i informowania Cię o postępach.';

  @override
  String get profileInfoBannerSemanticLabel =>
      'Informacje o wykorzystaniu danych Twojego profilu';

  @override
  String get accountSettings => 'Ustawienia Konta';

  @override
  String get editPersonalInfo => 'Edytuj dane osobowe';

  @override
  String get editPersonalInfoDescription =>
      'Zaktualizuj swoje dane osobowe, adres i informacje kontaktowe';

  @override
  String get accessibilitySettings => 'Ustawienia dostępności';

  @override
  String get configureAccessibility => 'Konfiguruj opcje dostępności';

  @override
  String get accessibilityOptions => 'Opcje Dostępności';

  @override
  String get configureAccessibilityDescription =>
      'Skonfiguruj wysoki kontrast, duży tekst i obsługę czytnika ekranu';

  @override
  String get notificationSettings => 'Ustawienia Powiadomień';

  @override
  String get configureNotifications => 'Konfiguruj powiadomienia';

  @override
  String get eu261Rights =>
      'Zgodnie z rozporządzeniem EU261, przysługuje Ci odszkodowanie za:\n• Opóźnienia 3+ godzin\n• Odwołania lotów\n• Odmowę wejścia na pokład\n• Przekierowania lotów';

  @override
  String get dontLetAirlinesWin =>
      'Nie pozwól liniom lotniczym uniknąć płacenia tego, co Ci się należy!';

  @override
  String get submitClaimAnyway => 'Złóż Roszczenie Mimo To';

  @override
  String get newClaim => 'Nowe Roszczenie';

  @override
  String get notLoggedIn => 'Nie jesteś zalogowany';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordTitle => 'Reset your password';

  @override
  String get signInSubtitle =>
      'Sign in to access your flight compensation claims';

  @override
  String get signUpSubtitle =>
      'Sign up to track your flight compensation claims';

  @override
  String get resetPasswordSubtitle =>
      'Enter your email to receive a password reset link';

  @override
  String get emailHintExample => 'your.email@example.com';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordPlaceholder => '********';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get alreadyHaveAccountSignInCta => 'Already have an account? Sign In';

  @override
  String get dontHaveAccountSignUpCta => 'Don\'t have an account? Sign Up';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get passwordResetEmailSentMessage =>
      'Password reset email sent! Check your inbox.';

  @override
  String get authInvalidEmail => 'Please enter a valid email address';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authEmailRequired => 'Please enter your email';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get authUnexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authGoogleSignInFailed =>
      'Google sign-in failed. Please try again.';

  @override
  String get authPasswordResetFailed =>
      'Password reset failed. Please try again.';

  @override
  String get authSignOutFailed => 'Sign out failed. Please try again.';

  @override
  String get checkFlightEligibilityButtonText =>
      'Sprawdź uprawnienie do odszkodowania';

  @override
  String get euEligibleFlightsButtonText =>
      'Loty kwalifikujące się do odszkodowania w UE';

  @override
  String welcomeUser(String name, String role, Object userName) {
    return 'Witaj, $userName';
  }

  @override
  String errorFormSubmissionFailed(String errorMessage) {
    return 'Error submitting form: $errorMessage. Please check your connection and try again.';
  }

  @override
  String get contactAirlineForClaim => 'Contact Airline for Claim';

  @override
  String get flightMightNotBeEligible =>
      'Na podstawie dostępnych danych, Twój lot może nie kwalifikować się do odszkodowania.';

  @override
  String get knowYourRights => 'Poznaj Swoje Prawa';

  @override
  String get airlineDataDisclaimer =>
      'Linie lotnicze czasami zaniżają opóźnienia lub zmieniają statusy lotów. Jeśli doświadczyłeś opóźnienia 3+ godzin, odwołania lub przekierowania, nadal możesz być uprawniony do odszkodowania.';

  @override
  String get error => 'Błąd';

  @override
  String get status => 'Status';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get delay => 'Delay';

  @override
  String get flightEligibleForCompensation =>
      'Flight Eligible For Compensation';

  @override
  String flightInfoFormat(String flightCode, String flightDate) {
    return 'Flight $flightCode on $flightDate';
  }

  @override
  String minutesFormat(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get flightCompensationCheckerTitle =>
      'Sprawdzanie odszkodowania za lot';

  @override
  String get checkEligibilityForEu261 =>
      'Sprawdź uprawnienia do odszkodowania EU 261';

  @override
  String get flightNumberPlaceholder => 'Numer lotu (np. LO123)';

  @override
  String get pleaseEnterFlightNumber => 'Proszę podać numer lotu';

  @override
  String get dateOptionalPlaceholder => 'Data lotu (opcjonalnie)';

  @override
  String get leaveDateEmptyForToday => 'Pozostaw puste dla dzisiejszej daty';

  @override
  String get checkCompensationEligibility =>
      'Sprawdź kwalifikowalność do odszkodowania';

  @override
  String get continueToAttachmentsButton => 'Przejdź do załączników';

  @override
  String get flightNotFoundError =>
      'Lot nie znaleziony. Proszę sprawdzić numer lotu i spróbować ponownie.';

  @override
  String get invalidFlightNumberError =>
      'Nieprawidłowy format numeru lotu. Proszę wprowadzić prawidłowy numer lotu (np. BA123, LH456).';

  @override
  String get networkTimeoutError =>
      'Przekroczono limit czasu połączenia. Proszę sprawdzić połączenie internetowe i spróbować ponownie.';

  @override
  String get serverError =>
      'Serwer tymczasowo niedostępny. Proszę spróbować później.';

  @override
  String get rateLimitError =>
      'Zbyt wiele żądań. Proszę poczekać chwilę i spróbować ponownie.';

  @override
  String get generalFlightCheckError =>
      'Nie można sprawdzić informacji o locie. Proszę zweryfikować dane lotu i spróbować ponownie.';

  @override
  String get receiveNotifications => 'Otrzymuj powiadomienia';

  @override
  String get getClaimUpdates => 'Otrzymuj aktualizacje dotyczące roszczeń';

  @override
  String get saveProfile => 'Zapisz profil';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Adres';

  @override
  String get city => 'Miasto';

  @override
  String get country => 'Kraj';

  @override
  String get postalCode => 'Kod pocztowy';

  @override
  String get pleaseSelectFlightDate => 'Proszę wybrać datę lotu.';

  @override
  String get submitNewClaim => 'Złóż nowe roszczenie';

  @override
  String get pleaseEnterArrivalAirport => 'Wprowadź lotnisko przylotu';

  @override
  String get pleaseEnterReason => 'Wprowadź powód roszczenia';

  @override
  String get flightDateHint => 'Wybierz datę swojego lotu';

  @override
  String get number => 'Number';

  @override
  String welcomeUser3(String name, String role, String company) {
    return 'Welcome, $name ($role at $company)';
  }

  @override
  String get phoneNumber => 'Numer Telefonu';

  @override
  String get passportNumber => 'Numer paszportu';

  @override
  String get nationality => 'Narodowość';

  @override
  String get dateOfBirth => 'Data urodzenia';

  @override
  String get dateFormat => 'DD/MM/RRRR';

  @override
  String get privacySettings => 'Ustawienia prywatności';

  @override
  String get consentToShareData => 'Zgoda na udostępnianie danych';

  @override
  String get requiredForProcessing => 'Wymagane do przetwarzania roszczeń';

  @override
  String get claims => 'Roszczenia';

  @override
  String get errorLoadingProfile => 'Błąd podczas ładowania profilu';

  @override
  String get profileSaved => 'Profil zapisany pomyślnie';

  @override
  String get editProfile => 'Edytuj profil';

  @override
  String get profileAccuracyInfo =>
      'Upewnij się, że informacje w profilu są dokładne';

  @override
  String get keepProfileUpToDate => 'Aktualizuj swój profil na bieżąco';

  @override
  String get profilePrivacy => 'Chronimy Twoją prywatność i dane';

  @override
  String get correctContactDetails =>
      'Poprawne dane kontaktowe pomagają w uzyskaniu odszkodowania';

  @override
  String get emailReadyToSend => 'Your Compensation Email is Ready!';

  @override
  String get emailCopyInstructions =>
      'Copy the email details below and paste them into your email app';

  @override
  String get cc => 'CC';

  @override
  String get subject => 'Subject';

  @override
  String get emailBody => 'Email Body';

  @override
  String get howToSendEmail => 'How to send this email:';

  @override
  String get emailStep1 => 'Tap \"Copy Email\" below';

  @override
  String get emailStep2 => 'Open your email app (Gmail, Outlook, etc.)';

  @override
  String get emailStep3 => 'Create a new email';

  @override
  String get emailStep4 => 'Paste the copied content';

  @override
  String get emailStep5 => 'Send your compensation claim!';

  @override
  String get copyEmail => 'Copy Email';

  @override
  String get emailCopiedSuccess => 'Email copied to clipboard!';

  @override
  String get supportOurMission => 'Wesprzyj naszą misję';

  @override
  String get helpKeepAppFree =>
      'Pomóż nam utrzymać tę aplikację bezpłatną i wesprzyj opiekę hospicyjną';

  @override
  String get yourContributionMakesDifference => 'Twoja darowizna ma znaczenie';

  @override
  String get hospiceFoundation => 'Fundacja Hospicyjna';

  @override
  String get appDevelopment => 'Rozwój Aplikacji';

  @override
  String get comfortCareForPatients => 'Opieka i komfort dla pacjentów';

  @override
  String get newFeaturesAndImprovements => 'Nowe funkcje i ulepszenia';

  @override
  String get chooseYourSupportAmount => 'Wybierz kwotę wsparcia:';

  @override
  String get totalDonation => 'Całkowita Darowizna';

  @override
  String get donationSummary => 'Podsumowanie Darowizny';

  @override
  String get choosePaymentMethod => 'Wybierz metodę płatności:';

  @override
  String get paymentMethod => 'Metoda płatności';

  @override
  String get creditDebitCard => 'Karta kredytowa/debetowa';

  @override
  String get visaMastercardAmericanExpress =>
      'Visa, Mastercard, American Express';

  @override
  String get payWithPayPalAccount => 'Płać za pomocą konta PayPal';

  @override
  String get applePay => 'Apple Pay';

  @override
  String get notAvailableOnThisDevice => 'Niedostępne na tym urządzeniu';

  @override
  String get googlePay => 'Google Pay';

  @override
  String get quickAndSecure => 'Szybko i bezpiecznie';

  @override
  String get smallSupport => 'Małe Wsparcie';

  @override
  String get goodSupport => 'Dobre Wsparcie';

  @override
  String get greatSupport => 'Świetne Wsparcie';

  @override
  String yourAmountHelps(String amount) {
    return 'Twoje $amount pomaga:';
  }

  @override
  String get hospicePatientCare => 'Opieka nad pacjentami hospicjum';

  @override
  String get appImprovements => 'Ulepszenia aplikacji';

  @override
  String continueWithAmount(String amount) {
    return 'Kontynuuj z $amount';
  }

  @override
  String get selectAnAmount => 'Wybierz kwotę';

  @override
  String get maybeLater => 'Może później';

  @override
  String get securePaymentInfo =>
      'Bezpieczna płatność • Brak ukrytych opłat • Paragon podatkowy';

  @override
  String get learnMoreHospiceFoundation =>
      'Dowiedz się więcej o Fundacji Hospicyjnej: fundacja-hospicjum.org';

  @override
  String get touchIdOrFaceId => 'Touch ID lub Face ID';

  @override
  String get continueToPayment => 'Przejdź do płatności';

  @override
  String get selectAPaymentMethod => 'Wybierz metodę płatności';

  @override
  String get securePayment => 'Bezpieczna płatność';

  @override
  String get paymentSecurityInfo =>
      'Twoje informacje płatnicze są zaszyfrowane i bezpieczne. Nie przechowujemy szczegółów Twojej płatności.';

  @override
  String get taxReceiptEmail =>
      'Paragon podatkowy zostanie wysłany na Twój email';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, American Express';

  @override
  String get notAvailableOnDevice => 'Niedostępne na tym urządzeniu';

  @override
  String get comfortAndCareForPatients => 'Komfort i opieka dla pacjentów';

  @override
  String get chooseSupportAmount => 'Wybierz kwotę wsparcia:';

  @override
  String get emailReadyTitle =>
      'Twój e-mail dotyczący odszkodowania jest gotowy do wysłania!';

  @override
  String get emailWillBeSentSecurely =>
      'Twój e‑mail zostanie wysłany bezpiecznie za pośrednictwem naszego serwisu backendowego';

  @override
  String get toLabel => 'Do';

  @override
  String get ccLabel => 'CC:';

  @override
  String get subjectLabel => 'Subject:';

  @override
  String get emailBodyLabel => 'Email Body:';

  @override
  String get secureTransmissionNotice =>
      'Twoja wiadomość e‑mail zostanie wysłana bezpiecznie przy użyciu szyfrowanej transmisji';

  @override
  String get sendingEllipsis => 'Sending...';

  @override
  String get sendEmailSecurely => 'Wyślij e-mail bezpiecznie';

  @override
  String get openingEmailApp => 'Opening email app...';

  @override
  String get tipReturnBackGesture =>
      'Tip: to return, use your device Back gesture (not the Gmail arrow).';

  @override
  String get returnToAppTitle => 'Return to Flight Compensation';

  @override
  String get returnToAppBody => 'Tap to come back and finish your claim.';

  @override
  String get errorFailedToSendEmail => 'Failed to send email';

  @override
  String get unexpectedErrorSendingEmail =>
      'Unexpected error occurred while sending email';

  @override
  String get emailSentSuccessfully => 'Email sent successfully!';

  @override
  String get predictingDelay => 'Prognozowanie opóźnienia…';

  @override
  String get predictionUnavailable => 'Brak dostępnej prognozy';

  @override
  String delayRiskPercent(int risk) {
    return 'Ryzyko opóźnienia $risk%';
  }

  @override
  String avgMinutesShort(int minutes) {
    return 'Śr. $minutes min';
  }

  @override
  String get attachmentGuidanceTitle => 'Attachments';

  @override
  String get emailPreviewAttachmentGuidance =>
      'Załączniki będzie można dodać w następnym kroku. Pamiętaj, aby dołączać wyłącznie pliki w formatach JPG, PNG lub PDF.';

  @override
  String get worldIdVerifyTitle => 'Zweryfikuj z World ID';

  @override
  String get worldIdVerifyDesc =>
      'Zweryfikuj swoją tożsamość prywatnie za pomocą World ID. Pomaga to zapobiegać nadużyciom i utrzymać aplikację bezpłatną.';

  @override
  String get worldIdVerifySemantic =>
      'Zweryfikuj swoją tożsamość (Worldcoin World ID). Dostępne tylko w wersji web.';

  @override
  String get worldIdTemporarilyUnavailable =>
      'World ID jest tymczasowo niedostępny. Spróbuj ponownie później.';

  @override
  String get worldAppSignInTitle => 'Zaloguj się w World App';

  @override
  String get worldAppSignInDesc =>
      'Zaloguj się w World App, aby zweryfikować swoją tożsamość. To pomaga zapobiegać nadużyciom i utrzymać aplikację bezpłatną.';

  @override
  String get worldAppOpenError =>
      'Nie udało się otworzyć World App. Spróbuj ponownie.';

  @override
  String worldAppOpenException(String error) {
    return 'Błąd podczas otwierania World App: $error';
  }

  @override
  String get worldIdOidcTitle => 'Zaloguj się World ID (OIDC)';

  @override
  String get worldIdOidcDesc =>
      'Zaloguj się przez World ID z użyciem bezpiecznego OIDC + PKCE.';

  @override
  String get emailClipboardFallbackPrimary =>
      'Brak dostępnej aplikacji e‑mail. Treść wiadomości została skopiowana do schowka. Wklej ją w dowolnej usłudze e‑mail.';

  @override
  String get emailClipboardFallbackAdvisory =>
      'Po wklejeniu możesz sprawdzić i poprawić tekst oraz dołączyć dokumenty, np. bilety lub karty pokładowe (JPG, PNG, PDF).';
}
