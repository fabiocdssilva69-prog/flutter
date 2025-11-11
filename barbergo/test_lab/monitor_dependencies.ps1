# Monitor de Dependências
Write-Host "📦 Monitorando dependências..." -ForegroundColor Cyan

# Verificar atualizações
flutter pub outdated

# Verificar vulnerabilidades conhecidas (exemplo)
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -match "freezed:\s*2\.") {
    Write-Host "⚠️  Freezed 2.x tem bugs conhecidos, considere upgrade" -ForegroundColor Yellow
}

Write-Host "✅ Monitoramento concluído!" -ForegroundColor Green
