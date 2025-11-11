# 🗺️ GOOGLE MAPS API - CONFIGURAÇÃO PENDENTE

**Status:** ⏳ AGUARDANDO CONFIGURAÇÃO MANUAL  
**Tempo estimado:** 30-40 minutos  
**Prioridade:** MÉDIA (não bloqueia desenvolvimento atual)

---

## 📋 CHECKLIST DE CONFIGURAÇÃO

### 1. Habilitar APIs no Google Cloud Console (15 min)

**Link:** <https://console.cloud.google.com/apis/library?project=barbergo-38c21>

Habilite estas 5 APIs:

- [ ] **Maps SDK for Android** - Para mapa no app Android
- [ ] **Maps SDK for iOS** - Para mapa no app iOS  
- [ ] **Maps JavaScript API** - Para mapa na versão web
- [ ] **Geocoding API** - Para converter endereços em coordenadas
- [ ] **Places API** - Para buscar locais e autocompletar endereços

---

### 2. Criar API Key (5 min)

**Link:** <https://console.cloud.google.com/apis/credentials?project=barbergo-38c21>

1. Clique em **+ CREATE CREDENTIALS** → **API Key**
2. Copie a chave gerada: `AIzaSy...` (salve em local seguro)
3. Renomeie para: "BarberGO Maps Key"

⚠️ **NÃO feche a janela ainda!** Continue para restrições.

---

### 3. Obter SHA-1 do App Android (5 min)

```powershell
cd C:\workspaces\fabiocdssilva69-prog\barbergo\android
.\gradlew.bat signingReport
```

**Saída esperada:**

```
Variant: debug
Config: debug
Store: ...
Alias: ...
SHA1: 3B:7D:9C:... ← COPIE ESTE
SHA-256: ...
```

📋 **Copie o SHA-1 da linha "Variant: debug"**

---

### 4. Restringir API Key (5 min)

**Ainda na janela da API Key criada:**

#### Application restrictions

1. Selecione: **Android apps**
2. Clique **+ ADD AN ITEM**
3. Preencha:
   - **Package name:** `br.com.barbergo.app`
   - **SHA-1 certificate fingerprint:** [Cole o SHA-1 do passo 3]
4. Clique **Done**

#### API restrictions

1. Selecione: **Restrict key**
2. Marque estas 5 APIs:
   - [x] Maps SDK for Android
   - [x] Maps SDK for iOS
   - [x] Maps JavaScript API
   - [x] Geocoding API
   - [x] Places API
3. Clique **Save**

⏳ Aguarde 5-10 minutos para as restrições serem aplicadas.

---

### 5. Configurar Projeto Flutter (10 min)

#### 5.1. Criar arquivo .env na raiz

```bash
# Crie o arquivo se não existir
New-Item -Path ".env" -ItemType File -Force
```

**Conteúdo do .env:**

```env
GOOGLE_MAPS_API_KEY=AIzaSy...  # Cole sua chave aqui
```

#### 5.2. Adicionar ao .gitignore

```bash
# Adicione esta linha ao .gitignore se não existir
echo ".env" | Out-File -FilePath .gitignore -Append -Encoding UTF8
```

#### 5.3. Configurar Android

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

Adicione dentro de `<application>` (após `android:icon`):

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${GOOGLE_MAPS_API_KEY}"/>
```

#### 5.4. Configurar iOS

**Arquivo:** `ios/Runner/AppDelegate.swift`

Adicione no topo (após imports):

```swift
import GoogleMaps

// Dentro do método application(), ANTES do return:
GMSServices.provideAPIKey("AIzaSy...")  // Cole sua chave aqui
```

---

## 🧪 TESTE DE VALIDAÇÃO

### Após configurar, teste

```bash
flutter clean
flutter pub get
flutter run
```

**No app:**

1. Navegue para tela com mapa (quando implementada)
2. Verifique se o mapa carrega
3. Verifique se não há erros no console

**Erros comuns:**

- "API key not valid": Aguarde 5-10 min ou verifique restrições
- "This API project is not authorized": Verifique se API está habilitada
- "SHA-1 not matching": Verifique SHA-1 no Google Cloud Console

---

## 📝 NOTAS IMPORTANTES

### Segurança

- ✅ `.env` deve estar no `.gitignore`
- ✅ Nunca commite a API Key diretamente no código
- ✅ Use restrições de aplicativo (SHA-1)
- ⚠️ SHA-1 de **PRODUÇÃO** deve ser adicionado antes do release

### Custos

- **Free tier:** $200 de crédito/mês
- **Uso esperado (Beta):** < $50/mês
- **Monitoramento:** <https://console.cloud.google.com/billing/usage>

### SHA-1 de Produção

Quando gerar release APK/Bundle:

```bash
cd android
.\gradlew.bat signingReport --configuration=release
# Copie SHA-1 de "Variant: release"
# Adicione no Google Cloud Console (mesmo local)
```

---

## 🔗 LINKS ÚTEIS

- **Google Cloud Console:** <https://console.cloud.google.com/>
- **Billing & Usage:** <https://console.cloud.google.com/billing/usage?project=barbergo-38c21>
- **APIs Enabled:** <https://console.cloud.google.com/apis/dashboard?project=barbergo-38c21>
- **Credentials:** <https://console.cloud.google.com/apis/credentials?project=barbergo-38c21>

---

## ✅ APÓS CONCLUIR

Marque aqui quando terminar:

- [x] 5 APIs habilitadas ✅
- [x] API Key criada: `AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ` ✅
- [x] SHA-1 obtido: `28:BF:6A:A0:81:61:4F:A9:9D:29:A9:54:E7:84:41:B3:B9:38:1F:8F` ✅
- [x] Restrições aplicadas ✅ (COMPLETO!)
- [x] .env atualizado com chave ✅
- [x] .env já estava no .gitignore ✅
- [x] AndroidManifest.xml configurado ✅
- [x] AppDelegate.swift configurado ✅
- [ ] Testado no emulador/dispositivo ⏳
- [ ] Mapa carrega sem erros ⏳

**⚠️ AÇÃO NECESSÁRIA: Configure as restrições no Google Cloud Console usando os dados acima!**

---

**Última atualização:** 02/11/2025  
**Responsável:** A definir  
**Prioridade:** Média (Sprint 2)
