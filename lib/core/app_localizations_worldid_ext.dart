import 'package:f35_flight_compensation/l10n2/app_localizations.dart';

/// Lightweight localization extension for World ID strings.
/// This avoids touching the generated ARB pipeline and works immediately.
/// When ARB is fixed/regenerated, these can be migrated to ARB-backed keys.
extension WorldIdL10nExt on AppLocalizations {
  String get _lang {
    final l = localeName.toLowerCase();
    if (l.startsWith('pl')) return 'pl';
    if (l.startsWith('de')) return 'de';
    if (l.startsWith('es')) return 'es';
    if (l.startsWith('fr')) return 'fr';
    if (l.startsWith('pt')) return 'pt';
    return 'en';
  }

  String get worldIdVerifyTitle {
    switch (_lang) {
      case 'pl':
        return 'Zweryfikuj z World ID';
      case 'de':
        return 'Mit World ID verifizieren';
      case 'es':
        return 'Verificar con World ID';
      case 'fr':
        return 'Vérifier avec World ID';
      case 'pt':
        return 'Verificar com World ID';
      default:
        return 'Verify with World ID';
    }
  }

  String get worldIdVerifyDesc {
    switch (_lang) {
      case 'pl':
        return 'Zweryfikuj swoją tożsamość prywatnie za pomocą World ID. Pomaga to zapobiegać nadużyciom i utrzymać aplikację bezpłatną.';
      case 'de':
        return 'Bestätigen Sie Ihre Identität privat mit World ID. Dies hilft Missbrauch zu verhindern und die App kostenlos zu halten.';
      case 'es':
        return 'Verifique su identidad de forma privada con World ID. Esto nos ayuda a prevenir abusos y mantener la app gratuita.';
      case 'fr':
        return 'Vérifiez votre identité en toute confidentialité avec World ID. Cela nous aide à prévenir les abus tout en gardant l’application gratuite.';
      case 'pt':
        return 'Verifique a sua identidade de forma privada com o World ID. Isso ajuda a prevenir abusos e a manter a aplicação gratuita.';
      default:
        return 'Verify your identity privately using World ID. This helps us prevent abuse while keeping the app free.';
    }
  }

  String get worldIdVerifySemantic {
    switch (_lang) {
      case 'pl':
        return 'Zweryfikuj swoją tożsamość (Worldcoin World ID). Dostępne tylko w wersji web.';
      case 'de':
        return 'Verifizieren Sie Ihre Identität mit Worldcoin World ID. Derzeit nur im Web verfügbar.';
      case 'es':
        return 'Verifique su humanidad con Worldcoin World ID. Solo disponible en la web por ahora.';
      case 'fr':
        return 'Vérifiez votre identité avec Worldcoin World ID. Pour l’instant disponible uniquement sur le Web.';
      case 'pt':
        return 'Verifique a sua identidade com o Worldcoin World ID. Apenas na Web por enquanto.';
      default:
        return 'Verify your humanity with Worldcoin World ID. Web only for now.';
    }
  }

  String get worldIdTemporarilyUnavailable {
    switch (_lang) {
      case 'pl':
        return 'World ID jest tymczasowo niedostępny. Spróbuj ponownie później.';
      case 'de':
        return 'World ID ist vorübergehend nicht verfügbar. Bitte versuchen Sie es später erneut.';
      case 'es':
        return 'World ID no está disponible temporalmente. Por favor, inténtelo más tarde.';
      case 'fr':
        return 'World ID est temporairement indisponible. Veuillez réessayer plus tard.';
      case 'pt':
        return 'O World ID está temporariamente indisponível. Tente novamente mais tarde.';
      default:
        return 'World ID is temporarily unavailable. Please try again later.';
    }
  }

  // Success and error messages
  String get worldIdVerified {
    switch (_lang) {
      case 'pl':
        return 'World ID zweryfikowany';
      case 'de':
        return 'World ID verifiziert';
      case 'es':
        return 'World ID verificado';
      case 'fr':
        return 'World ID vérifié';
      case 'pt':
        return 'World ID verificado';
      default:
        return 'World ID verified';
    }
  }

  String get worldIdBackendMissingAppId {
    switch (_lang) {
      case 'pl':
        return 'Brak konfiguracji WLD_APP_ID po stronie serwera. Skonfiguruj i wdroż ponownie.';
      case 'de':
        return 'Backend: WLD_APP_ID fehlt. Bitte konfigurieren und erneut deployen.';
      case 'es':
        return 'Falta WLD_APP_ID en el backend. Configúrelo y vuelva a desplegar.';
      case 'fr':
        return 'WLD_APP_ID manquant côté serveur. Configurez-le et redéployez.';
      case 'pt':
        return 'WLD_APP_ID ausente no backend. Configure e faça novo deploy.';
      default:
        return 'Backend missing WLD_APP_ID. Configure it and redeploy.';
    }
  }

  String worldIdVerificationFailed(String code, String? message) {
    final suffix = (message != null && message.isNotEmpty) ? ' $message' : '';
    switch (_lang) {
      case 'pl':
        return 'Weryfikacja nie powiodła się: ${code.isEmpty ? 'BŁĄD' : code}$suffix';
      case 'de':
        return 'Verifizierung fehlgeschlagen: ${code.isEmpty ? 'FEHLER' : code}$suffix';
      case 'es':
        return 'La verificación falló: ${code.isEmpty ? 'ERROR' : code}$suffix';
      case 'fr':
        return 'Échec de la vérification : ${code.isEmpty ? 'ERREUR' : code}$suffix';
      case 'pt':
        return 'Falha na verificação: ${code.isEmpty ? 'ERRO' : code}$suffix';
      default:
        return 'Verification failed: ${code.isEmpty ? 'ERROR' : code}$suffix';
    }
  }

  String get worldAppSignInTitle {
    switch (_lang) {
      case 'pl':
        return 'Zaloguj się w World App';
      case 'de':
        return 'Mit World App anmelden';
      case 'es':
        return 'Iniciar sesión con World App';
      case 'fr':
        return 'Se connecter avec World App';
      case 'pt':
        return 'Entrar com o World App';
      default:
        return 'Sign in with World App';
    }
  }
  String get worldAppSignInDesc => _lang == 'pl'
      ? 'Zaloguj się w World App, aby zweryfikować swoją tożsamość. To pomaga zapobiegać nadużyciom i utrzymać aplikację bezpłatną.'
      : _lang == 'de'
          ? 'Melden Sie sich mit der World App an, um Ihre Identität zu verifizieren. Das hilft, Missbrauch zu verhindern und die App kostenlos zu halten.'
          : _lang == 'es'
              ? 'Inicie sesión con World App para verificar su identidad. Esto ayuda a prevenir abusos y mantener la app gratuita.'
              : _lang == 'fr'
                  ? 'Connectez-vous avec World App pour vérifier votre identité. Cela aide à prévenir les abus tout en gardant l’application gratuite.'
                  : _lang == 'pt'
                      ? 'Entre com o World App para verificar a sua identidade. Isso ajuda a prevenir abusos e manter a aplicação gratuita.'
                      : 'Sign in with World App to verify your identity. This helps prevent abuse while keeping the app free.';

  String get worldAppOpenError {
    switch (_lang) {
      case 'pl':
        return 'Nie udało się otworzyć World App. Spróbuj ponownie.';
      case 'de':
        return 'World App konnte nicht geöffnet werden. Bitte erneut versuchen.';
      case 'es':
        return 'No se pudo abrir World App. Por favor, inténtelo de nuevo.';
      case 'fr':
        return 'Impossible d’ouvrir World App. Veuillez réessayer.';
      case 'pt':
        return 'Não foi possível abrir o World App. Tente novamente.';
      default:
        return 'Could not open World App. Please try again.';
    }
  }
  String worldAppOpenException(String error) {
    switch (_lang) {
      case 'pl':
        return 'Błąd podczas otwierania World App: $error';
      case 'de':
        return 'Fehler beim Öffnen der World App: $error';
      case 'es':
        return 'Error al abrir World App: $error';
      case 'fr':
        return 'Erreur lors de l’ouverture de World App : $error';
      case 'pt':
        return 'Erro ao abrir o World App: $error';
      default:
        return 'Error opening World App: $error';
    }
  }

  String get worldIdOidcTitle {
    switch (_lang) {
      case 'pl':
        return 'Zaloguj się World ID (OIDC)';
      case 'de':
        return 'Mit World ID anmelden (OIDC)';
      case 'es':
        return 'Iniciar sesión con World ID (OIDC)';
      case 'fr':
        return 'Se connecter avec World ID (OIDC)';
      case 'pt':
        return 'Entrar com World ID (OIDC)';
      default:
        return 'Sign in with World ID (OIDC)';
    }
  }
  String get worldIdOidcDesc {
    switch (_lang) {
      case 'pl':
        return 'Zaloguj się przez World ID z użyciem bezpiecznego OIDC + PKCE.';
      case 'de':
        return 'Melden Sie sich mit World ID über sicheres OIDC + PKCE an.';
      case 'es':
        return 'Inicie sesión con World ID mediante OIDC + PKCE seguro.';
      case 'fr':
        return 'Connectez-vous avec World ID via OIDC + PKCE sécurisé.';
      case 'pt':
        return 'Entre com o World ID através de OIDC + PKCE seguro.';
      default:
        return 'Sign in with World ID via secure OIDC + PKCE.';
    }
  }
}
