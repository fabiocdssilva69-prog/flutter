# 🚀 Guia Rápido Pós-Reinicialização - BarberGO

## ⚡ AÇÕES IMEDIATAS (Execute nesta ordem)

### 1️⃣ Executar Script de Verificação
```powershell
cd c:\workspaces\fabiocdssilva69-prog\barbergo
.\verificar_ambiente.ps1
```

### 2️⃣ Verificar Resultado do Flutter Doctor
Problemas comuns e soluções:
- ❌ **Android SDK não encontrado**: Instalar via Android Studio
- ❌ **Android Studio não encontrado**: Baixar de android.com/studio
- ❌ **Licenças Android não aceitas**: `flutter doctor --android-licenses`
- ⚠️  **Visual Studio não encontrado**: Necessário apenas para Windows Desktop builds

### 3️⃣ Configurar Emulador Android (se necessário)

#### Opção A: Via Android Studio (Recomendado)
1. Abrir Android Studio
2. Tools → Device Manager (ou AVD Manager)
3. Create Virtual Device
4. Selecionar: **Pixel 5** ou **Pixel 7**
5. System Image: **API 33 (Android 13)** ou superior
6. Configuração recomendada:
   - RAM: 2048 MB (mínimo) / 4096 MB (ideal)
   - VM Heap: 512 MB
   - Internal Storage: 2048 MB
   - SD Card: 512 MB

#### Opção B: Via Linha de Comando
```powershell
# Listar emuladores disponíveis
flutter emulators

# Se não houver emuladores, criar um via Android Studio primeiro

# Iniciar emulador específico
flutter emulators --launch <nome_emulador>

# Exemplo:
flutter emulators --launch Pixel_5_API_33
```

### 4️⃣ Verificar Emulador Funcionando
```powershell
# Aguardar emulador inicializar (pode levar 1-2 minutos)
# Verificar dispositivo conectado
flutter devices

# Deve mostrar algo como:
# Android SDK built for x86_64 (mobile) • emulator-5554 • android-x64 • Android 13 (API 33)
```

### 5️⃣ Executar Testes de Integração
```powershell
# Substituir <device-id> pelo ID do dispositivo da etapa anterior
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/auth_integration_test.dart -d <device-id>

# Exemplo:
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/auth_integration_test.dart -d emulator-5554
```

---

## 🎯 ALTERNATIVAS SE EMULADOR ESTIVER LENTO

### Opção 1: Testes no Chrome (Mais Rápido)
```powershell
# Habilitar web
flutter config --enable-web

# Executar no Chrome
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/auth_integration_test.dart -d chrome
```

### Opção 2: Windows Desktop Build
```powershell
# Habilitar Windows desktop
flutter config --enable-windows-desktop

# Executar no Windows
flutter run -d windows
```

### Opção 3: Firebase Emulator Suite (Backend Local)
```powershell
# Instalar Firebase CLI (se ainda não tiver)
npm install -g firebase-tools

# Login no Firebase
firebase login

# Inicializar emuladores
firebase init emulators

# Selecionar:
# - Authentication Emulator
# - Firestore Emulator
# - Functions Emulator (opcional)

# Iniciar emuladores
firebase emulators:start
```

---

## 📚 DOCUMENTOS DE REFERÊNCIA

1. **PLANO_AMBIENTE_TESTES_E_FIREBASE.md** - Plano completo e roadmap
2. **verificar_ambiente.ps1** - Script de verificação automática
3. **Este arquivo** - Guia rápido de ações

---

## 🔧 COMANDOS ÚTEIS

### Flutter
```powershell
flutter clean                  # Limpar cache
flutter pub get               # Baixar dependências
flutter pub outdated          # Ver pacotes desatualizados
flutter test                  # Rodar todos os testes
flutter devices               # Listar dispositivos
flutter emulators             # Listar emuladores
flutter doctor -v             # Diagnóstico completo
```

### Git
```powershell
git status                    # Ver mudanças
git add .                     # Adicionar tudo
git commit -m "mensagem"      # Commitar
git push                      # Enviar para repositório
```

### Firebase
```powershell
firebase login                # Login na conta
firebase projects:list        # Listar projetos
firebase emulators:start      # Iniciar emuladores locais
flutterfire configure         # Reconfigurar Firebase no projeto
```

---

## 🐛 TROUBLESHOOTING RÁPIDO

### Problema: Emulador não inicia
**Solução:**
```powershell
# Verificar se Intel HAXM ou AMD Hyper-V está habilitado
# Reiniciar Android Studio
# Tentar criar novo emulador com configurações menores
```

### Problema: Flutter Doctor mostra erros
**Solução:**
```powershell
flutter doctor --android-licenses  # Aceitar licenças
flutter config --android-sdk <caminho>  # Configurar SDK manualmente
```

### Problema: Testes falhando
**Solução:**
```powershell
flutter clean
flutter pub get
flutter test test/auth_controller_test.dart --reporter=expanded
```

### Problema: Firebase não conecta
**Solução:**
```powershell
flutterfire configure --project=barbergo-4a9fc
# Seguir instruções na tela
```

---

## 📊 MÉTRICAS DE SUCESSO

### ✅ Ambiente Configurado com Sucesso se:
- [ ] `flutter doctor` sem erros críticos (apenas warnings OK)
- [ ] Pelo menos 1 dispositivo disponível (`flutter devices`)
- [ ] Testes unitários passando (6/6)
- [ ] Emulador Android ou alternativa funcionando
- [ ] App compila sem erros

### 🎯 Próximo Objetivo:
Executar **testes de integração** no emulador e validar fluxo completo de autenticação

---

## 💡 DICAS DE PRODUTIVIDADE

1. **Use Hot Reload**: `r` durante execução do app
2. **Use Hot Restart**: `R` durante execução do app
3. **Mantenha emulador aberto**: Não feche entre testes
4. **Use VSCode Launch Configs**: F5 para debug rápido
5. **Monitore logs**: `flutter logs` em terminal separado

---

## 🔥 APÓS AMBIENTE FUNCIONAR

Consulte **PLANO_AMBIENTE_TESTES_E_FIREBASE.md** para:
- Roadmap completo de integração Firebase
- Lista de recursos a implementar
- Arquitetura de dados sugerida
- Comandos avançados
- Recursos de estudo

---

**Status Atual**: ✅ Documentação preparada | ⏳ Aguardando reinicialização

**Próxima Ação**: Reiniciar → Executar `verificar_ambiente.ps1` → Configurar emulador
