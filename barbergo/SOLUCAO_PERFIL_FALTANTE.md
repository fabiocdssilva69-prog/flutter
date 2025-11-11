# 🔥 PROBLEMA: Perfil Não Existe no Firestore

## Diagnóstico Completo

### ❌ Erro Identificado
```
[LOG ERROR] currentUserProfileProvider Timeout. 
UserID: 6RYGS6HoEkhQgikNxUIkn7NpwmI3
```

### 🔍 Causa Raiz
**Coleção `profiles` vazia no Firestore** (visível no screenshot do Firebase Console)

O usuário `6RYGS6HoEkhQgikNxUIkn7NpwmI3` existe no **Firebase Authentication**, mas **NÃO tem documento** correspondente na coleção `profiles` do Firestore.

### 🤔 Por Que Isso Aconteceu?

O fluxo correto do app é:
1. **SignUp** (`auth_controller.dart`) → Cria conta no Firebase Auth
2. **Onboarding** (`onboarding_controller.dart`) → Cria perfil no Firestore

**O que provavelmente aconteceu:**
- ✅ SignUp foi concluído (conta criada)
- ❌ Onboarding foi pulado ou falhou (perfil não criado)
- 🔄 Login posterior tenta carregar perfil inexistente → Timeout

---

## ✅ Soluções

### Opção 1: Novo Registro Completo (RECOMENDADO)

1. **Faça logout** no app
2. **Crie uma NOVA conta** com email diferente
3. **Complete TODO o onboarding**:
   - Escolha tipo de conta (Barbeiro/Barbearia)
   - Preencha nome
   - Preencha localização
   - Clique em "Concluir"
4. ✅ Perfil será criado corretamente

### Opção 2: Criar Perfil Manualmente (Script de Emergência)

⚠️ **Use APENAS se não puder criar nova conta**

```powershell
# 1. Certifique-se de estar LOGADO no app
# 2. Execute o script:
dart run lib/criar_perfil_emergencia.dart
```

O script criará um perfil padrão no Firestore.

**Antes de executar**, edite o arquivo `criar_perfil_emergencia.dart` linha 45-46:
```dart
'name': 'Seu Nome Aqui',        // 👈 Altere
'accountType': 'barber',         // 👈 'barber' ou 'barbershop'
```

### Opção 3: Criar Perfil no Firebase Console

1. Abra: https://console.firebase.google.com/
2. Vá em: **Firestore Database** → **Dados**
3. Clique em: **Adicionar coleção**
4. Nome da coleção: `profiles`
5. Clique em **Próximo**
6. ID do documento: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
7. Adicione os seguintes campos:

| Campo | Tipo | Valor |
|-------|------|-------|
| `userId` | string | `6RYGS6HoEkhQgikNxUIkn7NpwmI3` |
| `email` | string | (seu email) |
| `name` | string | (seu nome) |
| `accountType` | string | `barber` ou `barbershop` |
| `bio` | string | `Perfil criado manualmente` |
| `location` | string | `Florianópolis, SC` |
| `contactPhone` | string | (vazio ou seu telefone) |
| `fcmToken` | null | (deixe null) |
| `avatarUrl` | null | (deixe null) |
| `portfolioUrls` | array | `[]` (array vazio) |
| `preciseLocation` | null | (deixe null) |
| `searchRadiusKm` | number | `25` |
| `createdAt` | timestamp | (clique em "Usar timestamp do servidor") |
| `updatedAt` | timestamp | (clique em "Usar timestamp do servidor") |

8. Clique em **Salvar**
9. ✅ Feche e reabra o app

---

## 🔧 Correção de Código Necessária

O ideal seria o **SignUp criar automaticamente um perfil básico** para evitar esse problema.

### Sugestão de Melhoria: `auth_controller.dart`

Após o `signUp`, criar um perfil inicial:

```dart
Future<bool> signUp(String email, String password) async {
  // ... validações ...
  
  try {
    final userCredential = await authRepository
        .signUpWithEmailAndPassword(email, password)
        .timeout(const Duration(seconds: 30));

    // 🆕 CRIAR PERFIL INICIAL AUTOMATICAMENTE
    if (userCredential.user != null) {
      final initialProfile = ProfileEntity(
        userId: userCredential.user!.uid,
        email: email,
        name: 'Novo Usuário', // Será atualizado no onboarding
        accountType: AccountType.barber, // Padrão temporário
        createdAt: DateTime.now(),
      );
      
      await ref.read(profileRepositoryProvider).saveProfile(initialProfile);
    }

    state = const AsyncData(null);
    return true;
  } catch (error, stackTrace) {
    // ...
  }
}
```

**Vantagem:** Garante que SEMPRE haverá um perfil, mesmo que incompleto.

---

## 🎯 Recomendação Final

**Para continuar AGORA:**
- Use **Opção 3** (criar perfil no Firebase Console) - mais rápido e seguro

**Para evitar no futuro:**
- Implemente a correção no `auth_controller.dart` (criar perfil inicial no SignUp)
- Ou force o onboarding após SignUp (não permitir pular)

---

## ✅ Como Validar Correção

Após criar o perfil (qualquer método):

1. Feche o app completamente
2. Reabra o app
3. Faça login
4. Execute:
```powershell
flutter logs -d uwbekb8hpf6lamts 2>&1 | Select-String -Pattern "FCM_Lock|LOGIN|Timeout" | Select-Object -First 30
```

**Esperado:**
- ✅ Login bem-sucedido
- ✅ `FCM_LockAcquired` → `FCM_UpdatingTokenInBackend_Atomic` → `FCM_TokenUpdateSuccess_Atomic` → `FCM_LockReleased`
- ❌ NÃO deve aparecer "Timeout"

---

## 📊 Status Atual

- ✅ **Mutex FCM**: FUNCIONANDO PERFEITAMENTE (loop eliminado)
- ✅ **Conversão Timestamp**: CORRIGIDA
- ❌ **Perfil Firestore**: FALTANDO (bloqueando login)
- 🔄 **Próximo Passo**: Criar perfil usando uma das 3 opções acima
