# Script para executar o BarberGO no Perplexity Comet Browser

Write-Host "🚀 Iniciando BarberGO no Perplexity Comet..." -ForegroundColor Cyan
Write-Host ""

# Verifica se o Comet está instalado
$cometPath = "C:\Program Files\Perplexity\Comet\Application\comet.exe"
$cometPathAlt = "C:\Users\$env:USERNAME\AppData\Local\Perplexity\Comet\Application\comet.exe"

$cometFound = $false
$cometExecutable = ""

if (Test-Path $cometPath) {
    $cometFound = $true
    $cometExecutable = $cometPath
    Write-Host "✅ Perplexity Comet encontrado em: $cometPath" -ForegroundColor Green
} elseif (Test-Path $cometPathAlt) {
    $cometFound = $true
    $cometExecutable = $cometPathAlt
    Write-Host "✅ Perplexity Comet encontrado em: $cometPathAlt" -ForegroundColor Green
} else {
    Write-Host "❌ Perplexity Comet não encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Para instalar o Perplexity Comet:" -ForegroundColor Yellow
    Write-Host "   1. Visite: https://www.perplexity.ai/comet" -ForegroundColor Yellow
    Write-Host "   2. Baixe e instale o navegador" -ForegroundColor Yellow
    Write-Host "   3. Execute este script novamente" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔄 Executando no Chrome como fallback..." -ForegroundColor Yellow
    
    # Fallback para Chrome
    flutter run -d chrome
    exit
}

Write-Host ""
Write-Host "🔧 Configurando ambiente para Comet..." -ForegroundColor Cyan

# Define variáveis de ambiente para otimizações do Comet
$env:FLUTTER_WEB_BROWSER = "comet"
$env:CHROME_EXECUTABLE = $cometExecutable

Write-Host "✅ Variáveis de ambiente configuradas" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Lançando aplicação..." -ForegroundColor Cyan
Write-Host ""

# Executa o Flutter com o Comet
flutter run -d chrome --web-browser-flag="--user-agent=PerplexityComet/1.0 Chrome/120.0.0.0"

Write-Host ""
Write-Host "✅ Aplicação encerrada" -ForegroundColor Green
