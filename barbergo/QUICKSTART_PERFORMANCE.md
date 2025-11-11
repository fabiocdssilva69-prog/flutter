# 🚀 Quick Start - Otimização de Performance

**Tempo estimado:** 5 minutos  
**Redução de RAM esperada:** ~5GB (de 8GB para 2-3GB)

---

## Opção 1: Automática (Recomendado)

### Execute o script de instalação:

```powershell
.\scripts\install-vscode-1.99.3.ps1
```

O script vai:
- ✅ Baixar VS Code 1.99.3 automaticamente
- ✅ Fechar o VS Code atual (se necessário)
- ✅ Instalar a versão otimizada
- ✅ Limpar arquivos temporários

**Pronto!** As configurações otimizadas já estão aplicadas em `.vscode/settings.json`.

---

## Opção 2: Manual

### Passo 1: Download (1 minuto)

Clique no link abaixo para baixar o VS Code 1.99.3:

**Windows 64-bit:**  
https://update.code.visualstudio.com/1.99.3/win32-x64/stable

### Passo 2: Instalação (2 minutos)

1. Feche o VS Code atual
2. Execute o instalador baixado
3. Aguarde a instalação concluir

### Passo 3: Verificação (1 minuto)

1. Abra o VS Code
2. Vá em `Ajuda > Sobre`
3. Confirme: Versão `1.99.3`

**Pronto!** As configurações otimizadas já estão aplicadas em `.vscode/settings.json`.

---

## 📊 Como Testar

### Antes de Começar a Desenvolver

1. **Abra o Task Manager** (`Ctrl+Shift+Esc`)
2. **Ordene por memória**
3. **Anote o uso atual** do processo `Code.exe`

### Durante o Desenvolvimento

Execute o app pelo terminal (melhor que F5):

```powershell
flutter run
```

### Resultado Esperado

| Métrica | Antes | Depois |
|---------|-------|--------|
| RAM do VS Code | ~8GB | ~2-3GB |
| Fluidez | 😠 Travando | 🚀 Rápido |
| Hot Reload | 3-5s | <1s |

---

## 🔧 Configurações Aplicadas

O arquivo `.vscode/settings.json` agora inclui:

- ✅ **Desativação de atualizações automáticas**
- ✅ **Redução do File Watcher** (ignora `build/`, `.dart_tool/`, etc)
- ✅ **Limite de abas abertas** (máximo 10)
- ✅ **Otimizações de busca** (mais rápida)
- ✅ **Simplificação da UI** (menos minimap, breadcrumbs)
- ✅ **Desativação de features extras do Dart**

---

## 💡 Dicas Adicionais

### Para Economizar Mais RAM:

1. **Use terminal externo** em vez do integrado
2. **Feche DevTools** quando não estiver usando
3. **Use dispositivo físico** em vez de emulador (se possível)
4. **Desative extensões** que você não usa

### Revisar Extensões:

```
Ctrl+Shift+X → Clique na engrenagem → Disable (Workspace)
```

Desative temporariamente:
- ❌ Temas/ícones extras
- ❌ Live Server
- ❌ Preview HTML
- ❌ Extensões que você não usa há meses

---

## 📚 Documentação Completa

Para informações detalhadas, troubleshooting e opções avançadas, consulte:

**→ [VSCODE_PERFORMANCE_GUIDE.md](./VSCODE_PERFORMANCE_GUIDE.md)**

Inclui:
- Instalação portátil (múltiplas versões)
- Troubleshooting detalhado
- Configurações avançadas
- Opções para equipe/CI
- Scripts de automação

---

## 🆘 Problemas?

### VS Code ainda pesado?

```powershell
# Desative todas as extensões temporariamente
code --disable-extensions

# Limpe o cache
rm -r $env:APPDATA\Code\Cache
rm -r $env:APPDATA\Code\CachedData

# Reinicie o Analysis Server
# No VS Code: Ctrl+Shift+P → "Dart: Restart Analysis Server"
```

### Não conseguiu fazer downgrade?

Use a **versão portátil**:
1. Baixe: https://update.code.visualstudio.com/1.99.3/win32-x64-archive/stable
2. Extraia para `C:\VSCode-1.99.3\`
3. Crie pasta `data` dentro dela
4. Execute `Code.exe`

---

## ✅ Checklist Final

- [ ] VS Code 1.99.3 instalado e verificado
- [ ] Projeto BarberGo reaberto
- [ ] Configurações aplicadas automaticamente
- [ ] Teste de memória realizado (Task Manager)
- [ ] App rodando via `flutter run`
- [ ] Extensões desnecessárias desativadas

---

**Boa codificação! 🚀**

*Se tudo funcionou bem, considere compartilhar este guia com a equipe.*
