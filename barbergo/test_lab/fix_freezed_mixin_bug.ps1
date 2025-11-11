# ============================================================================
# 🔧 CORREÇÃO MANUAL DO BUG DO FREEZED 3.2.x - MIXIN CONSTRAINT
# ============================================================================
# 
# BUG: Freezed gera `mixin _$Entity {` sem constraint, causando:
# "Missing concrete implementations"
# 
# SOLUÇÃO: Adicionar constraint `on Entity` manualmente em todos .freezed.dart
# ============================================================================

$ErrorActionPreference = "Continue"

Write-Host "`n🔧 CORREÇÃO MANUAL - Bug do Mixin Freezed 3.2.x" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Encontrar todos os arquivos .freezed.dart
$freezedFiles = Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart

Write-Host "`n📋 Arquivos .freezed.dart encontrados: $($freezedFiles.Count)" -ForegroundColor Cyan

$fixedCount = 0
$errorCount = 0

foreach ($file in $freezedFiles) {
  Write-Host "`n📄 Processando: $($file.Name)" -ForegroundColor Yellow
    
  $content = Get-Content $file.FullName -Raw
    
  # Detectar padrão bugado: mixin _$ClassName {
  # Deve ser: mixin _$ClassName on ClassName {
    
  # Extrair nome da classe do nome do arquivo
  # Ex: user_interaction_entity.freezed.dart -> UserInteractionEntity
  $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $fileName = $fileName -replace '\.freezed$', ''
    
  # Converter snake_case para PascalCase
  $className = ($fileName -split '_' | ForEach-Object { 
      $_.Substring(0, 1).ToUpper() + $_.Substring(1)
    }) -join ''
    
  Write-Host "  🔍 Classe detectada: $className" -ForegroundColor Cyan
    
  # Procurar padrão bugado (pode ter quebra de linha ou não)
  $bugPattern = "mixin\s+_\`$$className\s*\{"
    
  if ($content -match $bugPattern) {
    Write-Host "  ❌ Bug encontrado: mixin _`$$className {" -ForegroundColor Red
        
    # Aplicar correção: adicionar constraint "on $className"
    $fixedContent = $content -replace $bugPattern, "mixin _`$$className on $className {`n"    # Salvar arquivo corrigido
    $fixedContent | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
        
    Write-Host "  ✅ CORRIGIDO: mixin _`$$className on $className {" -ForegroundColor Green
    $fixedCount++
  }
  else {
    Write-Host "  ✅ Já está correto ou não tem o padrão bugado" -ForegroundColor Green
  }
}

Write-Host "`n" -NoNewline
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 RESULTADO DA CORREÇÃO" -ForegroundColor Cyan
Write-Host ("=" * 70) -ForegroundColor Cyan
Write-Host "✅ Arquivos corrigidos: $fixedCount" -ForegroundColor Green
Write-Host "📋 Total processado: $($freezedFiles.Count)" -ForegroundColor Cyan

if ($fixedCount -gt 0) {
  Write-Host "`n🔍 Verificando erros após correção..." -ForegroundColor Cyan
  $analyzeOutput = & dart analyze lib/src/domain/entities/ 2>&1 | Out-String
    
  $errors = ([regex]::Matches($analyzeOutput, "error •")).Count
    
  Write-Host "📊 Erros restantes: $errors" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Red" })
    
  if ($errors -eq 0) {
    Write-Host "`n🎉🎉🎉 SUCESSO TOTAL! 🎉🎉🎉" -ForegroundColor Green
    Write-Host "✅ Todas as entidades compilam sem erros!" -ForegroundColor Green
    Write-Host "`n🚀 Próximo passo: Testar no device" -ForegroundColor Cyan
    Write-Host "   flutter run -d uwbekb8hpf6lamts" -ForegroundColor Gray
  }
  else {
    Write-Host "`n⚠️ Ainda há erros. Listando primeiros 10..." -ForegroundColor Yellow
    & dart analyze lib/src/domain/entities/ 2>&1 | Select-String "error" | Select-Object -First 10
  }
}

Write-Host "`n" -NoNewline
Write-Host ("=" * 70) -ForegroundColor Cyan
