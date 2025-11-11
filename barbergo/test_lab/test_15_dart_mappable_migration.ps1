# 🧪 TESTE 15: Migração dart_mappable (user_interaction_entity)
# Hipótese: dart_mappable não tem o bug do Freezed

Write-Host "🧪 TESTE 15: Migração dart_mappable (menor entidade)" -ForegroundColor Cyan
Write-Host "=" * 60

$testStart = Get-Date
$entityFile = "lib/src/domain/entities/user_interaction_entity.dart"
$backupFile = "$entityFile.freezed_backup"

# PASSO 1: Backup do arquivo original
Write-Host "`n💾 Fazendo backup..." -ForegroundColor Yellow
Copy-Item $entityFile $backupFile -Force

# PASSO 2: Criar versão dart_mappable
Write-Host "📝 Convertendo para dart_mappable..." -ForegroundColor Yellow

$newContent = @"
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

import 'converters.dart';
import 'enums.dart';

part 'user_interaction_entity.mapper.dart';

@MappableClass()
class UserInteractionEntity with UserInteractionEntityMappable {
  final String vacancyId;
  final InteractionType type;
  
  @MappableField(hook: TimestampMappableHook())
  final DateTime timestamp;

  const UserInteractionEntity({
    required this.vacancyId,
    required this.type,
    required this.timestamp,
  });

  // dart_mappable gera automaticamente: fromJson, toJson, copyWith, ==, hashCode
}

// Hook customizado para Timestamp (Firestore)
class TimestampMappableHook extends MappingHook {
  const TimestampMappableHook();

  @override
  Object? beforeDecode(Object? value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    return value;
  }

  @override
  Object? beforeEncode(Object? value) {
    if (value is DateTime) {
      return Timestamp.fromDate(value);
    }
    return value;
  }
}
"@

Set-Content $entityFile $newContent -NoNewline

# PASSO 3: Remover arquivo .freezed.dart antigo
$freezedFile = "lib/src/domain/entities/user_interaction_entity.freezed.dart"
if (Test-Path $freezedFile) {
  Remove-Item $freezedFile -Force
  Write-Host "🗑️ Removido $freezedFile" -ForegroundColor Gray
}

# PASSO 4: Regenerar com dart_mappable
Write-Host "`n🔄 Regenerando código..." -ForegroundColor Yellow
$buildOutput = dart run build_runner build --delete-conflicting-outputs 2>&1

# PASSO 5: Verificar se .mapper.dart foi gerado
$mapperFile = "lib/src/domain/entities/user_interaction_entity.mapper.dart"
$mapperExists = Test-Path $mapperFile

# PASSO 6: Testar compilação
Write-Host "`n🔍 Testando compilação..." -ForegroundColor Yellow
$analyzeOutput = dart analyze --fatal-infos 2>&1 | Select-String "user_interaction_entity"
$hasErrors = $analyzeOutput | Select-String "error"

$testDuration = ((Get-Date) - $testStart).TotalSeconds

Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan

if ($mapperExists -and -not $hasErrors) {
  Write-Host "✅✅✅ SUCESSO! dart_mappable funciona! ✅✅✅" -ForegroundColor Green
  Write-Host "📄 Gerado: user_interaction_entity.mapper.dart" -ForegroundColor Cyan
  Write-Host "⏱️ Tempo: $([math]::Round($testDuration, 1))s" -ForegroundColor Yellow
  Write-Host "`n🎯 SOLUÇÃO ENCONTRADA: Migrar todas as 7 entidades para dart_mappable!" -ForegroundColor Green
  Write-Host "📋 Próximo passo: Aplicar em todas as entidades com bug" -ForegroundColor Yellow
    
  # Salvar resultado
  $result = @{
    success     = $true
    mapper_file = $mapperFile
    duration    = $testDuration
    backup      = $backupFile
  } | ConvertTo-Json
    
  Set-Content "test_lab/results/test_15_SUCCESS.json" $result
  exit 0
}
else {
  Write-Host "❌ FALHOU - dart_mappable também tem problemas" -ForegroundColor Red
  Write-Host "Erros:" -ForegroundColor Yellow
  $analyzeOutput | Select-Object -First 10
    
  # Restaurar backup
  Write-Host "`n↩️ Restaurando arquivo original..." -ForegroundColor Yellow
  Move-Item $backupFile $entityFile -Force
  exit 1
}
