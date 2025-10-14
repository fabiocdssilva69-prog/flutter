# 🚀 COMO TESTAR O BARBERGO - GUIA RÁPIDO

## ⚠️ Status Atual

O projeto está **98% pronto**, mas com alguns erros de compilação que precisam ser corrigidos antes de rodar:

### 🔴 Erros Pendentes (Total: ~25 erros)

1. ✅ **AppColors.primaryColor** → Corrigido para `AppColors.primary`
2. ✅ **VacancyType.freelance** → Corrigido para `VacancyType.freelancer`
3. ✅ **application.appliedAt** → Corrigido para `application.createdAt`
4. ⚠️ **UserEntity.name** → Falta buscar ProfileEntity.name
5. ⚠️ **Provider Ref types** → Falta regenerar build_runner
6. ⚠️ **AsyncValue.valueOrNull** → Falta refatorar para `.when()`

---

## 📝 Checklist de Correções Necessárias

### 1. Regenerar Build Runner
```powershell
# Limpar e regenerar
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### 2. Corrigir UserEntity.name

**Problema**: `UserEntity` não tem campo `name`, que está em `ProfileEntity`.

**Arquivos afetados**:
- `lib/src/features/management/widgets/application_tile.dart`
- `lib/src/features/barber/screens/my_applications_view.dart`

**Solução**: Criar provider composto que retorna ProfileEntity:
```dart
// Em core_data_controller.dart
@riverpod
Future<ProfileEntity?> userProfile(UserProfileRef ref, String userId) async {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return await profileRepo.getProfileByUserId(userId);
}
```

Então usar:
```dart
// Em application_tile.dart
final profileAsync = ref.watch(userProfileProvider(application.barberId));
// E acessar: profile.name
```

### 3. Corrigir AsyncValue.valueOrNull

**Arquivo**: `lib/src/features/ai/controllers/artistic_chat_controller.dart`

**Problema**:
```dart
final current = state.valueOrNull ?? [];  // ❌ Não existe
```

**Solução**:
```dart
final current = state.when(
  data: (messages) => messages,
  loading: () => <ChatMessage>[],
  error: (_, __) => <ChatMessage>[],
);
```

### 4. Remover ApplicationStatus.withdrawn

**Arquivo**: `lib/src/features/management/widgets/application_tile.dart`

**Problema**:
```dart
case ApplicationStatus.withdrawn:  // ❌ Não existe no enum
```

**Solução**: Remover esse case completamente.

### 5. Corrigir updateData no FirestoreService

**Arquivo**: `lib/src/data/repositories/application_repository.dart`

**Problema**:
```dart
await _service.updateData(...)  // ❌ Método não existe
```

**Solução**:
```dart
await _service.updateDocument(
  path: 'applications/${applicationId}',
  data: {'status': status.name},
);
```

---

## 🎯 Passos para Testar

### Opção A: Correção Rápida (Recomendado)

1. **Execute o script de correções**:
```powershell
.\fix_errors.ps1
```

2. **Regenere código**:
```powershell
dart run build_runner build --delete-conflicting-outputs
```

3. **Compile e rode**:
```powershell
flutter run -d chrome
```

### Opção B: Correção Manual

Siga cada item do checklist acima manualmente.

---

## 🧪 Testes Após Correções

### 1. Teste de Login
```
URL: http://localhost:8080
Email: test@barber.com
Password: 123456
```

### 2. Teste de Navegação
- ✅ Login como BARBER: Ver tabs "Descobrir" e "Minhas Candidaturas"
- ✅ Login como BARBERSHOP: Ver tabs "Minhas Vagas" e "Configurações"

### 3. Teste de Criação de Vaga (Barbershop)
1. Clicar no FAB (+)
2. Preencher:
   - Título: "Barbeiro Sênior"
   - Tipo: Freelancer
   - Horas: 40
3. Submeter
4. Verificar vaga aparece na lista

### 4. Teste de Candidatura (Barber)
1. Na tab "Descobrir", swipe right para candidatar
2. Ir para tab "Minhas Candidaturas"
3. Ver candidatura listada

### 5. Teste de Chat AI
1. Navegar para AI Studio
2. Enviar mensagem: "Como aumentar vendas?"
3. Verificar:
   - Resposta da IA aparece
   - Mensagens persistem após refresh
   - Histórico é mantido

---

## 🔍 Verificação de Firestore

### Collections esperadas:
```
users/
  {uid}/
    email, accountType, subscriptionTier
    
profiles/
  {uid}/
    name, phone, address, etc
    
vacancies/
  {vacancyId}/
    title, type, createdBy, status, workHours
    
applications/
  {applicationId}/
    vacancyId, barberId, barbershopId, status, createdAt
    
users/{uid}/ai_chats/{personaKey}/messages/
  {messageId}/
    role, content, timestamp
```

---

## 📊 Resumo do Status

| Componente | Status | Nota |
|-----------|--------|------|
| **Build Runner** | ⚠️ Precisa rodar | Após correções |
| **Providers** | ⚠️ Refs faltando | Após build_runner |
| **Entities** | ✅ OK | Freezed funcionando |
| **Repositories** | ⚠️ 1-2 métodos | updateData → updateDocument |
| **Controllers** | ⚠️ AsyncValue | Refatorar valueOrNull |
| **UI Components** | ⚠️ UserEntity.name | Usar ProfileEntity |
| **Routing** | ✅ OK | GoRouter configurado |
| **Firebase** | ✅ OK | Configurado |

---

## 🛠️ Comandos Úteis

```powershell
# Limpar tudo
flutter clean
rm -r build/

# Reinstalar deps
flutter pub get

# Regenerar código
dart run build_runner build --delete-conflicting-outputs

# Verificar erros
flutter analyze

# Rodar app
flutter run -d chrome --web-port=8080

# Ver devices
flutter devices

# Hot reload (no terminal do flutter)
r  # reload
R  # restart completo
q  # quit
```

---

## 📞 Próximos Passos

1. ✅ Executar `fix_errors.ps1`
2. ⚠️ Corrigir manualmente os 5 itens do checklist
3. ⚠️ Regenerar build_runner
4. ⚠️ Testar compilação
5. ⚠️ Abrir no Chrome e testar fluxos

---

## 💡 Dica

Se encontrar muitos erros, corrija na seguinte ordem:
1. **Provider Refs** (build_runner)
2. **Entity fields** (name, appliedAt, etc)
3. **Enums** (VacancyType, ApplicationStatus)
4. **AsyncValue** (valueOrNull → .when())
5. **UI** (AppColors, etc)

---

**Estimativa de tempo para correções**: 15-30 minutos
**Estimativa de tempo para testes**: 10-15 minutos

**Total**: ~45 minutos para app 100% funcional! 🎉
