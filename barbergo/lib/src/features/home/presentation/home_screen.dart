import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../domain/entities/enums.dart';
import '../../discovery/controllers/application_controller.dart';
import '../../discovery/controllers/discovery_controller.dart';
import '../../discovery/widgets/vacancy_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final accountType = ref.watch(currentAccountTypeProvider);

    if (accountType == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = _getScreensForAccountType(accountType);
    final navItems = _getNavItemsForAccountType(accountType);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        items: navItems,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ai-test'),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.smart_toy),
        label: const Text('Testar IA'),
      ),
    );
  }

  List<Widget> _getScreensForAccountType(AccountType accountType) {
    if (accountType == AccountType.barber) {
      return const [
        _BarberDiscoveryView(),
        _BarberApplicationsView(),
        _BarberProfileView(),
      ];
    } else {
      return const [_BarbershopVacanciesView(), _BarbershopSettingsView()];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsForAccountType(
    AccountType accountType,
  ) {
    if (accountType == AccountType.barber) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Descobrir'),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Candidaturas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ];
    } else {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Vagas'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
      ];
    }
  }
}

// ==================== BARBER VIEWS ====================

class _BarberDiscoveryView extends ConsumerWidget {
  const _BarberDiscoveryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacanciesAsync = ref.watch(activeVacanciesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Descobrir Vagas'), centerTitle: true),
      body: vacanciesAsync.when(
        data: (vacancies) {
          if (vacancies.isEmpty) {
            return const Center(
              child: Text('Nenhuma vaga disponível no momento'),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CardSwiper(
                cardsCount: vacancies.length,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                      return VacancyCard(vacancy: vacancies[index]);
                    },
                onSwipe: (previousIndex, currentIndex, direction) async {
                  // Swipe para a direita = candidatar
                  if (direction == CardSwiperDirection.right) {
                    final vacancy = vacancies[previousIndex];
                    try {
                      await ref
                          .read(applicationControllerProvider.notifier)
                          .applyForVacancy(vacancy);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Candidatura enviada com sucesso!'),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erro: $error')));
                      }
                    }
                  }
                  return true;
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Erro ao carregar vagas: $error')),
      ),
    );
  }
}

class _BarberApplicationsView extends StatelessWidget {
  const _BarberApplicationsView();

  @override
  Widget build(BuildContext context) {
    // Importa a view real do barber
    return const Center(
      child: Text('Candidaturas placeholder - integrar com MyApplicationsView'),
    );
  }
}

class _BarberProfileView extends StatelessWidget {
  const _BarberProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: const Center(child: Text('Perfil do barbeiro (Em breve)')),
    );
  }
}

// ==================== BARBERSHOP VIEWS ====================

class _BarbershopVacanciesView extends StatelessWidget {
  const _BarbershopVacanciesView();

  @override
  Widget build(BuildContext context) {
    // Importa a view real de vagas
    return const Center(
      child: Text('Vagas placeholder - integrar com MyVacanciesView'),
    );
  }
}

class _BarbershopSettingsView extends StatelessWidget {
  const _BarbershopSettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: const Center(child: Text('Configurações (Em breve)')),
    );
  }
}
