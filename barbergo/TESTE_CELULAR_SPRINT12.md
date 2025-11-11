# Guia de Teste - Sprint 12 no Celular 📱

## Status: Executando no Redmi Note 8 Pro

**Dispositivo**: Redmi Note 8 Pro (Android 11 - API 30)  
**Data**: 18 de Outubro de 2025

---

## Checklist de Testes

### 1️⃣ Login & Autenticação
- [ ] Abrir o app
- [ ] Fazer login com conta de **Barbearia**
- [ ] Verificar se o perfil carrega corretamente
- [ ] Anotar o nome da barbearia e localização (city/state)

---

### 2️⃣ Criar Vaga (Barbearia)
- [ ] Ir para a aba **Management** (Gestão)
- [ ] Clicar em **"+ Nova Vaga"**
- [ ] Preencher:
  - Título: "Barbeiro Profissional"
  - Tipo: Full-time ou Freelance
  - Requisitos: "Experiência com cortes modernos"
  - Horas: "Segunda a Sábado, 9h-18h"
  - Comissão: "60% por corte"
- [ ] Clicar em **"Criar Vaga"**
- [ ] **VERIFICAR**: A vaga aparece na lista com:
  - ✅ Nome da barbearia (desnormalizado)
  - ✅ Localização city/state (desnormalizado)
  - ✅ Status: **ATIVA** (chip verde)

---

### 3️⃣ Gestão de Status (Barbearia)
- [ ] Abrir a vaga criada (clicar na lista)
- [ ] Ver detalhes da vaga
- [ ] Clicar no ícone **"Pausar"** (⏸️) no AppBar
- [ ] **VERIFICAR**: Dialog de confirmação aparece
- [ ] Confirmar a pausa
- [ ] **VERIFICAR**: 
  - ✅ Status muda para **PAUSADA** (chip laranja)
  - ✅ Ícone muda para **"Reabrir"** (▶️)
  - ✅ UI atualiza em tempo real
- [ ] Clicar em **"Reabrir"** novamente
- [ ] **VERIFICAR**: Status volta para **ATIVA**

---

### 4️⃣ Logout & Login como Barbeiro
- [ ] Fazer logout da conta de Barbearia
- [ ] Fazer login com conta de **Barbeiro**
- [ ] Verificar se o perfil carrega
- [ ] Anotar a localização (city/state) do barbeiro

---

### 5️⃣ Feed de Descoberta (Barbeiro)
- [ ] Ir para a aba **Home** (Feed)
- [ ] **VERIFICAR**: Aparecem APENAS vagas:
  - ✅ Da MESMA localização (city/state)
  - ✅ Com status ATIVA (não aparecem pausadas)
  - ✅ Com nome da barbearia visível no card
  - ✅ Com localização visível no card
- [ ] Se não aparecer nada: 
  - ⚠️ Verificar se as localizações coincidem (Barbearia vs Barbeiro)
  - ⚠️ Criar vaga com mesma location

---

### 6️⃣ Swipe & Interações (Barbeiro)
**Teste 1 - Swipe Direita (Aplicar)**:
- [ ] Arrastar o card da vaga para a **direita** →
- [ ] **VERIFICAR**:
  - ✅ SnackBar: "Candidatura enviada para [Nome da Barbearia]!"
  - ✅ O card desaparece do feed
  - ✅ A vaga NÃO reaparece (mesmo fechando/abrindo o app)

**Teste 2 - Swipe Esquerda (Ignorar)**:
- [ ] Criar outra vaga na Barbearia (para ter mais cards)
- [ ] No feed do Barbeiro, arrastar card para **esquerda** ←
- [ ] **VERIFICAR**:
  - ✅ O card desaparece
  - ✅ A vaga NÃO reaparece (ignorada)
  - ✅ Nenhum SnackBar aparece (só registra interação)

---

### 7️⃣ Minhas Candidaturas (Barbeiro)
- [ ] Ir para a aba **Candidaturas** (Applications)
- [ ] **VERIFICAR**:
  - ✅ Aparece a vaga que você aplicou (swipe direita)
  - ✅ Nome da barbearia está visível (desnormalizado)
  - ✅ Status: **PENDENTE** (chip amarelo)
  - ✅ Data de candidatura aparece

---

### 8️⃣ Ver Candidatos (Barbearia)
- [ ] Logout do Barbeiro
- [ ] Login como Barbearia novamente
- [ ] Ir para **Management** → Abrir a vaga
- [ ] Rolar para baixo até **"Candidatos (X)"**
- [ ] **VERIFICAR**:
  - ✅ Lista mostra o barbeiro que aplicou
  - ✅ Nome do barbeiro aparece
  - ✅ Status: PENDENTE
  - ✅ Botões "Aceitar" e "Rejeitar" funcionam

---

### 9️⃣ Aceitar/Rejeitar Candidatura (Barbearia)
**Teste Aceitar**:
- [ ] Clicar em **"Aceitar"** no candidato
- [ ] **VERIFICAR**: Dialog de confirmação aparece
- [ ] Confirmar
- [ ] **VERIFICAR**:
  - ✅ Status muda para **ACEITO** (chip verde)
  - ✅ Botões desabilitam

**Teste Rejeitar**:
- [ ] Criar outra vaga e fazer novo barbeiro aplicar
- [ ] Clicar em **"Rejeitar"**
- [ ] **VERIFICAR**:
  - ✅ Status muda para **REJEITADO** (chip vermelho)

---

### 🔟 Sincronização Real-Time (Teste Avançado)
**Prepare**:
- [ ] Abrir app no celular (Barbeiro logado)
- [ ] Abrir app no computador/emulador (Barbearia logada)

**Teste**:
- [ ] No computador: Criar nova vaga ATIVA
- [ ] **VERIFICAR no celular**: Nova vaga aparece automaticamente no feed (sem recarregar)
- [ ] No computador: Pausar a vaga
- [ ] **VERIFICAR no celular**: Vaga desaparece do feed em tempo real
- [ ] No computador: Reabrir a vaga
- [ ] **VERIFICAR no celular**: Vaga reaparece no feed

---

## Erros Esperados (Podem Acontecer)

### ❌ "Nenhuma vaga disponível"
**Causa**: Localização diferente entre Barbearia e Barbeiro  
**Solução**: 
1. Verificar `ProfileEntity.location` de ambos
2. Editar perfil para usar mesma city/state
3. Recarregar o feed

### ❌ Vaga não aparece após criar
**Causa**: Status `isActive = false` ou sem `locationCityState`  
**Solução**:
1. Verificar no Firestore: `vacancies/{vacancyId}/isActive`
2. Verificar `vacancies/{vacancyId}/locationCityState`
3. Recriar vaga se necessário

### ❌ App trava ao dar swipe
**Causa**: `InteractionRepository` ou `ApplicationController` com erro  
**Solução**:
1. Ver logs no terminal: `flutter logs`
2. Verificar se Firestore está online
3. Verificar permissões de rede do app

### ❌ Nome da barbearia aparece "null" ou vazio
**Causa**: Desnormalização falhou em `createVacancy()`  
**Solução**:
1. Verificar `ProfileEntity.name` está preenchido
2. Recriar a vaga
3. Verificar logs do `ManagementController`

---

## Performance Esperada

### Métricas Alvo (Sprint 12)
- **Tempo de carregamento do feed**: < 100ms
- **Tempo de swipe → feedback**: < 50ms
- **Atualização real-time**: < 500ms
- **Scroll do feed**: 60 FPS (fluido)

### Como Medir
1. Abrir DevTools: `flutter run --profile`
2. Ver tab **Performance**
3. Verificar frame times durante swipes

---

## Checklist de Validação Final

### Funcionalidades Core ✅
- [ ] Criar vaga com desnormalização
- [ ] Pausar/reabrir vaga
- [ ] Feed filtra por localização (server-side)
- [ ] Feed remove vagas já vistas (client-side)
- [ ] Swipe direita cria candidatura
- [ ] Swipe esquerda registra "ignored"
- [ ] Candidaturas aparecem na lista
- [ ] Barbearia vê candidatos
- [ ] Aceitar/rejeitar funciona

### Performance ✅
- [ ] Feed carrega rápido (< 100ms)
- [ ] Swipes são instantâneos
- [ ] UI não trava
- [ ] Scroll é fluido

### UX ✅
- [ ] Cards bonitos e legíveis
- [ ] Chips de status com cores corretas
- [ ] SnackBars aparecem nos momentos certos
- [ ] Confirmações antes de ações destrutivas
- [ ] Feedback visual em todas as ações

---

## Próximos Passos Após Testes

### Se TODOS os testes passarem ✅
1. Fazer commit final:
   ```bash
   git add .
   git commit -m "feat(sprint12): Smart Matching System - TESTED & WORKING"
   git push origin barbergo
   ```

2. Criar release notes
3. Documentar bugs conhecidos (se houver)
4. Planejar Sprint 13

### Se houver BUGS 🐛
1. Anotar todos os erros encontrados
2. Criar arquivo `BUGS_SPRINT12.md`
3. Priorizar correções (crítico → menor)
4. Implementar fixes
5. Re-testar

---

## Notas do Teste

**Anotações do usuário**:
```
[Use este espaço para anotar observações durante o teste]

- 
- 
- 
```

**Bugs Encontrados**:
```
1. 
2. 
3. 
```

**Sugestões de Melhoria**:
```
- 
- 
- 
```

---

**Data do Teste**: 18/10/2025  
**Dispositivo**: Redmi Note 8 Pro (Android 11)  
**Build**: Debug Mode  
**Tester**: @fabiocdssilva69-prog
