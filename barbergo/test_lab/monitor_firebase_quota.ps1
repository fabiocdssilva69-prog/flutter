# Monitor de Quota Firebase
Write-Host "📊 Verificando uso do Firebase..." -ForegroundColor Cyan
firebase projects:list
Write-Host "`n💡 Para ver quotas: https://console.firebase.google.com" -ForegroundColor Cyan
Write-Host "⚠️  Implementar cache local para reduzir reads" -ForegroundColor Yellow
