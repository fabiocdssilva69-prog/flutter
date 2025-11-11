import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/services/geolocation_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/media_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/portfolio_grid.dart';
import '../widgets/user_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  // Parâmetro que define se a tela está em modo Onboarding
  final bool isOnboarding;
  // AccountType é necessário se for Onboarding e o perfil ainda não existir
  final AccountType? initialAccountType;

  const ProfileScreen({super.key, this.isOnboarding = false, this.initialAccountType});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  AccountType? _selectedAccountType;
  bool _isInitialized = false;

  // NOVO: Variáveis de estado para Geolocalização
  Position? _currentPosition;
  bool _isFetchingLocation = false;
  int _searchRadiusKm = 25;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Inicializa os campos do formulário com os dados existentes do perfil
  void _initializeForm(ProfileEntity? profile) {
    if (_isInitialized) return;

    if (profile != null) {
      _nameController.text = profile.name;
      _bioController.text = profile.bio;
      _locationController.text = profile.location;
      _phoneController.text = profile.contactPhone;
      _selectedAccountType = profile.accountType;
      // NOVO: Inicializa o raio
      _searchRadiusKm = profile.searchRadiusKm;
    } else if (widget.initialAccountType != null) {
      // Se não houver perfil (Onboarding), usa o tipo inicial passado
      _selectedAccountType = widget.initialAccountType;
    }
    _isInitialized = true;
  }

  // NOVO: Captura a localização atual via GPS
  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      final position = await ref.read(geolocationServiceProvider).getCurrentPosition();
      if (position != null && mounted) {
        setState(() {
          _currentPosition = position;
          _locationController.text =
              "Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}";
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao capturar localização: $e")));
      }
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_selectedAccountType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.fieldRequired)));
      return;
    }

    if (_formKey.currentState!.validate()) {
      // NOVO: Valida se o usuário tem preciseLocation
      final existingProfile = ref.read(currentUserProfileProvider).value;
      if (existingProfile?.preciseLocation == null && _currentPosition == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Por favor, capture sua localização (GPS) antes de salvar.")));
        return;
      }

      final success = await ref
          .read(profileControllerProvider.notifier)
          .saveProfile(
            name: _nameController.text,
            bio: _bioController.text,
            location: _locationController.text,
            contactPhone: _phoneController.text,
            accountType: _selectedAccountType!,
            newPosition: _currentPosition, // NOVO
            newSearchRadiusKm: _searchRadiusKm, // NOVO
          );

      if (success && mounted) {
        setState(() => _currentPosition = null); // Reset após salvar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.profileSavedSuccess)));
        // Se for Onboarding, a navegação será tratada automaticamente pelo Router (após a atualização do Stream).
        // Se for Edição normal (não onboarding), não fazemos nada extra, pois o usuário já está na aba de perfil.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa o perfil atual para preencher o formulário
    final profileAsync = ref.watch(currentUserProfileProvider);

    // Listener para erros na ação de salvar
    ref.listen<AsyncValue>(profileControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    // NOVO: Listener para erros no MediaController
    ref.listen<AsyncValue>(mediaControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    // Estado de loading da ação de salvar
    final isSaving = ref.watch(profileControllerProvider).isLoading;

    // Se for Onboarding, envolvemos em Scaffold com AppBar. Se não, apenas o corpo.
    Widget content = profileAsync.when(
      data: (profile) {
        _initializeForm(profile);
        return _buildForm(isSaving, profile);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Erro ao carregar perfil: $e")),
    );

    if (widget.isOnboarding) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.onboardingScreenTitle),
          // Impede o usuário de voltar durante o Onboarding
          automaticallyImplyLeading: false,
        ),
        body: content,
      );
    }

    // Modo de visualização/edição padrão (dentro da navegação principal)
    return Scaffold(body: content);
  }

  Widget _buildForm(bool isSaving, ProfileEntity? profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: AbsorbPointer(
          // Bloqueia a UI durante o salvamento
          absorbing: isSaving,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSaving) const LinearProgressIndicator(),

              // Se não for onboarding, mostramos o cabeçalho de perfil e o botão de logout
              if (!widget.isOnboarding) _buildProfileHeader(profile),

              // Tipo de Conta (Dropdown)
              DropdownButtonFormField<AccountType>(
                decoration: InputDecoration(labelText: context.l10n.accountType, border: const OutlineInputBorder()),
                initialValue: _selectedAccountType,
                items: AccountType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type == AccountType.barber ? context.l10n.barber : context.l10n.barbershop),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedAccountType = value),
                validator: (v) => v == null ? context.l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),

              // Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: context.l10n.nameLabel, border: const OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? context.l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),

              // NOVO: Localização com botão GPS
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: context.l10n.locationLabel,
                        helperText: "Use o botão GPS para precisão.",
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? "Informe ou capture sua localização" : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: _isFetchingLocation
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.gps_fixed),
                    onPressed: _isFetchingLocation ? null : _fetchLocation,
                    tooltip: "Capturar Localização Atual",
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: context.l10n.phoneLabel, border: const OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.length < 8) ? context.l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),

              // Biografia
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: context.l10n.bioLabel,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (v) => (v == null || v.length < 10) ? context.l10n.fieldRequired : null,
              ),
              const SizedBox(height: 16),

              // NOVO: Slider de Raio (somente para barbeiros)
              if (_selectedAccountType == AccountType.barber) ...[
                const Divider(height: 32),
                Text("Preferências de Busca", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text("Distância máxima para encontrar vagas: $_searchRadiusKm KM"),
                Slider(
                  value: _searchRadiusKm.toDouble(),
                  min: 5,
                  max: 100,
                  divisions: 19,
                  label: "$_searchRadiusKm KM",
                  onChanged: isSaving ? null : (value) => setState(() => _searchRadiusKm = value.toInt()),
                ),
                const SizedBox(height: 16),
              ],

              // Botão de Salvar
              ElevatedButton(
                onPressed: isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
                child: Text(
                  widget.isOnboarding ? context.l10n.completeRegistrationButton : context.l10n.saveChangesButton,
                ),
              ),

              // NOVO: Seção de Portfólio
              const SizedBox(height: 32),
              const Divider(height: 32),
              Text("Portfólio (Máx 6 fotos)", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final currentUrls = ref.watch(currentUserProfileProvider).value?.portfolioUrls ?? [];
                  return PortfolioGrid(imageUrls: currentUrls, isEditing: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity? profile) {
    final isMediaLoading = ref.watch(mediaControllerProvider).isLoading;

    return Column(
      children: [
        // Avatar com botão de edição
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            UserAvatar(imageUrl: profile?.avatarUrl, radius: 50),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.3))],
              ),
              child: IconButton(
                icon: isMediaLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.camera_alt, color: AppColors.primary, size: 20),
                onPressed: isMediaLoading
                    ? null
                    : () async {
                        await ref.read(mediaControllerProvider.notifier).uploadImage(true);
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(context.l10n.profileScreenTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        // Botão de Logout
        Center(
          child: TextButton.icon(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout, color: Colors.red),
            label: Text(context.l10n.logout, style: const TextStyle(color: Colors.red)),
          ),
        ),
        const Divider(height: 32),
      ],
    );
  }
}
