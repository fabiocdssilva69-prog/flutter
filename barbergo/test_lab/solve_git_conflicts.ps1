# Resolver Conflicts em .freezed.dart
Write-Host "🔧 Resolvendo conflicts em arquivos gerados..." -ForegroundColor Cyan
Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart | Remove-Item -Force
Get-ChildItem -Path lib -Recurse -Filter *.g.dart | Remove-Item -Force
dart run build_runner build --delete-conflicting-outputs
Write-Host "✅ Conflicts resolvidos via regeneração" -ForegroundColor Green
