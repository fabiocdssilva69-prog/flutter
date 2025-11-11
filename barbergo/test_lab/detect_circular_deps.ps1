# Detector de Dependências Circulares
$errors = & dart analyze 2>&1 | Out-String
if ($errors -match "is a supertype of itself") {
    Write-Host "❌ CIRCULAR DEPENDENCY DETECTADA!" -ForegroundColor Red
    Write-Host "🔧 Solução: Reverter última mudança e regenerar" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Sem circular dependencies" -ForegroundColor Green
    exit 0
}
