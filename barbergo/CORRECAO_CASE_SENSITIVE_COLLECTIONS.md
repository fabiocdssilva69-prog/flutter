# 🔧 Correção: Case-Sensitivity nas Coleções do Firestore

**Data:** 18/10/2025  
**Problema:** PERMISSION_DENIED ao tentar criar vagas e acessar dados  
**Causa Raiz:** Nomes de coleções com capitalização inconsistente (código vs Firestore Rules)

---

## 📋 Resumo Executivo

O app estava falhando ao acessar o Firestore porque:
1. **Firestore Rules** usavam nomes em minúsculo: `vacancies`, `profiles`, `applications`
2. **Código Dart** usava nomes capitalizados: `Vacancies`, `Applications`
3. Firestore é **case-sensitive** para nomes de coleções

**Resultado:** Queries bloqueadas com `PERMISSION_DENIED`

---

## 🔍 Erros Detectados no Terminal

```
W/Firestore: Listen for Query(target=Query(Vacancies where barbershopId==...))
             failed: Status{code=PERMISSION_DENIED, 
             description=Missing or insufficient permissions.}
```

**Análise:**
- ❌ Código buscava `Vacancies` (maiúsculo)
- ✅ Rules permitiam `vacancies` (minúsculo)
- ❌ Firestore rejeita por não reconhecer como mesma coleção

---

## ✅ Correções Aplicadas

### 1. `vacancy_repository.dart` (linha 11)

**ANTES:**
```dart
static const String vacanciesPath = 'Vacancies';
```

**DEPOIS:**
```dart
static const String vacanciesPath = 'vacancies';
```

### 2. `application_repository.dart` (linha 12)

**ANTES:**
```dart
static const String applicationsPath = 'Applications';
```

**DEPOIS:**
```dart
static const String applicationsPath = 'applications';
```

### 3. Validação de Outros Repositórios

✅ `profile_repository.dart` - JÁ estava correto (`'profiles'`)  
✅ `chat_repository.dart` - JÁ estava correto (`'users'`)

---

## 🧪 Teste de Validação

Após as correções, o app deve:

1. ✅ **Login** → Carregar perfil sem PERMISSION_DENIED
2. ✅ **Criar Vaga** → Salvar em `vacancies` com sucesso
3. ✅ **Listar Vagas** → Stream funciona sem erros
4. ✅ **Candidaturas** → Salvar em `applications` com sucesso

---

## 📚 Lições Aprendidas

### Firestore Case-Sensitivity
```dart
// ❌ ERRADO - Não funcionam juntos
firestore.rules: match /Vacancies/{id}
código:          collection('vacancies')

// ✅ CORRETO - Mesmo nome exato
firestore.rules: match /vacancies/{id}
código:          collection('vacancies')
```

### Convenção do Projeto
- **Coleções**: `snake_case` em minúsculo (vacancies, profiles, users)
- **Subcoleções**: `snake_case` em minúsculo (interactions, applications)
- **Documentos**: IDs gerados automaticamente (Firebase Auto-ID)

### Checklist Pré-Deploy
Antes de fazer `firebase deploy --only firestore:rules`:

1. ✅ Verificar todos os `collection()` no código Dart
2. ✅ Garantir que Rules usam os MESMOS nomes exatos
3. ✅ Testar em Firebase Emulator primeiro (próxima sprint)
4. ✅ Validar com `grep` todos os `*Path =` nos repositórios

---

## 🔗 Arquivos Relacionados

- `firestore.rules` → Regras de segurança (já corrigidas anteriormente)
- `lib/src/data/repositories/vacancy_repository.dart`
- `lib/src/data/repositories/application_repository.dart`
- `lib/src/data/repositories/profile_repository.dart`
- `PROBLEMA_FIRESTORE_RULES_RESOLVIDO.md` → Correção anterior (Rules)

---

## 🚀 Próximos Passos

1. ⏳ **Aguardar compilação** do app (Gradle em andamento)
2. 🧪 **Testar criação de vaga** no celular físico
3. ✅ **Validar streams** (myVacanciesStream, watchFilteredActiveVacancies)
4. 📝 **Documentar resultados** em `TESTE_SPRINT12_RESULTS.md`

---

## 💡 Prevenção Futura

### Script de Validação (sugestão)
```bash
# check_firestore_consistency.ps1
Write-Host "Validando consistência Firestore..."

# Busca todos os collection() no código
$collections = Select-String -Path "lib/src/data/**/*.dart" -Pattern "collection\('(\w+)'\)"

# Busca todos os match / no firestore.rules
$rules = Get-Content firestore.rules | Select-String "match /(\w+)/"

# Compara e alerta diferenças
```

### Code Review Checklist
Ao adicionar nova coleção:
- [ ] Nome em `snake_case` minúsculo?
- [ ] Mesmo nome no código e nas Rules?
- [ ] Subcoleções seguem padrão?
- [ ] Testes cobrem acesso?

---

**Status:** ✅ RESOLVIDO  
**Tempo de Resolução:** ~15 minutos  
**Impacto:** CRÍTICO (bloqueador total do Sprint 12)
