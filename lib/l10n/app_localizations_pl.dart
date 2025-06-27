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
  String get flightNumber => 'Numer Lotu';

  @override
  String get airline => 'Linia Lotnicza';

  @override
  String get departureAirport => 'Lotnisko Wylotu';

  @override
  String get arrivalAirport => 'Lotnisko Przylotu';

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
  String get pleaseEnterDepartureAirport => 'Proszę podać lotnisko wylotu.';

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
  String get pleaseCompleteAllFields => 'Please complete all required fields.';

  @override
  String get pleaseAttachDocuments => 'Please attach required documents.';

  @override
  String get allFieldsCompleted => 'All fields completed.';

  @override
  String get processingDocument => 'Przetwarzanie dokumentu...';

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
  String get copyAllText => 'Copy all text';

  @override
  String get claims => 'Claims';

  @override
  String get noClaimsYet => 'No Claims Yet';

  @override
  String get startCompensationClaimInstructions => 'Rozpocznij składanie wniosku o odszkodowanie, wybierając lot z sekcji Loty kwalifikujące się w UE';

  @override
  String get active => 'Aktywne';

  @override
  String get actionRequired => 'Wymagana akcja';

  @override
  String get completed => 'Ukończone';

  @override
  String get profileInfoCardTitle => 'Twój profil zawiera Twoje dane osobowe i kontaktowe. Są one wykorzystywane do przetwarzania Twoich roszczeń o odszkodowanie za lot i informowania Cię o postępach.';

  @override
  String get accountSettings => 'Ustawienia Konta';

  @override
  String get accessibilityOptions => 'Opcje Dostępności';

  @override
  String get configureAccessibilityDescription => 'Skonfiguruj wysoki kontrast, duży tekst i obsługę czytnika ekranu';

  @override
  String get configureNotificationsDescription => 'Skonfiguruj sposób otrzymywania aktualizacji dotyczących roszczeń';

  @override
  String get tipProfileUpToDate => 'Aktualizuj swój profil, aby zapewnić płynne przetwarzanie roszczeń.';

  @override
  String get tipInformationPrivate => 'Twoje informacje są prywatne i wykorzystywane wyłącznie do celów roszczeń o odszkodowanie.';

  @override
  String get tipContactDetails => 'Upewnij się, że Twoje dane kontaktowe są poprawne, abyśmy mogli się z Tobą skontaktować w sprawie Twojego roszczenia.';

  @override
  String get tipAccessibilitySettings => 'Sprawdź ustawienia dostępności, aby dostosować aplikację do swoich potrzeb.';

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
  String get flightDate => 'Data Lotu';

  @override
  String get checkCompensationEligibility => 'Sprawdź Uprawnienie do Odszkodowania';

  @override
  String get supportingDocumentsHint => 'Dołącz karty pokładowe, bilety i inne dokumenty, aby wzmocnić swoje roszczenie.';

  @override
  String get scanDocument => 'Zeskanuj Dokument';

  @override
  String get uploadDocument => 'Prześlij Dokument';

  @override
  String get scanDocumentHint => 'Użyj aparatu, aby automatycznie wypełnić formularz';

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
  String get editPersonalAndContactInformation => 'Edytuj swoje dane osobowe i kontaktowe';

  @override
  String get configureAccessibilityOptions => 'Skonfiguruj opcje dostępności aplikacji';

  @override
  String get configureHighContrastLargeTextAndScreenReaderSupport => 'Skonfiguruj wysoki kontrast, duży tekst i obsługę czytnika ekranu';

  @override
  String get applicationPreferences => 'Preferencje Aplikacji';

  @override
  String get notificationSettings => 'Ustawienia Powiadomień';

  @override
  String get configureNotificationPreferences => 'Skonfiguruj preferencje powiadomień';

  @override
  String get configureHowYouReceiveClaimUpdates => 'Skonfiguruj sposób otrzymywania aktualizacji dotyczących roszczeń';

  @override
  String get language => 'pl';

  @override
  String get changeApplicationLanguage => 'Zmień język aplikacji';

  @override
  String get selectYourPreferredLanguage => 'Wybierz preferowany język';

  @override
  String get tipsAndReminders => 'Wskazówki i Przypomnienia';

  @override
  String get importantTipsAboutProfileInformation => 'Ważne wskazówki dotyczące informacji o Twoim profilu';

  @override
  String get noClaimsYetTitle => 'Brak Roszczeń';

  @override
  String get noClaimsYetSubtitle => 'Rozpocznij składanie wniosku o odszkodowanie, wybierając lot z sekcji Loty kwalifikujące się w UE';

  @override
  String get extractingText => 'Wyodrębnianie tekstu i identyfikacja pól';

  @override
  String get scanInstructions => 'Umieść dokument w ramce i zrób zdjęcie';

  @override
  String get formFilledWithScannedData => 'Formularz wypełniony danymi z zeskanowanego dokumentu';

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
  String get euWideEligibleFlights => 'Loty kwalifikujące się do odszkodowania w całej UE';

  @override
  String get requiredFieldsCompleted => 'Wszystkie wymagane pola są wypełnione.';

  @override
  String get scanningDocumentsNote => 'Skanowanie dokumentów może wstępnie wypełnić niektóre pola.';

  @override
  String get tipCheckEligibility => '• Upewnij się, że Twój lot kwalifikuje się do odszkodowania (np. opóźnienie >3h, odwołanie, odmowa wejścia na pokład).';

  @override
  String get tipDoubleCheckDetails => '• Sprawdź wszystkie szczegóły przed złożeniem, aby uniknąć opóźnień.';

  @override
  String get tooltipFaqHelp => 'Przejdź do często zadawanych pytań i sekcji pomocy';

  @override
  String formSubmissionError(String errorMessage) {
    return 'Błąd podczas wysyłania formularza: $errorMessage. Sprawdź połączenie i spróbuj ponownie.';
  }

  @override
  String get networkError => 'Network error. Please check your internet connection.';

  @override
  String get generalError => 'An unexpected error occurred. Please try again later.';

  @override
  String get loginRequiredForClaim => 'You must be logged in to submit a claim.';

  @override
  String get quickClaimTitle => 'Quick Claim';

  @override
  String get quickClaimInfoBanner => 'For EU-eligible flights. Fill in basic info for a quick preliminary check.';

  @override
  String get flightNumberHintQuickClaim => 'Usually a 2-letter airline code and digits, e.g. LH1234';

  @override
  String get departureAirportHintQuickClaim => 'e.g. FRA for Frankfurt, LHR for London Heathrow';

  @override
  String get arrivalAirportHintQuickClaim => 'e.g. JFK for New York, CDG for Paris';

  @override
  String get reasonForClaimLabel => 'Powód Roszczenia (np. Opóźnienie > 3h)';

  @override
  String get reasonForClaimHint => 'Proszę wprowadź powód';

  @override
  String get compensationAmountOptionalLabel => 'Compensation Amount (optional)';

  @override
  String get compensationAmountHint => 'If you know the amount you are eligible for, enter it here';

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
  String get dialogContentClaimSubmitted => 'Your claim has been submitted successfully.';

  @override
  String get dialogButtonOK => 'OK';

  @override
  String get documentManagementTitle => 'Zarządzanie dokumentami';

  @override
  String get attachDocumentsTitle => 'Attach Documents';

  @override
  String get uploadNewButton => 'Upload New';

  @override
  String get continueButton => 'Continue';

  @override
  String get noDocumentsMessage => 'You have no documents.';

  @override
  String get uploadFirstDocumentButton => 'Upload First Document';

  @override
  String get uploadingMessage => 'Uploading document...';

  @override
  String get uploadSuccessMessage => 'Document uploaded successfully!';

  @override
  String get uploadFailedMessage => 'Upload failed. Please try again.';

  @override
  String get claimAttachment => 'Załącznik do roszczenia';

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
  String get errorMustBeLoggedIn => 'You must be logged in to perform this action.';

  @override
  String get errorFailedToSubmitClaim => 'Failed to submit claim. Please try again.';

  @override
  String get dialogTitleError => 'Error';

  @override
  String get validatorFlightNumberRequired => 'Flight number is required.';

  @override
  String get tooltipFlightNumberQuickClaim => 'Enter the flight number (e.g., BA2490).';

  @override
  String get tooltipFlightDateQuickClaim => 'Select the date of your flight.';

  @override
  String get validatorDepartureAirportRequired => 'Departure airport is required.';

  @override
  String get euEligibleFlightsTitle => 'EU Eligible Flights';

  @override
  String get filterByAirlineName => 'Filter by Airline Name';

  @override
  String get loadingFlights => 'Loading eligible flights...';

  @override
  String get errorLoadingFlights => 'Error loading flights';

  @override
  String get noEligibleFlightsFound => 'No eligible flights found.';

  @override
  String get noFlightsMatchFilter => 'No flights match your filter.';

  @override
  String get checkCompensation => 'Check Compensation';

  @override
  String get tooltipDepartureAirportQuickClaim => 'Enter the 3-letter IATA code for the departure airport (e.g., LHR).';

  @override
  String get validatorArrivalAirportRequired => 'Arrival airport is required.';

  @override
  String get tooltipArrivalAirportQuickClaim => 'Enter the 3-letter IATA code for the arrival airport (e.g., JFK).';

  @override
  String get hintTextReasonQuickClaim => 'Reason (delay, cancellation, etc.)';

  @override
  String get validatorReasonRequired => 'Reason for claim is required.';

  @override
  String get tooltipReasonQuickClaim => 'Briefly state the reason for your claim (e.g., 4-hour delay).';

  @override
  String get tooltipCompensationAmountQuickClaim => 'Enter the compensation amount if known (e.g., 250 EUR).';

  @override
  String get tipsAndRemindersTitle => 'Tips & Reminders';

  @override
  String get tipSecureData => '• Your data is stored securely and used only for claim processing.';

  @override
  String compensationEligibleArrivalsAt(String airportIcao) {
    return 'Przyloty kwalifikujące się do odszkodowania na $airportIcao';
  }

  @override
  String errorWithDetails(String error) {
    return 'Błąd: $error';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get signInToTrackClaims => 'Sign in to track your claims';

  @override
  String get createAccountDescription => 'Create an account or sign in to manage your compensation claims.';

  @override
  String get signInOrSignUp => 'Sign In / Sign Up';

  @override
  String get genericUser => 'User';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get carrierName => 'Nazwa przewoźnika';

  @override
  String get pickDate => 'Wybierz datę';

  @override
  String get clearDate => 'Wyczyść datę';

  @override
  String get noEligibleArrivalsFound => 'Nie znaleziono przylotów kwalifikujących się do odszkodowania dla wybranych filtrów.';

  @override
  String flightAndAirline(String flightNumber, String airlineName) {
    return '$flightNumber - $airlineName';
  }

  @override
  String scheduledTime(String time) {
    return 'Planowo: $time';
  }

  @override
  String fromAirportName(String airportName) {
    return 'Z: $airportName';
  }

  @override
  String revisedTime(String time) {
    return 'Zmieniono: $time';
  }

  @override
  String status(String status) {
    return 'Status: $status';
  }

  @override
  String get euCompensationEligible => 'Kwalifikuje się do odszkodowania UE';

  @override
  String actualTime(String time) {
    return 'Rzeczywiście: $time';
  }

  @override
  String delayAmount(String delay) {
    return 'Opóźnienie: $delay';
  }

  @override
  String aircraftModel(String model) {
    return 'Samolot: $model';
  }

  @override
  String compensationAmount(String amount) {
    return 'Odszkodowanie: $amount';
  }

  @override
  String get flightNumberLabel => 'Numer Lotu';

  @override
  String get flightNumberHint => 'Proszę wprowadź numer lotu';

  @override
  String get departureAirportLabel => 'Lotnisko Wylotu (IATA)';

  @override
  String get departureAirportHint => 'Proszę wprowadź lotnisko wylotu';

  @override
  String get arrivalAirportLabel => 'Lotnisko Przylotu (IATA)';

  @override
  String get arrivalAirportHint => 'Proszę wprowadź lotnisko przylotu';

  @override
  String get flightDateLabel => 'Data Lotu';

  @override
  String get flightDateHint => 'Wybierz datę lotu';

  @override
  String get flightDateError => 'Proszę wybierz datę lotu';

  @override
  String get continueToAttachmentsButton => 'Przejdź do Załączników';

  @override
  String get fieldValue => 'Wartość Pola';

  @override
  String get errorConnectionFailed => 'Błąd połączenia. Sprawdź swoje połączenie sieciowe.';

  @override
  String get submitNewClaimTitle => 'Złóż Nowe Roszczenie';

  @override
  String get airlineLabel => 'Linia Lotnicza';

  @override
  String get other => 'Other';

  @override
  String get documentTypeBoardingPass => 'Boarding Pass';

  @override
  String get documentTypeId => 'ID Document';

  @override
  String get documentTypeTicket => 'Ticket';

  @override
  String get documentTypeBookingConfirmation => 'Booking Confirmation';

  @override
  String get documentTypeETicket => 'E-Ticket';

  @override
  String get documentTypeLuggageTag => 'Luggage Tag';

  @override
  String get documentTypeDelayConfirmation => 'Delay Confirmation';

  @override
  String get documentTypeHotelReceipt => 'Hotel Receipt';

  @override
  String get documentTypeMealReceipt => 'Meal Receipt';

  @override
  String get documentTypeTransportReceipt => 'Transport Receipt';

  @override
  String get documentTypeOther => 'Inny';
}
