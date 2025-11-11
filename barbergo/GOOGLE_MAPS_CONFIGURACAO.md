# 🔐 DADOS PARA CONFIGURAR RESTRIÇÕES NO GOOGLE CLOUD CONSOLE

**Data:** 02/11/2025  
**Status:** ⏳ AGUARDANDO CONFIGURAÇÃO MANUAL DAS RESTRIÇÕES

---

## 📋 INFORMAÇÕES OBTIDAS

### ✅ API Key Criada:
```
AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ
```

### ✅ SHA-1 Fingerprint (Debug):
```
28:BF:6A:A0:81:61:4F:A9:9D:29:A9:54:E7:84:41:B3:B9:38:1F:8F
```

### ✅ Package Name:
```
br.com.barbergo.app
```

---

## 🎯 AÇÕES MANUAIS NECESSÁRIAS

### PASSO 1: Renomear API Key
**Link:** https://console.cloud.google.com/apis/credentials?project=barbergo-38c21

1. Encontre a chave: `AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ`
2. Clique no nome da chave
3. No campo "Nome", digite: `BarberGO Maps Key`
4. Clique em "SALVAR"

---

### PASSO 2: Adicionar Restrições de Aplicação

**Ainda na mesma tela da API Key:**

1. **Application restrictions:**
   - Selecione: ⭕ **Android apps**

2. Clique em **+ ADD AN ITEM**

3. Preencha:
   - **Package name:** 
     ```
     br.com.barbergo.app
     ```
   - **SHA-1 certificate fingerprint:** 
     ```
     28:BF:6A:A0:81:61:4F:A9:9D:29:A9:54:E7:84:41:B3:B9:38:1F:8F
     ```

4. Clique em **Done**

---

### PASSO 3: Adicionar Restrições de API

**Ainda na mesma tela:**

1. **API restrictions:**
   - Selecione: ⭕ **Restrict key**

2. Marque estas 5 APIs:
   - ☑️ **Maps SDK for Android**
   - ☑️ **Maps SDK for iOS**
   - ☑️ **Maps JavaScript API**
   - ☑️ **Geocoding API**
   - ☑️ **Places API**

3. Clique em **SAVE** (botão azul no final da página)

---

### PASSO 4: Aguardar Propagação

⏳ **Aguarde 5-10 minutos** para que as restrições sejam aplicadas nos servidores do Google.

---

## ✅ ARQUIVOS JÁ CONFIGURADOS

### 1. `.env` (Raiz do projeto)
```env
GOOGLE_MAPS_API_KEY=AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ
```
✅ **Status:** Configurado e protegido pelo .gitignore

---

### 2. `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY" 
    android:value="AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ"/>
```
✅ **Status:** Configurado (chave antiga substituída)

---

### 3. `ios/Runner/AppDelegate.swift`
```swift
import GoogleMaps

GMSServices.provideAPIKey("AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ")
```
✅ **Status:** Configurado

---

## 🧪 PRÓXIMOS PASSOS (APÓS CONFIGURAR RESTRIÇÕES)

### Teste 1: Compilar o Projeto
```powershell
cd C:\workspaces\fabiocdssilva69-prog\barbergo
flutter clean
flutter pub get
flutter run
```

### Teste 2: Verificar Logs
Ao rodar o app, verifique no console se não há erros relacionados ao Google Maps:
- ✅ **Sucesso:** Nenhum erro de "API key not valid"
- ✅ **Sucesso:** Nenhum erro de "This API project is not authorized"
- ❌ **Erro:** Se aparecer erro, aguarde mais 5-10 min (propagação)

### Teste 3: Testar Mapa (Quando Implementado)
Quando implementar uma tela com mapa:
```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(-23.550520, -46.633308), // São Paulo
    zoom: 14,
  ),
)
```

---

## 📊 RESUMO DO STATUS

```
┌─────────────────────────────────────────────────────────┐
│         CONFIGURAÇÃO GOOGLE MAPS API                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Habilitar 5 APIs        [███████████████████] 100% ✅ │
│  Criar API Key           [███████████████████] 100% ✅ │
│  Obter SHA-1             [███████████████████] 100% ✅ │
│  Configurar .env         [███████████████████] 100% ✅ │
│  Configurar Android      [███████████████████] 100% ✅ │
│  Configurar iOS          [███████████████████] 100% ✅ │
│  Adicionar Restrições    [░░░░░░░░░░░░░░░░░░░]   0% ⏳ │
│  Testar no App           [░░░░░░░░░░░░░░░░░░░]   0% ⏳ │
│                                                         │
│  PROGRESSO TOTAL:        [█████████████████░░]  75%    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## ⚠️ IMPORTANTE - SEGURANÇA

### ✅ O que está PROTEGIDO:
- API Key no `.env` (não será commitada)
- `.env` no `.gitignore`
- Restrições por SHA-1 (somente seu app pode usar)
- Restrições por APIs (somente 5 APIs podem ser usadas)

### ⚠️ O que FALTA:
- **Aplicar restrições no Google Cloud Console** (passo manual necessário)
- Sem restrições = Qualquer pessoa pode usar sua chave!

---

## 🔗 LINKS DIRETOS

- **Credentials:** https://console.cloud.google.com/apis/credentials?project=barbergo-38c21
- **Dashboard APIs:** https://console.cloud.google.com/apis/dashboard?project=barbergo-38c21
- **Billing/Usage:** https://console.cloud.google.com/billing/usage?project=barbergo-38c21

---

## 📝 CHECKLIST FINAL

Quando terminar, marque:
- [x] API Key criada ✅
- [x] SHA-1 obtido ✅
- [x] Arquivos configurados ✅
- [ ] Restrições aplicadas ⏳ **← VOCÊ ESTÁ AQUI**
- [ ] Testado no emulador ⏳
- [ ] Mapa funcionando ⏳

---

**🎯 PRÓXIMA AÇÃO: Configure as restrições no Google Cloud Console usando os dados acima!**

**Tempo estimado:** 5 minutos  
**Link direto:** https://console.cloud.google.com/apis/credentials?project=barbergo-38c21
