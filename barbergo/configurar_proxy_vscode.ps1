# ==============================================================================
# CONFIGURAÇÃO MANUAL DO VSCODE - PROXY
# ==============================================================================
# Execute este script normalmente (não precisa de Admin)
# ==============================================================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "CONFIGURAÇÃO DO VSCODE - PROXY" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$settingsPath = "$env:APPDATA\Code\User\settings.json"

Write-Host "Caminho do settings.json:" -ForegroundColor Yellow
Write-Host "$settingsPath`n" -ForegroundColor Cyan

if (Test-Path $settingsPath) {
    Write-Host "✅ Arquivo settings.json encontrado" -ForegroundColor Green
    
    # Ler conteúdo atual
    Write-Host "`nConteúdo atual (primeiras 20 linhas):" -ForegroundColor Yellow
    Get-Content $settingsPath -Head 20 | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    
    Write-Host "`n...`n" -ForegroundColor Gray
    
    # Criar backup
    $backupPath = "$settingsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $settingsPath $backupPath
    Write-Host "✅ Backup criado em: $backupPath`n" -ForegroundColor Green
    
    # Tentar ler como JSON
    try {
        $settings = Get-Content $settingsPath -Raw
        
        # Verificar se já tem as configurações de proxy
        $hasProxySupport = $settings -match '"http\.proxySupport"'
        $hasProxy = $settings -match '"http\.proxy"'
        $hasProxySSL = $settings -match '"http\.proxyStrictSSL"'
        
        if ($hasProxySupport -or $hasProxy -or $hasProxySSL) {
            Write-Host "⚠️ Configurações de proxy já existem!" -ForegroundColor Yellow
            Write-Host "Deseja SUBSTITUIR as configurações existentes? (S/N): " -ForegroundColor Yellow -NoNewline
            $response = Read-Host
            
            if ($response -ne 'S' -and $response -ne 's') {
                Write-Host "`nℹ️ Operação cancelada. Nenhuma alteração feita." -ForegroundColor Cyan
                exit 0
            }
        }
        
        # Remover configurações antigas de proxy (se existirem)
        $settings = $settings -replace '"http\.proxySupport"\s*:\s*"[^"]*"\s*,?\s*', ''
        $settings = $settings -replace '"http\.proxy"\s*:\s*"[^"]*"\s*,?\s*', ''
        $settings = $settings -replace '"http\.proxyStrictSSL"\s*:\s*(true|false)\s*,?\s*', ''
        
        # Adicionar novas configurações
        # Encontrar a última chave antes do }
        if ($settings -match '\{') {
            $settings = $settings -replace '\{', @"
{
  "http.proxySupport": "off",
  "http.proxy": "",
  "http.proxyStrictSSL": false,
"@
        }
        
        # Salvar
        $settings | Set-Content $settingsPath -Encoding UTF8
        
        Write-Host "`n✅ Configurações de proxy atualizadas com sucesso!" -ForegroundColor Green
        Write-Host "`nNovas configurações:" -ForegroundColor Yellow
        Write-Host '  "http.proxySupport": "off"' -ForegroundColor Cyan
        Write-Host '  "http.proxy": ""' -ForegroundColor Cyan
        Write-Host '  "http.proxyStrictSSL": false' -ForegroundColor Cyan
        
    } catch {
        Write-Host "❌ Erro ao processar settings.json: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n📝 CONFIGURAÇÃO MANUAL NECESSÁRIA:" -ForegroundColor Yellow
        Write-Host "`n1. Abra o VSCode" -ForegroundColor White
        Write-Host "2. Pressione Ctrl+," -ForegroundColor White
        Write-Host "3. Clique no ícone {} no canto superior direito" -ForegroundColor White
        Write-Host "4. Adicione as seguintes linhas:" -ForegroundColor White
        Write-Host @"

  "http.proxySupport": "off",
  "http.proxy": "",
  "http.proxyStrictSSL": false

"@ -ForegroundColor Cyan
    }
    
} else {
    Write-Host "⚠️ Arquivo settings.json NÃO encontrado!" -ForegroundColor Red
    Write-Host "`nCriando novo arquivo..." -ForegroundColor Yellow
    
    $newSettings = @"
{
  "http.proxySupport": "off",
  "http.proxy": "",
  "http.proxyStrictSSL": false
}
"@
    
    # Criar diretório se não existir
    $settingsDir = Split-Path $settingsPath
    if (-not (Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
    }
    
    $newSettings | Set-Content $settingsPath -Encoding UTF8
    Write-Host "✅ Arquivo settings.json criado com configurações de proxy!" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PRÓXIMOS PASSOS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Reinicie o VSCode (Ctrl+Shift+P → 'Reload Window')" -ForegroundColor White
Write-Host "2. Execute: flutter doctor -v" -ForegroundColor White
Write-Host "3. Verifique se o Dart Tooling Daemon conecta corretamente" -ForegroundColor White
Write-Host "4. Teste a aplicação: flutter run -d chrome`n" -ForegroundColor White

Write-Host "========================================`n" -ForegroundColor Cyan
