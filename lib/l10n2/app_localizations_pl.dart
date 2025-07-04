// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Odszkodowanie za Lot';

  @override
  String welcomeUser(String userName) {
    return 'Witaj, $userName';
  }

  @override
  String get signOut => 'Wyloguj się';

  @override
  String get newClaim => 'Nowe Roszczenie';

  @override
  String get home => 'Strona Główna';

  @override
  String get settings => 'Ustawienia';

  @override
  String get languageSelection => 'Język';

  @override
  String get passengerName => 'Imię i Nazwisko Pasażera';

  @override
  String get passengerDetails => 'Dane Pasażera';

  @override
  String get flightNumber => 'Numer lotu:';

  @override
  String get airline => 'Linia lotnicza';

  @override
  String get departureAirport => 'Lotnisko odlotu:';

  @override
  String get arrivalAirport => 'Lotnisko przylotu:';

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
  String get submitClaim => 'Złóż Roszczenie';

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
  String get cropping => 'Przycinanie...';

  @override
  String get rotate => 'Obróć';

  @override
  String get aspectRatio => 'Proporcje Obrazu';

  @override
  String get aspectRatioFree => 'Dowolne';

  @override
  String get aspectRatioSquare => 'Kwadrat';

  @override
  String get aspectRatioPortrait => 'Portret';

  @override
  String get aspectRatioLandscape => 'Krajobraz';

  @override
  String aspectRatioMode(String ratio) {
    return 'Proporcje: $ratio';
  }

  @override
  String get documentOcrResult => 'Wynik OCR';

  @override
  String get extractedFields => 'Wyodrębnione Pola';

  @override
  String get fullText => 'Pełny Tekst';

  @override
  String get documentSaved => 'Dokument zapisany.';

  @override
  String get useExtractedData => 'Użyj Wyodrębnionych Danych';

  @override
  String get copyToClipboard => 'Skopiowano do schowka.';

  @override
  String get documentType => 'Typ Dokumentu';

  @override
  String get saveDocument => 'Zapisz Dokument';

  @override
  String get fieldName => 'Nazwa Pola';

  @override
  String get done => 'Gotowe';

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
  String get welcomeMessage => 'Witamy w aplikacji!';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get fillForm => 'Wypełnij Formularz';

  @override
  String get chooseUseInfo => 'Wybierz, jak chcesz użyć tych informacji:';

  @override
  String get fillPassengerFlight => 'Wypełnij informacje o pasażerze i locie';

  @override
  String get ocrResults => 'Wyniki OCR';

  @override
  String get noFieldsExtracted => 'Nie wyodrębniono żadnych pól z dokumentu.';

  @override
  String get extractedInformation => 'Wyodrębnione Informacje';

  @override
  String get rawOcrText => 'Surowy Tekst OCR';

  @override
  String get copyAllText => 'Kopiuj Cały Tekst';

  @override
  String get claims => 'Roszczenia';

  @override
  String get noClaimsYet => 'Brak zgłoszeń';

  @override
  String get startCompensationClaimInstructions =>
      'Rozpocznij zgłoszenie odszkodowania, wybierając lot z sekcji Loty kwalifikujące się w UE';

  @override
  String get active => 'Aktywne';

  @override
  String get actionRequired => 'Wymagana akcja';

  @override
  String get completed => 'Ukończone';

  @override
  String get profileInfoCardTitle =>
      'Twój profil zawiera Twoje dane osobowe i kontaktowe. Są one wykorzystywane do przetwarzania Twoich roszczeń o odszkodowanie za lot i informowania Cię o postępach.';

  @override
  String get accountSettings => 'Ustawienia Konta';

  @override
  String get accessibilityOptions => 'Opcje Dostępności';

  @override
  String get configureAccessibilityDescription =>
      'Skonfiguruj wysoki kontrast, duży tekst i obsługę czytnika ekranu';

  @override
  String get configureNotificationsDescription =>
      'Skonfiguruj sposób otrzymywania aktualizacji dotyczących roszczeń';

  @override
  String get tipProfileUpToDate => 'Utrzymuj swój profil aktualnym';

  @override
  String get tipInformationPrivate => 'Twoje informacje są prywatne';

  @override
  String get tipContactDetails => 'Dane kontaktowe';

  @override
  String get tipAccessibilitySettings => 'Ustawienia dostępności';

  @override
  String get cancel => 'Anuluj';

  @override
  String get next => 'Dalej';

  @override
  String get previous => 'Wstecz';

  @override
  String arrivalsAt(String airport) {
    return 'Przyloty do $airport';
  }

  @override
  String get filterByAirline => 'Filtruj według linii lotniczej';

  @override
  String get flightStatusDelayed => 'Opóźniony';

  @override
  String get flightStatusCancelled => 'Anulowany';

  @override
  String get flightStatusDiverted => 'Przekierowany';

  @override
  String get flightStatusOnTime => 'Na czas';

  @override
  String get flight => 'Lot';

  @override
  String get flights => 'Loty';

  @override
  String get myFlights => 'Moje Loty';

  @override
  String get findFlight => 'Znajdź Lot';

  @override
  String get flightDate => 'Data lotu:';

  @override
  String get checkCompensationEligibility =>
      'Sprawdź Uprawnienie do Odszkodowania';

  @override
  String get supportingDocumentsHint =>
      'Dołącz karty pokładowe, bilety i inne dokumenty, aby wzmocnić swoje roszczenie.';

  @override
  String get scanDocument => 'Zeskanuj Dokument';

  @override
  String get uploadDocument => 'Prześlij Dokument';

  @override
  String get scanDocumentHint =>
      'Użyj aparatu, aby automatycznie wypełnić formularz';

  @override
  String get uploadDocumentHint => 'Wybierz z pamięci urządzenia';

  @override
  String get noDocumentsYet => 'Brak załączonych dokumentów';

  @override
  String get enterFlightNumberFirst => 'Najpierw wprowadź numer lotu';

  @override
  String get viewAll => 'Zobacz Wszystko';

  @override
  String get documentScanner => 'Skaner Dokumentów';

  @override
  String get profileInformation => 'Informacje Profilowe';

  @override
  String get editPersonalInformation => 'Edytuj swoje dane osobowe';

  @override
  String get editPersonalAndContactInformation =>
      'Edytuj swoje dane osobowe i kontaktowe';

  @override
  String get configureAccessibilityOptions =>
      'Skonfiguruj opcje dostępności aplikacji';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport =>
      'Skonfiguruj wysoki kontrast, duży tekst i obsługę czytnika ekranu';

  @override
  String get applicationPreferences => 'Preferencje Aplikacji';

  @override
  String get notificationSettings => 'Ustawienia Powiadomień';

  @override
  String get configureNotificationPreferences =>
      'Skonfiguruj preferencje powiadomień';

  @override
  String get configureHowYouReceiveClaimUpdates =>
      'Skonfiguruj sposób otrzymywania aktualizacji dotyczących roszczeń';

  @override
  String get language => 'Język';

  @override
  String get changeApplicationLanguage => 'Zmień język aplikacji';

  @override
  String get selectYourPreferredLanguage => 'Wybierz preferowany język';

  @override
  String get tipsAndReminders => 'Wskazówki i Przypomnienia';

  @override
  String get importantTipsAboutProfileInformation =>
      'Ważne wskazówki dotyczące informacji o Twoim profilu';

  @override
  String get noClaimsYetTitle => 'Brak Roszczeń';

  @override
  String get noClaimsYetSubtitle =>
      'Rozpocznij składanie wniosku o odszkodowanie, wybierając lot z sekcji Loty kwalifikujące się w UE';

  @override
  String get extractingText => 'Wyodrębnianie tekstu i identyfikacja pól';

  @override
  String get scanInstructions => 'Umieść dokument w ramce i zrób zdjęcie';

  @override
  String get formFilledWithScannedData =>
      'Formularz wypełniony danymi z zeskanowanego dokumentu';

  @override
  String get flightDetails => 'Szczegóły Lotu';

  @override
  String get phoneNumber => 'Numer Telefonu';

  @override
  String get required => 'Wymagane';

  @override
  String get submit => 'Zatwierdź';

  @override
  String get submissionChecklist => 'Lista Kontrolna Zgłoszenia';

  @override
  String get documentAttached => 'Dokument Załączony';

  @override
  String get compensationClaimForm => 'Formularz Roszczenia o Odszkodowanie';

  @override
  String get prefilledFromProfile => 'Wypełnione wstępnie z Twojego profilu';

  @override
  String get flightSearch => 'Wyszukiwanie Lotu';

  @override
  String get searchFlightNumber => 'Wyszukaj po numerze lotu';

  @override
  String get delayedFlightDetected => 'Wykryto Opóźniony Lot';

  @override
  String get flightDetected => 'Wykryto Lot';

  @override
  String get flightLabel => 'Lot:';

  @override
  String get fromAirport => 'Z:';

  @override
  String get toAirport => 'Do:';

  @override
  String get statusLabel => 'Status:';

  @override
  String get delayedEligible => 'Opóźniony i potencjalnie kwalifikujący się';

  @override
  String get startClaim => 'Rozpocznij Roszczenie';

  @override
  String get claimNotFound => 'Nie znaleziono roszczenia';

  @override
  String get claimNotFoundDesc =>
      'Żądane roszczenie nie zostało znalezione. Mogło zostać usunięte.';

  @override
  String get backToDashboard => 'Powrót do panelu głównego';

  @override
  String get euWideEligibleFlights =>
      'Loty kwalifikujące się do odszkodowania w całej UE';

  @override
  String get submitNewClaim => 'Złóż nowe roszczenie';

  @override
  String get reasonForClaim => 'Powód reklamacji:';

  @override
  String get flightDateHint => 'Wybierz datę swojego lotu';

  @override
  String get continueToAttachments => 'Przejdź do załączników';

  @override
  String get pleaseEnterFlightNumber => 'Wprowadź numer lotu';

  @override
  String get pleaseEnterArrivalAirport => 'Wprowadź lotnisko przylotu';

  @override
  String get pleaseEnterReason => 'Wprowadź powód roszczenia';

  @override
  String get pleaseSelectFlightDate => 'Proszę wybrać datę lotu.';

  @override
  String get claimDetails => 'Szczegóły roszczenia';

  @override
  String get refresh => 'Odśwież';

  @override
  String get errorLoadingClaim => 'Błąd ładowania roszczenia';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get unknownError => 'Nieznany błąd';

  @override
  String get requiredFieldsCompleted =>
      'Wszystkie wymagane pola są wypełnione.';

  @override
  String get scanningDocumentsNote =>
      'Skanowanie dokumentów może wstępnie wypełnić niektóre pola.';

  @override
  String get tipCheckEligibility =>
      'Sprawdź kwalifikowalność według rozporządzenia UE 261/2004 przed złożeniem roszczenia.';

  @override
  String get tipDoubleCheckDetails =>
      'Dokładnie sprawdź wszystkie szczegóły przed złożeniem roszczenia.';

  @override
  String get tooltipFaqHelp => 'Zobacz pomoc FAQ';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Błąd podczas wysyłania formularza: $errorMessage. Sprawdź połączenie i spróbuj ponownie.';
  }

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get generalError =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get loginRequiredForClaim =>
      'You must be logged in to submit a claim.';

  @override
  String get quickClaimTitle => 'Szybkie zgłoszenie';

  @override
  String get quickClaimInfoBanner =>
      'Dla lotów objętych przepisami UE. Wprowadź podstawowe informacje do wstępnej weryfikacji.';

  @override
  String get flightNumberHintQuickClaim =>
      'Zwykle 2-literowy kod linii lotniczej i cyfry, np. LH1234';

  @override
  String get departureAirportHintQuickClaim =>
      'np. FRA dla Frankfurtu, LHR dla Londynu Heathrow';

  @override
  String get arrivalAirportHintQuickClaim =>
      'np. JFK dla Nowego Jorku, CDG dla Paryża';

  @override
  String get reasonForClaimLabel => 'Powód roszczenia';

  @override
  String get reasonForClaimHint =>
      'Podaj szczegóły dotyczące tego, co stało się z twoim lotem';

  @override
  String get compensationAmountOptionalLabel =>
      'Kwota odszkodowania (opcjonalnie)';

  @override
  String get compensationAmountHint =>
      'Jeśli znasz kwotę, do której jesteś uprawniony, wprowadź ją tutaj';

  @override
  String get euWideCompensationTitle => 'EU-wide Compensation';

  @override
  String get last72HoursButton => 'Ostatnie 72 godziny';

  @override
  String get scheduledLabel => 'Scheduled:';

  @override
  String get statusLabelEuList => 'Status:';

  @override
  String get potentialCompensationLabel => 'Potential Compensation:';

  @override
  String get prefillCompensationFormButton => 'Pre-fill Compensation Form';

  @override
  String get claimsTabActive => 'Active';

  @override
  String get claimsTabActionRequired => 'Action Required';

  @override
  String get claimsTabCompleted => 'Completed';

  @override
  String get dialogTitleSuccess => 'Success!';

  @override
  String get dialogContentClaimSubmitted =>
      'Your claim has been submitted successfully.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Zarządzanie dokumentami';

  @override
  String get documentsForFlightTitle => 'Dokumenty dla lotu';

  @override
  String get errorLoadingDocuments => 'Błąd ładowania dokumentów';

  @override
  String get addDocumentTooltip => 'Dodaj dokument';

  @override
  String get deleteDocumentTitle => 'Usunąć dokument?';

  @override
  String get deleteDocumentMessage => 'Czy na pewno chcesz usunąć';

  @override
  String get delete => 'Usuń';

  @override
  String get errorMustBeLoggedIn =>
      'You must be logged in to perform this action.';

  @override
  String get errorFailedToSubmitClaim =>
      'Failed to submit claim. Please try again.';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get validatorFlightNumberRequired => 'Flight number is required.';

  @override
  String get tooltipFlightNumberQuickClaim =>
      'Wprowadź numer lotu tak, jak widnieje na bilecie lub rezerwacji';

  @override
  String get tooltipFlightDateQuickClaim =>
      'Data planowanego odlotu twojego lotu';

  @override
  String get validatorDepartureAirportRequired =>
      'Departure airport is required.';

  @override
  String get tooltipDepartureAirportQuickClaim =>
      'Wprowadź 3-literowy kod IATA dla lotniska wylotu';

  @override
  String get validatorArrivalAirportRequired => 'Arrival airport is required.';

  @override
  String get tooltipArrivalAirportQuickClaim =>
      'Wprowadź 3-literowy kod IATA dla lotniska przylotu';

  @override
  String get hintTextReasonQuickClaim =>
      'Podaj powód roszczenia: opóźnienie, odwołanie, odmowa wejścia na pokład, itp.';

  @override
  String get validatorReasonRequired => 'Reason for claim is required.';

  @override
  String get tooltipReasonQuickClaim =>
      'Wyjaśnij szczegółowo powód swojego roszczenia';

  @override
  String get tooltipCompensationAmountQuickClaim =>
      'Wprowadź kwotę, jeśli wiesz, do czego jesteś uprawniony';

  @override
  String get tipsAndRemindersTitle => 'Wskazówki i przypomnienia';

  @override
  String get tipSecureData => 'Twoje dane są bezpieczne i zaszyfrowane.';

  @override
  String get processingDocument => 'Przetwarzanie dokumentu...';

  @override
  String get fieldValue => 'Wartość Pola';

  @override
  String get errorConnectionFailed =>
      'Błąd połączenia. Sprawdź swoje połączenie sieciowe.';

  @override
  String lastHours(int hours) {
    return 'Ostatnie $hours godziny';
  }

  @override
  String noFlightsMatchingFilter(String filter) {
    return 'Brak lotów spełniających filtr: $filter';
  }

  @override
  String get forceRefreshData => 'Wymuś odświeżenie danych';

  @override
  String get forcingFreshDataLoad => 'Wymuszanie ponownego ładowania danych...';

  @override
  String get checkAgain => 'Sprawdź ponownie';

  @override
  String get euWideCompensationEligibleFlights =>
      'Loty kwalifikujące się do odszkodowania w UE';

  @override
  String get noEligibleFlightsFound =>
      'Nie znaleziono kwalifikujących się lotów';

  @override
  String noEligibleFlightsDescription(int hours) {
    return 'Nie znaleziono lotów z ostatnich $hours godzin.';
  }

  @override
  String get apiConnectionIssue =>
      'Problem z połączeniem z API. Spróbuj ponownie.';

  @override
  String get createClaim => 'Utwórz zgłoszenie';

  @override
  String get submitted => 'Wysłane';

  @override
  String get inReview => 'W trakcie weryfikacji';

  @override
  String get processing => 'Przetwarzanie';

  @override
  String get approved => 'Zatwierdzone';

  @override
  String get rejected => 'Odrzucone';

  @override
  String get paid => 'Wypłacone';

  @override
  String get underAppeal => 'W odwołaniu';

  @override
  String get unknown => 'Nieznany';

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
  String claimForFlight(Object number, Object status) {
    return 'Zgłoszenie dla lotu $number - $status';
  }

  @override
  String flightRouteDetails(Object number, Object departure, Object arrival) {
    return 'Lot $number: $departure - $arrival';
  }

  @override
  String get viewClaimDetails => 'Wyświetl szczegóły zgłoszenia';

  @override
  String get totalCompensation => 'Łączna rekompensata';

  @override
  String get pendingAmount => 'Kwota oczekująca';

  @override
  String get pending => 'Oczekujące';

  @override
  String get claimsDashboard => 'Panel zgłoszeń';

  @override
  String get refreshDashboard => 'Odśwież panel';

  @override
  String get claimsSummary => 'Podsumowanie zgłoszeń';

  @override
  String get totalClaims => 'Wszystkie zgłoszenia';

  @override
  String get accessibilitySettings => 'Ustawienia dostępności';

  @override
  String get configureAccessibility => 'Konfiguruj opcje dostępności';

  @override
  String get configureNotifications => 'Konfiguruj powiadomienia';

  @override
  String get notificationSettingsComingSoon =>
      'Ustawienia powiadomień wkrótce!';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get editPersonalInfo => 'Edytuj dane osobowe';

  @override
  String get editPersonalInfoDescription =>
      'Zaktualizuj swoje dane osobowe, adres i informacje kontaktowe';

  @override
  String errorSigningOut(String error) {
    return 'Błąd podczas wylogowywania: $error';
  }

  @override
  String get signInOrSignUp => 'Zaloguj się / Zarejestruj się';

  @override
  String get genericUser => 'Użytkownik';

  @override
  String get dismiss => 'Zamknij';

  @override
  String get signInToTrackClaims => 'Zaloguj się, aby śledzić swoje roszczenia';

  @override
  String get createAccountDescription =>
      'Utwórz konto, aby łatwo śledzić wszystkie swoje roszczenia o odszkodowanie';

  @override
  String get continueToAttachmentsButton => 'Przejdź do załączników';

  @override
  String get continueToReview => 'Continue to Review';

  @override
  String get country => 'Kraj';

  @override
  String get privacySettings => 'Ustawienia prywatności';

  @override
  String get consentToShareData => 'Zgoda na udostępnianie danych';

  @override
  String get requiredForProcessing => 'Wymagane do przetwarzania roszczeń';

  @override
  String get receiveNotifications => 'Otrzymuj powiadomienia';

  @override
  String get getClaimUpdates => 'Otrzymuj aktualizacje dotyczące roszczeń';

  @override
  String get saveProfile => 'Zapisz profil';

  @override
  String get passportNumber => 'Numer paszportu';

  @override
  String get nationality => 'Narodowość';

  @override
  String get dateOfBirth => 'Data urodzenia';

  @override
  String get dateFormat => 'DD/MM/RRRR';

  @override
  String get address => 'Adres';

  @override
  String get city => 'Miasto';

  @override
  String get postalCode => 'Kod pocztowy';

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
  String get fullName => 'Pełne imię i nazwisko';

  @override
  String get attachDocuments => 'Dołącz dokumenty';

  @override
  String get uploadingDocument => 'Przesyłanie dokumentu...';

  @override
  String get noDocuments => 'Nie masz żadnych dokumentów.';

  @override
  String get uploadFirstDocument => 'Prześlij pierwszy dokument';

  @override
  String get uploadNew => 'Prześlij nowy';

  @override
  String get documentUploadSuccess => 'Dokument został pomyślnie przesłany!';

  @override
  String get uploadFailed => 'Przesyłanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get continueAction => 'Kontynuuj';

  @override
  String get claimAttachment => 'Załącznik do roszczenia';

  @override
  String get previewEmail => 'Podgląd e-mail';

  @override
  String get pdfPreviewMessage => 'Tutaj zostanie wyświetlony podgląd PDF.';

  @override
  String get downloadPdf => 'Pobierz PDF';

  @override
  String get filePreviewNotAvailable => 'Podgląd pliku niedostępny';

  @override
  String get deleteDocument => 'Usuń dokument';

  @override
  String get deleteDocumentConfirmation =>
      'Czy na pewno chcesz usunąć ten dokument?';

  @override
  String get documentDeletedSuccess => 'Dokument został pomyślnie usunięty';

  @override
  String get documentDeleteFailed => 'Nie udało się usunąć dokumentu';

  @override
  String get other => 'inne';

  @override
  String get reviewYourClaim => 'Krok 1: Przejrzyj swoją reklamację';

  @override
  String get reviewClaimDetails =>
      'Proszę przejrzeć szczegóły reklamacji przed kontynuacją.';

  @override
  String get attachments => 'Załączniki:';

  @override
  String get proceedToConfirmation => 'Przejdź do potwierdzenia';

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
  String get confirmAndSendEmail => 'Potwierdź i wyślij e-mail';

  @override
  String get reviewAndConfirm => 'Przejrzyj i potwierdź';

  @override
  String get pleaseConfirmDetails =>
      'Prosimy o potwierdzenie, że poniższe dane są poprawne:';

  @override
  String get emailAppOpenedMessage =>
      'Aplikacja e-mail została otwarta. Prosimy o wysłanie e-maila w celu finalizacji reklamacji.';

  @override
  String emailAppErrorMessage(String email) {
    return 'Nie można otworzyć aplikacji e-mail. Prosimy o ręczne wysłanie reklamacji na adres $email.';
  }
}
