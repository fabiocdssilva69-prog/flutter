# 🔗 Integração de Avaliações no ProfileDetailScreen

## 📝 Instruções de Implementação

### 1️⃣ **Adicionar no Header do Perfil**

**Localização:** Após o nome e informações básicas do perfil

```dart
// lib/src/features/profile/screens/profile_detail_screen.dart

// Adicionar import
import '../../ratings/widgets/rating_stars.dart';
import '../../ratings/screens/rating_screen.dart';
import '../../ratings/screens/ratings_list_screen.dart';

// No body do ProfileDetailScreen, adicionar seção de avaliações:

// Após nome, idade, localização...
if (profile.reviewCount > 0)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingStars(
          rating: profile.rating,
          size: 20,
          showRating: true,
          count: profile.reviewCount,
        ),
      ],
    ),
  ),

// Se não tem avaliações ainda
if (profile.reviewCount == 0)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      'Nenhuma avaliação ainda',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    ),
  ),
```

---

### 2️⃣ **Adicionar Botão "Avaliar"**

**Localização:** Abaixo das informações básicas, antes da bio

```dart
// Botão para avaliar o usuário
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(
          targetUserId: profile.userId,
          targetName: profile.name,
        ),
      ),
    );
  },
  icon: const Icon(Icons.star),
  label: const Text('Avaliar'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.amber,
    foregroundColor: Colors.white,
  ),
),
```

---

### 3️⃣ **Adicionar Seção "Avaliações"**

**Localização:** Após a bio e fotos do portfólio

```dart
// Seção de Avaliações
Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header da seção
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Avaliações',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (profile.reviewCount > 3)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingsListScreen(
                      userId: profile.userId,
                      userName: profile.name,
                    ),
                  ),
                );
              },
              child: const Text('Ver Todas'),
            ),
        ],
      ),

      const SizedBox(height: 12),

      // Stream das últimas 3 avaliações
      _buildRatingsPreview(profile.userId),
    ],
  ),
)
```

---

### 4️⃣ **Método para Exibir Preview das Avaliações**

**Adicionar no State da tela:**

```dart
Widget _buildRatingsPreview(String userId) {
  return StreamBuilder<List<RatingEntity>>(
    stream: ref.read(ratingRepositoryProvider).watchRatingsForUser(userId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Erro ao carregar avaliações',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      final ratings = snapshot.data ?? [];

      if (ratings.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(Icons.star_border, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Nenhuma avaliação ainda',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      // Mostrar apenas as 3 primeiras
      final previewRatings = ratings.take(3).toList();

      return Column(
        children: [
          for (final rating in previewRatings)
            _buildRatingCard(rating),
          
          // Se tem mais que 3, mostrar botão "Ver Todas"
          if (ratings.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatingsListScreen(
                        userId: userId,
                        userName: profile.name,
                      ),
                    ),
                  );
                },
                child: Text('Ver todas as ${ratings.length} avaliações'),
              ),
            ),
        ],
      );
    },
  );
}

Widget _buildRatingCard(RatingEntity rating) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com estrelas e data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingStars(
                rating: rating.stars.toDouble(),
                size: 16,
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(rating.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          // Comentário
          if (rating.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rating.comment,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Nome do avaliador (buscar profile)
          const SizedBox(height: 4),
          FutureBuilder<ProfileEntity?>(
            future: ref.read(profileRepositoryProvider).getProfile(rating.fromUserId),
            builder: (context, snapshot) {
              final raterProfile = snapshot.data;
              return Text(
                raterProfile?.name ?? 'Usuário',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
```

---

### 5️⃣ **Adicionar Imports Necessários**

```dart
import 'package:intl/intl.dart';
import '../../ratings/widgets/rating_stars.dart';
import '../../ratings/screens/rating_screen.dart';
import '../../ratings/screens/ratings_list_screen.dart';
import '../../../domain/entities/rating_entity.dart';
import '../../../data/repositories/rating_repository.dart';
```

---

## 🎨 Exemplo Visual

### **Header do Perfil:**
```
╔════════════════════════════════╗
║      [Avatar]                  ║
║      João Silva, 28            ║
║      Barbeiro                  ║
║      ⭐⭐⭐⭐☆ 4.5 (42)         ║  ← RatingStars
║                                ║
║      [⭐ Avaliar]              ║  ← Botão
╚════════════════════════════════╝
```

### **Seção de Avaliações:**
```
╔════════════════════════════════╗
║  Avaliações     [Ver Todas →]  ║
║                                ║
║  ┌──────────────────────────┐ ║
║  │ ⭐⭐⭐⭐⭐  10/01/2025    │ ║
║  │ Excelente profissional!  │ ║
║  │ por Maria Santos         │ ║
║  └──────────────────────────┘ ║
║                                ║
║  ┌──────────────────────────┐ ║
║  │ ⭐⭐⭐⭐☆  08/01/2025    │ ║
║  │ Muito bom, recomendo!    │ ║
║  │ por Carlos Lima          │ ║
║  └──────────────────────────┘ ║
║                                ║
║  ┌──────────────────────────┐ ║
║  │ ⭐⭐⭐⭐⭐  05/01/2025    │ ║
║  │ Perfeito!                │ ║
║  │ por Ana Costa            │ ║
║  └──────────────────────────┘ ║
║                                ║
║  [Ver todas as 42 avaliações]  ║  ← Se tem mais
╚════════════════════════════════╝
```

---

## ✅ Checklist de Implementação

- [ ] Adicionar imports necessários
- [ ] Adicionar RatingStars no header do perfil
- [ ] Adicionar botão "Avaliar"
- [ ] Criar seção "Avaliações"
- [ ] Implementar `_buildRatingsPreview()` com Stream
- [ ] Implementar `_buildRatingCard()` para cards
- [ ] Testar navegação para RatingScreen
- [ ] Testar navegação para RatingsListScreen
- [ ] Verificar atualização em tempo real (streams)
- [ ] Testar empty state (sem avaliações)

---

## 🧪 Como Testar

1. **Navegar para ProfileDetailScreen de um perfil**
2. **Verificar header:** Deve mostrar RatingStars se tiver avaliações
3. **Clicar em "Avaliar":** Deve abrir RatingScreen
4. **Criar avaliação:** Selecionar estrelas, escrever comentário, enviar
5. **Voltar para ProfileDetailScreen:** Deve mostrar nova avaliação na seção
6. **Verificar atualização automática:** Avaliação aparece sem recarregar tela
7. **Clicar em "Ver Todas":** Deve abrir RatingsListScreen
8. **Testar com perfil sem avaliações:** Deve mostrar empty state

---

## 🎯 Resultado Esperado

✅ Perfis exibem avaliações de forma clara e elegante  
✅ Usuários podem avaliar facilmente (1 clique)  
✅ Preview mostra últimas 3 avaliações  
✅ Atualização em tempo real via Stream  
✅ Navegação fluida entre telas  

---

**Próximo passo após integração:** Criar Cloud Functions para atualizar automaticamente os campos `rating` e `reviewCount` no perfil quando uma avaliação é criada/atualizada/deletada.
