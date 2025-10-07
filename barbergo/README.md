# BarberGO

BarberGO é um aplicativo móvel desenhado para conectar barbeiros freelancers a barbearias que estão procurando profissionais para vagas como freelancer, CLT ou comissionado. O projeto utiliza o Flutter para criar aplicações multi‑plataforma a partir de um único código‑fonte:contentReference[oaicite:1]{index=1}. Adotamos os princípios da Clean Architecture, que promovem a separação de responsabilidades e visam criar bases de código modulares, escaláveis e testáveis:contentReference[oaicite:2]{index=2}. Para gerenciamento de estado usamos o Riverpod, um framework reativo de cache e data‑binding que suporta programação declarativa e a recomputação automática de chamadas de rede:contentReference[oaicite:3]{index=3}:contentReference[oaicite:4]{index=4}.

## Stack Tecnológica

- **Flutter + Dart** para UI e lógica de negócio, permitindo compilar aplicações nativas para várias plataformas a partir de um único código:contentReference[oaicite:5]{index=5}.
- **Firebase** (Auth, Cloud Firestore, Storage) para serviços de backend.
- **Riverpod** para gerenciamento de estado e injeção de dependências:contentReference[oaicite:6]{index=6}.
- **Clean Architecture** para organizar as camadas (presentation, domain, data) e facilitar testes e manutenção:contentReference[oaicite:7]{index=7}.
- Bibliotecas adicionais: **go_router** para navegação, **freezed_annotation** e **json_annotation** para modelos imutáveis, **cached_network_image** para carregamento de imagens e **intl** para internacionalização.

## Pré‑requisitos

Antes de começar, instale e configure:

- **Flutter SDK** e adicione ao PATH.
- **Firebase CLI** e **Node.js** (para as ferramentas do Firebase).
- **Git** para versionamento.
- Um editor de código como **Visual Studio Code**, com a extensão do Flutter instalada.

Siga a documentação oficial do Flutter para detalhes de instalação e configuração.
