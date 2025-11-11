# Testes de Serialização JSON
Write-Host "🧪 Testando serialização de entidades..." -ForegroundColor Cyan

$entities = Get-ChildItem -Path lib/src/domain/entities -Recurse -Filter *_entity.dart

$testsPassed = 0
$testsFailed = 0

foreach ($entity in $entities) {
    $entityName = [System.IO.Path]::GetFileNameWithoutExtension($entity.Name)
    Write-Host "`n  Testing $entityName..." -NoNewline
    
    # Verificar se tem fromJson e toJson
    $content = Get-Content $entity.FullName -Raw
    $hasFromJson = $content -match "fromJson\("
    $hasToJson = $content -match "toJson\(\)"
    
    if ($hasFromJson -and $hasToJson) {
        Write-Host " ✅ PASSOU" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host " ❌ FALHOU" -ForegroundColor Red
        $testsFailed++
    }
}

Write-Host "`n📊 Resultado: $testsPassed passaram, $testsFailed falharam" -ForegroundColor Cyan
