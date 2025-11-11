// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'BarberGO';

  @override
  String get tabDiscovery => 'Descobrir';

  @override
  String get tabApplications => 'Candidaturas';

  @override
  String get tabInbox => 'Inbox';

  @override
  String get tabAiStudio => 'AI Studio';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get tabMyVacancies => 'Minhas Vagas';

  @override
  String get fieldRequired => 'Campo obrigatório';

  @override
  String get error => 'Erro';

  @override
  String get loading => 'Carregando...';

  @override
  String get logout => 'Sair da Conta';

  @override
  String get profileScreenTitle => 'Meu Perfil';

  @override
  String get onboardingScreenTitle => 'Complete seu Cadastro';

  @override
  String get accountType => 'Tipo de Conta';

  @override
  String get barber => 'Barbeiro(a)';

  @override
  String get barbershop => 'Barbearia';

  @override
  String get nameLabel => 'Nome Completo ou Nome da Barbearia';

  @override
  String get locationLabel => 'Localização (Ex: Cidade, Estado)';

  @override
  String get phoneLabel => 'Telefone de Contato';

  @override
  String get bioLabel => 'Biografia ou Descrição dos Serviços';

  @override
  String get saveChangesButton => 'SALVAR ALTERAÇÕES';

  @override
  String get completeRegistrationButton => 'CONCLUIR CADASTRO';

  @override
  String get profileSavedSuccess => 'Perfil salvo com sucesso!';

  @override
  String get swipeToApply => 'Arraste → para Candidatar-se';

  @override
  String get noVacanciesFound =>
      'Nenhuma vaga ativa encontrada no momento. Volte mais tarde!';

  @override
  String applicationSentTo(Object barbershopName) {
    return 'Candidatura enviada para: $barbershopName';
  }

  @override
  String get requirementsTitle => 'Requisitos:';

  @override
  String get noRequirementsSpecified =>
      'A barbearia não especificou requisitos detalhados.';

  @override
  String commissionLabel(Object percentage) {
    return '$percentage% Comissão';
  }

  @override
  String get viewPhotos => 'Ver Fotos';

  @override
  String get viewRequirements => 'Ver Requisitos';

  @override
  String get publishNewVacancy => 'Publicar Nova Vaga';

  @override
  String get createVacancyTitle => 'Publicar Nova Vaga';

  @override
  String get vacancyTitleLabel => 'Título da Vaga (Ex: Barbeiro Freelancer)';

  @override
  String get vacancyTypeLabel => 'Tipo de Contratação';

  @override
  String get freelancer => 'Freelancer';

  @override
  String get clt => 'CLT (Fixo)';

  @override
  String get commissioned => 'Comissionado (%)';

  @override
  String get commissionPercentageLabel => 'Porcentagem da Comissão (%)';

  @override
  String get workHoursLabel =>
      'Horário de Trabalho (Ex: Terça a Sábado, 9h às 19h)';

  @override
  String get requirementsOptionalLabel =>
      'Requisitos e Experiências (Opcional)';

  @override
  String get vacancyCreatedSuccess => 'Vaga criada com sucesso!';

  @override
  String get manageCandidatesTitle => 'Gerenciar Candidatos';

  @override
  String get applicationsReceivedTitle => 'Candidaturas Recebidas:';

  @override
  String get noApplicationsYet => 'Nenhum barbeiro se candidatou ainda.';

  @override
  String get rejectButton => 'Rejeitar';

  @override
  String get acceptAndOpenChatButton => 'Aceitar e Abrir Chat';

  @override
  String get statusActive => 'ATIVA';

  @override
  String get statusPaused => 'PAUSADA';

  @override
  String get pauseVacancy => 'Pausar Vaga';

  @override
  String get reopenVacancy => 'Reabrir Vaga';

  @override
  String confirmPauseReopen(Object action) {
    return 'Tem certeza que deseja $action esta vaga? Vagas pausadas não aparecem na busca.';
  }

  @override
  String get startConversation => 'INICIAR CONVERSA';

  @override
  String get continueBrowsing => 'Continuar Navegando';

  @override
  String get itsAMatch => 'É um Match! 🎉';

  @override
  String matchMessage(Object userName) {
    return 'Você e $userName combinaram! Agora vocês podem conversar.';
  }

  @override
  String get typeMessageHint => 'Digite sua mensagem...';

  @override
  String get noConversationsYet => 'Nenhuma conversa iniciada ainda.';

  @override
  String get noNotificationsYet => 'Nenhuma notificação por enquanto.';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get markAllAsRead => 'Marcar todas como lidas';

  @override
  String get aiStudioTitle => 'BarberGO AI Studio';

  @override
  String get aiStudioDescription =>
      'Ferramentas inteligentes para impulsionar sua carreira e seu negócio.';

  @override
  String get forYourCareer => 'Para Sua Carreira';

  @override
  String get forYourBusiness => 'Para Seu Negócio';

  @override
  String get generalTools => 'Ferramentas Gerais';

  @override
  String get errorLoadingProfile => 'Erro ao carregar perfil.';

  @override
  String get errorLoadingChat => 'Erro ao carregar o chat.';

  @override
  String get authError => 'Usuário não autenticado.';

  @override
  String get locationRequiredForVacancy =>
      'Atualize sua localização exata (GPS) no Perfil antes de criar vagas.';

  @override
  String get locationPermissionDenied => 'Permissão de localização negada.';

  @override
  String get gpsCaptureRequired =>
      'Por favor, capture sua localização (GPS) antes de salvar.';

  @override
  String get errorLoadingMatch => 'Erro ao carregar tela de Match.';

  @override
  String get portfolioLimitReached =>
      'Limite de 6 fotos no portfólio atingido.';

  @override
  String get removeImage => 'Remover Imagem';

  @override
  String get confirmRemoveImage =>
      'Tem certeza que deseja remover esta imagem do seu portfólio?';
}
