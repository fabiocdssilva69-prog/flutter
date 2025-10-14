# BarberGO

BarberGO é um aplicativo móvel desenhado para conectar barbeiros freelancers a barbearias que estão procurando profissionais para vagas como freelancer, CLT ou comissionado. O projeto utiliza o Flutter para criar aplicações multi‑plataforma a partir de um único código‑fonte:contentReference[oaicite:1]{index=1}. Adotamos os princípios da Clean Architecture, que promovem a separação de responsabilidades e visam criar bases de código modulares, escaláveis e testáveis:contentReference[oaicite:2]{index=2}. Para gerenciamento de estado usamos o Riverpod, um framework reativo de cache e data‑binding que suporta programação declarativa e a recomputação automática de chamadas de rede:contentReference[oaicite:3]{index=3}:contentReference[oaicite:4]{index=4}.

## Stack Tecnológica

- **Flutter + Dart** para UI e lógica de negócio, permitindo compilar aplicações nativas para várias plataformas a partir de um único código:contentReference[oaicite:5]{index=5}.
- **Firebase** (Auth, Cloud Firestore, Storage) para serviços de backend.
- **Riverpod** para gerenciamento de estado e injeção de dependências:contentReference[oaicite:6]{index=6}.
- **Clean Architecture** para organizar as camadas (presentation, domain, data) e facilitar testes e manutenção:contentReference[oaicite:7]{index=7}.
- **🤖 Integração IA Híbrida** (Gemini + GPT-4 + Claude):
  - **Gemini 1.5 Flash/Pro**: Geração de bio, análise de portfólio com Vision (GRÁTIS com Google One Ultra)
  - **GPT-4o**: Smart matching, análise de compatibilidade (Incluído no Pro $200/mês)
  - **Claude 3.5 Sonnet**: Geração de contratos CLT e documentos legais (~$5/mês)
- Bibliotecas adicionais: **go_router** para navegação, **freezed_annotation** e **json_annotation** para modelos imutáveis, **cached_network_image** para carregamento de imagens e **intl** para internacionalização.

## 🤖 Recursos de IA

O BarberGO possui integração avançada com 3 modelos de IA, escolhidos estrategicamente para máxima performance e custo-benefício:

### ✨ Funcionalidades
- **Geração Inteligente de Bio** - Gemini cria biografias profissionais em segundos
- **Smart Matching** - GPT-4 analisa compatibilidade barbeiro x vaga com score 0-100
- **Análise de Portfólio** - Vision AI detecta estilos, técnicas e qualidade dos cortes
- **Geração de Contratos** - Claude produz documentos CLT completos e em conformidade com LGPD
- **Orquestração Inteligente** - Sistema escolhe automaticamente o melhor modelo para cada tarefa

### 💰 Custo Total: ~$5/mês
- Gemini: **GRÁTIS** (Google One Ultra 30TB)
- GPT-4: **$0 adicional** (já incluído no Pro $200)
- Claude: **~$5/mês** (apenas para contratos)

📖 **[Documentação completa da integração IA](lib/src/features/ai/README.md)**

---

## Pré‑requisitos

Antes de começar, instale e configure:

- **Flutter SDK** e adicione ao PATH.
- **Firebase CLI** e **Node.js** (para as ferramentas do Firebase).
- **Git** para versionamento.
- Um editor de código como **Visual Studio Code**, com a extensão do Flutter instalada.
- **API Keys** (opcional, apenas se usar recursos de IA):
  - Gemini API Key (Google AI Studio)
  - OpenAI API Key (Platform OpenAI)
  - Anthropic API Key (Console Anthropic)

Siga a documentação oficial do Flutter para detalhes de instalação e configuração.
