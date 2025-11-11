# BarberGO App

**O Tinder profissional para conectar Barbeiros a Barbearias** 💼✂️

> **Conceito Core**: Marketplace de RECRUTAMENTO que conecta barbeiros talentosos buscando emprego com barbearias procurando profissionais qualificados.

📖 **[Leia o conceito completo aqui](CORE_CONCEPT.md)**

## 🚀 Visão Geral

BarberGO é um **app de recrutamento profissional** (não um marketplace de serviços) que utiliza mecânica de swipe/match para conectar:
- 🏢 **Barbearias** criando vagas e buscando talentos
- ✂️ **Barbeiros** procurando oportunidades de emprego fixo

### Stack Tecnológica

BarberGO utiliza uma stack moderna para oferecer uma experiência fluida e inteligente:

- **Framework:** Flutter
- **Backend:** Firebase (Auth, Firestore, Cloud Messaging)
- **State Management:** Riverpod 2.x (com Generators)
- **Arquitetura:** Clean Architecture
- **IA:** Integração com OpenAI (GPT-4)

## 🛠️ Configuração do Ambiente de Desenvolvimento

### Pré-requisitos

1. Flutter SDK (Versão estável mais recente)
2. Dart SDK
3. Firebase CLI (para deploy de regras/índices)
4. IDE (VS Code recomendado)

### Passos para Execução

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/fabiocdssilva69-prog/barbergo-app.git
   cd barbergo-app
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure as Variáveis de Ambiente (`.env`):**
   
   Crie um arquivo `.env` na raiz do projeto (NÃO FAÇA COMMIT DESTE ARQUIVO). Certifique-se que o arquivo está listado na seção `assets` do `pubspec.yaml`.
   
   ```dotenv
   OPENAI_API_KEY=sk-proj-YOUR_OPENAI_KEY_HERE
   ```

4. **Configure o Firebase:**
   
   Certifique-se de que o arquivo `lib/firebase_options.dart` está presente e configurado para seu projeto Firebase (geralmente via `flutterfire configure`).

5. **Gere o Código (Riverpod/Freezed):**
   
   Este passo é crucial para gerar os provedores e modelos.
   
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Execute o aplicativo:**
   ```bash
   # Para Web
   flutter run -d chrome
   
   # Para Android (com emulador ou dispositivo conectado)
   flutter run
   ```

## 📂 Estrutura do Projeto

O projeto segue os princípios da Clean Architecture:

- `lib/src/core`: Serviços globais, Configuração, Tema, Roteamento
- `lib/src/data`: Repositórios e acesso a dados
- `lib/src/domain`: Entidades (Freezed), Enums e regras de negócio puras
- `lib/src/features`: Código organizado por funcionalidade (Auth, Profile, Discovery, Applications)

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
