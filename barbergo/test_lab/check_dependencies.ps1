# Checker de Dependências
Write-Host "📦 Verificando dependências desatualizadas..." -ForegroundColor Cyan

$outdated = flutter pub outdated --json 2>&1 | Out-String
Write-Host "📊 Relatório de dependências:" -ForegroundColor Yellow
flutter pub outdated

Write-Host "`n💡 Para atualizar:" -ForegroundColor Cyan
Write-Host "  flutter pub upgrade --major-versions" -ForegroundColor Gray
Write-Host "`n⚠️  ATENÇÃO: Sempre testar após upgrade!" -ForegroundColor Yellow
