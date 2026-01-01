# 🍎 Guia de Build iOS - Codemagic

## ✅ Passo 1: Criar Conta no Codemagic
1. Acesse: https://codemagic.io/signup
2. Faça login com GitHub/GitLab/Bitbucket
3. Conecte seu repositório BarberGO

## ✅ Passo 2: Certificados Apple (necessário)

### Você precisa:
1. **Apple Developer Account** ($99/ano)
   - Acesse: https://developer.apple.com/programs/

2. **Certificados e Provisioning Profiles**
   
   **Opção A - Automático (Recomendado):**
   - No Codemagic, vá em: Teams → Integrations → App Store Connect
   - Clique em "Enable App Store Connect integration"
   - Gere uma **API Key** no App Store Connect:
     * https://appstoreconnect.apple.com/access/api
     * Clique em "Keys" → "+" (criar nova key)
     * Role: App Manager
     * Baixe o arquivo `.p8`
   - Cole no Codemagic:
     * Issuer ID
     * Key ID
     * Private Key (.p8 content)
   
   **Opção B - Manual:**
   - Acesse Xcode em um Mac
   - Vá em Preferences → Accounts → Add Apple ID
   - Download Manual Profiles

## ✅ Passo 3: Configurar no Codemagic

1. **Adicionar Aplicação:**
   - Dashboard → Add Application
   - Escolha seu repositório
   - Branch: `main` ou `master`

2. **Configurar Build:**
   - O arquivo `codemagic.yaml` já está configurado!
   - Codemagic detecta automaticamente

3. **Adicionar Variáveis de Ambiente:**
   - Settings → Environment Variables
   - Adicione:
     ```
     APP_STORE_CONNECT_ISSUER_ID
     APP_STORE_CONNECT_KEY_IDENTIFIER
     APP_STORE_CONNECT_PRIVATE_KEY
     ```

4. **Trigger Build:**
   - Clique em "Start new build"
   - Escolha workflow: `ios-workflow`
   - Aguarde ~15-20 minutos

## ✅ Passo 4: Testar no TestFlight

Após o build:
1. Codemagic faz upload automático (se configurado)
2. Ou baixe o `.ipa` dos artifacts
3. Faça upload manual no App Store Connect:
   - https://appstoreconnect.apple.com
   - MyApps → BarberGO → TestFlight
   - Adicione testadores internos/externos

## 🚀 Alternativa Mais Rápida - FlutterFlow

Se quiser testar AGORA mesmo no iOS:

1. **Crie conta gratuita:** https://flutterflow.io
2. **Import Project:** 
   - Upload seu código Flutter
   - FlutterFlow compila iOS na nuvem
3. **Test Mode:**
   - Escaneia QR code com iPhone
   - Testa app em 5 minutos
4. **Export código** depois para continuar desenvolvimento

## 📱 Build Local (se conseguir um Mac)

```bash
# No Mac
flutter build ios --release
open build/ios/archive/Runner.xcarchive

# No Xcode Organizer:
# 1. Validate App
# 2. Distribute App → App Store Connect
```

## 💰 Custos

- **Codemagic Free Tier:** 500 min/mês grátis (suficiente para ~25 builds iOS)
- **Apple Developer:** $99/ano (obrigatório)
- **Mac Cloud (opcional):** $20-40/mês

## 🔥 Começar AGORA

1. ✅ Criar Apple Developer Account
2. ✅ Criar conta Codemagic
3. ✅ Push código para GitHub (se ainda não está)
4. ✅ Conectar repositório no Codemagic
5. ✅ Configurar certificados
6. ✅ Start build!

Tempo estimado: 30 minutos
