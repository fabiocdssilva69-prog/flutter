import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/vacancy_entity.dart';
import '../providers/multi_ai_provider.dart';

part 'contract_generator_controller.g.dart';

/// Tipos de documento que podem ser gerados
enum DocumentType {
  workContract, // Contrato de trabalho
  serviceAgreement, // Acordo de prestação de serviços
  commissionAgreement, // Acordo de comissão
  termsOfService, // Termos de serviço
  privacyPolicy, // Política de privacidade
  ndaAgreement, // Acordo de confidencialidade
}

/// Controller para geração de documentos legais usando Claude 3.5 Sonnet
@riverpod
class ContractGenerator extends _$ContractGenerator {
  @override
  FutureOr<String?> build() => null;

  /// Gera contrato de trabalho completo
  Future<String> generateWorkContract({
    required UserEntity barbershop,
    required UserEntity barber,
    required VacancyEntity vacancy,
    DateTime? startDate,
    double? salary,
    Map<String, dynamic>? additionalClauses,
  }) async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final params = {
        'document_type': 'Contrato de Trabalho',
        'barbershop': {'name': barbershop.name, 'email': barbershop.email},
        'barber': {'name': barber.name, 'email': barber.email},
        'vacancy': {
          'title': vacancy.title,
          'type': vacancy.type.name,
          'workHours': vacancy.workHours,
          'commission': vacancy.commissionPercentage,
        },
        'startDate': startDate?.toIso8601String() ?? 'A definir',
        'salary': salary != null
            ? 'R\$ ${salary.toStringAsFixed(2)}'
            : 'Conforme acordo',
        'additionalClauses': additionalClauses ?? {},
      };

      final prompt = _buildContractPrompt(params);
      final contract = await claudeService.generateLongText(
        prompt: prompt,
        maxTokens: 6000, // Contratos são longos
      );

      state = AsyncValue.data(contract);
      return contract;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  String _buildContractPrompt(Map<String, dynamic> params) {
    return '''
Gere um CONTRATO DE TRABALHO profissional e juridicamente adequado para o Brasil:

DADOS DAS PARTES:
Empregador (Barbearia): ${params['barbershop']['name']}
Empregado (Barbeiro): ${params['barber']['name']}

DADOS DO CARGO:
Título: ${params['vacancy']['title']}
Tipo: ${params['vacancy']['type']}
Horário: ${params['vacancy']['workHours']}
${params['vacancy']['commission'] != null ? 'Comissão: ${params['vacancy']['commission']}%' : ''}

DATA DE INÍCIO: ${params['startDate']}
REMUNERAÇÃO: ${params['salary']}

REQUISITOS DO DOCUMENTO:
1. Estrutura formal de contrato trabalhista brasileiro
2. Cláusulas essenciais:
   - Qualificação das partes
   - Objeto do contrato
   - Remuneração e benefícios
   - Jornada de trabalho
   - Direitos e deveres
   - Rescisão
   - Confidencialidade
   - Foro competente
3. Linguagem jurídica apropriada
4. Compliance com CLT (Consolidação das Leis do Trabalho)
5. LGPD (Lei Geral de Proteção de Dados)
6. Formatação em Markdown com seções numeradas

IMPORTANTE:
- Inclua campos para assinaturas digitais
- Data por extenso
- Testemunhas (2)
- Cláusulas de proteção para ambas as partes
''';
  }

  /// Gera acordo de prestação de serviços (Freelance)
  Future<String> generateServiceAgreement({
    required UserEntity barbershop,
    required UserEntity barber,
    required VacancyEntity vacancy,
    required double hourlyRate,
  }) async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final document = await claudeService.generateDocument(
        documentType: 'Acordo de Prestação de Serviços',
        params: {
          'contratante': barbershop.name,
          'prestador': barber.name,
          'servico': vacancy.title,
          'valor_hora': 'R\$ ${hourlyRate.toStringAsFixed(2)}',
          'modalidade': 'Freelancer/Autônomo',
        },
      );

      state = AsyncValue.data(document);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera acordo de comissão
  Future<String> generateCommissionAgreement({
    required UserEntity barbershop,
    required UserEntity barber,
    required double commissionPercentage,
    String? paymentTerms,
  }) async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final document = await claudeService.generateDocument(
        documentType: 'Acordo de Comissão sobre Serviços',
        params: {
          'barbearia': barbershop.name,
          'barbeiro': barber.name,
          'percentual_comissao': '$commissionPercentage%',
          'forma_pagamento': paymentTerms ?? 'Semanal',
          'base_calculo': 'Valor total dos serviços prestados',
        },
      );

      state = AsyncValue.data(document);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera termos de serviço do app
  Future<String> generateTermsOfService() async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final document = await claudeService.generateDocument(
        documentType: 'Termos de Serviço - BarberGO App',
        params: {
          'app_name': 'BarberGO',
          'description': 'Plataforma de conexão entre barbeiros e barbearias',
          'services': 'Matching, Comunicação, Gestão de Vagas',
          'user_types': 'Barbeiros e Barbearias',
          'compliance': 'LGPD, Marco Civil da Internet',
        },
      );

      state = AsyncValue.data(document);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera política de privacidade
  Future<String> generatePrivacyPolicy() async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final document = await claudeService.generateDocument(
        documentType: 'Política de Privacidade - BarberGO',
        params: {
          'app_name': 'BarberGO',
          'data_collected':
              'Nome, Email, Telefone, Localização, Fotos de Portfólio',
          'data_usage': 'Matching, Comunicação, Melhoria do Serviço',
          'data_sharing': 'Apenas entre usuários conectados',
          'user_rights': 'Acesso, Correção, Exclusão, Portabilidade',
          'lgpd_compliance': 'Sim',
          'dpo_contact': 'privacy@barbergo.app',
        },
      );

      state = AsyncValue.data(document);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Gera NDA (Acordo de Confidencialidade)
  Future<String> generateNDA({
    required String party1Name,
    required String party2Name,
  }) async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final document = await claudeService.generateDocument(
        documentType: 'Acordo de Confidencialidade (NDA)',
        params: {
          'parte_1': party1Name,
          'parte_2': party2Name,
          'objeto':
              'Informações comerciais e técnicas trocadas durante negociação',
          'prazo': '2 anos',
          'penalidades': 'Conforme legislação brasileira',
        },
      );

      state = AsyncValue.data(document);
      return document;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Personaliza documento existente
  Future<String> customizeDocument({
    required String baseDocument,
    required Map<String, String> replacements,
  }) async {
    state = const AsyncLoading();

    try {
      final claudeService = ref.read(claudeServiceProvider.notifier);

      final prompt =
          '''
Personalize este documento substituindo os seguintes campos:

${replacements.entries.map((e) => '${e.key} → ${e.value}').join('\n')}

DOCUMENTO BASE:
$baseDocument

Retorne o documento personalizado mantendo toda a estrutura e formatação.
''';

      final customized = await claudeService.generateLongText(
        prompt: prompt,
        maxTokens: 8000,
      );

      state = AsyncValue.data(customized);
      return customized;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
