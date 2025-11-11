# Script de Instalação Automática do VS Code 1.99.3
# BarberGo - Performance Optimization
# Última atualização: 08/11/2025

$ErrorActionPreference = "Stop"

Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   VS Code 1.99.3 - Instalação Automática             ║" -ForegroundColor Cyan
Write-Host "║   BarberGo Performance Optimization                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Configurações
$vscodeVersion = "1.99.3"
$downloadUrl = "https://update.code.visualstudio.com/$vscodeVersion/win32-x64/stable"
$installerPath = "$env:TEMP\VSCodeSetup-$vscodeVersion.exe"

# Verifica se está rodando como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
  Write-Host "⚠️  AVISO: Rodando sem privilégios de administrador." -ForegroundColor Yellow
  Write-Host "   A instalação pode pedir elevação de privilégios." -ForegroundColor Yellow
  Write-Host ""
}

# Verifica se o VS Code está rodando
$vscodeRunning = Get-Process -Name "Code" -ErrorAction SilentlyContinue

if ($vscodeRunning) {
  Write-Host "❌ VS Code está em execução!" -ForegroundColor Red
  Write-Host "   Por favor, feche todas as janelas do VS Code e execute novamente." -ForegroundColor Yellow
  Write-Host ""
    
  $response = Read-Host "Deseja tentar fechar automaticamente? (S/N)"
    
  if ($response -eq "S" -or $response -eq "s") {
    Write-Host "Fechando VS Code..." -ForegroundColor Yellow
    Get-Process -Name "Code" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
  }
  else {
    Write-Host "Instalação cancelada." -ForegroundColor Red
    exit 1
  }
}

# Download
Write-Host "📥 Baixando VS Code $vscodeVersion..." -ForegroundColor Green
Write-Host "   URL: $downloadUrl" -ForegroundColor Gray

try {
  # Usa WebClient para mostrar progresso
  $webClient = New-Object System.Net.WebClient
    
  # Event handler para progresso
  Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -SourceIdentifier WebClient.DownloadProgressChanged -Action {
    Write-Progress -Activity "Baixando VS Code" -Status "$($EventArgs.ProgressPercentage)% completo" -PercentComplete $EventArgs.ProgressPercentage
  } | Out-Null
    
  $webClient.DownloadFile($downloadUrl, $installerPath)
  Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged -ErrorAction SilentlyContinue
  Write-Progress -Activity "Baixando VS Code" -Completed
    
  Write-Host "✅ Download concluído!" -ForegroundColor Green
  Write-Host ""
}
catch {
  Write-Host "❌ Erro ao baixar: $_" -ForegroundColor Red
  exit 1
}

# Verifica se o arquivo foi baixado
if (-not (Test-Path $installerPath)) {
  Write-Host "❌ Arquivo de instalação não encontrado!" -ForegroundColor Red
  exit 1
}

$fileSize = (Get-Item $installerPath).Length / 1MB
Write-Host "📦 Tamanho do arquivo: $($fileSize.ToString('0.00')) MB" -ForegroundColor Gray
Write-Host ""

# Instalação
Write-Host "🚀 Instalando VS Code $vscodeVersion..." -ForegroundColor Green
Write-Host ""

$installArgs = @(
  "/VERYSILENT",           # Instalação silenciosa
  "/NORESTART",            # Não reiniciar o PC
  "/MERGETASKS=!runcode",  # Não executar após instalação
  "/SUPPRESSMSGBOXES"      # Suprimir caixas de mensagem
)

try {
  $process = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru
    
  if ($process.ExitCode -eq 0) {
    Write-Host "✅ Instalação concluída com sucesso!" -ForegroundColor Green
  }
  else {
    Write-Host "⚠️  Instalação concluída com código de saída: $($process.ExitCode)" -ForegroundColor Yellow
  }
}
catch {
  Write-Host "❌ Erro durante a instalação: $_" -ForegroundColor Red
  exit 1
}

# Limpeza
Write-Host ""
Write-Host "🧹 Limpando arquivos temporários..." -ForegroundColor Gray

try {
  Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
  Write-Host "✅ Limpeza concluída!" -ForegroundColor Green
}
catch {
  Write-Host "⚠️  Não foi possível remover o instalador temporário." -ForegroundColor Yellow
}

# Verificação
Write-Host ""
Write-Host "🔍 Verificando instalação..." -ForegroundColor Cyan

$vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (Test-Path $vscodePath) {
  Write-Host "✅ VS Code encontrado em: $vscodePath" -ForegroundColor Green
}
else {
  Write-Host "⚠️  Caminho padrão não encontrado. VS Code pode estar instalado em outro local." -ForegroundColor Yellow
}

# Instruções finais
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✅ INSTALAÇÃO CONCLUÍDA!                 ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   1. Abra o VS Code" -ForegroundColor White
Write-Host "   2. Vá em: Ajuda > Sobre" -ForegroundColor White
Write-Host "   3. Confirme que a versão é 1.99.3" -ForegroundColor White
Write-Host "   4. Reabra o projeto BarberGo" -ForegroundColor White
Write-Host "   5. As configurações otimizadas serão aplicadas automaticamente" -ForegroundColor White
Write-Host ""
Write-Host "💡 Dicas:" -ForegroundColor Cyan
Write-Host "   • Use 'flutter run' no terminal em vez de F5" -ForegroundColor Gray
Write-Host "   • Monitore o uso de RAM pelo Task Manager" -ForegroundColor Gray
Write-Host "   • Consulte o guia completo: VSCODE_PERFORMANCE_GUIDE.md" -ForegroundColor Gray
Write-Host ""

$openVSCode = Read-Host "Deseja abrir o VS Code agora? (S/N)"

if ($openVSCode -eq "S" -or $openVSCode -eq "s") {
  Write-Host "Abrindo VS Code..." -ForegroundColor Green
  Start-Process "code" -ArgumentList "$PSScriptRoot\.."
}
else {
  Write-Host "Script finalizado. Boa codificação! 🚀" -ForegroundColor Green
}
