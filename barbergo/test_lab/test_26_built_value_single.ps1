# 🧪 TESTE 26: built_value - Migração 1 Entidade
# Hipótese: built_value é alternativa robusta sem bugs

Write-Host "🧪 TESTE 26: built_value Migration (user_interaction_entity)" -ForegroundColor Cyan
Write-Host "=" * 70

$testStart = Get-Date
$score = 0

# PASSO 1: Backup arquivo original
Write-Host "`n💾 Backup user_interaction_entity..." -ForegroundColor Yellow
$entityFile = "lib/src/domain/entities/user_interaction_entity.dart"
Copy-Item $entityFile "$entityFile.test26_backup" -Force

# PASSO 2: Instalar built_value
Write-Host "`n📦 Instalando built_value..." -ForegroundColor Yellow
Copy-Item "pubspec.yaml" "pubspec.yaml.test26_backup" -Force

# Adicionar built_value ao pubspec
$pubspec = Get-Content "pubspec.yaml" -Raw
if ($pubspec -notmatch 'built_value:') {
  $pubspec = $pubspec -replace '(dependencies:)', "`$1`n  built_value: ^8.9.2"
  $pubspec = $pubspec -replace '(dev_dependencies:)', "`$1`n  built_value_generator: ^8.9.2`n  built_value_test: ^8.9.2"
  Set-Content "pubspec.yaml" $pubspec -NoNewline
    
  flutter pub get | Out-Null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ built_value instalado!" -ForegroundColor Green
    $score += 10
  }
  else {
    Write-Host "❌ Erro ao instalar built_value" -ForegroundColor Red
    Move-Item "pubspec.yaml.test26_backup" "pubspec.yaml" -Force
    Move-Item "$entityFile.test26_backup" $entityFile -Force
    exit 1
  }
}

# PASSO 3: Converter entidade para built_value
Write-Host "`n📝 Convertendo para built_value..." -ForegroundColor Yellow

$builtValueCode = @'
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'converters.dart';
import 'enums.dart';

part 'user_interaction_entity.g.dart';

abstract class UserInteractionEntity 
    implements Built<UserInteractionEntity, UserInteractionEntityBuilder> {
  
  String get vacancyId;
  InteractionType get type;
  DateTime get timestamp;

  UserInteractionEntity._();
  factory UserInteractionEntity([void Function(UserInteractionEntityBuilder) updates]) = 
      _$UserInteractionEntity;

  // Serialization
  static Serializer<UserInteractionEntity> get serializer => 
      _$userInteractionEntitySerializer;

  Map<String, dynamic> toJson() {
    return {
      'vacancyId': vacancyId,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory UserInteractionEntity.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];
    final dateTime = timestamp is Timestamp 
        ? timestamp.toDate() 
        : DateTime.parse(timestamp.toString());
    
    return UserInteractionEntity((b) => b
      ..vacancyId = json['vacancyId'] as String
      ..type = InteractionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type']
      )
      ..timestamp = dateTime
    );
  }
}
'@

Set-Content $entityFile $builtValueCode -NoNewline
$score += 20

# PASSO 4: Regenerar código
Write-Host "`n🔄 Regenerando código..." -ForegroundColor Yellow
$buildOutput = dart run build_runner build --delete-conflicting-outputs 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

if ($buildSuccess) {
  Write-Host "✅ Código gerado com sucesso!" -ForegroundColor Green
  $score += 20
}
else {
  Write-Host "❌ Erro na geração" -ForegroundColor Red
  Write-Host ($buildOutput | Select-String "error|Error" | Select-Object -First 5)
}

# PASSO 5: Verificar arquivo gerado
$generatedFile = "lib/src/domain/entities/user_interaction_entity.g.dart"
if (Test-Path $generatedFile) {
  Write-Host "✅ Arquivo .g.dart gerado!" -ForegroundColor Green
  $score += 15
}

# PASSO 6: Testar compilação
Write-Host "`n🧪 Testando compilação..." -ForegroundColor Yellow
$analyzeOutput = dart analyze --fatal-infos $entityFile 2>&1
$errorCount = ($analyzeOutput | Select-String "error •").Count

Write-Host "📊 Erros: $errorCount" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Red" })

if ($errorCount -eq 0) {
  Write-Host "✅ SEM ERROS! built_value funciona perfeitamente!" -ForegroundColor Green
  $score += 35
    
  # TESTE BÔNUS: Verificar funcionalidades
  Write-Host "`n🏆 Testando funcionalidades built_value..." -ForegroundColor Cyan
    
  # Verificar se copyWith existe (built_value gera rebuild())
  $genContent = Get-Content $generatedFile -Raw
  if ($genContent -match 'rebuild') {
    Write-Host "✅ rebuild() disponível (equivalente a copyWith)" -ForegroundColor Green
    $score += 5
  }
    
  if ($genContent -match 'operator ==') {
    Write-Host "✅ Equality (==) implementado" -ForegroundColor Green
    $score += 5
  }
    
  if ($genContent -match 'hashCode') {
    Write-Host "✅ hashCode implementado" -ForegroundColor Green
    $score += 5
  }
}

$testDuration = ((Get-Date) - $testStart).TotalSeconds

# RESULTADO FINAL
Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 RESULTADO TESTE 26" -ForegroundColor White
Write-Host "=" * 70

$result = @{
  test            = 26
  name            = "built_value - 1 Entidade"
  score           = $score
  max_score       = 115  # Com bônus
  errors          = $errorCount
  duration        = $testDuration
  success         = ($score -ge 70)
  files_generated = @($generatedFile)
  recommendation  = if ($score -ge 85) { 
    "✅ EXCELENTE! Migrar todas as entidades!" 
  }
  elseif ($score -ge 70) { 
    "✅ BOM! Solução viável" 
  }
  elseif ($score -ge 40) { 
    "⚠️ Funciona mas com problemas" 
  }
  else { 
    "❌ Não funcional" 
  }
}

Write-Host "🎯 Pontuação: $score/115" -ForegroundColor $(if ($score -ge 85) { "Green" } elseif ($score -ge 70) { "Yellow" } else { "Red" })
Write-Host "⏱️ Duração: $([math]::Round($testDuration, 1))s" -ForegroundColor Cyan
Write-Host "📋 Recomendação: $($result.recommendation)" -ForegroundColor $(if ($score -ge 85) { "Green" } elseif ($score -ge 70) { "Yellow" } else { "Red" })

# Salvar resultado
New-Item -Path "test_lab/results" -ItemType Directory -Force | Out-Null
$result | ConvertTo-Json | Set-Content "test_lab/results/test_26_result.json"

# PASSO 7: Restaurar original (ou manter se sucesso)
if ($score -ge 85) {
  Write-Host "`n✅ MANTENDO built_value (sucesso!)..." -ForegroundColor Green
  Write-Host "📝 Backup disponível: $entityFile.test26_backup" -ForegroundColor Cyan
}
else {
  Write-Host "`n↩️ Restaurando original..." -ForegroundColor Yellow
  Move-Item "$entityFile.test26_backup" $entityFile -Force
  Move-Item "pubspec.yaml.test26_backup" "pubspec.yaml" -Force
  flutter pub get | Out-Null
}

if ($score -ge 70) {
  exit 0
}
else {
  exit 1
}
