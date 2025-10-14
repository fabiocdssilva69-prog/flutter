#!/bin/bash

# Script para executar o BarberGO no Perplexity Comet Browser

echo "🚀 Iniciando BarberGO no Perplexity Comet..."
echo ""

# Verifica se o Comet está instalado
COMET_PATHS=(
    "/Applications/Perplexity Comet.app/Contents/MacOS/Perplexity Comet"
    "$HOME/.local/share/perplexity/comet/comet"
    "/opt/perplexity-comet/comet"
)

COMET_FOUND=false
COMET_EXECUTABLE=""

for path in "${COMET_PATHS[@]}"; do
    if [ -f "$path" ]; then
        COMET_FOUND=true
        COMET_EXECUTABLE="$path"
        echo "✅ Perplexity Comet encontrado em: $path"
        break
    fi
done

if [ "$COMET_FOUND" = false ]; then
    echo "❌ Perplexity Comet não encontrado!"
    echo ""
    echo "📥 Para instalar o Perplexity Comet:"
    echo "   1. Visite: https://www.perplexity.ai/comet"
    echo "   2. Baixe e instale o navegador"
    echo "   3. Execute este script novamente"
    echo ""
    echo "🔄 Executando no Chrome como fallback..."
    flutter run -d chrome
    exit 1
fi

echo ""
echo "🔧 Configurando ambiente para Comet..."

# Define variáveis de ambiente
export FLUTTER_WEB_BROWSER="comet"
export CHROME_EXECUTABLE="$COMET_EXECUTABLE"

echo "✅ Variáveis de ambiente configuradas"
echo ""
echo "🚀 Lançando aplicação..."
echo ""

# Executa o Flutter com o Comet
flutter run -d chrome --web-browser-flag="--user-agent=PerplexityComet/1.0 Chrome/120.0.0.0"

echo ""
echo "✅ Aplicação encerrada"
