# 🚀 Dev Mode - Limpeza Rápida

Scripts criados para otimizar o ambiente de desenvolvimento Flutter.

## ⚡ Uso Rápido (30 segundos)

### 1️⃣ Limpeza Automática
```powershell
# Execute como Administrador (obrigatório)
.\dev-mode-quick.ps1
```
**O que faz:**
- Para processos pesados (Chrome, Teams, OneDrive, Spotify, etc.)
- Limpa cache temporário (~200-500 MB)  
- Libera memória (~1-2 GB)
- Mostra resultado final

### 2️⃣ Auditoria (opcional)
```powershell
# Mostra o que está consumindo recursos
.\system-audit.ps1
```

## 🎯 Uso Recomendado

**Antes de desenvolver:**
1. Execute `dev-mode-quick.ps1` (como Admin)
2. Inicie o Flutter: `flutter run -d uwbekb8hpf6lamts`

**Para restaurar tudo:** Reinicie o computador

## ⚠️ Processos que serão parados

Seguros para desenvolvimento:
- OneDrive, Teams, Chrome, Firefox, Edge
- Spotify, Discord, Slack, Zoom
- Steam, Epic Games, Adobe updaters
- Dropbox, Google Drive

**NÃO afeta:** Windows, antivírus, VS Code, Flutter, Android Studio

## 🔧 Comandos Diretos (sem scripts)

Se preferir comandos manuais:

```powershell
# Para OneDrive
taskkill /f /im OneDrive.exe

# Para Teams  
taskkill /f /im Teams.exe

# Para Chrome
taskkill /f /im chrome.exe

# Limpar temp
del /q /f /s %temp%\*
```

## 📊 Monitoramento

Verificar uso de RAM:
```powershell
Get-Process | Sort-Object WS -Descending | Select-Object -First 10
```

---

**Criado em:** 3 de novembro de 2025  
**Tempo de execução:** ~30 segundos  
**Ganho estimado:** 1-3 GB RAM livre