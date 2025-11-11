import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../controllers/profile_controller.dart';
import '../widgets/price_range_editor.dart';
import '../widgets/services_editor.dart';
import '../widgets/working_hours_editor.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileEntity profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();

  final List<XFile> _newPhotos = [];
  List<String> _services = [];
  Map<String, String?> _workingHours = {};
  Map<String, int>? _priceRange;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _bioController.text = widget.profile.bio;
    _addressController.text = widget.profile.location;
    _instagramController.text = ''; // TODO: Adicionar ao ProfileEntity se necessário
    _facebookController.text = ''; // TODO: Adicionar ao ProfileEntity se necessário
    _services = List.from(widget.profile.services);
    _workingHours = widget.profile.workingHours != null ? Map.from(widget.profile.workingHours!) : {};
    _priceRange = widget.profile.hourlyRate != null
        ? {'min': widget.profile.hourlyRate!.toInt(), 'max': (widget.profile.hourlyRate! * 2).toInt()}
        : {'min': 20, 'max': 200};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    if (value.trim().length > 100) {
      return 'Nome muito longo (máximo 100 caracteres)';
    }
    return null;
  }

  String? _validateBio(String? value) {
    // Bio é opcional, mas se preenchida deve ter requisitos
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 10) {
        return 'Bio deve ter pelo menos 10 caracteres';
      }
      if (value.trim().length > 500) {
        return 'Bio muito longa (máximo 500 caracteres)';
      }
    }
    return null;
  }

  String? _validateAddress(String? value) {
    // Address é opcional, mas se preenchido deve ter requisitos
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 5) {
        return 'Endereço deve ter pelo menos 5 caracteres';
      }
      if (value.trim().length > 200) {
        return 'Endereço muito longo (máximo 200 caracteres)';
      }
    }
    return null;
  }

  String? _validateUrl(String? value, String platform) {
    // URLs de redes sociais são opcionais
    if (value != null && value.trim().isNotEmpty) {
      // Validação básica de URL
      final urlPattern = RegExp(r'^https?://');
      if (!urlPattern.hasMatch(value.trim())) {
        return 'URL deve começar com http:// ou https://';
      }

      // Validação específica por plataforma
      if (platform == 'instagram' && !value.contains('instagram.com')) {
        return 'URL deve ser do Instagram';
      }
      if (platform == 'facebook' && !value.contains('facebook.com')) {
        return 'URL deve ser do Facebook';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Salvar'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPhotosSection(),
            const SizedBox(height: 24),
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildBioSection(),
            const SizedBox(height: 24),
            _buildServicesSection(),
            const SizedBox(height: 24),
            _buildWorkingHoursSection(),
            const SizedBox(height: 24),
            _buildPriceRangeSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildSocialMediaSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos do Perfil', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Adicione até 6 fotos. A primeira será sua foto principal.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                widget.profile.portfolioUrls.length,
                (index) => _buildExistingPhoto(widget.profile.portfolioUrls[index], index),
              ),
              ..._newPhotos.asMap().entries.map((entry) {
                return _buildNewPhoto(entry.value, entry.key);
              }),
              if ((widget.profile.portfolioUrls.length + _newPhotos.length) < 6) _buildAddPhotoButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingPhoto(String url, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: url, width: 100, height: 100, fit: BoxFit.cover),
          ),
          if (index == 0)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Principal',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewPhoto(XFile file, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _newPhotos.removeAt(index);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Icon(Icons.add_a_photo, size: 32, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Básicas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Nome *',
            helperText: 'Mínimo 2 caracteres',
            border: OutlineInputBorder(),
          ),
          validator: _validateName,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sobre Você', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Conte um pouco sobre sua experiência e estilo',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bioController,
          decoration: InputDecoration(
            labelText: 'Bio (opcional)',
            helperText: 'Se preenchida: mínimo 10, máximo 500 caracteres',
            hintText: 'Ex: Barbeiro há 10 anos, especializado em cortes modernos...',
            border: const OutlineInputBorder(),
            counterText: '${_bioController.text.length}/500',
          ),
          maxLines: 4,
          maxLength: 500,
          validator: _validateBio,
          onChanged: (value) => setState(() {}),
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Serviços Oferecidos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showServicesEditor(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_services.isEmpty)
          Text('Nenhum serviço adicionado', style: TextStyle(color: Colors.grey[600]))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _services.map((service) {
              return Chip(
                label: Text(service),
                onDeleted: () {
                  setState(() {
                    _services.remove(service);
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildWorkingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Horário de Funcionamento',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showWorkingHoursEditor(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_workingHours.isEmpty)
          Text('Horário não configurado', style: TextStyle(color: Colors.grey[600]))
        else
          ...['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].map((day) {
            final hours = _workingHours[day];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_getWeekdayName(day)),
                  Text(
                    hours ?? 'Fechado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hours != null ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Faixa de Preço',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showPriceRangeEditor(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_priceRange != null)
          Text(
            'R\$ ${_priceRange!['min']} - R\$ ${_priceRange!['max']}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold),
          )
        else
          Text('Faixa de preço não configurada', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Localização', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Endereço (opcional)',
            helperText: 'Se preenchido: mínimo 5 caracteres',
            hintText: 'Rua, número, bairro, cidade',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.location_on),
          ),
          maxLines: 2,
          validator: _validateAddress,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            // TODO: Open map picker
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Seleção de localização no mapa - Em breve!')));
          },
          icon: const Icon(Icons.map),
          label: const Text('Selecionar no Mapa'),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Redes Sociais', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _instagramController,
          decoration: const InputDecoration(
            labelText: 'Instagram (opcional)',
            helperText: 'URL completa começando com https://',
            hintText: 'https://instagram.com/seu_usuario',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.camera_alt),
          ),
          keyboardType: TextInputType.url,
          validator: (value) => _validateUrl(value, 'instagram'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _facebookController,
          decoration: const InputDecoration(
            labelText: 'Facebook (opcional)',
            helperText: 'URL completa começando com https://',
            hintText: 'https://facebook.com/sua_pagina',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.facebook),
          ),
          keyboardType: TextInputType.url,
          validator: (value) => _validateUrl(value, 'facebook'),
        ),
      ],
    );
  }

  Future<void> _pickPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (photo != null) {
      setState(() {
        _newPhotos.add(photo);
      });
    }
  }

  void _showServicesEditor() {
    showDialog(
      context: context,
      builder: (context) => ServicesEditor(
        initialServices: _services,
        onSave: (services) {
          setState(() {
            _services = services;
          });
        },
      ),
    );
  }

  void _showWorkingHoursEditor() {
    showDialog(
      context: context,
      builder: (context) => WorkingHoursEditor(
        initialHours: _workingHours,
        onSave: (hours) {
          setState(() {
            _workingHours = hours;
          });
        },
      ),
    );
  }

  void _showPriceRangeEditor() {
    showDialog(
      context: context,
      builder: (context) => PriceRangeEditor(
        initialRange: _priceRange,
        onSave: (range) {
          setState(() {
            _priceRange = range;
          });
        },
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profileRepo = ref.read(profileRepositoryProvider);

      // TODO: Implementar upload de novas fotos quando necessário
      if (_newPhotos.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ Upload de fotos será implementado'), duration: Duration(seconds: 2)),
          );
        }
      }

      // Atualizar perfil no Firestore
      final updatedData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'location': _addressController.text.trim(),
        'services': _services,
        'workingHours': _workingHours.isEmpty ? null : _workingHours,
        'hourlyRate': _priceRange != null ? _priceRange!['min']!.toDouble() : null,
        'updatedAt': DateTime.now(),
      };

      await profileRepo.updateProfile(userId: widget.profile.userId, data: updatedData);

      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Retorna true para indicar sucesso
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erro ao salvar perfil: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getWeekdayName(String key) {
    const weekdays = {
      'monday': 'Segunda',
      'tuesday': 'Terça',
      'wednesday': 'Quarta',
      'thursday': 'Quinta',
      'friday': 'Sexta',
      'saturday': 'Sábado',
      'sunday': 'Domingo',
    };
    return weekdays[key] ?? key;
  }
}
