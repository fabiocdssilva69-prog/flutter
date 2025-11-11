# 🌐 WORKFLOW TESTES WEB - Guia Prático (16GB RAM)

**Atualizado**: 16/10/2025  
**Status**: ✅ 100% FUNCIONAL  
**Estratégia**: Foco total em Web até upgrade RAM 32GB

---

## ⚡ COMANDOS DO DIA (Cole e Execute)

```powershell
# 🚀 INICIAR DESENVOLVIMENTO
flutter run -d chrome

# 🧪 TESTES RÁPIDOS (5-10 seg)
flutter test

# ✅ TESTES COMPLETOS (2-3 min)
.\run_web_tests.ps1

# 🧹 LIBERAR MEMÓRIA
.\liberar_memoria.ps1
```

---

## 📅 ROTINA DIÁRIA

### 🌅 Manhã (5 min)

```powershell
# 1. Abrir terminal no projeto
cd C:\workspaces\fabiocdssilva69-prog\barbergo

# 2. Verificar memória
.\liberar_memoria.ps1

# 3. Se RAM livre < 6GB → Reiniciar PC
# (Se necessário) Restart-Computer

# 4. Abrir VS Code
code .
```

### 💻 Desenvolvimento (Ciclo)

```powershell
# 1. Iniciar app (1x)
flutter run -d chrome

# 2. Desenvolver
# → Editar código
# → Salvar (Ctrl+S)
# → Hot reload automático! ✨

# 3. Testar mudanças
flutter test test/seu_arquivo_test.dart

# 4. Repetir ciclo 2-3
```

### 🔄 A Cada 2-3 Horas

```powershell
# Manutenção de RAM
.\liberar_memoria.ps1

# Se mostrar RAM < 4GB:
# - Fechar navegador
# - Fechar/reabrir VS Code
```

### ✅ Antes de Commitar

```powershell
# 1. Testes unitários
flutter test
# Espera: All tests passed! ✅

# 2. Testes integração web
.\run_web_tests.ps1
# Espera: ChromeDriver inicia → Testes executam ✅

# 3. Análise estática
flutter analyze
# Espera: No issues found! ✅

# 4. Commit
git add .
git commit -m "feat: sua feature"
git push
```

### 🌙 Fim do Dia

```powershell
# Commit final do dia
git add .
git commit -m "chore: end of day checkpoint"
git push

# Fechar tudo
# - Salvar arquivos
# - Fechar VS Code
# - Fechar navegador

# Opcional: Desligar PC
shutdown /s /t 0
```

---

## 🎯 O QUE VOCÊ TEM

### ✅ Funcionando 100%

| Recurso | Status | Comando |
|---------|--------|---------|
| **Desenvolvimento Web** | ✅ | `flutter run -d chrome` |
| **Testes Unitários** | ✅ 6/6 | `flutter test` |
| **Testes Integração Web** | ✅ | `.\run_web_tests.ps1` |
| **ChromeDriver** | ✅ 141 | `chromedriver --version` |
| **Hot Reload** | ✅ | Automático ao salvar |
| **Análise Código** | ✅ | `flutter analyze` |

### ⏳ Aguardando RAM 32GB

| Recurso | Motivo | Quando |
|---------|--------|--------|
| **Emulador Android** | Consome 4-6GB | Após upgrade |
| **Testes Android** | Precisa emulador | Após upgrade |
| **Build Android** | Muito pesado | Após upgrade |

---

## 💡 DICAS ESSENCIAIS

### 1️⃣ Hot Reload é Seu Amigo

```powershell
# Inicie UMA vez:
flutter run -d chrome

# Depois:
# - Edite código
# - Salve (Ctrl+S)
# - App recarrega automaticamente! ⚡
# - Não precisa parar/reiniciar!
```

**Economia de tempo**: 90% menos espera!

### 2️⃣ Teste Apenas o Necessário

```powershell
# Durante desenvolvimento:
flutter test test/arquivo_atual_test.dart  # ⚡ Rápido

# Antes de commit:
flutter test                               # ✅ Tudo
.\run_web_tests.ps1                       # ✅ Integração
```

### 3️⃣ Mantenha VS Code Limpo

```
Fechar abas não usadas:
- Ctrl+W          → Fechar aba atual
- Ctrl+K W        → Fechar todas

Buscar arquivos:
- Ctrl+P          → Abrir arquivo rápido
- Ctrl+Shift+F    → Buscar em arquivos

Terminal:
- Ctrl+`          → Abrir/fechar terminal
```

### 4️⃣ Monitore a RAM

```powershell
# Execute a cada 2-3 horas:
.\liberar_memoria.ps1

# Se mostrar < 4GB livre:
# 1. Fechar navegador (exceto Chrome de dev)
# 2. Fechar VS Code
# 3. Reabrir VS Code
# 4. Continuar trabalhando
```

---

## 🔍 TROUBLESHOOTING

### 🐛 Sistema Travando

```powershell
# Solução 1: Liberar memória
.\liberar_memoria.ps1

# Solução 2: Reiniciar (mais eficaz)
Restart-Computer
```

### 🐛 Testes Web Falhando

```powershell
# 1. Limpar cache
flutter clean
flutter pub get

# 2. Verificar ChromeDriver
chromedriver --version

# 3. Tentar novamente
.\run_web_tests.ps1
```

### 🐛 App Não Carrega no Chrome

```powershell
# 1. Cancelar (Ctrl+C no terminal)

# 2. Limpar tudo
flutter clean
flutter pub get

# 3. Reiniciar
flutter run -d chrome
```

### 🐛 ChromeDriver Travado

```powershell
# Matar processo
Stop-Process -Name "chromedriver" -Force

# Tentar novamente
.\run_web_tests.ps1
```

---

## ✅ CHECKLIST DE VERIFICAÇÃO

### Antes de Começar o Dia

- [ ] RAM livre > 6GB (`.\liberar_memoria.ps1`)
- [ ] Apenas 1 janela VS Code aberta
- [ ] Navegador com poucas abas (<5)
- [ ] Apps não essenciais fechados

### Durante Desenvolvimento

- [ ] Usando `flutter run -d chrome`
- [ ] Hot reload funcionando (salvar = reload)
- [ ] Testando com `flutter test` após mudanças
- [ ] Fechando abas não usadas

### A Cada 2-3 Horas

- [ ] Executei `.\liberar_memoria.ps1`
- [ ] RAM livre > 4GB
- [ ] Se não, fechei/reabri apps

### Antes de Commitar

- [ ] `flutter test` → All passed ✅
- [ ] `.\run_web_tests.ps1` → Passed ✅
- [ ] `flutter analyze` → No issues ✅
- [ ] Commit + Push realizados ✅

---

## 🚫 O QUE NÃO FAZER

### ❌ NÃO use emulador Android

```powershell
# ❌ NÃO EXECUTE:
.\start_emulator.ps1
flutter emulators --launch
flutter run -d emulator-5554

# ✅ USE:
flutter run -d chrome
```

**Por quê?** 16GB RAM em 100% uso → Emulador trava sistema inteiro!

### ❌ NÃO abra muitas abas

```
❌ Chrome com 20+ abas abertas
✅ Chrome com 2-5 abas essenciais
```

### ❌ NÃO rode múltiplas instâncias VS Code

```
❌ 3 janelas VS Code abertas
✅ 1 janela VS Code
```

---

## 📊 MÉTRICAS DE SUCESSO

### Você Está Indo Bem Se:

- ✅ RAM livre > 4GB durante o dia
- ✅ Hot reload funciona consistentemente
- ✅ Testes unitários passam
- ✅ Testes web passam antes de commits
- ✅ Sistema não trava
- ✅ Fazendo 3+ commits por dia

### Precisa Ajustar Se:

- ❌ RAM livre < 2GB constantemente
- ❌ Sistema travando muito
- ❌ VS Code muito lento
- ❌ Testes falhando sem motivo

**Ajuste**: Reinicie o PC, feche apps, libere RAM mais frequentemente

---

## 🎯 RESUMO EXECUTIVO

### FAÇA:

✅ Use `flutter run -d chrome` para desenvolver  
✅ Use `flutter test` para feedback rápido  
✅ Use `.\run_web_tests.ps1` antes de commits  
✅ Execute `.\liberar_memoria.ps1` a cada 2-3h  
✅ Mantenha apenas 1 janela VS Code aberta  
✅ Feche abas não usadas do navegador  

### NÃO FAÇA:

❌ Não use emulador Android (aguarde RAM 32GB)  
❌ Não abra muitas abas do navegador  
❌ Não rode múltiplas instâncias VS Code  

### QUANDO TRAVAR:

🔄 Execute `.\liberar_memoria.ps1`  
🔄 Se não resolver: Reinicie o PC  

---

## 📚 DOCUMENTOS RELACIONADOS

- **ACAO_IMEDIATA_MEMORIA.md** → Problema de RAM explicado
- **GUIA_EMERGENCIA_MEMORIA.md** → Troubleshooting completo
- **GUIA_ULTRA_OTIMIZADO.md** → Todos os scripts
- **SUCESSO_COMPLETO_AMBIENTE_OTIMIZADO.md** → Status final

---

## 🚀 ESTÁ PRONTO!

**Comando para começar AGORA:**

```powershell
flutter run -d chrome
```

**Pressione 'r' para hot reload**  
**Pressione 'R' para restart**  
**Pressione 'q' para sair**

**Bora desenvolver! 💪**

---

**Status**: ✅ Ambiente 100% funcional para Web  
**Limitação**: Aguardando RAM 32GB para Android  
**Solução Temporária**: Foco total em testes Web  
**Próximo Upgrade**: RAM 32GB → Android habilitado
