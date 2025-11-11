# 🧪 TESTE 03: Usar base mixin (Dart 3.0+)
# Hipótese: Modificadores class podem ajudar o compilador

Write-Host "🧪 TESTE 03: Base Mixin" -ForegroundColor Cyan

$freezedFile = "lib/src/domain/entities/profile_entity.freezed.dart"
Copy-Item $freezedFile "$freezedFile.bak"

$content = Get-Content $freezedFile -Raw
$content = $content -replace '(?m)^mixin _\$(\w+)', 'base mixin _$$1'
Set-Content $freezedFile $content -NoNewline

Write-Host "📝 Modificado: base mixin _`$ProfileEntity" -ForegroundColor Yellow

$result = flutter build apk --debug 2>&1
if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ SUCESSO! Base mixin funciona!" -ForegroundColor Green
  "TESTE 03: ✅ SUCESSO - base mixin" | Out-File test_lab/results/03_success.txt
  exit 0
}
else {
  Write-Host "❌ FALHOU: Base mixin não funciona" -ForegroundColor Red
  $result | Select-String "Error" | Select-Object -First 10 | Out-File test_lab/results/03_failure.txt
  Move-Item "$freezedFile.bak" $freezedFile -Force
  exit 1
}
