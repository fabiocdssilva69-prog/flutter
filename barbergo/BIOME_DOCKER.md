# 🐳 Biome via Docker

Este projeto inclui scripts para executar o Biome via Docker, útil para ambientes onde você não quer instalar dependências npm globalmente.

## 📋 Pré-requisitos

- **Docker Desktop** instalado e **rodando**
- Windows com PowerShell

## 🚀 Como Usar

### Opção 1: Script Genérico

Execute qualquer comando Biome via Docker:

```powershell
.\run_biome_docker.ps1 --version
.\run_biome_docker.ps1 check --write .
.\run_biome_docker.ps1 format --write lib/
.\run_biome_docker.ps1 lint --write .
```

### Opção 2: Scripts Específicos

Use scripts dedicados para tarefas comuns:

```powershell
# Formatar arquivos
.\biome_format.ps1 .
.\biome_format.ps1 lib/

# Lint
.\biome_lint.ps1 .
.\biome_lint.ps1 src/

# Check completo (format + lint)
.\biome_check.ps1 .
.\biome_check.ps1 web/
```

## 🎯 Versões Disponíveis

O Biome Docker usa tags semânticas:

```powershell
# Versão específica (recomendado para produção)
ghcr.io/biomejs/biome:2.2.5

# Versão minor (recebe patches automaticamente)
ghcr.io/biomejs/biome:2.2

# Versão major (recebe minor/patch automaticamente)
ghcr.io/biomejs/biome:2

# Última versão (não recomendado para produção)
ghcr.io/biomejs/biome:latest
```

Para mudar a versão, edite os scripts `.ps1` e altere a linha:

```powershell
$ImageTag = "ghcr.io/biomejs/biome:2.2.5"
```

## 🆚 Docker vs npm

| Característica | Docker | npm |
|----------------|--------|-----|
| **Instalação** | Requer Docker Desktop | `npm install` |
| **Velocidade** | Mais lento (overhead do container) | Mais rápido |
| **Isolamento** | Total (não afeta sistema) | Instala em node_modules |
| **Tamanho** | ~50MB (imagem Docker) | ~15MB (pacote npm) |
| **Portabilidade** | Funciona em qualquer OS com Docker | Requer Node.js |
| **Uso** | `.\run_biome_docker.ps1` | `npm run check` |

## ⚠️ Troubleshooting

### Erro: "Docker não está rodando"

```powershell
# Solução 1: Inicie o Docker Desktop
# Procure "Docker Desktop" no menu Iniciar e execute

# Solução 2: Use npm em vez de Docker
npm run check
npm run format
npm run lint
```

### Erro: "The system cannot find the file specified"

O Docker Desktop não está instalado ou o serviço não está ativo.

**Instalação do Docker Desktop:**
1. Baixe em: https://www.docker.com/products/docker-desktop
2. Instale e reinicie o Windows
3. Inicie o Docker Desktop
4. Aguarde o ícone da baleia ficar verde

### Erro: Permissões no Windows

Execute o PowerShell como Administrador:

```powershell
# Permite execução de scripts PowerShell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📦 Alternativa: npm (Recomendado)

Se o Docker estiver causando problemas, use npm:

```bash
# Instalar Biome via npm (já configurado)
npm install

# Usar comandos npm (mais rápido)
npm run check   # Check completo
npm run format  # Apenas formatar
npm run lint    # Apenas lint
```

## 🔧 Configuração

O Biome está configurado via:
- **biome.json**: Regras de formatação e lint
- **.biomeignore**: Arquivos/pastas ignorados

Os scripts Docker montam o diretório atual como `/workspace` no container, então o Biome processa os arquivos locais.

## 📚 Documentação

- **Biome Docs**: https://biomejs.dev
- **Docker Hub**: https://github.com/biomejs/biome/pkgs/container/biome
- **GitHub**: https://github.com/biomejs/biome

## 🎯 Comandos Úteis

```powershell
# Ver versão
.\run_biome_docker.ps1 --version

# Ver ajuda
.\run_biome_docker.ps1 --help

# Check sem aplicar mudanças (dry-run)
.\run_biome_docker.ps1 check .

# Format específico para JSON
.\run_biome_docker.ps1 format --write "*.json"

# Lint com configuração customizada
.\run_biome_docker.ps1 lint --config-path=./custom-biome.json .
```

## 🏷️ Scripts Criados

- **run_biome_docker.ps1**: Script genérico com validação de Docker
- **biome_format.ps1**: Atalho para formatação
- **biome_lint.ps1**: Atalho para lint
- **biome_check.ps1**: Atalho para check completo

Todos os scripts verificam se o Docker está rodando antes de executar.
