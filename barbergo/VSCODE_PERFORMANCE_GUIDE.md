# Guia de Performance VS Code - BarberGo

**Última atualização:** 08 de Novembro de 2025

## 🚀 Problema Resolvido
O VS Code mais recente estava consumindo **8GB de RAM** para rodar o app Flutter, causando lentidão extrema no desenvolvimento.

## ✅ Solução Aplicada
1. **Downgrade para VS Code 1.99.3** (versão estável e rápida)
2. **Configurações otimizadas** aplicadas em `.vscode/settings.json`
3. **Práticas recomendadas** para desenvolvimento Flutter

---

## 📥 PARTE 1: Downgrade para VS Code 1.99.3

### Windows (64-bit) - Instalação Rápida

#### Opção A: Download Direto
1. **Baixe o instalador:**
   ```
   https://update.code.visualstudio.com/1.99.3/win32-x64/stable
   ```

2. **Feche o VS Code atual**
   - Salve todo o trabalho
   - Feche todas as janelas do VS Code

3. **Execute o instalador baixado**
   - Aceite substituir a instalação atual
   - Mantenha suas extensões e configurações

4. **Verifique a versão instalada**
   - Abra o VS Code
   - Vá em `Ajuda > Sobre`
   - Confirme que está na versão `1.99.3`

#### Opção B: Download Manual
1. Acesse: https://code.visualstudio.com/updates
2. Navegue até a versão 1.99.3
3. Baixe o instalador para Windows x64
4. Siga os passos 2-4 da Opção A

#### Opção C: Versão Portátil (Sem Instalação)
Para manter múltiplas versões ou não interferir na instalação global:

1. **Baixe o ZIP:**
   ```
   https://update.code.visualstudio.com/1.99.3/win32-x64-archive/stable
   ```

2. **Extraia para uma pasta** (ex: `C:\VSCode-1.99.3\`)

3. **Crie uma pasta `data` dentro:**
   ```powershell
   mkdir C:\VSCode-1.99.3\data
   ```

4. **Execute:** `C:\VSCode-1.99.3\Code.exe`

---

## ⚙️ PARTE 2: Configurações Aplicadas

As configurações abaixo **já foram aplicadas** no arquivo `.vscode/settings.json` do projeto.

### O que foi otimizado:

#### 🔒 Desativação de Atualizações
```json
"update.mode": "none",
"extensions.autoUpdate": false,
"extensions.autoCheckUpdates": false,
```
**Efeito:** Impede que o VS Code atualize automaticamente para versões mais pesadas.

#### 📁 Redução do File Watcher
```json
"files.watcherExclude": {
    "**/build/**": true,
    "**/.dart_tool/**": true,
    "**/.gradle/**": true,
    "**/ios/Pods/**": true,
    "**/node_modules/**": true
}
```
**Efeito:** Reduz drasticamente o uso de CPU/RAM ao ignorar pastas de build e cache.

#### 🔍 Otimização de Buscas
```json
"search.followSymlinks": false,
"search.useIgnoreFiles": true,
```
**Efeito:** Buscas no código ficam mais rápidas e consomem menos memória.

#### 📑 Limite de Abas Abertas
```json
"workbench.editor.limit.enabled": true,
"workbench.editor.limit.perEditorGroup": 5,
"workbench.editor.limit.value": 10,
```
**Efeito:** Fecha abas antigas automaticamente, liberando memória.

#### 🎨 Simplificação da UI
```json
"editor.minimap.enabled": false,
"breadcrumbs.enabled": false,
"workbench.startupEditor": "none",
```
**Efeito:** Remove elementos visuais que consomem memória.

#### 🎯 Otimizações Dart/Flutter
```json
"dart.previewLsp": false,
"dart.flutterOutline": false,
"dart.closingLabels": false,
```
**Efeito:** Desativa features extras do Dart Analysis Server.

---

## 🛠️ PARTE 3: Práticas Recomendadas

### Durante o Desenvolvimento

#### 1. Use o Terminal para Rodar o App
Em vez de usar `F5` ou o debug do VS Code:

```powershell
flutter run
```

**Vantagens:**
- Reduz ~30-40% do uso de memória
- Depurador do VS Code é pesado
- Hot reload continua funcionando normalmente

#### 2. Feche Painéis Desnecessários
- **DevTools:** Só abra quando precisar debugar
- **Terminal integrado:** Use o terminal externo se possível
- **Painéis laterais:** Minimize quando não estiver usando

#### 3. Limpe o Cache Regularmente
```powershell
flutter clean
dart pub cache clean
```

Execute semanalmente para liberar espaço e memória.

#### 4. Use Dispositivo Físico (Se Possível)
O emulador Android consome muita RAM. Se tiver um dispositivo físico:

```powershell
flutter devices
flutter run -d <device-id>
```

#### 5. Configure o Emulador com Menos RAM
Se precisar do emulador, limite a RAM dele:
- Abra o AVD Manager
- Edit > Advanced Settings
- RAM: 2048 MB (em vez de 4096+)

### Extensões do VS Code

#### Extensões Essenciais (Manter):
- ✅ Dart
- ✅ Flutter
- ✅ GitHub Copilot (se estiver usando)

#### Extensões para Desativar/Remover:
- ❌ Extensões de preview (ex: Live Server, Preview HTML)
- ❌ Extensões de análise pesadas (ex: SonarLint)
- ❌ Themes/Icons desnecessários
- ❌ Extensões que você não usa há meses

**Como desativar:**
1. `Ctrl+Shift+X` para abrir extensões
2. Clique na engrenagem da extensão
3. `Disable (Workspace)` - desativa só neste projeto

---

## 📊 PARTE 4: Medindo o Impacto

### Antes das Otimizações
- 💾 **RAM:** ~8GB em uso
- 🐌 **Performance:** Lenta, travamentos frequentes
- ⚡ **Hot Reload:** 3-5 segundos

### Depois das Otimizações (Esperado)
- 💾 **RAM:** ~2-3GB em uso
- 🚀 **Performance:** Fluida
- ⚡ **Hot Reload:** < 1 segundo

### Como Monitorar
No Windows, use o **Task Manager** (`Ctrl+Shift+Esc`):
- Ordene por memória
- Observe o processo `Code.exe`

---

## 🔧 PARTE 5: Troubleshooting

### Se o VS Code continuar pesado

#### 1. Desative TODAS as extensões temporariamente
```powershell
code --disable-extensions
```

Se melhorar, reative uma por uma para identificar a culpada.

#### 2. Limpe o cache do VS Code
```powershell
rm -r $env:APPDATA\Code\Cache
rm -r $env:APPDATA\Code\CachedData
```

#### 3. Verifique o Analysis Server
```powershell
# No terminal integrado do VS Code
Dart: Restart Analysis Server
```

Ou adicione ao `analysis_options.yaml`:
```yaml
analyzer:
  exclude:
    - build/**
    - lib/generated/**
```

#### 4. Use o Workspace em Modo "Trust"
- `File > Preferences > Settings`
- Busque por "trust"
- Configure `security.workspace.trust.enabled` como `false` (com cuidado)

#### 5. Último recurso: Reset completo
```powershell
# Backup primeiro!
code --user-data-dir="C:\VSCode-Temp"
```

---

## 👥 PARTE 6: Para a Equipe

### Compartilhando as Configurações

As configurações já estão em `.vscode/settings.json` e serão aplicadas automaticamente quando qualquer membro da equipe abrir o projeto.

### Padronizando a Versão do VS Code

#### Opção 1: Documentação no README
Adicione no README.md principal:

```markdown
## Requisitos de Desenvolvimento
- **VS Code:** Versão 1.99.3 (recomendado)
  - Download: https://update.code.visualstudio.com/1.99.3/win32-x64/stable
```

#### Opção 2: Script de Instalação Automática
Crie `scripts/install-vscode.ps1`:

```powershell
# Download e instalação do VS Code 1.99.3
$url = "https://update.code.visualstudio.com/1.99.3/win32-x64/stable"
$output = "$env:TEMP\VSCodeSetup.exe"

Write-Host "Baixando VS Code 1.99.3..."
Invoke-WebRequest -Uri $url -OutFile $output

Write-Host "Instalando..."
Start-Process -FilePath $output -ArgumentList "/SILENT /MERGETASKS=!runcode" -Wait

Write-Host "Concluído! Reinicie o VS Code."
```

#### Opção 3: DevContainer (Avançado)
Se quiser isolar completamente o ambiente de desenvolvimento:

```json
// .devcontainer/devcontainer.json
{
  "name": "BarberGo Dev",
  "image": "mcr.microsoft.com/vscode/devcontainers/dart:latest",
  "extensions": [
    "Dart-Code.dart-code",
    "Dart-Code.flutter"
  ],
  "settings": {
    // Todas as otimizações aqui
  }
}
```

---

## 📝 Checklist de Aplicação

- [ ] **Downgrade feito:** VS Code 1.99.3 instalado
- [ ] **Verificação:** Comando `Ajuda > Sobre` confirma versão
- [ ] **Configurações aplicadas:** `.vscode/settings.json` atualizado
- [ ] **VS Code reiniciado:** Para aplicar todas as mudanças
- [ ] **Teste inicial:** App rodando via `flutter run`
- [ ] **Medição de memória:** Task Manager mostrando uso reduzido
- [ ] **Extensões revisadas:** Desativadas as não essenciais
- [ ] **Equipe notificada:** Todos cientes das mudanças

---

## 🆘 Suporte

Se encontrar problemas após aplicar estas otimizações:

1. **Reverta uma configuração por vez** no `.vscode/settings.json`
2. **Teste com e sem extensões** para isolar o problema
3. **Documente o comportamento** para análise futura

---

## 📚 Recursos Adicionais

- [VS Code Performance Tips](https://code.visualstudio.com/docs/getstarted/tips-and-tricks#_performance)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Dart Analysis Server Options](https://github.com/dart-lang/sdk/tree/main/pkg/analysis_server)

---

**Nota:** Este guia foi criado especificamente para otimizar o desenvolvimento do projeto BarberGo. Adapte conforme necessário para outros projetos.
