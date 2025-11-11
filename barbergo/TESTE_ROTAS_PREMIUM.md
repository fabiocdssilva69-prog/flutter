# 🧪 Guia de Testes - Features Premium

**Data**: 07/11/2025  
**APK**: `build\app\outputs\flutter-apk\app-debug.apk`  
**Status**: ✅ Pronto para Testar

---

## 🚀 Instalação

### Opção 1: Flutter Install (Recomendado)
```bash
# Com o celular conectado via USB
flutter install

# Logs em tempo real
flutter logs
```

### Opção 2: ADB Manual
```bash
# Instalar APK
adb install build\app\outputs\flutter-apk\app-debug.apk

# Ver logs
adb logcat | Select-String "flutter"
```

---

## 🧪 Roteiro de Testes

### 1️⃣ Chat Room (WhatsApp-Style)

**Rota**: `/chat-room/:roomId`

**Como Testar**:
1. Abrir o app
2. Fazer login
3. Navegar para uma conversa existente
4. **OU** usar Deep Link:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "barbergo://chat-room/test123" com.barbergo.app
   ```

**O Que Verificar**:
- ✅ Bolhas de mensagem estilo WhatsApp
- ✅ Indicador de status online (bolinha verde)
- ✅ Timestamps formatados (HH:mm)
- ✅ Área de digitação com botão enviar
- ✅ Auto-scroll para última mensagem
- ✅ Avatar do usuário
- ✅ AppBar com nome e status

**Firebase Collections**:
```
chat_rooms/{roomId}
  └─ messages/{messageId}
```

---

### 2️⃣ Sistema de Pagamentos

**Rotas**: 
- `/payment` (genérico)
- `/payment/:bookingId` (com agendamento)

**Como Testar**:
1. Navegar para tela de pagamento
2. **OU** usar Deep Link:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "barbergo://payment" com.barbergo.app
   ```

**O Que Verificar**:

#### PIX
- ✅ QR Code gerado corretamente
- ✅ Botão "Copiar Código PIX"
- ✅ Código copiado para clipboard
- ✅ Countdown de 5 minutos

#### Cartão de Crédito
- ✅ Formulário com validação
- ✅ Número do cartão formatado (1234 5678 9012 3456)
- ✅ Data de validade (MM/AA)
- ✅ CVV com 3 dígitos
- ✅ Opção "Salvar cartão"

#### Carteira Virtual
- ✅ Exibir saldo disponível
- ✅ Verificar saldo insuficiente
- ✅ Processar pagamento

**Firebase Collections**:
```
payment_transactions/{transactionId}
saved_cards/{cardId}
```

---

### 3️⃣ Dashboard BI com Gemini AI

**Rota**: `/bi-dashboard`

**Como Testar**:
1. Navegar para Dashboard
2. **OU** usar Deep Link:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "barbergo://bi-dashboard" com.barbergo.app
   ```

**O Que Verificar**:

#### KPIs (6 Cards)
- ✅ Receita Total
- ✅ Ticket Médio
- ✅ Total de Agendamentos
- ✅ Total de Clientes
- ✅ Taxa de Retenção
- ✅ Taxa de Cancelamento
- ✅ Setas de tendência (↑ verde, ↓ vermelha)

#### Gráficos
- ✅ Gráfico de Linha (Crescimento)
- ✅ Gráfico de Barras (Agendamentos por Hora)
- ✅ Gráfico de Pizza (Receita por Serviço)
- ✅ Cores corretas (primárias do tema)
- ✅ Animações suaves

#### Insights AI (Gemini 2.0)
- ✅ Seção "Insights Inteligentes"
- ✅ 3-5 insights acionáveis
- ✅ Ícones específicos (💡 insights, 🎯 oportunidades, ⚠️ alertas)
- ✅ Recomendações práticas
- ✅ Expandir/colapsar insights

**Teste de AI**:
- Com API Key: Insights personalizados do Gemini
- Sem API Key: Fallback com heurísticas inteligentes

**Firebase Collections**:
```
bookings (leitura para análise)
profiles (leitura para clientes)
```

---

### 4️⃣ Acessibilidade

**Rota**: `/accessibility-settings`

**Como Testar**:
1. Ir para Configurações > Acessibilidade
2. **OU** usar Deep Link:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "barbergo://accessibility-settings" com.barbergo.app
   ```

**O Que Verificar**:

#### Modo Alto Contraste
- ✅ Toggle ativa/desativa
- ✅ Cores mudam instantaneamente
- ✅ Texto branco em fundo preto

#### Modo Texto Grande
- ✅ Slider de 0.8x a 2.0x
- ✅ Preview em tempo real
- ✅ Persistência após fechar app

#### Redução de Movimento
- ✅ Desabilita animações
- ✅ Transições instantâneas

#### Feedback Háptico
- ✅ Vibração ao tocar botões
- ✅ Intensidade ajustável

#### Idiomas (15 opções)
- ✅ Português (padrão)
- ✅ Inglês, Espanhol, Francês, etc.
- ✅ Mudança imediata de interface

#### ⚠️ Recursos com Placeholder
- 🟡 Reconhecimento de Voz (prints no console)
- 🟡 Text-to-Speech (prints no console)
- 💡 **Motivo**: Incompatibilidade Android SDK Platform 31

---

## 📊 Checklist de Validação

### Funcionalidades Essenciais
- [ ] **Chat**: Mensagens enviadas e recebidas
- [ ] **Pagamentos**: QR Code PIX gerado
- [ ] **BI Dashboard**: Gráficos renderizados
- [ ] **Acessibilidade**: Modo Alto Contraste funciona

### Integração Firebase
- [ ] **Chat**: Mensagens salvando em Firestore
- [ ] **Pagamentos**: Transações registradas
- [ ] **BI Dashboard**: Dados carregados de `bookings`

### Performance
- [ ] **Tempo de carregamento**: < 3s para cada tela
- [ ] **Animações**: 60 FPS (fl_chart)
- [ ] **Responsividade**: Sem travamentos

### UI/UX
- [ ] **Tema**: Cores consistentes com o app
- [ ] **AppBar**: Títulos corretos
- [ ] **Navegação**: Botões voltar funcionando
- [ ] **Toasts/Snackbars**: Feedback visual de ações

---

## 🐛 Problemas Conhecidos

### 1. Voice Features (Baixa Prioridade)
- **Status**: ⚠️ Placeholder implementado
- **Impacto**: Comandos de voz não funcionam
- **Workaround**: Interface visual completa
- **Solução Futura**: Migrar para `flutter_voice` ou API nativa

### 2. Gemini AI (Requer API Key)
- **Status**: ✅ Fallback implementado
- **Impacto**: Sem insights personalizados se não houver key
- **Workaround**: Heurísticas inteligentes baseadas em regras
- **Como Adicionar Key**: Ver `COMO_ADICIONAR_API_KEYS.md`

---

## 📸 Screenshots Recomendados

Capture telas das seguintes situações:

1. **Chat Room**:
   - Conversa com 5+ mensagens
   - Indicador "online" visível
   - Área de digitação focada

2. **Pagamentos**:
   - QR Code PIX exibido
   - Formulário de cartão preenchido
   - Confirmação de pagamento

3. **BI Dashboard**:
   - 6 cards KPI visíveis
   - Gráfico de linha com dados
   - Insights AI expandidos

4. **Acessibilidade**:
   - Modo Alto Contraste ATIVADO
   - Slider de texto em 2.0x
   - Lista de 15 idiomas

---

## 🚨 Comandos de Emergência

### Se o App Crashar
```bash
# Ver logs completos
adb logcat -s flutter:V

# Reinstalar
flutter clean
flutter pub get
flutter build apk --debug
flutter install
```

### Se Firebase Não Conectar
```bash
# Verificar regras do Firestore
firebase firestore:rules
# Ver no console: https://console.firebase.google.com/
```

### Se Rotas Não Funcionarem
```bash
# Reexecutar build_runner
dart run build_runner build --delete-conflicting-outputs
```

---

## ✅ Critérios de Sucesso

### Sprint Considerado **100% Completo** Se:
1. ✅ As 4 features navegáveis via rotas
2. ✅ Chat salva mensagens no Firebase
3. ✅ QR Code PIX gerado corretamente
4. ✅ BI Dashboard exibe 3 gráficos
5. ✅ Modo Alto Contraste altera cores
6. ✅ App não crasha em nenhuma tela

### Sprint Considerado **95% Completo** Se:
- ⚠️ Voice features não funcionam (já esperado)
- ⚠️ Gemini AI usa fallback (sem API key)

---

## 📱 Dispositivos Testados

- **Previsto**: Redmi Note 8 Pro, Android 11
- **Outros**: (adicione aqui após testar)

---

**Última Atualização**: 07/11/2025 - 15:00  
**Responsável**: GitHub Copilot  
**Status**: 🚀 Pronto para Testes
