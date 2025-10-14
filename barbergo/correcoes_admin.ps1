# ==============================================================================
# CORREÇÕES ADMINISTRATIVAS - EXECUTE COMO ADMINISTRADOR
# ==============================================================================
# Clique com botão direito no PowerShell → "Executar como Administrador"
# Depois execute: .\correcoes_admin.ps1
# ==============================================================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "CORREÇÕES ADMINISTRATIVAS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Verificar se está rodando como Admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ ERRO: Este script precisa ser executado como ADMINISTRADOR!" -ForegroundColor Red
    Write-Host "`n   Feche este PowerShell e:" -ForegroundColor Yellow
    Write-Host "   1. Clique com botão direito em PowerShell" -ForegroundColor White
    Write-Host "   2. Selecione 'Executar como Administrador'" -ForegroundColor White
    Write-Host "   3. Execute: cd 'C:\workspaces\fabiocdssilva69-prog\barbergo'" -ForegroundColor White
    Write-Host "   4. Execute: .\correcoes_admin.ps1`n" -ForegroundColor White
    exit 1
}

Write-Host "✅ Executando como Administrador`n" -ForegroundColor Green

# 1. CRIAR REGRA DE FIREWALL PARA PORTA 9100
Write-Host "[1/3] Criando regra de firewall para porta 9100..." -ForegroundColor Yellow
try {
    # Verificar se regra já existe
    $existingRule = Get-NetFirewallRule -DisplayName "Dart Tooling Daemon - Port 9100" -ErrorAction SilentlyContinue
    
    if ($existingRule) {
        Write-Host "   ℹ️ Regra já existe, removendo a antiga..." -ForegroundColor Cyan
        Remove-NetFirewallRule -DisplayName "Dart Tooling Daemon - Port 9100"
    }
    
    # Criar nova regra
    New-NetFirewallRule `
        -DisplayName "Dart Tooling Daemon - Port 9100" `
        -Description "Permite comunicação WebSocket do Dart Tooling Daemon (DTD) na porta 9100 para VSCode" `
        -Direction Inbound `
        -LocalPort 9100 `
        -Protocol TCP `
        -Action Allow `
        -Enabled True `
        -Profile Any | Out-Null
    
    Write-Host "   ✅ Regra de firewall criada com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Erro ao criar regra de firewall: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. ADICIONAR FLUTTER SDK ÀS EXCLUSÕES DO WINDOWS DEFENDER
Write-Host "`n[2/3] Adicionando Flutter SDK às exclusões do Windows Defender..." -ForegroundColor Yellow
$flutterPath = "C:\workspaces\fabiocdssilva69-prog\barbergo\flutter"
try {
    # Verificar se já está nas exclusões
    $exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
    
    if ($exclusions -contains $flutterPath) {
        Write-Host "   ℹ️ Flutter SDK já está nas exclusões" -ForegroundColor Cyan
    } else {
        Add-MpPreference -ExclusionPath $flutterPath
        Write-Host "   ✅ Flutter SDK adicionado às exclusões!" -ForegroundColor Green
    }
    
    # Adicionar também o diretório de trabalho
    $workspacePath = "C:\workspaces\fabiocdssilva69-prog\barbergo"
    if ($exclusions -contains $workspacePath) {
        Write-Host "   ℹ️ Workspace já está nas exclusões" -ForegroundColor Cyan
    } else {
        Add-MpPreference -ExclusionPath $workspacePath
        Write-Host "   ✅ Workspace adicionado às exclusões!" -ForegroundColor Green
    }
} catch {
    Write-Host "   ❌ Erro ao adicionar exclusões: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. VERIFICAR PERMISSÕES DE PORTA
Write-Host "`n[3/3] Verificando permissões de porta..." -ForegroundColor Yellow
try {
    $port9100 = netstat -ano | findstr :9100
    if ($port9100) {
        Write-Host "   ✅ Porta 9100 está ativa e acessível" -ForegroundColor Green
        Write-Host "   $port9100" -ForegroundColor Cyan
    } else {
        Write-Host "   ⚠️ Porta 9100 não está ativa (normal se Flutter não estiver rodando)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Erro ao verificar porta: $($_.Exception.Message)" -ForegroundColor Red
}

# RESUMO FINAL
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "RESUMO DAS CORREÇÕES" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "✅ Correções administrativas concluídas!" -ForegroundColor Green
Write-Host "`nPRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "1. Configure o proxy no VSCode manualmente (veja instruções abaixo)" -ForegroundColor White
Write-Host "2. Reinicie o VSCode" -ForegroundColor White
Write-Host "3. Execute: flutter doctor -v" -ForegroundColor White
Write-Host "4. Teste a aplicação: flutter run -d chrome`n" -ForegroundColor White

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CONFIGURAÇÃO MANUAL DO VSCODE" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Abra o VSCode" -ForegroundColor White
Write-Host "2. Pressione Ctrl+Shift+P" -ForegroundColor White
Write-Host "3. Digite: 'Preferences: Open User Settings (JSON)'" -ForegroundColor White
Write-Host "4. Adicione as seguintes linhas:" -ForegroundColor White
Write-Host @"

{
  "http.proxySupport": "off",
  "http.proxy": "",
  "http.proxyStrictSSL": false
}

"@ -ForegroundColor Cyan

Write-Host "`n5. Salve o arquivo (Ctrl+S)" -ForegroundColor White
Write-Host "6. Reinicie o VSCode (Ctrl+Shift+P → 'Reload Window')`n" -ForegroundColor White

Write-Host "========================================`n" -ForegroundColor Cyan
