# 📋 Checklist de Smoke Tests - Sprint 29

## 🎯 Objetivo
Validar funcionalidades críticas após implementação do Mutex FCM e compressão de imagens.

---

## ✅ TESTE 1: Autenticação (FCM Token)

### Passos:
1. Abrir app (já deve estar aberto)
2. Se não logado, fazer login ou criar conta
3. **Monitorar logs em tempo real**

### Comando de Monitoramento:
```powershell
flutter logs -d uwbekb8hpf6lamts 2>&1 | Select-String -Pattern "FCM_Lock|LOGIN|Auth" -Context 0,0 | Select-Object -First 30
```

### Resultado Esperado:
- ✅ Login bem-sucedido
- ✅ Logs mostram: `FCM_LockAcquired` → `FCM_UpdatingTokenInBackend_Atomic` → `FCM_TokenUpdateSuccess_Atomic` → `FCM_LockReleased`
- ✅ **APENAS 1 SEQUÊNCIA** (não múltiplas como antes)

### Status: [ ] PASS / [ ] FAIL

---

## ✅ TESTE 2: Compressão de Imagens (Avatar)

### Passos:
1. Ir para tela de Perfil
2. Clicar em "Editar Perfil" ou ícone de câmera
3. Selecionar/tirar foto do avatar
4. Aguardar upload

### Comando de Monitoramento:
```powershell
flutter logs -d uwbekb8hpf6lamts 2>&1 | Select-String -Pattern "ImageCompress|Upload" -Context 0,1 | Select-Object -First 20
```

### Resultado Esperado:
- ✅ Avatar atualizado na tela
- ✅ Logs mostram: `ImageCompress_Success: {originalKB: XXXX, compressedKB: YYYY, reductionPercent: ZZ%}`
- ✅ Redução de tamanho entre **50-70%**

### Métricas Observadas:
- Original: _____ KB
- Comprimido: _____ KB
- Redução: _____ %

### Status: [ ] PASS / [ ] FAIL

---

## ✅ TESTE 3: Navegação Principal

### Passos:
1. Navegar por todas as abas do bottom navigation
2. Testar transições de tela (push/pop)
3. Verificar se não há crashes ou travamentos

### Abas para testar:
- [ ] Home/Feed
- [ ] Perfil
- [ ] Vagas (lista e detalhes)
- [ ] Chat/Mensagens (se disponível)

### Resultado Esperado:
- ✅ Todas as abas carregam corretamente
- ✅ Transições suaves
- ✅ Nenhum erro de navegação

### Status: [ ] PASS / [ ] FAIL

---

## ✅ TESTE 4: Features Principais (CRUD)

### Para Barbeiros:
- [ ] Criar nova vaga
- [ ] Editar vaga existente
- [ ] Visualizar lista de vagas criadas
- [ ] Adicionar foto ao portfólio (testar compressão)

### Para Clientes:
- [ ] Buscar vagas disponíveis
- [ ] Visualizar detalhes de vaga
- [ ] Favoritar vaga (se implementado)
- [ ] Enviar mensagem ao barbeiro

### Comando de Monitoramento (Upload Portfolio):
```powershell
flutter logs -d uwbekb8hpf6lamts 2>&1 | Select-String -Pattern "ImageCompress|Portfolio|Upload" -Context 0,1 | Select-Object -First 20
```

### Resultado Esperado:
- ✅ Operações CRUD funcionam
- ✅ Fotos de portfólio comprimidas (1080px, 75% quality)
- ✅ Dados sincronizados com Firestore

### Status: [ ] PASS / [ ] FAIL

---

## ✅ TESTE 5: Performance & Bateria

### Passos:
1. Deixar app em primeiro plano por 5 minutos
2. Verificar temperatura do dispositivo
3. Monitorar consumo de bateria (Configurações → Bateria → Uso por app)

### Comando de Monitoramento (Loop FCM):
```powershell
# Executar por 60 segundos e contar eventos FCM
flutter logs -d uwbekb8hpf6lamts 2>&1 | Select-String -Pattern "FCM_Updating" | Measure-Object
```

### Resultado Esperado:
- ✅ Dispositivo NÃO aquece excessivamente
- ✅ Consumo de bateria razoável (< 5% em 5 min)
- ✅ **Contagem de `FCM_Updating`: 0-1 (máximo!)** ← CRÍTICO!

### Métricas Observadas:
- Bateria inicial: _____ %
- Bateria após 5 min: _____ %
- Consumo: _____ %
- Eventos FCM_Updating em 60s: _____ (esperado: 0-1)

### Status: [ ] PASS / [ ] FAIL

---

## 📊 RESUMO FINAL

| Teste | Status | Observações |
|-------|--------|-------------|
| 1. Autenticação | [ ] PASS / [ ] FAIL | |
| 2. Compressão Imagens | [ ] PASS / [ ] FAIL | Redução: _____% |
| 3. Navegação | [ ] PASS / [ ] FAIL | |
| 4. Features CRUD | [ ] PASS / [ ] FAIL | |
| 5. Performance | [ ] PASS / [ ] FAIL | Consumo: _____% |

---

## 🐛 Bugs Encontrados

### Bug 1:
- **Descrição:** 
- **Severidade:** [ ] CRÍTICO [ ] ALTO [ ] MÉDIO [ ] BAIXO
- **Passos para reproduzir:**
- **Logs:**

### Bug 2:
- **Descrição:** 
- **Severidade:** [ ] CRÍTICO [ ] ALTO [ ] MÉDIO [ ] BAIXO
- **Passos para reproduzir:**
- **Logs:**

---

## ✅ CONCLUSÃO

**Status Geral:** [ ] APROVADO [ ] REPROVADO [ ] PARCIAL

**Decisão:**
- [ ] **Prosseguir para Sprint 30 (Beta)**
- [ ] **Corrigir bugs críticos antes**
- [ ] **Mais testes necessários**

**Assinatura:** _________________ **Data:** ___/___/_____
