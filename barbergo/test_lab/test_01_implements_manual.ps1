# 🧪 TESTE 01: Adicionar implements manual nas classes
# Hipótese: Se adicionarmos implements _$ProfileEntity, o compilador pode aceitar

Write-Host "🧪 TESTE 01: Implements Manual" -ForegroundColor Cyan

# Backup
Copy-Item lib/src/domain/entities/profile_entity.dart lib/src/domain/entities/profile_entity.dart.bak

# Modificação
$content = Get-Content lib/src/domain/entities/profile_entity.dart -Raw
$content = $content -replace 'class (\w+Entity) with _\$(\w+Entity)', 'class $1 implements _$$2'
Set-Content lib/src/domain/entities/profile_entity.dart $content -NoNewline

Write-Host "📝 Modificado: class ProfileEntity implements _`$ProfileEntity" -ForegroundColor Yellow

# Regenera
dart run build_runner build --delete-conflicting-outputs 2>&1 | Out-Null

# Testa compilação
$result = flutter build apk --debug 2>&1
if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ SUCESSO! Implements manual funciona!" -ForegroundColor Green
  "TESTE 01: ✅ SUCESSO - implements manual" | Out-File test_lab/results/01_success.txt
  exit 0
}
else {
  Write-Host "❌ FALHOU: Implements manual não funciona" -ForegroundColor Red
  $result | Out-File test_lab/results/01_failure.txt
    
  # Restaura backup
  Move-Item lib/src/domain/entities/profile_entity.dart.bak lib/src/domain/entities/profile_entity.dart -Force
  exit 1
}
