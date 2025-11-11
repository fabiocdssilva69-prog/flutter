# Multi-Device Tester
Write-Host "📱 Detectando devices disponíveis..." -ForegroundColor Cyan

$devices = flutter devices | Out-String
Write-Host $devices

Write-Host "`n💡 Para testar em device específico:" -ForegroundColor Cyan
Write-Host "  flutter run -d <device-id>" -ForegroundColor Gray
Write-Host "`n💡 Para testar em TODOS os devices:" -ForegroundColor Cyan
Write-Host "  flutter run -d all" -ForegroundColor Gray
