# 🔍 DEBUG: "Nenhum perfil disponível" na Tela Descobrir

## 📱 **SINTOMA**

Tela **Descobrir** mostra:
- "Nenhum perfil disponível"
- "Tente aumentar o raio de busca"

## 🔍 **ANÁLISE DO CÓDIGO**

### **Controller: `discovery_controller.dart`**

```dart
@riverpod
Stream<List<ProfileEntity>> discoverProfiles(Ref ref) {
  // 1. Pega usuário atual
  final currentUser = ref.watch(authRepositoryProvider).currentUser;
  if (currentUser == null) return const Stream.empty();

  // 2. Pega perfil atual
  final currentProfile = ref.watch(currentUserProfileProvider).value;
  if (currentProfile == null) return const Stream.empty();

  // 3. Filtra por tipo de conta OPOSTO
  final accountTypeFilter = currentProfile.accountType == AccountType.barber
      ? AccountType.barbershop
      : AccountType.barber;

  // 4. Query no Firestore
  return FirebaseFirestore.instance
      .collection('profiles')
      .where('accountType', isEqualTo: accountTypeFilter.name)
      .limit(20)
      .snapshots()
      .map((snapshot) => /* ... */);
}
```

### **Lógica**:
1. ✅ Usuário autenticado: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
2. ✅ Perfil atual: `NOBRUS BARBERSHOP` (accountType: **barbershop**)
3. 🔍 **Filtro aplicado**: `accountType == 'barber'` (busca barbeiros)
4. ❓ **Query Firestore**: `profiles` onde `accountType = 'barber'`

---

## 🎯 **POSSÍVEIS CAUSAS**

### **Causa 1: Profiles não têm campo `accountType` correto**

**Verificação necessária**:
```
Firebase Console → Firestore → profiles collection
```

**O que checar em cada profile**:
```javascript
{
  userId: "...",
  accountType: "barber" ou "barbershop", // ← CAMPO CRÍTICO
  name: "...",
  email: "...",
  // ...
}
```

### **Causa 2: Campo está como ENUM ao invés de string**

O código usa `.name` para converter enum:
```dart
accountTypeFilter.name // "barber" ou "barbershop" (string)
```

Mas no Firestore pode estar como:
- ❌ **Número**: `0` ou `1` (enum index)
- ❌ **Objeto**: `{index: 0}`
- ✅ **String**: `"barber"` ou `"barbershop"`

### **Causa 3: Profiles criados antes da correção**

Os profiles foram criados **manualmente** no Firebase Console. Podem ter:
- ❌ Campo `accountType` faltando
- ❌ Campo com valor diferente (`"BARBER"` vs `"barber"`)
- ❌ Campo com tipo errado (Map ao invés de string)

---

## ✅ **SOLUÇÃO IMEDIATA**

### **PASSO 1: Verificar Profiles no Firestore**

1. **Abra**: https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles

2. **Clique em cada profile e verifique**:

#### **Profile A (João Silva)**
```javascript
{
  userId: "PROFILE_A_UID",
  accountType: "barber",  // ← DEVE SER STRING "barber"
  name: "João Silva",
  email: "joao@example.com",
  // ... outros campos
}
```

#### **Profile C (Maria Santos)**
```javascript
{
  userId: "PROFILE_C_UID",
  accountType: "barber",  // ← DEVE SER STRING "barber"
  name: "Maria Santos",
  email: "maria@example.com",
  // ... outros campos
}
```

#### **Profile B (NOBRUS BARBERSHOP - Você)**
```javascript
{
  userId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
  accountType: "barbershop",  // ← DEVE SER STRING "barbershop"
  name: "NOBRUS BARBERSHOP",
  email: "nobrus@example.com",
  // ... outros campos
}
```

---

## 🔧 **CORREÇÃO MANUAL NO FIREBASE**

### **Se o campo `accountType` estiver ERRADO ou FALTANDO**:

1. **Clique no documento do profile**
2. **Procure o campo `accountType`**
3. **Edite ou adicione**:
   - **Tipo**: `string`
   - **Valor**: `"barber"` (para João e Maria) ou `"barbershop"` (para NOBRUS)

4. **Salve**

---

## 🧪 **TESTE ALTERNATIVO: Query Manual**

Para confirmar se o problema é a query, vamos adicionar logs:

### **Opção 1: Ver logs do terminal**

Execute o app e procure por logs começando com `I/flutter`:
```
I/flutter (18420): 📊 [discoverProfiles] currentUser: 6RYGS6HoEkhQgikNxUIkn7NpwmI3
I/flutter (18420): 📊 [discoverProfiles] accountType: barbershop
I/flutter (18420): 📊 [discoverProfiles] accountTypeFilter: barber
I/flutter (18420): 📊 [discoverProfiles] Profiles found: 0
```

Se não aparecer nada, vamos adicionar logs ao código.

---

## 🚀 **AÇÃO IMEDIATA PARA VOCÊ**

### **1. Verifique os 3 profiles no Firestore**:

- https://console.firebase.google.com/project/barbergo-38c21/firestore/data/~2Fprofiles

**Me responda**:
- ✅ Profile A (João Silva) tem `accountType: "barber"`?
- ✅ Profile C (Maria Santos) tem `accountType: "barber"`?
- ✅ Profile B (NOBRUS) tem `accountType: "barbershop"`?

### **2. Se algum campo estiver errado**:

- Edite no Firebase Console e salve
- Execute **Hot Reload** no app (pressione `r` no terminal)
- Ou reinicie o app

### **3. Tire um print da collection `profiles`**:

- No Firebase Console, abra a collection `profiles`
- Mostre a lista de documentos (com os 3 IDs visíveis)
- Me envie o print

---

## 🐛 **PRÓXIMO PASSO SE NÃO RESOLVER**

Se os campos estiverem corretos, vamos adicionar logs de debug ao código para entender por que a query não retorna resultados.

**Aguardando sua verificação no Firebase Console!** 🔍
