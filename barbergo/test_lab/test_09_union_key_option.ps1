# 🧪 TESTE 09: Usar @Freezed() com opções especiais
# Hipótese: unionKey, unionValueCase podem alterar geração

Write-Host "🧪 TESTE 09: @Freezed() Options" -ForegroundColor Cyan

$entityFile = "lib/src/domain/entities/profile_entity.dart"
Copy-Item $entityFile "$entityFile.bak"

$content = Get-Content $entityFile -Raw

# Adiciona opções ao @freezed
$content = $content -replace '@freezed', '@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none, copyWith: true, equal: true, toStringOverride: true)'

Set-Content $entityFile $content -NoNewline

Write-Host "📝 Adicionado opções customizadas ao @Freezed()" -ForegroundColor Yellow

# Regenera
Get-ChildItem -Path lib/src/domain/entities -Filter *.freezed.dart | Remove-Item -Force
dart run build_runner build --delete-conflicting-outputs 2>&1 | Out-Null

$result = dart analyze lib/src/domain/entities/profile_entity.dart 2>&1
if ($result -notmatch "missing implementations") {
  Write-Host "✅ SUCESSO! @Freezed() options mudam geração!" -ForegroundColor Green
  "TESTE 09: ✅ SUCESSO - @Freezed() options" | Out-File test_lab/results/09_success.txt
  exit 0
}
else {
  Write-Host "❌ FALHOU: Opções não alteram bug" -ForegroundColor Red
  $result | Out-File test_lab/results/09_failure.txt
  Move-Item "$entityFile.bak" $entityFile -Force
  exit 1
}
