# 🎯 Sprint 23: Qualidade de Código, Testes, Internacionalização e Preparação para Beta

**Data Início:** 23 de outubro de 2025  
**Objetivo:** Estabelecer infraestrutura de testes automatizados, implementar internacionalização (i18n), refatorar widgets complexos, limpar código e configurar ícones

---

## 📋 Status Geral

| Item | Status | Prioridade |
|------|--------|-----------|
| Infraestrutura de Testes | 🟡 Em Progresso | P0 |
| Testes Unitários | 🔴 Não Iniciado | P0 |
| Testes de Widget | 🔴 Não Iniciado | P1 |
| Internacionalização (i18n) | 🔴 Não Iniciado | P0 |
| Refatoração de Widgets | 🔴 Não Iniciado | P1 |
| Ícones da Aplicação | 🔴 Não Iniciado | P2 |
| Análise de Qualidade | 🔴 Não Iniciado | P1 |

---

## 🎯 Objetivos da Sprint

### 1. Infraestrutura de Testes (P0)
**Meta:** Configurar ambiente completo para testes automatizados

#### Dependências a Adicionar
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.4          # ✅ JÁ INSTALADO
  mocktail: ^1.0.4         # Alternativa moderna ao mockito
  fake_cloud_firestore: ^3.0.0  # Mock do Firestore
  firebase_auth_mocks: ^0.15.1  # ✅ JÁ INSTALADO
```

#### Estrutura de Diretórios
```
test/
├── unit/
│   ├── services/
│   │   ├── logger_service_test.dart
│   │   ├── notification_service_test.dart
│   │   ├── ai_service_test.dart
│   │   └── auth_service_test.dart
│   ├── repositories/
│   │   ├── vacancy_repository_test.dart
│   │   ├── application_repository_test.dart
│   │   └── profile_repository_test.dart
│   └── models/
│       ├── vacancy_model_test.dart
│       ├── application_model_test.dart
│       └── profile_model_test.dart
├── widget/
│   ├── auth/
│   │   ├── login_screen_test.dart
│   │   └── register_screen_test.dart
│   ├── vacancies/
│   │   ├── vacancy_card_test.dart
│   │   └── vacancy_list_test.dart
│   └── management/
│       ├── application_tile_test.dart
│       └── vacancy_tile_test.dart
├── integration/
│   ├── auth_flow_test.dart
│   ├── vacancy_creation_flow_test.dart
│   └── application_flow_test.dart
└── helpers/
    ├── test_helpers.dart
    ├── mock_factories.dart
    └── firebase_test_setup.dart

integration_test/
├── app_test.dart
├── auth_integration_test.dart  # ✅ JÁ EXISTE
└── e2e_flow_test.dart
```

---

### 2. Testes Unitários (P0)
**Meta:** Cobertura mínima de 80% para serviços críticos

#### Serviços Prioritários
1. **LoggerService** (`lib/src/core/services/logger_service.dart`)
   - ✅ Classe identificada
   - Métodos: `logEvent()`, `logError()`, `logScreenView()`
   - Casos de teste:
     - Sanitização de nomes de eventos (prefixos reservados)
     - Limite de 40 caracteres
     - Integração com Analytics e Crashlytics

2. **NotificationService** (`lib/src/core/services/notification_service.dart`)
   - ✅ Classe identificada
   - Métodos: `_registerToken()`, push handling
   - Casos de teste:
     - Registro de token FCM
     - Recebimento de notificações
     - Navegação por deep links

3. **AiService** (`lib/src/core/services/ai_service.dart`)
   - ✅ Classe identificada
   - Métodos: Chamadas para APIs de IA
   - Casos de teste:
     - Mock de respostas das APIs
     - Tratamento de erros
     - Rate limiting

#### Exemplo de Teste Unitário
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:barbergo_app/src/core/services/logger_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  group('LoggerService', () {
    late LoggerService loggerService;
    late MockFirebaseAnalytics mockAnalytics;

    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      loggerService = LoggerService(analytics: mockAnalytics);
    });

    test('should sanitize reserved event name prefixes', () async {
      // Arrange
      const eventName = 'firebase_test_event';
      
      // Act
      await loggerService.logEvent(eventName);
      
      // Assert
      verify(mockAnalytics.logEvent(
        name: 'app_test_event', // firebase_ removido
        parameters: any,
      )).called(1);
    });

    test('should truncate event names longer than 40 characters', () async {
      // Arrange
      const longEventName = 'a' * 50;
      
      // Act
      await loggerService.logEvent(longEventName);
      
      // Assert
      verify(mockAnalytics.logEvent(
        name: argThat(hasLength(40)),
        parameters: any,
      )).called(1);
    });
  });
}
```

---

### 3. Internacionalização (i18n) - P0
**Meta:** Suportar Português (BR) e Inglês (US)

#### Configuração

**1. Adicionar dependências ao pubspec.yaml:**
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0  # ✅ JÁ INSTALADO
```

**2. Criar l10n.yaml na raiz do projeto:**
```yaml
arb-dir: lib/l10n
template-arb-file: app_pt_BR.arb
output-localization-file: app_localizations.dart
```

**3. Estrutura de arquivos:**
```
lib/
└── l10n/
    ├── app_pt_BR.arb  # Português (padrão)
    └── app_en_US.arb  # Inglês
```

#### Arquivo ARB - Português (app_pt_BR.arb)
```json
{
  "@@locale": "pt_BR",
  "appTitle": "BarberGo",
  "@appTitle": {
    "description": "Nome do aplicativo"
  },
  "loginTitle": "Entrar",
  "loginEmail": "E-mail",
  "loginPassword": "Senha",
  "loginButton": "Entrar",
  "loginForgotPassword": "Esqueceu a senha?",
  "loginNoAccount": "Não tem conta? Cadastre-se",
  
  "registerTitle": "Criar Conta",
  "registerName": "Nome completo",
  "registerAccountType": "Tipo de conta",
  "registerBarber": "Barbeiro",
  "registerBarbershop": "Barbearia",
  
  "vacanciesTitle": "Vagas Disponíveis",
  "vacanciesFilter": "Filtrar",
  "vacanciesNoResults": "Nenhuma vaga encontrada",
  "vacancyApply": "Candidatar",
  
  "myApplicationsTitle": "Minhas Candidaturas",
  "applicationStatusPending": "Pendente",
  "applicationStatusAccepted": "Aceita",
  "applicationStatusRejected": "Rejeitada",
  
  "errorGeneric": "Ocorreu um erro. Tente novamente.",
  "errorNetwork": "Erro de conexão. Verifique sua internet.",
  "errorAuth": "Email ou senha incorretos.",
  
  "commonSave": "Salvar",
  "commonCancel": "Cancelar",
  "commonDelete": "Excluir",
  "commonEdit": "Editar",
  "commonBack": "Voltar"
}
```

#### Arquivo ARB - Inglês (app_en_US.arb)
```json
{
  "@@locale": "en_US",
  "appTitle": "BarberGo",
  "loginTitle": "Sign In",
  "loginEmail": "Email",
  "loginPassword": "Password",
  "loginButton": "Sign In",
  "loginForgotPassword": "Forgot password?",
  "loginNoAccount": "No account? Sign up",
  
  "registerTitle": "Create Account",
  "registerName": "Full name",
  "registerAccountType": "Account type",
  "registerBarber": "Barber",
  "registerBarbershop": "Barbershop",
  
  "vacanciesTitle": "Available Jobs",
  "vacanciesFilter": "Filter",
  "vacanciesNoResults": "No jobs found",
  "vacancyApply": "Apply",
  
  "myApplicationsTitle": "My Applications",
  "applicationStatusPending": "Pending",
  "applicationStatusAccepted": "Accepted",
  "applicationStatusRejected": "Rejected",
  
  "errorGeneric": "An error occurred. Please try again.",
  "errorNetwork": "Connection error. Check your internet.",
  "errorAuth": "Incorrect email or password.",
  
  "commonSave": "Save",
  "commonCancel": "Cancel",
  "commonDelete": "Delete",
  "commonEdit": "Edit",
  "commonBack": "Back"
}
```

#### Configurar MaterialApp
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ],
  // ...
)
```

#### Uso nas telas
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.vacanciesTitle), // "Vagas Disponíveis" ou "Available Jobs"
    ),
    body: Center(
      child: Text(l10n.vacanciesNoResults),
    ),
  );
}
```

---

### 4. Refatoração de Widgets (P1)
**Meta:** Reduzir complexidade e melhorar reutilização

#### Widgets para Refatorar
1. **VacancyCard** - Extrair subwidgets
2. **ApplicationTile** - Simplificar lógica de estado
3. **ProfileScreen** - Dividir em seções
4. **LoginScreen** - Extrair form fields

#### Princípios SOLID a Aplicar
- **S**ingle Responsibility: Cada widget tem uma única responsabilidade
- **O**pen/Closed: Extensível sem modificar código existente
- **L**iskov Substitution: Subwidgets substituíveis
- **I**nterface Segregation: Interfaces mínimas
- **D**ependency Inversion: Depender de abstrações (Riverpod)

#### Exemplo de Refatoração
**Antes:**
```dart
class VacancyCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          // 200 linhas de código complexo
          Text(vacancy.title),
          Text(vacancy.description),
          Row(
            children: [
              Icon(Icons.location),
              Text(vacancy.location),
            ],
          ),
          ElevatedButton(
            onPressed: () { /* lógica complexa */ },
            child: Text('Candidatar'),
          ),
        ],
      ),
    );
  }
}
```

**Depois:**
```dart
class VacancyCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          _VacancyHeader(vacancy: vacancy),
          _VacancyBody(vacancy: vacancy),
          _VacancyFooter(vacancy: vacancy),
        ],
      ),
    );
  }
}

class _VacancyHeader extends StatelessWidget { /* ... */ }
class _VacancyBody extends StatelessWidget { /* ... */ }
class _VacancyFooter extends ConsumerWidget { /* ... */ }
```

---

### 5. Ícones da Aplicação (P2)
**Meta:** Configurar ícones para Android e iOS

#### Configuração

**1. Adicionar dependência:**
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

**2. Criar flutter_launcher_icons.yaml:**
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  
  # Configurações Android
  android_adaptive_icon_background: "#FFFFFF"
  android_adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
  
  # Configurações iOS
  remove_alpha_ios: true
  
  # Configurações Web
  web:
    generate: true
    image_path: "assets/icons/app_icon.png"
    background_color: "#FFFFFF"
    theme_color: "#000000"
```

**3. Estrutura de assets:**
```
assets/
└── icons/
    ├── app_icon.png (1024x1024)
    └── app_icon_foreground.png (432x432 para Android Adaptive)
```

**4. Gerar ícones:**
```bash
flutter pub run flutter_launcher_icons
```

---

### 6. Análise de Qualidade de Código (P1)
**Meta:** Corrigir todos os warnings, aplicar linting rigoroso

#### Melhorar analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  
  errors:
    missing_required_param: error
    missing_return: error
    todo: ignore
    deprecated_member_use: warning
  
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mapper.dart"
    - "lib/generated/**"

linter:
  rules:
    # Erros
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_types_as_parameter_names
    - empty_catches
    - no_duplicate_case_values
    - valid_regexps
    
    # Estilo
    - always_declare_return_types
    - annotate_overrides
    - avoid_empty_else
    - avoid_returning_null_for_void
    - camel_case_types
    - constant_identifier_names
    - curly_braces_in_flow_control_structures
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_single_quotes
    - sort_child_properties_last
    - use_key_in_widget_constructors
    
    # Documentação
    - package_api_docs
    - public_member_api_docs
```

#### Métricas de Qualidade
- **Complexidade Ciclomática:** < 10 por método
- **Linhas por Arquivo:** < 300 linhas
- **Métodos por Classe:** < 10 métodos públicos
- **Parâmetros por Método:** < 4 parâmetros

#### Comandos de Análise
```bash
# Análise completa
dart analyze

# Métricas de código
dart analyze --format=json > analysis_report.json

# Verificar apenas erros
dart analyze --fatal-infos --fatal-warnings
```

---

## 📊 Roadmap de Implementação

### Fase 1: Fundação de Testes (4-6 horas)
1. ✅ Criar SPRINT_23_PLANO.md
2. 🔄 Adicionar dependências de teste
3. 🔄 Criar estrutura de diretórios test/
4. 🔄 Criar helpers de teste (mock_factories.dart, test_helpers.dart)
5. 🔄 Configurar fake_cloud_firestore

### Fase 2: Testes Unitários (6-8 horas)
1. Testes para LoggerService (2h)
2. Testes para NotificationService (2h)
3. Testes para AiService (2h)
4. Testes para Repositories (2h)

### Fase 3: Internacionalização (3-4 horas)
1. Criar l10n.yaml
2. Criar arquivos ARB (pt_BR, en_US)
3. Gerar código com `flutter gen-l10n`
4. Atualizar MaterialApp
5. Refatorar telas para usar l10n

### Fase 4: Refatoração (4-6 horas)
1. Refatorar VacancyCard
2. Refatorar ApplicationTile
3. Refatorar ProfileScreen
4. Refatorar LoginScreen

### Fase 5: Ícones e Qualidade (2-3 horas)
1. Criar ícones
2. Configurar flutter_launcher_icons
3. Melhorar analysis_options.yaml
4. Corrigir warnings
5. Executar análise final

**Total Estimado: 19-27 horas**

---

## ✅ Critérios de Aceitação

### Testes
- [ ] Cobertura de testes > 80% para serviços críticos
- [ ] Todos os testes unitários passam
- [ ] Testes de widget para telas principais
- [ ] CI/CD configurado para rodar testes automaticamente

### Internacionalização
- [ ] Suporte completo para pt_BR e en_US
- [ ] Todas as strings hardcoded removidas
- [ ] Sistema de locale switching funcional
- [ ] Fallback para pt_BR quando locale não suportado

### Refatoração
- [ ] Complexidade ciclomática < 10
- [ ] Widgets divididos em componentes reutilizáveis
- [ ] Princípios SOLID aplicados
- [ ] Código documentado com comentários

### Qualidade
- [ ] `dart analyze` sem warnings
- [ ] Linting rules configuradas
- [ ] Ícones gerados para Android e iOS
- [ ] Documentação atualizada

---

## 🔄 Próximos Passos

1. **Executar Fase 1** - Configurar infraestrutura de testes
2. **Criar primeiro teste** - LoggerService como exemplo
3. **Configurar i18n** - Criar arquivos ARB
4. **Refatorar um widget** - VacancyCard como piloto
5. **Executar análise** - Corrigir warnings

---

## 📚 Referências

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Flutter i18n Guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [Flutter Lints](https://pub.dev/packages/flutter_lints)
- [SOLID Principles in Dart](https://dart.academy/solid-principles/)

---

**Sprint 23 iniciada em:** 23 de outubro de 2025  
**Responsável:** Equipe BarberGo  
**Prioridade:** P0 - CRÍTICO para Beta Release
