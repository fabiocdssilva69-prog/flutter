# Como Adicionar Candidaturas de Teste

## Problema Identificado

A tela de detalhes da vaga fica em **loading infinito** porque:

1. Não existem candidaturas (applications) no Firestore
2. A tela espera carregar a lista de applications antes de renderizar

## Solução Rápida: Adicionar Candidatura de Teste

### Via Firebase Console

1. Acesse: <https://console.firebase.google.com/project/barbergo-38c21/firestore>

2. Crie uma nova collection chamada `applications` (se não existir)

3. Adicione um documento com os seguintes campos:

```json
{
  "applicationId": "app_test_001",
  "vacancyId": "vacancy_1760840099204",
  "barberId": "barber_test_001",
  "barbershopId": "6RYGS6HoEkhQgikNxUIkn7NpwmI3",
  "barbershopName": "NOBRUS BARBERSHOP",
  "status": "pending",
  "createdAt": [TIMESTAMP ATUAL],
  "updatedAt": [TIMESTAMP ATUAL]
}
```

**Importante:**

- Para `createdAt` e `updatedAt`, use o tipo **Timestamp** do Firestore
- Use o `vacancyId` de uma das suas vagas existentes

### Como Encontrar o vacancyId

1. No Firebase Console, vá em `vacancies`
2. Veja o ID do documento de uma vaga (ex: `vacancy_1760840099204`)
3. Use esse ID no campo `vacancyId` da application

## Índice Necessário

Se aparecer erro de índice faltando, o Firebase mostrará um link para criar automaticamente.

Ou crie manualmente em:
<https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes>

**Collection:** applications
**Fields:**

- `vacancyId` (Ascending)
- `createdAt` (Descending)

## Verificação

Após adicionar a candidatura:

1. Abra o app
2. Clique na vaga
3. Deve aparecer a candidatura ao invés do loading infinito

## Próximo Passo

Depois que isso funcionar, precisamos:

1. Implementar funcionalidade para barbeiros se candidatarem
2. Ou exibir mensagem "Nenhuma candidatura" imediatamente quando a lista estiver vazia
