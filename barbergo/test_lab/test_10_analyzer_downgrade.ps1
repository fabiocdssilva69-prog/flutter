# 🧪 TESTE 10: Downgrade de analyzer para versão específica
# Hipótese: Bug pode estar no analyzer, não no Freezed

Write-Host "🧪 TESTE 10: Analyzer Downgrade" -ForegroundColor Cyan

$analyzerVersions = @("7.5.0", "7.4.0", "7.3.0", "7.2.0", "7.1.0", "7.0.0")

foreach ($ver in $analyzerVersions) {
  Write-Host "`n📦 Testando analyzer $ver..." -ForegroundColor Yellow
    
  # Força versão específica
  flutter pub add "dev:analyzer:$ver" 2>&1 | Out-Null
    
  # Testa análise
  $result = dart analyze lib/src/domain/entities/profile_entity.dart 2>&1
    
  if ($result -notmatch "missing implementations") {
    Write-Host "   ✅ ANALYZER $ver FUNCIONA!" -ForegroundColor Green
    "TESTE 10: ✅ SUCESSO - analyzer $ver" | Out-File test_lab/results/10_success.txt
    "analyzer: $ver" | Out-File test_lab/results/10_working_version.txt
    exit 0
  }
  else {
    Write-Host "   ❌ Versão $ver ainda reporta erro" -ForegroundColor Red
    "TESTE 10 ($ver): ❌ Mesmo erro" | Out-File -Append test_lab/results/10_cascade.txt
  }
}

Write-Host "`n❌ Nenhuma versão de analyzer resolve" -ForegroundColor Red
exit 1
