# Script para executar Biome via Docker
# Uso: .\run_biome_docker.ps1 [comando]
# Exemplos:
#   .\run_biome_docker.ps1 --version
#   .\run_biome_docker.ps1 check --write .
#   .\run_biome_docker.ps1 format --write .

param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$BiomeArgs
)

$BiomeVersion = "2.2.5"
$ImageTag = "ghcr.io/biomejs/biome:$BiomeVersion"

Write-Host "🔍 Verificando Docker..." -ForegroundColor Cyan

# Verifica se Docker está rodando
try {
  docker info | Out-Null
  Write-Host "✅ Docker está ativo" -ForegroundColor Green
}
catch {
  Write-Host "❌ Docker não está rodando!" -ForegroundColor Red
  Write-Host "Por favor, inicie o Docker Desktop e tente novamente." -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Alternativa: Use npm em vez de Docker:" -ForegroundColor Cyan
  Write-Host "  npm run check" -ForegroundColor White
  Write-Host "  npm run format" -ForegroundColor White
  exit 1
}

Write-Host "🐳 Executando Biome $BiomeVersion via Docker..." -ForegroundColor Cyan
Write-Host "Comando: biome $BiomeArgs" -ForegroundColor Gray
Write-Host ""

# Executa o Biome via Docker
docker run --rm `
  -v "${PWD}:/workspace" `
  -w /workspace `
  $ImageTag `
  $BiomeArgs

if ($LASTEXITCODE -eq 0) {
  Write-Host ""
  Write-Host "✅ Comando executado com sucesso!" -ForegroundColor Green
}
else {
  Write-Host ""
  Write-Host "❌ Comando falhou com código $LASTEXITCODE" -ForegroundColor Red
}
