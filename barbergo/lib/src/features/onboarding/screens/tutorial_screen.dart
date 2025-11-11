import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/tutorial_provider.dart';

/// Tela de Tutorial do BarberGO (Onboarding)
///
/// Exibe 4 páginas introdutórias:
/// 1. Encontre Profissionais
/// 2. Dê Match e Converse
/// 3. Agende Serviços
/// 4. Seja Premium
///
/// Salva preferência local quando concluído (não exibe novamente)
class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 TUTORIAL: initState - Tutorial screen inicializada');
    debugPrint('🚀 TUTORIAL: Total de páginas: ${_pages.length}');
  }

  final List<TutorialPage> _pages = const [
    TutorialPage(
      icon: Icons.search,
      iconColor: Colors.blue,
      title: 'Encontre Profissionais',
      description: 'Descubra barbeiros qualificados ou barbearias próximas de você. Use o swipe para curtir perfis!',
    ),
    TutorialPage(
      icon: Icons.favorite,
      iconColor: Colors.red,
      title: 'Dê Match e Converse',
      description:
          'Quando ambos curtirem, é match! Inicie conversas, tire dúvidas e agende horários diretamente no chat.',
    ),
    TutorialPage(
      icon: Icons.calendar_today,
      iconColor: Colors.green,
      title: 'Agende Serviços',
      description: 'Barbeiros podem se candidatar a vagas. Barbearias podem publicar oportunidades de trabalho.',
    ),
    TutorialPage(
      icon: Icons.workspace_premium,
      iconColor: Colors.amber,
      title: 'Seja Premium',
      description: 'Ganhe Super Likes ilimitados, veja quem curtiu você, destaque seu perfil com Boost e muito mais!',
    ),
  ];

  void _onPageChanged(int page) {
    debugPrint('📖 TUTORIAL: Página alterada de $_currentPage para $page');
    setState(() {
      _currentPage = page;
    });
    debugPrint('📖 TUTORIAL: Estado atualizado - página atual: $_currentPage');
  }

  Future<void> _completeTutorial() async {
    debugPrint('✅ TUTORIAL: Iniciando conclusão do tutorial...');
    debugPrint('✅ TUTORIAL: Mounted: $mounted');

    try {
      final prefs = await SharedPreferences.getInstance();
      debugPrint('✅ TUTORIAL: SharedPreferences obtido');

      final result = await prefs.setBool('tutorial_completed', true);
      debugPrint('✅ TUTORIAL: tutorial_completed salvo = $result');

      // Verifica se realmente salvou
      final saved = prefs.getBool('tutorial_completed');
      debugPrint('✅ TUTORIAL: Verificação: tutorial_completed = $saved');

      // CRÍTICO: Invalida o provider para forçar reload do valor
      debugPrint('♻️ TUTORIAL: Invalidando tutorialCompletedProvider');
      ref.invalidate(tutorialCompletedProvider);
      debugPrint('♻️ TUTORIAL: Provider invalidado com sucesso');

      // Aguarda um frame para o provider atualizar
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) {
        debugPrint('❌ TUTORIAL: Widget não está montado, cancelando navegação');
        return;
      }

      // ✅ IMPORTANTE: NÃO navegamos manualmente!
      // O GoRouter redirect detectará que tutorial_completed = true
      // e redirecionará automaticamente para a tela correta:
      // - Se perfil existe: vai para /home
      // - Se perfil não existe: vai para /onboarding
      debugPrint('✅ TUTORIAL: Tutorial concluído! GoRouter fará o redirect automático');

      // Força uma reconstrução do router para aplicar o novo estado
      if (mounted) {
        debugPrint('✅ TUTORIAL: Forçando rebuild do GoRouter');
        // O invalidate do provider já foi feito acima, só esperamos o rebuild
      }
    } catch (e, stackTrace) {
      debugPrint('❌ TUTORIAL ERROR: Erro ao completar tutorial: $e');
      debugPrint('❌ TUTORIAL ERROR: Stack trace: $stackTrace');
    }
  }

  void _skipTutorial() {
    debugPrint('⏩ TUTORIAL: Botão PULAR pressionado');
    debugPrint('⏩ TUTORIAL: Página atual: $_currentPage, Total de páginas: ${_pages.length}');
    debugPrint('⏩ TUTORIAL: Animando para última página (${_pages.length - 1})');

    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    debugPrint('⏩ TUTORIAL: Animação iniciada');
  }

  void _nextPage() {
    debugPrint('▶️ TUTORIAL: Botão CONTINUAR/COMEÇAR pressionado');
    debugPrint('▶️ TUTORIAL: Página atual: $_currentPage, Total de páginas: ${_pages.length}');

    if (_currentPage < _pages.length - 1) {
      debugPrint('▶️ TUTORIAL: Avançando para próxima página');
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      debugPrint('▶️ TUTORIAL: Comando nextPage() executado');
    } else {
      debugPrint('🏁 TUTORIAL: Última página alcançada, completando tutorial');
      _completeTutorial();
    }
  }

  @override
  void dispose() {
    debugPrint('🗑️ TUTORIAL: Disposing PageController');
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 TUTORIAL: Build executado - página atual: $_currentPage');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Botão Pular (top-right)
            if (_currentPage < _pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    debugPrint('👆 TUTORIAL: Toque no botão PULAR detectado');
                    _skipTutorial();
                  },
                  child: Text('Pular', style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
                ),
              ),

            // PageView com as 4 páginas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Indicador de páginas (dots)
            _buildPageIndicator(),

            const SizedBox(height: 20),

            // Botão Continuar/Começar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint(
                      '👆 TUTORIAL: Toque no botão ${_currentPage < _pages.length - 1 ? "CONTINUAR" : "COMEÇAR"} detectado',
                    );
                    _nextPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Continuar' : 'Começar',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone
          Icon(page.icon, size: 120, color: page.iconColor),

          const SizedBox(height: 40),

          // Título
          Text(
            page.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Descrição
          Text(
            page.description,
            style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Modelo de dados para cada página do tutorial
class TutorialPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const TutorialPage({required this.icon, required this.iconColor, required this.title, required this.description});
}
