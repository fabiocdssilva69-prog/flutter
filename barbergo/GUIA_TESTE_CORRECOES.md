# 🧪 GUIA DE TESTE DAS CORREÇÕES - 05/11/2025

## 📱 PREPARAÇÃO DO DEVICE

### 1. Conectar o Celular Android (Redmi Note 8 Pro)

**Passos:**
1. Conectar celular ao computador via cabo USB
2. No celular, permitir "Transferência de arquivos" (MTP)
3. Ativar "Depuração USB" se ainda não estiver:
   - Configurações → Sobre o telefone
   - Tocar 7x em "Versão MIUI" para ativar modo desenvolvedor
   - Configurações → Configurações adicionais → Opções do desenvolvedor
   - Ativar "Depuração USB"

### 2. Verificar Conexão

```powershell
# Verificar se device aparece
flutter devices
```

**Resultado Esperado:**
```
Redmi Note 8 Pro (mobile) • uwbekb8hpf6lamts • android-arm64 • Android 10
```

---

## 🚀 TESTE 1: VALIDAÇÃO DOS 7 PERFIS

### Passo 1: Executar o App

```powershell
flutter run -d uwbekb8hpf6lamts
```

### Passo 2: Aguardar Build Completar

⏳ **Tempo Estimado:** 3-5 minutos (primeira vez)

**Logs Esperados:**
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app.apk...
```

### Passo 3: Fazer Login no App

- Abrir app no celular
- Fazer login com conta teste
- Aguardar chegar na tela principal

### Passo 4: Abrir Tela "Descobrir"

- Tocar no ícone de descoberta (coração/swipe)
- Aguardar carregar profiles

### Passo 5: Monitorar Logs no Console

**Procurar por estas linhas:**

```
🔍 [discoverProfiles] currentUser.uid: ...
🔍 [discoverProfiles] currentProfile.accountType: ...
🔍 [discoverProfiles] accountTypeFilter: barber
🔍 [discoverProfiles] snapshot.docs.length: ?
📋 [discoverProfiles] Doc IDs: barber_001, barber_002, ...
```

**✅ SUCESSO SE:**
```
📋 [discoverProfiles] Doc IDs: barber_001, barber_002, barber_003, barber_004, barber_005, barber_006, barber_007
✅ [discoverProfiles] Final profiles count: 7 (server-ordered)
```

**❌ FALHA SE:**
```
📋 [discoverProfiles] Doc IDs: barber_001, barber_003, barber_006, barber_007
✅ [discoverProfiles] Final profiles count: 4 (server-ordered)
```

### Passo 6: Contar Cards na Tela

**Manualmente:**
- Fazer swipe direita/esquerda
- Contar quantos profiles diferentes aparecem
- **ESPERADO:** 7 profiles
- **ANTES:** 4 profiles

### Passo 7: Verificar Logs Detalhados de Cada Profile

```
🔍 [discoverProfiles] Processing doc: barber_002
  📊 accountType: barber
  📊 email: joao.silva@example.com
  📊 boostedUntil: null
  📊 isPremium: false
  📊 updatedAt: 1730483400000
  📊 name: João Silva
```

**✅ Validar que barber_002, barber_004, barber_005 aparecem com campos corretos**

---

## 🚀 TESTE 2: CARDSWIPER BACK BUTTON

### Passo 1: Na Tela Discovery

- Confirmar que está vendo cards de profiles

### Passo 2: Fazer 3-4 Swipes

- Swipe direita (LIKE) ou esquerda (DISLIKE)
- Aguardar cada animação completar

### Passo 3: Pressionar BACK Button

- Usar botão físico BACK do Android
- Ou gesture de voltar

### Passo 4: Monitorar Console

**❌ NÃO DEVE APARECER:**
```
❌ [LOG ERROR] PlatformDispatcher.onError (Fatal)
setState() called after dispose(): _CardSwiperState#ece0f
#0 State.setState.<anonymous closure>
#2 _CardSwiperState._reset (package:flutter_card_swiper/...)
```

**✅ PODE APARECER (benigno):**
```
⚠️ CardSwiper dispose warning: ...
```

### Passo 5: Verificar Navegação

**✅ SUCESSO SE:**
- App volta para tela anterior suavemente
- Nenhum crash
- Nenhum setState error

**❌ FALHA SE:**
- App crasha
- Log mostra "setState() called after dispose"
- Tela fica congelada

---

## 🚀 TESTE 3: VALIDAÇÃO OPCIONAL DOS PERFIS (Python Script)

**Pré-requisito:**
```powershell
pip install firebase-admin
```

**Baixar Credenciais:**
1. Ir em: https://console.firebase.google.com/project/barbergo-38c21/settings/serviceaccounts/adminsdk
2. Clicar "Gerar nova chave privada"
3. Salvar como: `barbergo-38c21-firebase-adminsdk.json`
4. Colocar na pasta raiz do projeto

**Executar Validação:**
```powershell
python validate_profiles.py
```

**Resultado Esperado:**
```
📋 PROFILE: barber_002
Status: ✅ VÁLIDO

📊 Campos Encontrados:
  ✅ accountType: barber
  ✅ email: joao.silva@example.com
  ✅ boostedUntil: None
  ✅ isPremium: False
  ✅ updatedAt: 1730483400000
  ✅ name: João Silva

[... repete para barber_004 e barber_005 ...]

📊 RESUMO FINAL
✅ Válidos: 3/3
🎉 TODOS OS PERFIS ESTÃO VÁLIDOS!
```

---

## 📊 CHECKLIST DE VALIDAÇÃO

### ✅ Teste 1: 7 Perfis na Discovery

- [ ] Device conectado via USB
- [ ] App compilou e instalou sem erros
- [ ] Login realizado com sucesso
- [ ] Tela Discovery aberta
- [ ] **Logs mostram: `snapshot.docs.length: 7`**
- [ ] **Logs mostram: Doc IDs com barber_002, 004, 005**
- [ ] **Contagem manual: 7 cards aparecem**
- [ ] Campos de barber_002, 004, 005 estão corretos nos logs

### ✅ Teste 2: BACK Button Sem Crash

- [ ] Fiz 3-4 swipes na Discovery
- [ ] Pressionei BACK button
- [ ] **App voltou sem crash**
- [ ] **Nenhum "setState() called after dispose" no console**
- [ ] Navegação suave

### ✅ Teste 3: Script Python (Opcional)

- [ ] firebase-admin instalado
- [ ] Credenciais baixadas
- [ ] Script executado com sucesso
- [ ] **3/3 perfis válidos**

---

## 📝 REPORTAR RESULTADOS

**Formato:**

```markdown
## 🧪 RESULTADOS DOS TESTES - [Data/Hora]

### TESTE 1: 7 Perfis
- ✅/❌ Logs mostram 7 profiles
- ✅/❌ barber_002 aparece
- ✅/❌ barber_004 aparece
- ✅/❌ barber_005 aparece
- ✅/❌ Contagem manual: X profiles

### TESTE 2: BACK Button
- ✅/❌ Sem crash ao pressionar BACK
- ✅/❌ Sem setState error
- ✅/❌ Navegação suave

### TESTE 3: Python Script
- ✅/❌ Executado com sucesso
- ✅/❌ 3/3 perfis válidos

### OBSERVAÇÕES:
[Qualquer comportamento inesperado, logs estranhos, etc]
```

---

## 🔧 TROUBLESHOOTING

### Device Não Conecta

**Problema:**
```
No supported devices found with name or id matching 'uwbekb8hpf6lamts'
```

**Soluções:**
1. Reconectar cabo USB
2. Revogar e aceitar novamente "Depuração USB" no celular
3. Reiniciar ADB:
   ```powershell
   adb kill-server
   adb start-server
   flutter devices
   ```

### Ainda Mostra 4 Perfis

**Ação:**
1. Desinstalar app completamente do celular
2. Configurações → Apps → BarberGO → Desinstalar
3. Reinstalar:
   ```powershell
   flutter run -d uwbekb8hpf6lamts
   ```

**Motivo:** Cache do Firestore pode estar com dados antigos

### BACK Ainda Crasha

**Ação:**
1. Verificar se há versão mais nova do package:
   ```powershell
   flutter pub outdated
   flutter pub upgrade flutter_card_swiper
   ```

2. Se persistir, considerar substituir package em `pubspec.yaml`:
   ```yaml
   dependencies:
     appinio_swiper: ^2.1.1  # Alternativa sem bug
   ```

### Python Script Erro

**Erro Comum:**
```
ModuleNotFoundError: No module named 'firebase_admin'
```

**Solução:**
```powershell
pip install firebase-admin
```

**Erro de Credenciais:**
```
FileNotFoundError: barbergo-38c21-firebase-adminsdk.json
```

**Solução:**
- Confirmar arquivo está na pasta raiz
- Nome exato: `barbergo-38c21-firebase-adminsdk.json`

---

## 🎯 PRÓXIMOS PASSOS APÓS TESTES

### Se TODOS os testes passarem (✅✅✅):

**Bugs Resolvidos:**
- ✅ Bug #6: Discovery carrega 7 profiles (era 4)
- ✅ Bug #5: CardSwiper setState after dispose
- ✅ Database corretamente configurado

**Próxima Fase:**
1. Investigar Bug #4: Imagens não carregam
2. Testar Bug #7: Boost button
3. Validar Bug #8: Criação de vagas
4. Verificar Bug #9: Troca barbeiro ↔ barbearia

### Se ALGUM teste falhar (❌):

**Teste 1 Falha (ainda 4 profiles):**
1. Executar Python script para validar campos
2. Verificar Firebase Console → Indexes (status: Enabled?)
3. Desinstalar e reinstalar app (limpar cache)
4. Reportar logs detalhados dos profiles que aparecem

**Teste 2 Falha (BACK crasha):**
1. Verificar versão do flutter_card_swiper
2. Considerar upgrade ou substituição do package
3. Reportar stack trace completo do crash

**Teste 3 Falha (script erro):**
1. Verificar campos no Firebase Console manualmente
2. Comparar com campos esperados em `validate_profiles.py`

---

**Tempo Estimado Total:** 15-20 minutos
**Prioridade:** ALTA - Validação crítica das correções aplicadas

**Boa sorte com os testes! 🚀**
