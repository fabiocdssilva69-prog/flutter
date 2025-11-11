# Script para Abrir VS Code 1.99.3 Otimizado
# BarberGo Performance Optimization
# Última atualização: 08/11/2025

$ErrorActionPreference = "Stop"

Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   VS Code 1.99.3 Otimizado - BarberGo                ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Configurações
$vscodeExe = "C:\Program Files\Microsoft VS Code\Code.exe"
$userDataDir = "$env:LOCALAPPDATA\VSCode-1.99.3-Clean"
$projectPath = "$PSScriptRoot\.."

# Verifica se o executável existe
if (-not (Test-Path $vscodeExe)) {
    Write-Host "❌ VS Code 1.99.3 não encontrado em:" -ForegroundColor Red
    Write-Host "   $vscodeExe" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Execute primeiro: .\scripts\install-vscode-1.99.3.ps1" -ForegroundColor Yellow
    exit 1
}

# Cria o diretório de dados se não existir
if (-not (Test-Path $userDataDir)) {
    Write-Host "📁 Criando perfil limpo em:" -ForegroundColor Yellow
    Write-Host "   $userDataDir" -ForegroundColor Gray
    New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null
}

# Fecha VS Code antigo se estiver rodando
$oldVSCode = Get-Process -Name Code -ErrorAction SilentlyContinue | Where-Object { $_.Path -notlike "*Program Files*" }
if ($oldVSCode) {
    Write-Host "⚠️  Fechando VS Code 1.105.1 (versão antiga)..." -ForegroundColor Yellow
    $oldVSCode | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# Abre VS Code 1.99.3 otimizado
Write-Host "🚀 Abrindo VS Code 1.99.3 otimizado..." -ForegroundColor Green
Write-Host ""

try {
    Start-Process -FilePath $vscodeExe -ArgumentList "--user-data-dir `"$userDataDir`" `"$projectPath`""
    Start-Sleep -Seconds 3
    
    # Verifica se abriu
    $running = Get-Process -Name Code -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*Program Files*" }
    
    if ($running) {
        Write-Host "✅ VS Code 1.99.3 iniciado com sucesso!" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Dicas de uso:" -ForegroundColor Cyan
        Write-Host "   • Monitore RAM no Task Manager (Ctrl+Shift+Esc)" -ForegroundColor Gray
        Write-Host "   • Use 'flutter run' no terminal em vez de F5" -ForegroundColor Gray
        Write-Host "   • Feche DevTools quando não estiver usando" -ForegroundColor Gray
        Write-Host ""
        Write-Host "💾 Uso esperado de RAM: 2-3GB (vs 8GB anterior)" -ForegroundColor Green
    } else {
        Write-Host "⚠️  VS Code pode estar inicializando..." -ForegroundColor Yellow
        Write-Host "   Se não abrir em 10 segundos, verifique o Task Manager" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Erro ao abrir VS Code:" -ForegroundColor Red
    Write-Host "   $_" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "ℹ️  Para sempre usar esta versão, execute:" -ForegroundColor Cyan
Write-Host "   .\scripts\open-vscode-optimized.ps1" -ForegroundColor White
Write-Host ""
