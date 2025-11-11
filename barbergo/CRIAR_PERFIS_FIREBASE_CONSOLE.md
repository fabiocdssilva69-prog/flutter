# 🔥 Criar 10 Perfis no Firebase Console

## 📍 Acesse o Firebase Console

1. Vá em: <https://console.firebase.google.com/project/barbergo-38c21/firestore/data>
2. Clique na coleção **`profiles`**
3. Clique em **"Adicionar documento"** para cada perfil abaixo

---

## 👨‍💼 PERFIL 1: Carlos Silva (Barber Premium)

**ID do documento:** `barber_001`

**Campos:**

```
name: Carlos Silva
accountType: barber
isPremium: true
boostedUntil: 2025-11-09T18:30:00Z  (timestamp)
rating: 4.8  (number)
reviewCount: 127  (number)
bio: Especialista em cortes modernos e degradê
photoUrl: https://i.pravatar.cc/400?img=12

location (map):
  address: Av. Paulista, 1000 - Bela Vista, São Paulo - SP
  latitude: -23.5630  (number)
  longitude: -46.6565  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha

priceRange (map):
  min: 40  (number)
  max: 80  (number)

workingHours (map):
  monday: 09:00-19:00
  tuesday: 09:00-19:00
  wednesday: 09:00-19:00
  thursday: 09:00-19:00
  friday: 09:00-20:00
  saturday: 08:00-18:00
  sunday: Fechado

createdAt: 2024-11-02T18:30:00Z  (timestamp - 1 ano atrás)
updatedAt: 2025-11-02T16:30:00Z  (timestamp - 2 horas atrás)
```

---

## 👨‍💼 PERFIL 2: Rafael Costa (Barber)

**ID do documento:** `barber_002`

**Campos:**

```
name: Rafael Costa
accountType: barber
isPremium: false
rating: 4.6  (number)
reviewCount: 89  (number)
bio: Barbeiro tradicional, 10 anos de experiência
photoUrl: https://i.pravatar.cc/400?img=33

location (map):
  address: R. Augusta, 2500 - Jardins, São Paulo - SP
  latitude: -23.5580  (number)
  longitude: -46.6620  (number)

services (array):
  0: Corte
  1: Barba

priceRange (map):
  min: 35  (number)
  max: 60  (number)

workingHours (map):
  monday: 10:00-19:00
  tuesday: 10:00-19:00
  wednesday: 10:00-19:00
  thursday: 10:00-19:00
  friday: 10:00-20:00
  saturday: 09:00-17:00
  sunday: Fechado

createdAt: 2023-11-02T18:30:00Z  (timestamp - 2 anos atrás)
updatedAt: 2025-11-02T13:30:00Z  (timestamp - 5 horas atrás)
```

---

## 👨‍💼 PERFIL 3: Thiago Alves (Barber Premium)

**ID do documento:** `barber_003`

**Campos:**

```
name: Thiago Alves
accountType: barber
isPremium: true
boostedUntil: 2025-11-05T18:30:00Z  (timestamp - 3 dias)
rating: 4.9  (number)
reviewCount: 203  (number)
bio: Cortes estilosos e acabamento perfeito
photoUrl: https://i.pravatar.cc/400?img=51

location (map):
  address: Av. Faria Lima, 3000 - Itaim Bibi, São Paulo - SP
  latitude: -23.5750  (number)
  longitude: -46.6890  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha
  3: Pigmentação

priceRange (map):
  min: 50  (number)
  max: 100  (number)

workingHours (map):
  monday: 09:00-20:00
  tuesday: 09:00-20:00
  wednesday: 09:00-20:00
  thursday: 09:00-20:00
  friday: 09:00-21:00
  saturday: 08:00-19:00
  sunday: 10:00-16:00

createdAt: 2024-03-27T18:30:00Z  (timestamp - 540 dias atrás)
updatedAt: 2025-11-02T18:15:00Z  (timestamp - 15 min atrás)
```

---

## 🏢 PERFIL 4: Barbearia Classic (Premium)

**ID do documento:** `barbershop_001`

**Campos:**

```
name: Barbearia Classic
accountType: barbershop
isPremium: true
boostedUntil: 2025-11-17T18:30:00Z  (timestamp - 15 dias)
rating: 4.7  (number)
reviewCount: 312  (number)
bio: Barbearia tradicional desde 1985
photoUrl: https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400

location (map):
  address: R. da Consolação, 2000 - Consolação, São Paulo - SP
  latitude: -23.5540  (number)
  longitude: -46.6590  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha
  3: Massagem
  4: Hot Towel

priceRange (map):
  min: 45  (number)
  max: 120  (number)

workingHours (map):
  monday: Fechado
  tuesday: 10:00-20:00
  wednesday: 10:00-20:00
  thursday: 10:00-20:00
  friday: 10:00-21:00
  saturday: 09:00-20:00
  sunday: 10:00-18:00

createdAt: 2024-04-26T18:30:00Z  (timestamp - 600 dias atrás)
updatedAt: 2025-11-02T17:30:00Z  (timestamp - 1 hora atrás)
```

---

## 👨‍💼 PERFIL 5: Lucas Mendes (Barber Jovem)

**ID do documento:** `barber_004`

**Campos:**

```
name: Lucas Mendes
accountType: barber
isPremium: false
rating: 4.5  (number)
reviewCount: 45  (number)
bio: Jovem talento, especialista em fades
photoUrl: https://i.pravatar.cc/400?img=60

location (map):
  address: R. Oscar Freire, 1500 - Pinheiros, São Paulo - SP
  latitude: -23.5680  (number)
  longitude: -46.6710  (number)

services (array):
  0: Corte
  1: Barba
  2: Design

priceRange (map):
  min: 30  (number)
  max: 55  (number)

workingHours (map):
  monday: 11:00-20:00
  tuesday: 11:00-20:00
  wednesday: 11:00-20:00
  thursday: 11:00-20:00
  friday: 11:00-21:00
  saturday: 09:00-18:00
  sunday: Fechado

createdAt: 2025-10-03T18:30:00Z  (timestamp - 30 dias atrás)
updatedAt: 2025-11-02T10:30:00Z  (timestamp - 8 horas atrás)
```

---

## 🏢 PERFIL 6: Barbearia Premium (Top Premium)

**ID do documento:** `barbershop_002`

**Campos:**

```
name: Barbearia Premium
accountType: barbershop
isPremium: true
boostedUntil: 2025-12-02T18:30:00Z  (timestamp - 30 dias!)
rating: 4.9  (number)
reviewCount: 567  (number)
bio: Experiência premium em cortes masculinos
photoUrl: https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400

location (map):
  address: Av. Brigadeiro Faria Lima, 2000 - Jardim Paulistano, São Paulo - SP
  latitude: -23.5700  (number)
  longitude: -46.6850  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha
  3: Massagem
  4: Tratamento Capilar

priceRange (map):
  min: 80  (number)
  max: 200  (number)

workingHours (map):
  monday: 09:00-21:00
  tuesday: 09:00-21:00
  wednesday: 09:00-21:00
  thursday: 09:00-21:00
  friday: 09:00-22:00
  saturday: 08:00-20:00
  sunday: 10:00-18:00

createdAt: 2024-06-09T18:30:00Z  (timestamp - 450 dias atrás)
updatedAt: 2025-11-02T18:00:00Z  (timestamp - 30 min atrás)
```

---

## 👨‍💼 PERFIL 7: André Santos (Barber Criativo)

**ID do documento:** `barber_005`

**Campos:**

```
name: André Santos
accountType: barber
isPremium: false
rating: 4.7  (number)
reviewCount: 98  (number)
bio: Criatividade e estilo em cada corte
photoUrl: https://i.pravatar.cc/400?img=68

location (map):
  address: R. Haddock Lobo, 800 - Cerqueira César, São Paulo - SP
  latitude: -23.5615  (number)
  longitude: -46.6625  (number)

services (array):
  0: Corte
  1: Barba
  2: Coloração
  3: Platinado

priceRange (map):
  min: 40  (number)
  max: 90  (number)

workingHours (map):
  monday: 10:00-19:00
  tuesday: 10:00-19:00
  wednesday: 10:00-19:00
  thursday: 10:00-19:00
  friday: 10:00-20:00
  saturday: 09:00-17:00
  sunday: Fechado

createdAt: 2025-05-06T18:30:00Z  (timestamp - 180 dias atrás)
updatedAt: 2025-11-02T15:30:00Z  (timestamp - 3 horas atrás)
```

---

## 👨‍💼 PERFIL 8: Felipe Rodrigues (Especialista Afro)

**ID do documento:** `barber_006`

**Campos:**

```
name: Felipe Rodrigues
accountType: barber
isPremium: true
boostedUntil: 2025-11-07T18:30:00Z  (timestamp - 5 dias)
rating: 4.8  (number)
reviewCount: 156  (number)
bio: Especialista em cabelos afro e cacheados
photoUrl: https://i.pravatar.cc/400?img=15

location (map):
  address: Av. Ipiranga, 1000 - República, São Paulo - SP
  latitude: -23.5450  (number)
  longitude: -46.6430  (number)

services (array):
  0: Corte
  1: Barba
  2: Tratamento Afro
  3: Dreads

priceRange (map):
  min: 45  (number)
  max: 85  (number)

workingHours (map):
  monday: 10:00-20:00
  tuesday: 10:00-20:00
  wednesday: 10:00-20:00
  thursday: 10:00-20:00
  friday: 10:00-21:00
  saturday: 09:00-19:00
  sunday: 10:00-16:00

createdAt: 2025-02-05T18:30:00Z  (timestamp - 270 dias atrás)
updatedAt: 2025-11-02T14:30:00Z  (timestamp - 4 horas atrás)
```

---

## 🏢 PERFIL 9: The Barber House (Casual)

**ID do documento:** `barbershop_003`

**Campos:**

```
name: The Barber House
accountType: barbershop
isPremium: false
rating: 4.6  (number)
reviewCount: 234  (number)
bio: Ambiente descontraído, cortes de qualidade
photoUrl: https://images.unsplash.com/photo-1622286346003-c6e7c316c28a?w=400

location (map):
  address: R. Teodoro Sampaio, 2000 - Pinheiros, São Paulo - SP
  latitude: -23.5625  (number)
  longitude: -46.6780  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha

priceRange (map):
  min: 35  (number)
  max: 70  (number)

workingHours (map):
  monday: 10:00-20:00
  tuesday: 10:00-20:00
  wednesday: 10:00-20:00
  thursday: 10:00-20:00
  friday: 10:00-21:00
  saturday: 09:00-19:00
  sunday: Fechado

createdAt: 2024-08-08T18:30:00Z  (timestamp - 420 dias atrás)
updatedAt: 2025-11-02T12:30:00Z  (timestamp - 6 horas atrás)
```

---

## 👨‍💼 PERFIL 10: Marcelo Ferreira (Master Barber)

**ID do documento:** `barber_007`

**Campos:**

```
name: Marcelo Ferreira
accountType: barber
isPremium: true
boostedUntil: 2025-11-12T18:30:00Z  (timestamp - 10 dias)
rating: 4.9  (number)
reviewCount: 289  (number)
bio: Master barber, 15 anos transformando estilos
photoUrl: https://i.pravatar.cc/400?img=70

location (map):
  address: R. Estados Unidos, 1500 - Jardins, São Paulo - SP
  latitude: -23.5660  (number)
  longitude: -46.6750  (number)

services (array):
  0: Corte
  1: Barba
  2: Sobrancelha
  3: Massagem
  4: Tratamento

priceRange (map):
  min: 60  (number)
  max: 120  (number)

workingHours (map):
  monday: 09:00-20:00
  tuesday: 09:00-20:00
  wednesday: 09:00-20:00
  thursday: 09:00-20:00
  friday: 09:00-21:00
  saturday: 08:00-19:00
  sunday: 10:00-17:00

createdAt: 2024-01-07T18:30:00Z  (timestamp - 650 dias atrás)
updatedAt: 2025-11-02T17:45:00Z  (timestamp - 45 min atrás)
```

---

## ✅ Checklist de Criação

Marque conforme for criando:

- [ ] barber_001 - Carlos Silva (Premium, boosted 7 dias)
- [ ] barber_002 - Rafael Costa (Normal)
- [ ] barber_003 - Thiago Alves (Premium, boosted 3 dias)
- [ ] barbershop_001 - Barbearia Classic (Premium, boosted 15 dias)
- [ ] barber_004 - Lucas Mendes (Normal, jovem)
- [ ] barbershop_002 - Barbearia Premium (Premium, boosted 30 dias, top rated!)
- [ ] barber_005 - André Santos (Normal, criativo)
- [ ] barber_006 - Felipe Rodrigues (Premium, boosted 5 dias, afro specialist)
- [ ] barbershop_003 - The Barber House (Normal, casual)
- [ ] barber_007 - Marcelo Ferreira (Premium, boosted 10 dias, master barber)

---

## 🎯 Resultado Final

Você terá:

- ✅ **7 barbeiros** (5 premium, 2 normais)
- ✅ **3 barbearias** (2 premium, 1 normal)
- ✅ **6 perfis boosted** (aparecerão primeiro no Discovery)
- ✅ Mix de preços R$30-200
- ✅ Ratings 4.5-4.9 estrelas
- ✅ Reviews 45-567

## 🔄 Depois de Criar

1. Feche o app completamente
2. Abra novamente
3. Vá para **Discovery**
4. Você verá **7 barbeiros** (porque você é barbershop)
5. Os **6 boosted** aparecerão primeiro, depois os outros 4

---

## 💡 Dicas para Criar Mais Rápido

1. **Timestamp atual (now)**: Use `2025-11-02T18:30:00Z`
2. **Para calcular boostedUntil**:
   - 3 dias = `2025-11-05T18:30:00Z`
   - 7 dias = `2025-11-09T18:30:00Z`
   - 15 dias = `2025-11-17T18:30:00Z`
3. **Para campos MAP**: Clique em "Adicionar campo" dentro do campo pai
4. **Para campos ARRAY**: Clique em "Adicionar item" e numere sequencialmente

---

**Criado em**: 2 de novembro de 2025  
**Tempo estimado**: 15-20 minutos para criar todos os 10 perfis  
**Nível de dificuldade**: Médio (requer atenção aos tipos de dados)
