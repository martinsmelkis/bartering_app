import 'dart:convert';
import 'dart:io';

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/premium_profile_editor_cubit.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/image_utils.dart';
import 'package:barter_app/widgets/webp_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumProfileEditorScreen extends StatefulWidget {
  final String initialName;
  final String? initialDescription;

  const PremiumProfileEditorScreen({
    super.key,
    required this.initialName,
    this.initialDescription,
  });

  @override
  State<PremiumProfileEditorScreen> createState() => _PremiumProfileEditorScreenState();
}

class _PremiumProfileEditorScreenState extends State<PremiumProfileEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PremiumProfileEditorCubit>().initialize(
        initialName: widget.initialName,
        initialDescription: widget.initialDescription,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<PremiumProfileEditorCubit, PremiumProfileEditorState>(
      listener: (context, state) {
        final currentName = state.name ?? '';
        if (_nameController.text != currentName) {
          _nameController.value = _nameController.value.copyWith(
            text: currentName,
            selection: TextSelection.collapsed(offset: currentName.length),
            composing: TextRange.empty,
          );
        }

        final currentDescription = state.description ?? '';
        if (_descriptionController.text != currentDescription) {
          _descriptionController.value = _descriptionController.value.copyWith(
            text: currentDescription,
            selection: TextSelection.collapsed(offset: currentDescription.length),
            composing: TextRange.empty,
          );
        }

        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.statusMessage != null && state.statusMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.statusMessage!),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.premiumProfileEditorTitle),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  l10n.premiumProfileEditorHeader,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.premiumProfileEditorDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 20),
                _buildNameField(context, state),
                const SizedBox(height: 16),
                _buildDescriptionField(context, state),
                const SizedBox(height: 20),
                _buildAvatarSection(context, state),
                const SizedBox(height: 20),
                _buildWorkReferencesSection(context, state),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.isSaving
                        ? null
                        : () => context.read<PremiumProfileEditorCubit>().saveProfile(),
                    icon: state.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(state.isSaving ? l10n.premiumProfileEditorSaving : l10n.save),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField(BuildContext context, PremiumProfileEditorState state) {
    return TextFormField(
      controller: _nameController,
      onChanged: (value) => context.read<PremiumProfileEditorCubit>().updateName(value),
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.premiumProfileEditorDisplayNameOptional,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person_outline),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildDescriptionField(BuildContext context, PremiumProfileEditorState state) {
    return TextFormField(
      controller: _descriptionController,
      onChanged: (value) => context.read<PremiumProfileEditorCubit>().updateDescription(value),
      minLines: 3,
      maxLines: 6,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.premiumProfileEditorDescriptionOptional,
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.edit_note),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, PremiumProfileEditorState state) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.premiumProfileEditorAvatarSvg,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                state.avatarSvgFile != null
                    ? AppLocalizations.of(context)!.premiumProfileEditorSelectedFile(
                        state.avatarSvgFile!.name,
                      )
                    : (state.existingAvatarSvgContent?.trim().isNotEmpty == true
                        ? AppLocalizations.of(context)!
                            .premiumProfileEditorSelectedFile('current_profile_avatar.svg')
                        : AppLocalizations.of(context)!.premiumProfileEditorNoAvatarSvgSelected),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              if (state.avatarSvgFile != null ||
                  (state.existingAvatarSvgContent?.trim().isNotEmpty == true)) ...[
                SizedBox(
                  width: 96,
                  height: 96,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildAvatarPreview(state),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: state.isUploadingAvatar
                        ? null
                        : () => context.read<PremiumProfileEditorCubit>().selectAvatarSvg(),
                    icon: state.isUploadingAvatar
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file),
                    label: Text(AppLocalizations.of(context)!.premiumProfileEditorUploadSvg),
                  ),
                  OutlinedButton.icon(
                    onPressed: (state.avatarSvgFile == null &&
                            (state.existingAvatarSvgContent?.trim().isNotEmpty != true))
                        ? null
                        : () => context.read<PremiumProfileEditorCubit>().removeAvatarSvg(),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(AppLocalizations.of(context)!.premiumProfileEditorRemoveSvg),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(PremiumProfileEditorState state) {
    if (state.avatarSvgFile != null) {
      final xFile = state.avatarSvgFile!;
      if (kIsWeb) {
        return FutureBuilder<Uint8List>(
          future: xFile.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final svgText = utf8.decode(snapshot.data!, allowMalformed: true);
              return SvgPicture.string(svgText, fit: BoxFit.contain);
            }
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          },
        );
      }
      return FutureBuilder<String>(
        future: File(xFile.path).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SvgPicture.string(snapshot.data!, fit: BoxFit.contain);
          }
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }

    if (state.existingAvatarSvgContent?.trim().isNotEmpty == true) {
      return SvgPicture.string(state.existingAvatarSvgContent!, fit: BoxFit.contain);
    }

    return Container(color: Colors.grey.shade200);
  }

  Widget _buildLocalImagePreview(XFile imageFile) {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
        future: imageFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return Container(color: Colors.grey.shade200);
        },
      );
    }
    return Image.file(File(imageFile.path), fit: BoxFit.cover);
  }

  Widget _buildExistingWorkReferencePreview(String imageUrl) {
    final trimmed = imageUrl.trim();

    if (trimmed.startsWith('data:image') && trimmed.contains(',')) {
      try {
        final base64Part = trimmed.substring(trimmed.indexOf(',') + 1);
        final bytes = base64Decode(base64Part);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image_outlined),
          ),
        );
      } catch (_) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image_outlined),
        );
      }
    }

    final thumbnailUrl = ImageUtils.buildThumbnailUrl(
      baseUrl: ApiClient.serviceBaseUrl,
      imagePath: trimmed,
    );

    return WebPImage(
      imageUrl: thumbnailUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image_outlined),
      ),
    );
  }

  Widget _buildWorkReferencesSection(BuildContext context, PremiumProfileEditorState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.premiumProfileEditorWorkReferenceImages,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.premiumProfileEditorWorkReferenceDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (state.referenceImages.isEmpty && state.existingWorkReferenceImageUrls.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                ),
                child: Text(AppLocalizations.of(context)!.premiumProfileEditorNoWorkReferenceImages),
              )
            else
              Column(
                children: List.generate(
                  state.referenceImages.isNotEmpty
                      ? state.referenceImages.length
                      : state.existingWorkReferenceImageUrls.length,
                  (index) {
                    final hasNewImages = state.referenceImages.isNotEmpty;
                    final fileName = hasNewImages
                        ? state.referenceImages[index].name
                        : 'current_work_reference_${index + 1}.jpg';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SizedBox(
                                width: 52,
                                height: 52,
                                child: hasNewImages
                                    ? _buildLocalImagePreview(state.referenceImages[index])
                                    : _buildExistingWorkReferencePreview(
                                        state.existingWorkReferenceImageUrls[index],
                                      ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(fileName, overflow: TextOverflow.ellipsis)),
                            IconButton(
                              tooltip: AppLocalizations.of(context)!.delete,
                              onPressed: () => context.read<PremiumProfileEditorCubit>().removeReferenceImage(index),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: state.isUploadingReference
                  ? null
                  : () => context.read<PremiumProfileEditorCubit>().addReferenceImage(),
              icon: state.isUploadingReference
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_photo_alternate_outlined),
              label: Text(AppLocalizations.of(context)!.premiumProfileEditorAddImage),
            ),
          ],
        ),
      ),
    );
  }
}
