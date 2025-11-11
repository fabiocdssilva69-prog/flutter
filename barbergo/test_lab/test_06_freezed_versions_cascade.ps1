# 🧪 TESTE 06: Testar versões Freezed em cascata (3.0.6 → 3.0.0)
# Hipótese: Alguma versão 3.0.x pode funcionar com source_gen 3.x

Write-Host "🧪 TESTE 06: Freezed Version Cascade" -ForegroundColor Cyan

$versions = @("3.0.6", "3.0.5", "3.0.4", "3.0.3", "3.0.2", "3.0.1", "3.0.0")

foreach ($ver in $versions) {
  Write-Host "`n📦 Testando Freezed $ver..." -ForegroundColor Yellow
    
  # Tenta instalar (ignora erro de dependência)
  $installResult = flutter pub add "dev:freezed:$ver" 2>&1
    
  if ($installResult -match "version solving failed") {
    Write-Host "   ⏭️ Versão $ver incompatível (source_gen)" -ForegroundColor Gray
    "TESTE 06 ($ver): ❌ Incompatível (source_gen)" | Out-File -Append test_lab/results/06_cascade.txt
    continue
  }
    
  # Regenera
  dart run build_runner build --delete-conflicting-outputs 2>&1 | Out-Null
    
  # Testa compilação rápida (apenas análise)
  $analyzeResult = dart analyze lib/src/domain/entities/profile_entity.dart 2>&1
    
  if ($analyzeResult -notmatch "missing implementations") {
    Write-Host "   ✅ VERSÃO $ver FUNCIONA!" -ForegroundColor Green
    "TESTE 06: ✅ SUCESSO - Freezed $ver" | Out-File test_lab/results/06_success.txt
    "freezed: $ver" | Out-File test_lab/results/06_working_version.txt
    exit 0
  }
  else {
    Write-Host "   ❌ Versão $ver tem mesmo bug" -ForegroundColor Red
    "TESTE 06 ($ver): ❌ Mesmo bug de mixin" | Out-File -Append test_lab/results/06_cascade.txt
  }
}

Write-Host "`n❌ Nenhuma versão 3.0.x funciona" -ForegroundColor Red
exit 1
