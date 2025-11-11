# Gerador Automático de Índices Firestore
Write-Host "🔍 Analisando queries no código..." -ForegroundColor Cyan

$queries = @()
Get-ChildItem -Path lib -Recurse -Filter *.dart | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    # Detectar queries com orderBy, where múltiplos
    if ($content -match 'orderBy\(' -and $content -match 'where\(') {
        $queries += @{
            file = $_.Name
            needsIndex = $true
        }
    }
}

Write-Host "📊 Queries que precisam de índices: $($queries.Count)" -ForegroundColor Yellow

# Criar arquivo de índices sugeridos
$indexConfig = @"
{
  "indexes": [
    {
      "collectionGroup": "vacancies",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isActive", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "applications",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "barberId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "appliedAt", "order": "DESCENDING" }
      ]
    }
  ]
}
"@
$indexConfig | Out-File -FilePath "firestore-indexes-suggested.json" -Encoding UTF8 -Force
Write-Host "✅ Índices sugeridos salvos: firestore-indexes-suggested.json" -ForegroundColor Green
Write-Host "💡 Deploy com: firebase deploy --only firestore:indexes" -ForegroundColor Cyan
