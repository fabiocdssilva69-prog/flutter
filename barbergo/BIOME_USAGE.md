# 🎯 Biome - Guia Rápido de Uso

## 📊 Opções Disponíveis

### 1️⃣ Via npm (Recomendado - Mais Rápido)
```bash
npm run check    # Check completo
npm run format   # Apenas formatar
npm run lint     # Apenas lint
```

### 2️⃣ Via Docker (Mais Isolado)
```powershell
.\biome_check.ps1    # Check completo
.\biome_format.ps1   # Apenas formatar
.\biome_lint.ps1     # Apenas lint
```

### 3️⃣ Via Docker (Comando Genérico)
```powershell
.\run_biome_docker.ps1 check --write .
.\run_biome_docker.ps1 format --write .
.\run_biome_docker.ps1 lint --write .
```

### 4️⃣ Via npx (Sem Instalar)
```bash
npx @biomejs/biome check --write .
npx @biomejs/biome format --write .
npx @biomejs/biome lint --write .
```

## ⚡ Comparação de Performance

| Método | Velocidade | Uso de Memória | Requer |
|--------|------------|----------------|--------|
| npm    | ⚡⚡⚡ Rápido | 📦 Baixo | Node.js |
| npx    | ⚡⚡ Médio | 📦 Baixo | Node.js |
| Docker | ⚡ Lento | 📦📦 Alto | Docker Desktop |

## 🔧 Quando Usar Cada Método

### Use npm quando:
✅ Desenvolvimento local diário
✅ Performance é importante
✅ Já tem Node.js instalado
✅ CI/CD com cache de node_modules

### Use Docker quando:
✅ Ambiente isolado é necessário
✅ Múltiplos projetos com versões diferentes
✅ CI/CD com Docker já configurado
✅ Não quer instalar Node.js

### Use npx quando:
✅ Teste rápido sem instalar
✅ Scripts one-off
✅ Verificação de versão específica

## 📝 Exemplos Práticos

### Formatar apenas arquivos JSON
```bash
# npm
npx @biomejs/biome format --write "*.json"

# Docker
.\run_biome_docker.ps1 format --write "*.json"
```

### Check em subdiretório específico
```bash
# npm
npm run check web/

# Docker
.\biome_check.ps1 web/
```

### Ver diferenças sem aplicar (dry-run)
```bash
# npm
npx @biomejs/biome check .

# Docker
.\run_biome_docker.ps1 check .
```

## 🐳 Docker: Tags Disponíveis

```bash
ghcr.io/biomejs/biome:2.2.5   # Versão específica (recomendado)
ghcr.io/biomejs/biome:2.2     # Última patch da versão 2.2
ghcr.io/biomejs/biome:2       # Última minor/patch da versão 2
ghcr.io/biomejs/biome:latest  # Última versão (não recomendado)
```

## ⚠️ Status do Docker

Antes de usar Docker, verifique se está rodando:

```powershell
docker info
```

Se não estiver:
1. Abra Docker Desktop
2. Aguarde o ícone da baleia ficar verde
3. Execute o comando novamente

## 🎯 Recomendação

**Para este projeto (BarberGO):**
- **Dart**: Use `dart format lib/` (nativo do Flutter)
- **JSON/JS**: Use `npm run check` (Biome via npm)
- **CI/CD**: Use Docker para isolamento

**Biome NÃO formata Dart!** Use `dart format` para arquivos .dart
