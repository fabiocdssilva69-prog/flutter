# Script para monitorar logs do Flutter
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Monitor de Logs - BarberGo App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Aguardando conexão com o app..." -ForegroundColor Yellow
Write-Host "Por favor, abra o app BarberGo no device" -ForegroundColor Yellow
Write-Host ""
Write-Host "Pressione Ctrl+C para parar o monitoramento" -ForegroundColor Gray
Write-Host ""

# Executa flutter attach e captura saída
$deviceId = "uwbekb8hpf6lamts"
flutter attach -d $deviceId --verbose
