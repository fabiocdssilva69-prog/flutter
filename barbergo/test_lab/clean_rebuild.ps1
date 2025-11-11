# Clean Rebuild Completo
Write-Host "🧹 Limpeza completa..." -ForegroundColor Cyan

# Limpar cache
flutter clean
Remove-Item -Path ".dart_tool" -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart | Remove-Item -Force
Get-ChildItem -Path lib -Recurse -Filter *.g.dart | Remove-Item -Force

Write-Host "✅ Cache limpo" -ForegroundColor Green

# Reinstalar dependências
flutter pub get
Write-Host "✅ Dependências instaladas" -ForegroundColor Green

# Rebuild
dart run build_runner build --delete-conflicting-outputs
Write-Host "✅ Código regenerado" -ForegroundColor Green

Write-Host "`n🎉 Rebuild completo finalizado!" -ForegroundColor Green
