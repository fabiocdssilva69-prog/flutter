# ==============================================================================
# SCRIPT DE DIAGNÓSTICO COMPLETO - WEBSOCKET PORTA 9100
# ==============================================================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "DIAGNÓSTICO COMPLETO - BarberGO" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. FLUTTER DOCTOR
Write-Host "[1/10] Verificando Flutter Doctor..." -ForegroundColor Yellow
flutter doctor -v
Write-Host "`n✅ Flutter Doctor concluído`n" -ForegroundColor Green

# 2. PORTA 9100
Write-Host "[2/10] Verificando porta 9100..." -ForegroundColor Yellow
$port9100 = netstat -ano | findstr :9100
if ($port9100) {
    Write-Host "✅ Porta 9100 ATIVA (Dart Tooling Daemon rodando)" -ForegroundColor Green
    Write-Host $port9100
    
    # Identificar processo
    $pid = ($port9100 -split '\s+')[-1]
    $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "   Processo: $($process.ProcessName) (PID: $pid)" -ForegroundColor Cyan
        Write-Host "   Caminho: $($process.Path)" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ Porta 9100 NÃO ESTÁ ATIVA" -ForegroundColor Red
}

# 3. VERIFICAR PROCESSOS CONFLITANTES
Write-Host "`n[3/10] Verificando processos conflitantes..." -ForegroundColor Yellow
$dartProcesses = Get-Process -Name dart -ErrorAction SilentlyContinue
if ($dartProcesses) {
    Write-Host "✅ Processos Dart ativos: $($dartProcesses.Count)" -ForegroundColor Green
    foreach ($p in $dartProcesses) {
        Write-Host "   - PID $($p.Id): $($p.Path)" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ Nenhum processo Dart ativo" -ForegroundColor Yellow
}

# 4. CONFIGURAÇÃO DO VSCODE - PROXY
Write-Host "`n[4/10] Verificando configurações de proxy do VSCode..." -ForegroundColor Yellow
$settingsPath = "$env:APPDATA\Code\User\settings.json"
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath | ConvertFrom-Json
    
    $proxyConfig = @{
        "http.proxy" = $settings.'http.proxy'
        "http.proxySupport" = $settings.'http.proxySupport'
        "http.proxyStrictSSL" = $settings.'http.proxyStrictSSL'
    }
    
    Write-Host "   Configurações atuais:" -ForegroundColor Cyan
    $proxyConfig.GetEnumerator() | ForEach-Object {
        if ($_.Value) {
            Write-Host "   - $($_.Key): $($_.Value)" -ForegroundColor White
        } else {
            Write-Host "   - $($_.Key): (não configurado)" -ForegroundColor Gray
        }
    }
    
    # Recomendar configuração
    if ($settings.'http.proxySupport' -ne 'off') {
        Write-Host "`n   📝 RECOMENDAÇÃO: Configure http.proxySupport como 'off'" -ForegroundColor Yellow
        Write-Host "   Execute: code --user-data-dir=`"$env:APPDATA\Code`" --wait" -ForegroundColor Yellow
        Write-Host "   E adicione: `"http.proxySupport`": `"off`"" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Proxy desabilitado corretamente" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️ Arquivo settings.json não encontrado" -ForegroundColor Red
}

# 5. FIREWALL DO WINDOWS
Write-Host "`n[5/10] Verificando regras de firewall para porta 9100..." -ForegroundColor Yellow
$firewallRules = Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*9100*" -or $_.DisplayName -like "*Dart*" }
if ($firewallRules) {
    Write-Host "✅ Regras de firewall encontradas:" -ForegroundColor Green
    foreach ($rule in $firewallRules) {
        Write-Host "   - $($rule.DisplayName) (Ação: $($rule.Action), Direção: $($rule.Direction))" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ Nenhuma regra de firewall específica encontrada" -ForegroundColor Yellow
    Write-Host "`n   📝 Para criar uma regra, execute como ADMINISTRADOR:" -ForegroundColor Yellow
    Write-Host "   New-NetFirewallRule -DisplayName 'Dart Tooling Daemon' -Direction Inbound -LocalPort 9100 -Protocol TCP -Action Allow" -ForegroundColor White
}

# 6. WINDOWS DEFENDER - EXCLUSÕES
Write-Host "`n[6/10] Verificando exclusões do Windows Defender..." -ForegroundColor Yellow
$flutterPath = "C:\workspaces\fabiocdssilva69-prog\barbergo\flutter"
try {
    $exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
    if ($exclusions -contains $flutterPath) {
        Write-Host "✅ Flutter SDK já está nas exclusões" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Flutter SDK NÃO está nas exclusões" -ForegroundColor Yellow
        Write-Host "`n   📝 Para adicionar, execute como ADMINISTRADOR:" -ForegroundColor Yellow
        Write-Host "   Add-MpPreference -ExclusionPath '$flutterPath'" -ForegroundColor White
    }
} catch {
    Write-Host "⚠️ Não foi possível verificar exclusões (talvez precise de Admin)" -ForegroundColor Red
}

# 7. LOGS DO VSCODE - WEBSOCKET
Write-Host "`n[7/10] Analisando logs do VSCode para erros WebSocket..." -ForegroundColor Yellow
$logsPath = "$env:APPDATA\Code\logs"
if (Test-Path $logsPath) {
    $latestLog = Get-ChildItem $logsPath -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestLog) {
        Write-Host "   Pasta de logs mais recente: $($latestLog.Name)" -ForegroundColor Cyan
        
        $rendererLog = Join-Path $latestLog.FullName "renderer*.log"
        $logFiles = Get-ChildItem $rendererLog -ErrorAction SilentlyContinue
        
        if ($logFiles) {
            Write-Host "   Buscando erros WebSocket..." -ForegroundColor Cyan
            $errors = $logFiles | ForEach-Object { 
                Get-Content $_.FullName | Select-String -Pattern "websocket|ws:|9100|dart.*error|connection.*refused" -CaseSensitive:$false 
            } | Select-Object -First 10
            
            if ($errors) {
                Write-Host "   ⚠️ Erros encontrados:" -ForegroundColor Red
                foreach ($error in $errors) {
                    Write-Host "   - $($error.Line)" -ForegroundColor Yellow
                }
            } else {
                Write-Host "   ✅ Nenhum erro WebSocket encontrado nos logs" -ForegroundColor Green
            }
        } else {
            Write-Host "   ℹ️ Nenhum arquivo de log renderer encontrado" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "⚠️ Pasta de logs não encontrada" -ForegroundColor Red
}

# 8. EXTENSÕES DART/FLUTTER
Write-Host "`n[8/10] Verificando extensões Dart/Flutter..." -ForegroundColor Yellow
$extensions = code --list-extensions --show-versions | Select-String -Pattern "dart|flutter"
if ($extensions) {
    Write-Host "✅ Extensões instaladas:" -ForegroundColor Green
    foreach ($ext in $extensions) {
        Write-Host "   - $ext" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️ Extensões Dart/Flutter não encontradas" -ForegroundColor Red
    Write-Host "`n   📝 Para instalar:" -ForegroundColor Yellow
    Write-Host "   code --install-extension dart-code.dart-code" -ForegroundColor White
    Write-Host "   code --install-extension dart-code.flutter" -ForegroundColor White
}

# 9. TESTES DE CONECTIVIDADE
Write-Host "`n[9/10] Testando conectividade local..." -ForegroundColor Yellow
try {
    $testConnection = Test-NetConnection -ComputerName localhost -Port 9100 -InformationLevel Quiet -WarningAction SilentlyContinue
    if ($testConnection) {
        Write-Host "✅ Conexão com localhost:9100 bem-sucedida" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Não foi possível conectar em localhost:9100" -ForegroundColor Red
    }
} catch {
    Write-Host "⚠️ Erro ao testar conectividade: $($_.Exception.Message)" -ForegroundColor Red
}

# 10. RESUMO E RECOMENDAÇÕES
Write-Host "`n[10/10] Gerando resumo..." -ForegroundColor Yellow
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMO DO DIAGNÓSTICO" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Pontuação
$score = 0
if ($port9100) { $score++ }
if ($dartProcesses) { $score++ }
if ($settings.'http.proxySupport' -eq 'off') { $score++ }
if ($extensions) { $score++ }

Write-Host "Pontuação de Saúde: $score/4`n" -ForegroundColor $(if ($score -ge 3) { 'Green' } else { 'Yellow' })

Write-Host "AÇÕES RECOMENDADAS:" -ForegroundColor Yellow
Write-Host "1. Se proxy não está 'off', configure no settings.json" -ForegroundColor White
Write-Host "2. Adicione Flutter SDK às exclusões do antivírus (admin)" -ForegroundColor White
Write-Host "3. Crie regra de firewall para porta 9100 (admin)" -ForegroundColor White
Write-Host "4. Reinicie o VSCode após mudanças de configuração" -ForegroundColor White
Write-Host "5. Se problemas persistirem, reinstale extensões Dart/Flutter`n" -ForegroundColor White

Write-Host "========================================`n" -ForegroundColor Cyan

# Perguntar se deseja aplicar correções automáticas
$response = Read-Host "Deseja aplicar correções automáticas? (S/N)"
if ($response -eq 'S' -or $response -eq 's') {
    Write-Host "`n🔧 Aplicando correções..." -ForegroundColor Cyan
    
    # Atualizar settings.json
    if ($settings.'http.proxySupport' -ne 'off') {
        Write-Host "   Atualizando http.proxySupport para 'off'..." -ForegroundColor Yellow
        $settings.'http.proxySupport' = 'off'
        $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
        Write-Host "   ✅ settings.json atualizado" -ForegroundColor Green
    }
    
    Write-Host "`n✅ Correções aplicadas! Reinicie o VSCode." -ForegroundColor Green
} else {
    Write-Host "`nℹ️ Nenhuma correção aplicada. Execute manualmente conforme recomendações." -ForegroundColor Cyan
}

Write-Host "`n✅ Diagnóstico completo!`n" -ForegroundColor Green
