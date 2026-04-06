
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/screens/user_profile_screen/cubit/premium_profile_editor_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    context.read<PremiumProfileEditorCubit>().initialize(
      initialName: widget.initialName,
      initialDescription: widget.initialDescription,
    );
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

    return BlocListener<PremiumProfileEditorCubit, PremiumProfileEditorState>(
      listener: (context, state) {
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.premiumProfileEditorTitle),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<PremiumProfileEditorCubit, PremiumProfileEditorState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
            );
          },
        ),
      ),
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
    return Card(
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
              state.avatarSvgFile == null
                  ? AppLocalizations.of(context)!.premiumProfileEditorNoAvatarSvgSelected
                  : AppLocalizations.of(context)!.premiumProfileEditorSelectedFile(
                      state.avatarSvgFile!.name,
                    ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
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
                  onPressed: state.avatarSvgFile == null
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
            if (state.referenceImages.isEmpty)
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
                children: List.generate(state.referenceImages.length, (index) {
                  final imageFile = state.referenceImages[index];
                  final fileName = imageFile.name;

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
                          const Icon(Icons.image_outlined, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(fileName, overflow: TextOverflow.ellipsis)),
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.premiumProfileEditorReplace,
                            onPressed: state.isUploadingReference
                                ? null
                                : () => context.read<PremiumProfileEditorCubit>().replaceReferenceImage(index),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            tooltip: AppLocalizations.of(context)!.delete,
                            onPressed: () => context.read<PremiumProfileEditorCubit>().removeReferenceImage(index),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
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
