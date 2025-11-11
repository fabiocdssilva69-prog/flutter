# Reset Rápido para Hot Reload
Write-Host "🔄 Executando reset rápido..." -ForegroundColor Cyan
Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart | Remove-Item -Force
Get-ChildItem -Path lib -Recurse -Filter *.g.dart | Remove-Item -Force
Write-Host "✅ Arquivos gerados removidos" -ForegroundColor Green

dart run build_runner build --delete-conflicting-outputs
Write-Host "✅ Código regenerado" -ForegroundColor Green

Write-Host "🚀 Hot reload deve funcionar agora!" -ForegroundColor Green
