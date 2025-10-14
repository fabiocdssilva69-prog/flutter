# 🧪 Guia de Testes - Sprint 6 BarberGO

## 📋 Índice
1. [Setup Inicial](#setup-inicial)
2. [Teste 1: Login e Navegação](#teste-1-login-e-navegação)
3. [Teste 2: Barbershop - Criar Vaga](#teste-2-barbershop---criar-vaga)
4. [Teste 3: Barbershop - Gerenciar Candidatos](#teste-3-barbershop---gerenciar-candidatos)
5. [Teste 4: Barber - Ver e Candidatar](#teste-4-barber---ver-e-candidatar)
6. [Teste 5: Chat AI com Persistência](#teste-5-chat-ai-com-persistência)
7. [Troubleshooting](#troubleshooting)

---

## 🚀 Setup Inicial

### 1. Firebase Emulator (Opcional)
```powershell
# Se quiser testar localmente sem Firebase real
firebase emulators:start --only firestore,auth
```

### 2. Executar App
```powershell
# Chrome (recomendado para debug)
flutter run -d chrome --web-port=8080

# Edge (alternativa)
flutter run -d edge

# Windows Desktop (para testes nativos)
flutter run -d windows
```

### 3. Acesso Rápido
- URL Local: http://localhost:8080
- Hot Reload: Pressione `r` no terminal
- Hot Restart: Pressione `R` no terminal
- Quit: Pressione `q` no terminal

---

## 🔐 Teste 1: Login e Navegação

### Objetivo
Verificar autenticação e navegação adaptativa baseada no tipo de conta.

### Passos

1. **Login como Barbeiro**
   ```
   Email: barber@test.com
   Password: test123
   Account Type: BARBER
   ```
   
   ✅ **Validações:**
   - [ ] Login bem-sucedido
   - [ ] Redirecionado para HomeScreen
   - [ ] BottomNavigationBar visível com 2 tabs:
     - Tab 1: "Descobrir" (BarberDiscoveryView)
     - Tab 2: "Minhas Candidaturas" (MyApplicationsView)

2. **Login como Barbearia**
   ```
   Email: barbershop@test.com
   Password: test123
   Account Type: BARBERSHOP
   ```
   
   ✅ **Validações:**
   - [ ] Login bem-sucedido
   - [ ] Redirecionado para HomeScreen
   - [ ] BottomNavigationBar visível com 2 tabs:
     - Tab 1: "Minhas Vagas" (MyVacanciesView)
     - Tab 2: "Configurações" (placeholder)

---

## 💼 Teste 2: Barbershop - Criar Vaga

### Objetivo
Testar criação de vaga de emprego pela barbearia.

### Passos

1. **Acessar Criação de Vaga**
   - Login como BARBERSHOP
   - Na tab "Minhas Vagas", clicar no FAB (botão flutuante +)

2. **Preencher Formulário**
   ```
   Título: Barbeiro Sênior - Centro
   Tipo: FREELANCER (ou CLT / COMMISSION)
   Horas/Semana: 40
   Comissão: 60% (se tipo = COMMISSION)
   ```

3. **Submeter**
   - Clicar em "Criar Vaga"
   
   ✅ **Validações:**
   - [ ] Loading spinner durante criação
   - [ ] Mensagem de sucesso (SnackBar)
   - [ ] Vaga aparece na lista de "Minhas Vagas"
   - [ ] Vaga criada no Firestore (`vacancies` collection)

4. **Verificar Firestore (Firebase Console)**
   ```
   Collection: vacancies
   Document ID: [auto-generated]
   Fields:
     - title: "Barbeiro Sênior - Centro"
     - type: "freelancer"
     - createdBy: [barbershop_uid]
     - status: "active"
     - workHours: 40
     - createdAt: [timestamp]
   ```

---

## 👥 Teste 3: Barbershop - Gerenciar Candidatos

### Objetivo
Aceitar/rejeitar candidaturas de barbeiros.

### Passos

1. **Acessar Detalhes da Vaga**
   - Na lista "Minhas Vagas", clicar em qualquer vaga
   - Navega para `VacancyDetailsScreen`

2. **Visualizar Candidatos**
   
   ✅ **Validações:**
   - [ ] Lista de candidatos renderizada
   - [ ] Para cada candidato (ApplicationTile):
     - [ ] Nome do barbeiro carregado
     - [ ] Foto de perfil (ou ícone default)
     - [ ] Status da candidatura (pending/accepted/rejected)
     - [ ] Botões "Aceitar" e "Rejeitar" (apenas se pending)

3. **Aceitar Candidato**
   - Clicar em botão "Aceitar" ✅
   
   ✅ **Validações:**
   - [ ] Botões desabilitados durante processamento
   - [ ] Status atualiza para "accepted"
   - [ ] Cor muda para verde
   - [ ] Botões de ação desaparecem

4. **Rejeitar Candidato**
   - Clicar em botão "Rejeitar" ❌
   
   ✅ **Validações:**
   - [ ] Status atualiza para "rejected"
   - [ ] Cor muda para vermelho/cinza
   - [ ] Botões de ação desaparecem

5. **Real-time Updates**
   - Abrir 2 navegadores/abas com a mesma vaga
   - Aceitar candidato em uma aba
   
   ✅ **Validações:**
   - [ ] Outra aba atualiza automaticamente (Stream)
   - [ ] Não precisa refresh manual

---

## 🔍 Teste 4: Barber - Ver e Candidatar

### Objetivo
Barbeiro visualizar vagas e acompanhar suas candidaturas.

### Passos

1. **Descobrir Vagas**
   - Login como BARBER
   - Na tab "Descobrir", deslizar cards de vagas (CardSwiper)
   
   ✅ **Validações:**
   - [ ] Cards com título, tipo, horas/semana
   - [ ] Swipe right para candidatar
   - [ ] Swipe left para pular

2. **Candidatar-se**
   - Swipe right em uma vaga
   
   ✅ **Validações:**
   - [ ] Candidatura criada no Firestore
   - [ ] Mensagem de sucesso

3. **Ver Minhas Candidaturas**
   - Clicar na tab "Minhas Candidaturas"
   
   ✅ **Validações:**
   - [ ] Lista de todas as candidaturas do barbeiro
   - [ ] Para cada item:
     - [ ] Título da vaga
     - [ ] Nome da barbearia
     - [ ] Status (pending/accepted/rejected)
     - [ ] Data da candidatura

4. **Real-time Updates**
   - Com app aberto na tab "Minhas Candidaturas"
   - Em outra sessão (barbearia), aceitar a candidatura
   
   ✅ **Validações:**
   - [ ] Status atualiza automaticamente
   - [ ] Cor do card muda

---

## 💬 Teste 5: Chat AI com Persistência

### Objetivo
Testar integração OpenAI, persistência no Firestore e recuperação de histórico.

### Pré-requisitos
```dart
// Verificar se API Key está configurada
// lib/src/core/config/app_config.dart
const openAiApiKey = 'sk-...'; // Deve estar preenchida
```

### Passos

1. **Acessar Chat AI**
   - Navegar para tela de chat (AI Studio)
   - Escolher persona (ex: Business Advisor)

2. **Primeira Mensagem**
   ```
   User: "Como aumentar vendas da minha barbearia?"
   ```
   
   ✅ **Validações:**
   - [ ] Mensagem aparece instantaneamente (estado local)
   - [ ] Loading indicator enquanto aguarda IA
   - [ ] Resposta da IA aparece após ~2-5 segundos
   - [ ] LoggerService registra evento (console):
     ```
     🤖 AI Interaction | persona: business_advisor | 
     user_message_length: 38 | duration: 3500ms
     ```

3. **Verificar Persistência**
   - Abrir Firebase Console
   - Navegar para Firestore:
   ```
   users/
     {userId}/
       ai_chats/
         business_advisor/
           messages/
             {messageId1}/
               - role: "user"
               - content: "Como aumentar vendas..."
               - timestamp: [Timestamp]
             {messageId2}/
               - role: "assistant"
               - content: "Para aumentar as vendas..."
               - timestamp: [Timestamp]
   ```

4. **Histórico Persistente**
   - Fechar app completamente (ou refresh F5)
   - Reabrir e voltar ao mesmo chat
   
   ✅ **Validações:**
   - [ ] Mensagens anteriores carregadas
   - [ ] Ordem cronológica mantida
   - [ ] Pode continuar conversa

5. **Múltiplas Mensagens**
   - Enviar 3-5 mensagens seguidas
   
   ✅ **Validações:**
   - [ ] Todas salvas no Firestore
   - [ ] Scroll automático para última mensagem
   - [ ] Não há duplicatas

6. **Tratamento de Erros**
   - Desabilitar internet ou usar API Key inválida
   - Enviar mensagem
   
   ✅ **Validações:**
   - [ ] Erro exibido ao usuário
   - [ ] Mensagem de erro salva com `isError: true`
   - [ ] LoggerService registra erro:
     ```
     ❌ Error | AI Service | context: chat_send_message | 
     error: API_KEY_INVALID
     ```

---

## 🐛 Troubleshooting

### App não inicia

```powershell
# 1. Limpar build
flutter clean

# 2. Reinstalar dependências
flutter pub get

# 3. Regenerar código
dart run build_runner build --delete-conflicting-outputs

# 4. Tentar novamente
flutter run -d chrome
```

### Erro de Provider não encontrado

```dart
// Verificar se o provider está sendo usado dentro de ProviderScope
void main() {
  runApp(
    ProviderScope(  // ← Necessário!
      child: MyApp(),
    ),
  );
}
```

### Firestore não conecta

```yaml
# firebase_options.dart deve estar configurado
# Executar novamente:
flutterfire configure
```

### Hot Reload não funciona

```powershell
# No terminal do Flutter:
R  # Hot Restart completo
```

### Erro de CORS (Web)

- Problema comum com Firebase em localhost
- **Solução temporária**: Usar Firebase Emulator
- **Solução produção**: Configurar regras CORS no Firebase

### Chat AI retorna erro

**Possíveis causas:**
1. **API Key inválida**
   - Verificar em `app_config.dart`
   - Obter nova key em https://platform.openai.com

2. **Sem créditos OpenAI**
   - Verificar saldo em https://platform.openai.com/usage

3. **Timeout**
   - Aumentar timeout em `ai_service.dart`:
   ```dart
   connectTimeout: Duration(seconds: 60), // ← aumentar
   receiveTimeout: Duration(seconds: 120),
   ```

---

## 📊 Checklist Final de Validação

### Funcionalidades Core
- [ ] Login funciona para ambos tipos de conta
- [ ] Navegação adaptativa (BottomNavigationBar)
- [ ] Criar vaga (Barbershop)
- [ ] Listar vagas criadas (Barbershop)
- [ ] Ver detalhes da vaga e candidatos (Barbershop)
- [ ] Aceitar/rejeitar candidatos (Barbershop)
- [ ] Ver vagas disponíveis (Barber)
- [ ] Candidatar-se a vagas (Barber)
- [ ] Ver minhas candidaturas (Barber)

### Real-time & Persistência
- [ ] Streams atualizam automaticamente
- [ ] Chat AI persiste no Firestore
- [ ] Histórico de chat recuperado após refresh
- [ ] Múltiplas mensagens sincronizam corretamente

### Performance
- [ ] Hot Reload funciona (< 1s)
- [ ] Primeira carga do app (< 5s no web)
- [ ] Resposta da IA (2-10s dependendo do modelo)
- [ ] Firestore queries (< 500ms)

### Analytics
- [ ] LoggerService registra eventos no console
- [ ] Eventos de erro capturados
- [ ] Métricas de tempo disponíveis

---

## 🎯 Próximos Passos

1. **Testes Automatizados**
   ```powershell
   # Widget tests
   flutter test
   
   # Integration tests
   flutter test integration_test/
   ```

2. **Deploy**
   ```powershell
   # Build web
   flutter build web --release
   
   # Deploy Firebase Hosting
   firebase deploy --only hosting
   ```

3. **Monitoramento**
   - Configurar Firebase Analytics
   - Configurar Crashlytics
   - Monitorar uso da API OpenAI

---

## 📞 Suporte

- **Documentação Riverpod**: https://riverpod.dev
- **Firebase Flutter**: https://firebase.flutter.dev
- **OpenAI API**: https://platform.openai.com/docs

---

**Última atualização**: Sprint 6 - Outubro 2025
**Versão do Flutter**: 3.x
**Versão do Riverpod**: 3.0.1
