import 'dart:convert';

import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PremiumProfileEditorState {
  final bool isSaving;
  final bool isUploadingAvatar;
  final bool isUploadingReference;
  final String? name;
  final String? description;
  final XFile? avatarSvgFile;
  final List<XFile> referenceImages;
  final String? statusMessage;
  final String? errorMessage;

  const PremiumProfileEditorState({
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.isUploadingReference = false,
    this.name,
    this.description,
    this.avatarSvgFile,
    this.referenceImages = const [],
    this.statusMessage,
    this.errorMessage,
  });

  PremiumProfileEditorState copyWith({
    bool? isSaving,
    bool? isUploadingAvatar,
    bool? isUploadingReference,
    String? name,
    String? description,
    XFile? avatarSvgFile,
    List<XFile>? referenceImages,
    String? statusMessage,
    String? errorMessage,
    bool clearStatus = false,
    bool clearError = false,
    bool clearAvatar = false,
  }) {
    return PremiumProfileEditorState(
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      isUploadingReference: isUploadingReference ?? this.isUploadingReference,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarSvgFile: clearAvatar ? null : (avatarSvgFile ?? this.avatarSvgFile),
      referenceImages: referenceImages ?? this.referenceImages,
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PremiumProfileEditorCubit extends Cubit<PremiumProfileEditorState> {
  final ApiClient _apiClient;
  final UserRepository _userRepository;
  final ImagePicker _picker = ImagePicker();

  // Keep web bytes in memory similar to create_posting_screen logic.
  final Map<String, Uint8List> _webImageBytes = {};

  PremiumProfileEditorCubit({
    required ApiClient apiClient,
    required UserRepository userRepository,
  })  : _apiClient = apiClient,
        _userRepository = userRepository,
        super(const PremiumProfileEditorState());

  void initialize({
    String? initialName,
    String? initialDescription,
  }) {
    emit(
      state.copyWith(
        name: initialName,
        description: initialDescription,
        clearError: true,
        clearStatus: true,
      ),
    );
  }

  void updateName(String value) {
    emit(state.copyWith(name: value, clearError: true, clearStatus: true));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value, clearError: true, clearStatus: true));
  }

  Future<XFile?> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 100,
    );

    if (image != null && kIsWeb) {
      try {
        final bytes = await image.readAsBytes();
        _webImageBytes[image.path] = bytes;
      } catch (_) {
        // Ignore - path can still be used for immediate preview in web.
      }
    }

    return image;
  }

  Future<void> selectAvatarSvg({ImageSource source = ImageSource.gallery}) async {
    emit(state.copyWith(
      isUploadingAvatar: true,
      clearError: true,
      clearStatus: true,
    ));

    try {
      final image = await _pickImage(source);
      emit(state.copyWith(
        isUploadingAvatar: false,
        avatarSvgFile: image,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploadingAvatar: false,
        errorMessage: 'Failed to select avatar image: $e',
      ));
    }
  }

  Future<void> removeAvatarSvg() async {
    final avatarPath = state.avatarSvgFile?.path;
    if (avatarPath != null) {
      _webImageBytes.remove(avatarPath);
    }

    emit(state.copyWith(
      clearAvatar: true,
      statusMessage: 'Avatar image removed.',
      clearError: true,
    ));
  }

  Future<void> addReferenceImage({ImageSource source = ImageSource.gallery}) async {
    if (state.referenceImages.length >= 3) {
      emit(state.copyWith(errorMessage: 'Maximum 3 work reference images allowed.'));
      return;
    }

    emit(state.copyWith(
      isUploadingReference: true,
      clearError: true,
      clearStatus: true,
    ));

    try {
      final image = await _pickImage(source);
      if (image == null) {
        emit(state.copyWith(isUploadingReference: false));
        return;
      }

      final updatedImages = List<XFile>.from(state.referenceImages)..add(image);
      emit(state.copyWith(
        isUploadingReference: false,
        referenceImages: updatedImages,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploadingReference: false,
        errorMessage: 'Failed to add work reference image: $e',
      ));
    }
  }

  Future<void> replaceReferenceImage(
    int index, {
    ImageSource source = ImageSource.gallery,
  }) async {
    emit(state.copyWith(isUploadingReference: true, clearError: true, clearStatus: true));

    if (index < 0 || index >= state.referenceImages.length) {
      emit(state.copyWith(
        isUploadingReference: false,
        errorMessage: 'Invalid work reference image index.',
      ));
      return;
    }

    try {
      final image = await _pickImage(source);
      if (image == null) {
        emit(state.copyWith(isUploadingReference: false));
        return;
      }

      final previousPath = state.referenceImages[index].path;
      _webImageBytes.remove(previousPath);

      final updatedImages = List<XFile>.from(state.referenceImages)..[index] = image;

      emit(state.copyWith(
        isUploadingReference: false,
        referenceImages: updatedImages,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploadingReference: false,
        errorMessage: 'Failed to replace work reference image: $e',
      ));
    }
  }

  void removeReferenceImage(int index) {
    if (index < 0 || index >= state.referenceImages.length) {
      emit(state.copyWith(errorMessage: 'Invalid work reference image index.'));
      return;
    }

    final removedPath = state.referenceImages[index].path;
    _webImageBytes.remove(removedPath);

    final updatedImages = List<XFile>.from(state.referenceImages)..removeAt(index);
    emit(state.copyWith(
      referenceImages: updatedImages,
      statusMessage: 'Work reference image removed.',
      clearError: true,
    ));
  }

  Future<Uint8List> _readImageBytes(XFile image) async {
    return kIsWeb
        ? (_webImageBytes[image.path] ?? await image.readAsBytes())
        : await image.readAsBytes();
  }

  Future<String> _toDataBase64(XFile image) async {
    final bytes = await _readImageBytes(image);

    final extension = image.name.contains('.')
        ? image.name.split('.').last.toLowerCase()
        : 'jpeg';
    final mimeType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'bmp' => 'image/bmp',
      'svg' || 'svgz' => 'image/svg+xml',
      _ => 'image/jpeg',
    };

    final base64Payload = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64Payload';
  }

  Future<String?> _toSvgContent(XFile? avatarSvgFile) async {
    if (avatarSvgFile == null) return null;

    final bytes = await _readImageBytes(avatarSvgFile);
    final svgContent = utf8.decode(bytes, allowMalformed: true).trim();
    return svgContent.isEmpty ? null : svgContent;
  }

  Future<void> saveProfile() async {
    emit(state.copyWith(isSaving: true, clearError: true, clearStatus: true));

    try {
      final userId = await _userRepository.getUserId();
      if (userId == null || userId.isEmpty) {
        emit(state.copyWith(
          isSaving: false,
          errorMessage: 'Unable to update profile: missing user id.',
        ));
        return;
      }

      final keywordMap = await _userRepository.getProfileKeywordDataMap();
      final profileAvatarIcon = await _toSvgContent(state.avatarSvgFile);
      final workReferenceImageUrls = await Future.wait(
        state.referenceImages.map(_toDataBase64),
      );

      final updatedProfile = UserProfileData(
        userId: userId,
        name: (state.name ?? '').trim().isNotEmpty
            ? (state.name ?? '').trim()
            : (_userRepository.userName ?? ''),
        latitude: _userRepository.latitude,
        longitude: _userRepository.longitude,
        profileKeywordDataMap: keywordMap,
        selfDescription: (state.description ?? '').trim().isNotEmpty
            ? (state.description ?? '').trim()
            : null,
        profileAvatarIcon: profileAvatarIcon,
        workReferenceImageUrls: workReferenceImageUrls,
        activePostingIds: const [],
      );

      final updatedUserName = await _apiClient.updateProfileInfo(updatedProfile);
      if (updatedUserName.trim().isNotEmpty) {
        await _userRepository.setUserName(updatedUserName.trim());
      }

      emit(state.copyWith(
        isSaving: false,
        statusMessage: 'Profile updated successfully.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save profile: $e',
      ));
    }
  }
}
