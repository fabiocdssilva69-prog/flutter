# 🧪 TESTE 19: Patch Automático de .freezed.dart
# Hipótese: Podemos corrigir o código gerado automaticamente após build_runner

Write-Host "🧪 TESTE 19: Auto-Patch .freezed.dart (Pós-Geração)" -ForegroundColor Cyan
Write-Host "=" * 60

$testStart = Get-Date

# PASSO 1: Regenerar código Freezed
Write-Host "`n🔄 Regenerando código Freezed..." -ForegroundColor Yellow
dart run build_runner build --delete-conflicting-outputs | Out-Null

# PASSO 2: Identificar arquivos .freezed.dart com bug
Write-Host "`n🔍 Identificando arquivos bugados..." -ForegroundColor Yellow
$buggedFiles = @(
  "lib/src/domain/entities/profile_entity.freezed.dart",
  "lib/src/domain/entities/vacancy_entity.freezed.dart",
  "lib/src/domain/entities/application_entity.freezed.dart",
  "lib/src/domain/entities/notification_entity.freezed.dart",
  "lib/src/domain/entities/user_interaction_entity.freezed.dart",
  "lib/src/domain/entities/ai/chat_message.freezed.dart",
  "lib/src/features/ai/controllers/chat_state.freezed.dart"
)

$patchedCount = 0

foreach ($file in $buggedFiles) {
  if (-not (Test-Path $file)) {
    Write-Host "⚠️ Arquivo não existe: $file" -ForegroundColor Yellow
    continue
  }
    
  Write-Host "🔧 Patcheando: $(Split-Path $file -Leaf)" -ForegroundColor Cyan
    
  # Ler conteúdo
  $content = Get-Content $file -Raw
    
  # PATCH 1: Adicionar constraint ao mixin
  # Antes: mixin _$ProfileEntity {
  # Depois: mixin _$ProfileEntity on ProfileEntity {
    
  # Extrair nome da classe do mixin
  if ($content -match 'mixin _\$(\w+) \{') {
    $className = $Matches[1]
        
    # Aplicar patch
    $patched = $content -replace "mixin _\`$$className \{", "mixin _`$$className on $className {"
        
    # Verificar se patch foi aplicado
    if ($patched -ne $content) {
      Set-Content $file $patched -NoNewline
      Write-Host "  ✅ Patch aplicado: mixin _`$$className on $className {" -ForegroundColor Green
      $patchedCount++
    }
    else {
      Write-Host "  ⚠️ Patch não necessário ou já aplicado" -ForegroundColor Yellow
    }
  }
}

Write-Host "`n📊 Total de arquivos patcheados: $patchedCount" -ForegroundColor Cyan

# PASSO 3: Testar compilação
Write-Host "`n🧪 Testando compilação..." -ForegroundColor Yellow
$analyzeStart = Get-Date
$analyzeOutput = dart analyze --fatal-infos 2>&1
$analyzeErrors = $analyzeOutput | Select-String "error •" | Measure-Object | Select-Object -ExpandProperty Count
$analyzeDuration = ((Get-Date) - $analyzeStart).TotalSeconds

$testDuration = ((Get-Date) - $testStart).TotalSeconds

Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan

if ($analyzeErrors -eq 0) {
  Write-Host "✅✅✅ SUCESSO TOTAL! Patch resolveu o problema! ✅✅✅" -ForegroundColor Green
  Write-Host "📝 Arquivos patcheados: $patchedCount" -ForegroundColor Cyan
  Write-Host "🎯 Erros restantes: 0" -ForegroundColor Green
  Write-Host "⏱️ Tempo total: $([math]::Round($testDuration, 1))s" -ForegroundColor Yellow
    
  # Salvar script de patch para uso futuro
  $patchScript = @"
# Script de patch automático para Freezed 3.2.x
# Executar após cada build_runner build

`$files = Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart
foreach (`$f in `$files) {
    `$content = Get-Content `$f.FullName -Raw
    if (`$content -match 'mixin _\`$(\w+) \{') {
        `$className = `$Matches[1]
        `$patched = `$content -replace "mixin _\``$`$className \{", "mixin _``$`$className on `$className {"
        if (`$patched -ne `$content) {
            Set-Content `$f.FullName `$patched -NoNewline
            Write-Host "✅ Patched: `$(`$f.Name)" -ForegroundColor Green
        }
    }
}
"@
  Set-Content "patch_freezed_bug.ps1" $patchScript
  Write-Host "`n💾 Script salvo: patch_freezed_bug.ps1" -ForegroundColor Cyan
  Write-Host "📋 Use este script após cada build_runner" -ForegroundColor Yellow
    
  exit 0
}
else {
  Write-Host "❌ FALHOU - Ainda com $analyzeErrors erros" -ForegroundColor Red
  Write-Host "⏱️ Tempo: $([math]::Round($testDuration, 1))s" -ForegroundColor Yellow
  Write-Host "`nPrimeiros erros:" -ForegroundColor Yellow
  $analyzeOutput | Select-String "error •" | Select-Object -First 5
  exit 1
}
