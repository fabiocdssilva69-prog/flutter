import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'BarberGO'**
  String get appTitle;

  /// No description provided for @tabDiscovery.
  ///
  /// In pt, this message translates to:
  /// **'Descobrir'**
  String get tabDiscovery;

  /// No description provided for @tabApplications.
  ///
  /// In pt, this message translates to:
  /// **'Candidaturas'**
  String get tabApplications;

  /// No description provided for @tabInbox.
  ///
  /// In pt, this message translates to:
  /// **'Inbox'**
  String get tabInbox;

  /// No description provided for @tabAiStudio.
  ///
  /// In pt, this message translates to:
  /// **'AI Studio'**
  String get tabAiStudio;

  /// No description provided for @tabProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get tabProfile;

  /// No description provided for @tabMyVacancies.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Vagas'**
  String get tabMyVacancies;

  /// No description provided for @fieldRequired.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get fieldRequired;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get loading;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Sair da Conta'**
  String get logout;

  /// No description provided for @profileScreenTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meu Perfil'**
  String get profileScreenTitle;

  /// No description provided for @onboardingScreenTitle.
  ///
  /// In pt, this message translates to:
  /// **'Complete seu Cadastro'**
  String get onboardingScreenTitle;

  /// No description provided for @accountType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de Conta'**
  String get accountType;

  /// No description provided for @barber.
  ///
  /// In pt, this message translates to:
  /// **'Barbeiro(a)'**
  String get barber;

  /// No description provided for @barbershop.
  ///
  /// In pt, this message translates to:
  /// **'Barbearia'**
  String get barbershop;

  /// No description provided for @nameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo ou Nome da Barbearia'**
  String get nameLabel;

  /// No description provided for @locationLabel.
  ///
  /// In pt, this message translates to:
  /// **'Localização (Ex: Cidade, Estado)'**
  String get locationLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In pt, this message translates to:
  /// **'Telefone de Contato'**
  String get phoneLabel;

  /// No description provided for @bioLabel.
  ///
  /// In pt, this message translates to:
  /// **'Biografia ou Descrição dos Serviços'**
  String get bioLabel;

  /// No description provided for @saveChangesButton.
  ///
  /// In pt, this message translates to:
  /// **'SALVAR ALTERAÇÕES'**
  String get saveChangesButton;

  /// No description provided for @completeRegistrationButton.
  ///
  /// In pt, this message translates to:
  /// **'CONCLUIR CADASTRO'**
  String get completeRegistrationButton;

  /// No description provided for @profileSavedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Perfil salvo com sucesso!'**
  String get profileSavedSuccess;

  /// No description provided for @swipeToApply.
  ///
  /// In pt, this message translates to:
  /// **'Arraste → para Candidatar-se'**
  String get swipeToApply;

  /// No description provided for @noVacanciesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma vaga ativa encontrada no momento. Volte mais tarde!'**
  String get noVacanciesFound;

  /// No description provided for @applicationSentTo.
  ///
  /// In pt, this message translates to:
  /// **'Candidatura enviada para: {barbershopName}'**
  String applicationSentTo(Object barbershopName);

  /// No description provided for @requirementsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Requisitos:'**
  String get requirementsTitle;

  /// No description provided for @noRequirementsSpecified.
  ///
  /// In pt, this message translates to:
  /// **'A barbearia não especificou requisitos detalhados.'**
  String get noRequirementsSpecified;

  /// No description provided for @commissionLabel.
  ///
  /// In pt, this message translates to:
  /// **'{percentage}% Comissão'**
  String commissionLabel(Object percentage);

  /// No description provided for @viewPhotos.
  ///
  /// In pt, this message translates to:
  /// **'Ver Fotos'**
  String get viewPhotos;

  /// No description provided for @viewRequirements.
  ///
  /// In pt, this message translates to:
  /// **'Ver Requisitos'**
  String get viewRequirements;

  /// No description provided for @publishNewVacancy.
  ///
  /// In pt, this message translates to:
  /// **'Publicar Nova Vaga'**
  String get publishNewVacancy;

  /// No description provided for @createVacancyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Publicar Nova Vaga'**
  String get createVacancyTitle;

  /// No description provided for @vacancyTitleLabel.
  ///
  /// In pt, this message translates to:
  /// **'Título da Vaga (Ex: Barbeiro Freelancer)'**
  String get vacancyTitleLabel;

  /// No description provided for @vacancyTypeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de Contratação'**
  String get vacancyTypeLabel;

  /// No description provided for @freelancer.
  ///
  /// In pt, this message translates to:
  /// **'Freelancer'**
  String get freelancer;

  /// No description provided for @clt.
  ///
  /// In pt, this message translates to:
  /// **'CLT (Fixo)'**
  String get clt;

  /// No description provided for @commissioned.
  ///
  /// In pt, this message translates to:
  /// **'Comissionado (%)'**
  String get commissioned;

  /// No description provided for @commissionPercentageLabel.
  ///
  /// In pt, this message translates to:
  /// **'Porcentagem da Comissão (%)'**
  String get commissionPercentageLabel;

  /// No description provided for @workHoursLabel.
  ///
  /// In pt, this message translates to:
  /// **'Horário de Trabalho (Ex: Terça a Sábado, 9h às 19h)'**
  String get workHoursLabel;

  /// No description provided for @requirementsOptionalLabel.
  ///
  /// In pt, this message translates to:
  /// **'Requisitos e Experiências (Opcional)'**
  String get requirementsOptionalLabel;

  /// No description provided for @vacancyCreatedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Vaga criada com sucesso!'**
  String get vacancyCreatedSuccess;

  /// No description provided for @manageCandidatesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar Candidatos'**
  String get manageCandidatesTitle;

  /// No description provided for @applicationsReceivedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Candidaturas Recebidas:'**
  String get applicationsReceivedTitle;

  /// No description provided for @noApplicationsYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum barbeiro se candidatou ainda.'**
  String get noApplicationsYet;

  /// No description provided for @rejectButton.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar'**
  String get rejectButton;

  /// No description provided for @acceptAndOpenChatButton.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar e Abrir Chat'**
  String get acceptAndOpenChatButton;

  /// No description provided for @statusActive.
  ///
  /// In pt, this message translates to:
  /// **'ATIVA'**
  String get statusActive;

  /// No description provided for @statusPaused.
  ///
  /// In pt, this message translates to:
  /// **'PAUSADA'**
  String get statusPaused;

  /// No description provided for @pauseVacancy.
  ///
  /// In pt, this message translates to:
  /// **'Pausar Vaga'**
  String get pauseVacancy;

  /// No description provided for @reopenVacancy.
  ///
  /// In pt, this message translates to:
  /// **'Reabrir Vaga'**
  String get reopenVacancy;

  /// No description provided for @confirmPauseReopen.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja {action} esta vaga? Vagas pausadas não aparecem na busca.'**
  String confirmPauseReopen(Object action);

  /// No description provided for @startConversation.
  ///
  /// In pt, this message translates to:
  /// **'INICIAR CONVERSA'**
  String get startConversation;

  /// No description provided for @continueBrowsing.
  ///
  /// In pt, this message translates to:
  /// **'Continuar Navegando'**
  String get continueBrowsing;

  /// No description provided for @itsAMatch.
  ///
  /// In pt, this message translates to:
  /// **'É um Match! 🎉'**
  String get itsAMatch;

  /// No description provided for @matchMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você e {userName} combinaram! Agora vocês podem conversar.'**
  String matchMessage(Object userName);

  /// No description provided for @typeMessageHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua mensagem...'**
  String get typeMessageHint;

  /// No description provided for @noConversationsYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma conversa iniciada ainda.'**
  String get noConversationsYet;

  /// No description provided for @noNotificationsYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma notificação por enquanto.'**
  String get noNotificationsYet;

  /// No description provided for @notificationsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Notificações'**
  String get notificationsTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In pt, this message translates to:
  /// **'Marcar todas como lidas'**
  String get markAllAsRead;

  /// No description provided for @aiStudioTitle.
  ///
  /// In pt, this message translates to:
  /// **'BarberGO AI Studio'**
  String get aiStudioTitle;

  /// No description provided for @aiStudioDescription.
  ///
  /// In pt, this message translates to:
  /// **'Ferramentas inteligentes para impulsionar sua carreira e seu negócio.'**
  String get aiStudioDescription;

  /// No description provided for @forYourCareer.
  ///
  /// In pt, this message translates to:
  /// **'Para Sua Carreira'**
  String get forYourCareer;

  /// No description provided for @forYourBusiness.
  ///
  /// In pt, this message translates to:
  /// **'Para Seu Negócio'**
  String get forYourBusiness;

  /// No description provided for @generalTools.
  ///
  /// In pt, this message translates to:
  /// **'Ferramentas Gerais'**
  String get generalTools;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perfil.'**
  String get errorLoadingProfile;

  /// No description provided for @errorLoadingChat.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar o chat.'**
  String get errorLoadingChat;

  /// No description provided for @authError.
  ///
  /// In pt, this message translates to:
  /// **'Usuário não autenticado.'**
  String get authError;

  /// No description provided for @locationRequiredForVacancy.
  ///
  /// In pt, this message translates to:
  /// **'Atualize sua localização exata (GPS) no Perfil antes de criar vagas.'**
  String get locationRequiredForVacancy;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In pt, this message translates to:
  /// **'Permissão de localização negada.'**
  String get locationPermissionDenied;

  /// No description provided for @gpsCaptureRequired.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, capture sua localização (GPS) antes de salvar.'**
  String get gpsCaptureRequired;

  /// No description provided for @errorLoadingMatch.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar tela de Match.'**
  String get errorLoadingMatch;

  /// No description provided for @portfolioLimitReached.
  ///
  /// In pt, this message translates to:
  /// **'Limite de 6 fotos no portfólio atingido.'**
  String get portfolioLimitReached;

  /// No description provided for @removeImage.
  ///
  /// In pt, this message translates to:
  /// **'Remover Imagem'**
  String get removeImage;

  /// No description provided for @confirmRemoveImage.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja remover esta imagem do seu portfólio?'**
  String get confirmRemoveImage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
