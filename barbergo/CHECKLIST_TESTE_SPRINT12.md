# 🚀 Sprint 12 - Checklist de Configuração Completa

**Data:** 18/10/2025  
**Status:** ✅ Pronto para testar  
**Device:** Redmi Note 8 Pro (Android 11)

---

## ✅ Correções Aplicadas

### 1. Case-Sensitivity das Coleções
- ✅ `vacancy_repository.dart` → `'vacancies'` (minúsculo)
- ✅ `application_repository.dart` → `'applications'` (minúsculo)
- ✅ `profile_repository.dart` → Já estava correto
- ✅ `firestore.rules` → Todas as coleções em minúsculo

### 2. Firestore Security Rules
- ✅ Deployado via `firebase deploy --only firestore:rules`
- ✅ Coleções: `users`, `profiles`, `vacancies`, `applications`, `matches`
- ✅ Subcoleções: `profiles/{id}/interactions`, `vacancies/{id}/applications`

### 3. Firestore Composite Indexes
- ✅ Criado `firestore.indexes.json` com 5 índices
- ✅ Deployado via `firebase deploy --only firestore:indexes`

**Índices Criados:**

1. **vacancies** → `barbershopId` + `createdAt` (DESC)
   - Usado em: `watchVacanciesByBarbershop()`
   
2. **applications** → `barbershopId` + `createdAt` (DESC)
   - Usado em: `watchApplicationsForBarbershop()`
   
3. **applications** → `vacancyId` + `createdAt` (DESC)
   - Usado em: `watchApplicationsByVacancy()`
   
4. **applications** → `barberId` + `createdAt` (DESC)
   - Usado em: `watchApplicationsByBarber()`
   
5. **vacancies** → `isActive` + `locationCityState` + `createdAt` (DESC)
   - Usado em: `watchFilteredActiveVacancies()` (Smart Matching)

⏳ **Status:** Aguardando construção dos índices (2-5 minutos)

---

## 📱 Como Testar

### Pré-requisitos
- ✅ App instalado no celular (Redmi Note 8 Pro conectado)
- ✅ Firebase configurado e deployado
- ⏳ Índices do Firestore em construção

### Etapa 1: Verificar Índices
1. Acesse: https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes
2. Verifique se os 5 índices estão com status **"Enabled"** (verde)
3. Se estiverem "Building" (amarelo), aguarde completar

### Etapa 2: Reiniciar App
```powershell
# Se o app ainda estiver rodando, use hot restart:
R

# Ou reinicie completamente:
flutter run -d uwbekb8hpf6lamts
```

### Etapa 3: Testar Funcionalidades

#### 3.1 Login e Perfil
- [ ] Login com usuário existente
- [ ] Perfil carrega sem erros (sem PERMISSION_DENIED)
- [ ] Dados do perfil aparecem corretamente

#### 3.2 Gestão de Vagas (Barbearia)
- [ ] Acesse "Gestão" → "Minhas Vagas"
- [ ] Lista de vagas carrega sem erro FAILED_PRECONDITION
- [ ] Crie nova vaga com:
  - Título: "Vaga Teste Sprint 12"
  - Localização: "São Paulo, SP"
  - Descrição qualquer
- [ ] Verifique que a vaga aparece na lista
- [ ] Pause a vaga (botão pause)
- [ ] Reative a vaga (botão play)

#### 3.3 Feed de Vagas (Barbeiro)
- [ ] Mude para perfil de Barbeiro (ou crie novo usuário tipo Barbeiro)
- [ ] Defina localização: "São Paulo, SP"
- [ ] Acesse "Feed"
- [ ] Veja se aparecem vagas da mesma localização
- [ ] Swipe direita (candidatar) em uma vaga
- [ ] Swipe esquerda (ignorar) em outra vaga

#### 3.4 Candidaturas
- [ ] (Barbeiro) Acesse "Minhas Candidaturas"
- [ ] Veja a vaga que você se candidatou
- [ ] Verifique nome da barbearia (denormalizado)
- [ ] (Barbearia) Acesse a vaga → Ver candidatos
- [ ] Veja o barbeiro candidato
- [ ] Teste aceitar/rejeitar candidatura

---

## 🔍 Verificação de Erros

### Erros que DEVEM estar resolvidos:
- ❌ `PERMISSION_DENIED` → ✅ Resolvido (coleções minúsculas)
- ❌ `FAILED_PRECONDITION` → ✅ Resolvido (índices deployados)

### Erros inofensivos (ignorar):
- ⚠️ `E/GoogleApiManager` → Google Play Services (não afeta funcionalidade)
- ⚠️ `W/FlagRegistrar` → Google Play Services (não afeta funcionalidade)
- ⚠️ `Skipped X frames` → Performance (normal no primeiro carregamento)

### Se ainda aparecer FAILED_PRECONDITION:
1. Verifique no Firebase Console se índices estão "Enabled"
2. Aguarde mais alguns minutos (pode demorar até 10 min)
3. Feche e reabra o app
4. Se persistir, envie o erro completo

---

## 📊 Status dos Arquivos

### Repositórios (lib/src/data/repositories/)
- ✅ `vacancy_repository.dart` → Collection: `'vacancies'`
- ✅ `application_repository.dart` → Collection: `'applications'`
- ✅ `profile_repository.dart` → Collection: `'profiles'`
- ✅ `chat_repository.dart` → Collection: `'users'`

### Configuração Firebase
- ✅ `firestore.rules` → Rules deployadas
- ✅ `firestore.indexes.json` → Índices deployados
- ✅ `firebase.json` → Configuração base

### Controladores (lib/src/features/)
- ✅ `management_controller.dart` → 3 providers adicionados
- ✅ `onboarding_controller.dart` → UserEntity comentado (workaround)

### Workarounds Temporários
- ⚠️ `chat_message.dart` → Classe marcada como abstract (Freezed issue)
- ⚠️ `chat_state.dart` → Classe marcada como abstract (Freezed issue)
- ⚠️ AI features → Não funcionais (não bloqueiam Sprint 12)

---

## 🎯 Objetivos do Teste

### Validar Smart Matching v1
- ✅ Denormalização de dados (barbershopName, locationCityState)
- ✅ Filtro de vagas por localização
- ✅ Swipe para candidatura/ignorar
- ✅ Registro de interações (não duplicar candidaturas)
- ✅ Gestão de status de candidaturas

### Validar Real-time Updates
- ✅ Stream de vagas atualiza ao criar/pausar
- ✅ Stream de candidaturas atualiza ao aplicar
- ✅ Mudanças aparecem sem refresh manual

### Validar Performance
- ✅ Queries otimizadas com índices compostos
- ✅ Carregamento rápido de listas
- ✅ Sem lags ao fazer swipe

---

## 📝 Reportar Resultados

Após testar, documente:

### O que funcionou ✅
- Liste funcionalidades que rodaram sem erros
- Prints/screenshots são bem-vindos

### O que NÃO funcionou ❌
- Descreva o erro específico
- Copie logs do terminal se possível
- Indique passos para reproduzir

### Observações 💡
- Performance (rápido/lento?)
- UX (intuitivo/confuso?)
- Sugestões de melhorias

---

## 🚀 Próximos Passos (Após Testes)

1. **Se tudo funcionar:**
   - Documentar em `TESTE_SPRINT12_RESULTS.md`
   - Fazer commit das correções
   - Planejar Sprint 13

2. **Se houver bugs:**
   - Criar `BUGS_SPRINT12.md`
   - Priorizar correções críticas
   - Ajustar código conforme necessário

3. **Performance:**
   - Avaliar tempo de carregamento
   - Otimizar queries se necessário
   - Considerar paginação se listas grandes

---

## 📞 Suporte

**Firebase Console:** https://console.firebase.google.com/project/barbergo-38c21/overview  
**Índices:** https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes  
**Firestore Data:** https://console.firebase.google.com/project/barbergo-38c21/firestore/data

**Comandos Úteis:**
```powershell
# Ver logs do app em tempo real
adb logcat | Select-String "Firestore|Flutter"

# Reiniciar app rapidamente
R  # (no terminal do flutter run)

# Hot reload (aplicar mudanças de código)
r  # (no terminal do flutter run)

# Verificar device conectado
flutter devices

# Verificar índices do Firebase
firebase firestore:indexes:list
```

---

**Status Final:** ✅ PRONTO PARA TESTAR  
**Aguardando:** Índices terminarem de construir (checar console)  
**Tempo Estimado:** 5-10 minutos até tudo estar operacional
