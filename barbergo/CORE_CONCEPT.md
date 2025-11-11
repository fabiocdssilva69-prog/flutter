# 🎯 BarberGO - Core Business Concept

## O QUE É O BARBERGO?

**BarberGO é um marketplace de RECRUTAMENTO profissional** que conecta:
- 💼 **Barbearias** → buscando contratar barbeiros talentosos
- ✂️ **Barbeiros** → buscando vagas em barbearias estabelecidas

---

## 📱 COMPARAÇÃO COM TINDER

| Tinder | BarberGO |
|--------|----------|
| 👨 Homem busca 👩 Mulher | 🏢 Barbearia busca ✂️ Barbeiro |
| 👩 Mulher busca 👨 Homem | ✂️ Barbeiro busca 🏢 Vaga |
| ❤️ Match = Interesse mútuo | 🤝 Match = Fit profissional |
| 💬 Chat para marcar encontro | 💬 Chat para negociar contratação |
| 🎯 **Objetivo**: Relacionamento | 🎯 **Objetivo**: CONTRATAÇÃO |

---

## 🔄 FLUXO DO USUÁRIO

### Para BARBEIROS (buscando emprego):

```
1. Swipe em vagas de barbearias
2. Like = "Tenho interesse nesta vaga"
3. Match = Barbearia também curtiu seu perfil
4. Chat = Negociar salário, horários, benefícios
5. Application = Candidatura formal
6. Contratação ✅
```

### Para BARBEARIAS (buscando talentos):

```
1. Criar vaga (título, salário, requisitos)
2. Swipe em perfis de barbeiros
3. Like = "Quero entrevistar este profissional"
4. Match = Barbeiro também se interessou
5. Chat = Entrevistar, avaliar portfólio
6. Aceitar candidatura = Contratação ✅
```

---

## 🏗️ ARQUITETURA PRINCIPAL

### Entities Core:
- ✅ **ProfileEntity** (Barbeiro OU Barbearia)
- ✅ **VacancyEntity** (Vaga criada por Barbearia)
- ✅ **ApplicationEntity** (Candidatura de Barbeiro → Vaga)
- ✅ **MatchEntity** (Interesse mútuo)
- ✅ **SwipeEntity** (Like/Dislike)

### Controllers Core:
- ✅ **DiscoveryController** (mostrar vagas OU barbeiros dependendo do accountType)
- ✅ **ApplicationController** (gerenciar candidaturas)
- ✅ **ManagementController** (barbearia gerenciar vagas e candidatos)
- ✅ **SwipeController** (detectar matches)

### Screens Core:
- ✅ **SwipeScreen** (discovery dinâmico)
- ✅ **ProfileDetailScreen** (ver detalhes do profissional)
- ✅ **VacancyDetailScreen** (ver detalhes da vaga)
- ✅ **ManagementDashboard** (barbearia gerenciar candidaturas)
- ✅ **ChatScreen** (negociar contratação)

---

## ❌ O QUE NÃO É O BARBERGO

**NÃO É** um app de agendamento de serviços (tipo GetNinjas, Agendor)
- ❌ Cliente NÃO agenda corte de cabelo
- ❌ Barbeiro NÃO presta serviço direto ao cliente
- ❌ Não tem calendário de horários
- ❌ Não tem pagamento de serviços

**É** um app de recrutamento profissional (tipo LinkedIn Jobs, Indeed)
- ✅ Barbearia CONTRATA barbeiro
- ✅ Barbeiro PROCURA emprego fixo
- ✅ Match = oportunidade de trabalho
- ✅ Chat = processo seletivo

---

## 🗂️ FEATURES INATIVAS

### Phase 10 - Booking System (DESATIVADO)
Pasta: `lib/src/_inactive/booking/`

**Motivo**: Sistema de agendamento seria para marketplace B2C (cliente → barbeiro), mas nosso core é B2B (barbearia → barbeiro para contratação).

**Pode ser reativado no futuro** se houver pivô de modelo de negócio.

---

## 🚀 PRÓXIMAS PHASES (alinhadas ao core)

### Phase 11: Reviews & Ratings (AJUSTADO)
- ⭐ Barbearia avalia barbeiro contratado
- ⭐ Barbeiro avalia experiência na barbearia
- 📊 Rating influencia matches futuros

### Phase 12: Premium Features
- 🔥 Super Likes (destaque na fila)
- 👀 Ver quem deu like antes de decidir
- 📈 Boost (aparecer mais nas buscas)

### Phase 13: Analytics Dashboard
- 📊 Barbearia: quantas candidaturas recebeu, taxa de conversão
- 📊 Barbeiro: quantos matches, taxa de aceitação

---

## 💡 DIFERENCIAL COMPETITIVO

**Apps de Emprego Tradicionais** (LinkedIn, Indeed):
- ❌ Processo frio (enviar currículo e esperar)
- ❌ Sem conexão emocional
- ❌ Não mostra compatibilidade

**BarberGO**:
- ✅ Discovery dinâmico (swipe = engajamento)
- ✅ Portfólio visual (barbeiro mostra trabalho)
- ✅ Chat em tempo real (negociação rápida)
- ✅ Match score (algoritmo de compatibilidade)
- ✅ Gamificação (like/dislike é divertido)

---

## 🎯 RESUMO EM 1 FRASE

**"BarberGO é o Tinder para conectar barbeiros a barbearias, focado em CONTRATAÇÃO profissional, não em agendamento de serviços."**

---

**Última atualização**: 1 de Novembro de 2025
**Status**: Core concept definido ✅
**Próximo passo**: Melhorar UI de discovery de vagas + management dashboard
