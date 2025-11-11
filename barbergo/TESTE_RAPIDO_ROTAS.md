# 🧪 Teste Rápido - Features Premium

**APK Instalado**: ✅ Redmi Note 8 Pro  
**Data**: 07/11/2025

---

## 🎯 Como Testar Cada Feature

### 1. 💬 Chat Room (WhatsApp-Style)

**Navegação**: Você precisa passar os parâmetros obrigatórios na rota

**Exemplo de Navegação Programática**:
```dart
context.go(
  '/chat-room/abc123/user456/João Silva?avatar=https://example.com/avatar.jpg'
);
```

**Parâmetros**:
- `chatId`: ID da sala (ex: `abc123`)
- `otherUserId`: ID do outro usuário (ex: `user456`)
- `otherUserName`: Nome do outro usuário (ex: `João Silva`)
- `avatar` (opcional): URL do avatar (query parameter)

**Teste Manual**:
1. Abra o app
2. Navegue para uma conversa existente através do menu
3. Envie mensagens
4. Verifique bolhas de mensagem
5. Verifique indicador "online"

---

### 2. 💰 Sistema de Pagamentos

**Navegação**: Precisa passar `amount` e `description`

**Exemplo de Navegação**:
```dart
context.go(
  '/payment/150.00/Corte de Cabelo?bookingId=booking123'
);
```

**Parâmetros**:
- `amount`: Valor em reais (ex: `150.00`)
- `description`: Descrição do pagamento (ex: `Corte de Cabelo`)
- `bookingId` (opcional): ID do agendamento (query parameter)

**Teste Manual**:
1. Navegue para `/payment/50.00/Teste de Pagamento`
2. Selecione método PIX
3. Verifique QR Code gerado
4. Copie código PIX
5. Teste formulário de cartão

---

### 3. 📊 BI Dashboard

**Navegação**: Automaticamente pega o ID do usuário logado

**Exemplo de Navegação**:
```dart
context.go('/bi-dashboard');
```

**Teste Manual**:
1. Navegue para `/bi-dashboard`
2. Verifique 6 cards KPI
3. Verifique 3 gráficos (linha, barras, pizza)
4. Expanda "Insights Inteligentes"
5. Verifique recomendações AI

**Nota**: Se não houver API Key do Gemini configurada, usa fallback com heurísticas.

---

### 4. ♿ Acessibilidade

**Navegação**: Simples, sem parâmetros

**Exemplo de Navegação**:
```dart
context.go('/accessibility-settings');
```

**Teste Manual**:
1. Navegue para `/accessibility-settings`
2. Ative "Modo Alto Contraste"
3. Verifique mudança de cores
4. Ajuste "Tamanho de Texto" (slider)
5. Ative "Feedback Háptico"
6. Escolha outro idioma

**Limitação Conhecida**: Comandos de voz não funcionam (placeholder)

---

## 🔍 Validação de Erros

### Verificar Logs
```bash
# Terminal PowerShell
flutter logs

# Procurar por erros
flutter logs | Select-String "error|Error|ERROR"
```

### Firebase Console
- Chat: `https://console.firebase.google.com/project/[SEU_PROJETO]/firestore/data/chat_rooms`
- Pagamentos: `https://console.firebase.google.com/project/[SEU_PROJETO]/firestore/data/payment_transactions`

---

## ✅ Checklist Rápido

- [ ] Chat: Envia mensagens ✅
- [ ] Chat: Exibe online/offline ✅
- [ ] Payment: QR Code PIX ✅
- [ ] Payment: Formulário cartão ✅
- [ ] BI Dashboard: 6 KPIs ✅
- [ ] BI Dashboard: 3 gráficos ✅
- [ ] Acessibilidade: Alto Contraste ✅
- [ ] Acessibilidade: Texto Grande ✅

---

## 🚨 Se Encontrar Erro

1. **Erro de Navegação**:
   - Verifique se passou todos os parâmetros obrigatórios
   - Formato: `/chat-room/:chatId/:otherUserId/:otherUserName`

2. **Erro Firebase**:
   - Verifique internet
   - Veja regras do Firestore

3. **Erro Gemini AI**:
   - Normal se não tiver API Key
   - Fallback funciona automaticamente

---

**Última Atualização**: 07/11/2025 - 16:00  
**Status**: 🔄 Compilando APK atualizado com correções
