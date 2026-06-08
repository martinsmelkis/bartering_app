
import 'dart:convert';

import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/services/location_check_in_service.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PremiumProfileEditorState {
  final bool isSaving;
  final bool isUploadingAvatar;
  final bool isUploadingReference;
  final bool isAvatarExplicitlyRemoved;
  final String? name;
  final String? description;
  final XFile? avatarSvgFile;
  final String? existingAvatarSvgContent;
  final List<String> existingWorkReferenceImageUrls;
  final List<XFile> referenceImages;
  final String? statusMessage;
  final String? errorMessage;

  const PremiumProfileEditorState({
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.isUploadingReference = false,
    this.isAvatarExplicitlyRemoved = false,
    this.name,
    this.description,
    this.avatarSvgFile,
    this.existingAvatarSvgContent,
    this.existingWorkReferenceImageUrls = const [],
    this.referenceImages = const [],
    this.statusMessage,
    this.errorMessage,
  });

  PremiumProfileEditorState copyWith({
    bool? isSaving,
    bool? isUploadingAvatar,
    bool? isUploadingReference,
    bool? isAvatarExplicitlyRemoved,
    String? name,
    String? description,
    XFile? avatarSvgFile,
    String? existingAvatarSvgContent,
    List<String>? existingWorkReferenceImageUrls,
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
      isAvatarExplicitlyRemoved:
          clearAvatar ? true : (isAvatarExplicitlyRemoved ?? this.isAvatarExplicitlyRemoved),
      name: name ?? this.name,
      description: description ?? this.description,
      avatarSvgFile: clearAvatar ? null : (avatarSvgFile ?? this.avatarSvgFile),
      existingAvatarSvgContent: clearAvatar
          ? null
          : (existingAvatarSvgContent ?? this.existingAvatarSvgContent),
      existingWorkReferenceImageUrls:
          existingWorkReferenceImageUrls ?? this.existingWorkReferenceImageUrls,
      referenceImages: referenceImages ?? this.referenceImages,
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PremiumProfileEditorCubit extends Cubit<PremiumProfileEditorState> {
  final ApiClient _apiClient;
  final UserRepository _userRepository;
  final String _appUserId;
  final ImagePicker _picker = ImagePicker();

  bool _isHttpUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  List<String> _normalizeToHttpImageUrls(List<String> values) {
    final baseUrl = ApiClient.serviceBaseUrl.endsWith('/')
        ? ApiClient.serviceBaseUrl.substring(0, ApiClient.serviceBaseUrl.length - 1)
        : ApiClient.serviceBaseUrl;

    return values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .map((value) {
          if (_isHttpUrl(value)) return value;
          if (value.startsWith('/')) return '$baseUrl$value';
          return '';
        })
        .where((value) => _isHttpUrl(value))
        .toList();
  }

  // Keep web bytes in memory similar to create_posting_screen logic.
  final Map<String, Uint8List> _webImageBytes = {};

  PremiumProfileEditorCubit({
    required ApiClient apiClient,
    required UserRepository userRepository,
    required String appUserId,
  })  : _apiClient = apiClient,
        _userRepository = userRepository,
        _appUserId = appUserId,
        super(const PremiumProfileEditorState());

  Future<void> initialize({
    String? initialName,
    String? initialDescription,
  }) async {
    emit(
      state.copyWith(
        name: initialName,
        description: initialDescription,
        clearError: true,
        clearStatus: true,
      ),
    );

    try {
      final cached = _userRepository.getCachedProfileInfo();
      if (cached != null) {
        emit(state.copyWith(
          name: cached.name,
          description: cached.selfDescription,
          existingAvatarSvgContent: cached.profileAvatarIcon,
          isAvatarExplicitlyRemoved: false,
          existingWorkReferenceImageUrls: cached.workReferenceImageUrls,
          clearError: true,
          clearStatus: true,
        ));
        return;
      }

      final profile = await _apiClient.getProfileInfo(_appUserId);
      _userRepository.setCachedProfileInfo(profile);
      emit(state.copyWith(
        name: profile.name,
        description: profile.selfDescription,
        existingAvatarSvgContent: profile.profileAvatarIcon,
        isAvatarExplicitlyRemoved: false,
        existingWorkReferenceImageUrls: profile.workReferenceImageUrls,
        clearError: true,
        clearStatus: true,
      ));
    } catch (_) {
      // Keep initial values if remote fetch fails.
    }
  }

  void updateName(String value) {
    emit(state.copyWith(name: value, clearError: true, clearStatus: true));
  }

  void updateDescription(String value) {
    emit(state.copyWith(description: value, clearError: true, clearStatus: true));
  }

  Future<XFile?> _pickImage(
    ImageSource source, {
    bool applyResizeAndCompression = true,
  }) async {
    final XFile? image = applyResizeAndCompression
        ? await _picker.pickImage(
            source: source,
            maxWidth: 1920,
            maxHeight: 1920,
            imageQuality: 100,
          )
        : await _picker.pickImage(source: source);

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
      final image = await _pickImage(
        source,
        applyResizeAndCompression: false,
      );
      if (image == null) {
        emit(state.copyWith(isUploadingAvatar: false));
        return;
      }

      final svgContent = await _toSvgContent(image);
      if (svgContent == null) {
        final avatarPath = image.path;
        if (avatarPath.isNotEmpty) {
          _webImageBytes.remove(avatarPath);
        }

        emit(state.copyWith(
          isUploadingAvatar: false,
          errorMessage:
              'Please select a valid SVG file. The selected file appears to be a raster image (PNG/JPG).',
        ));
        return;
      }

      emit(state.copyWith(
        isUploadingAvatar: false,
        avatarSvgFile: image,
        isAvatarExplicitlyRemoved: false,
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
      existingAvatarSvgContent: null,
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

    final hasNewImages = state.referenceImages.isNotEmpty;
    final existingCount = state.existingWorkReferenceImageUrls.length;

    if (hasNewImages) {
      if (index < 0 || index >= state.referenceImages.length) {
        emit(state.copyWith(
          isUploadingReference: false,
          errorMessage: 'Invalid work reference image index.',
        ));
        return;
      }
    } else {
      if (index < 0 || index >= existingCount) {
        emit(state.copyWith(
          isUploadingReference: false,
          errorMessage: 'Invalid work reference image index.',
        ));
        return;
      }
    }

    try {
      final image = await _pickImage(source);
      if (image == null) {
        emit(state.copyWith(isUploadingReference: false));
        return;
      }

      if (hasNewImages) {
        final previousPath = state.referenceImages[index].path;
        _webImageBytes.remove(previousPath);

        final updatedImages = List<XFile>.from(state.referenceImages)..[index] = image;

        emit(state.copyWith(
          isUploadingReference: false,
          referenceImages: updatedImages,
        ));
      } else {
        emit(state.copyWith(
          isUploadingReference: false,
          errorMessage:
              'Replacing existing work reference images is not supported yet: backend accepts only hosted http/https URLs.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isUploadingReference: false,
        errorMessage: 'Failed to replace work reference image: $e',
      ));
    }
  }

  void removeReferenceImage(int index) {
    final hasNewImages = state.referenceImages.isNotEmpty;

    if (hasNewImages) {
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
      return;
    }

    if (index < 0 || index >= state.existingWorkReferenceImageUrls.length) {
      emit(state.copyWith(errorMessage: 'Invalid work reference image index.'));
      return;
    }

    final updatedExisting = List<String>.from(state.existingWorkReferenceImageUrls)
      ..removeAt(index);

    emit(state.copyWith(
      existingWorkReferenceImageUrls: updatedExisting,
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
    final decoded = utf8.decode(bytes, allowMalformed: true).trim();
    if (decoded.isEmpty) return null;

    final lower = decoded.toLowerCase();
    final looksLikeSvg = lower.contains('<svg') ||
        lower.startsWith('<?xml') ||
        lower.contains('xmlns="http://www.w3.org/2000/svg"') ||
        lower.contains("xmlns='http://www.w3.org/2000/svg'");

    if (!looksLikeSvg) {
      return null;
    }

    return decoded;
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
      final String? profileAvatarIcon;

      if (state.isAvatarExplicitlyRemoved) {
        profileAvatarIcon = "";
      } else if (state.avatarSvgFile != null) {
        profileAvatarIcon = await _toSvgContent(state.avatarSvgFile);
      } else {
        profileAvatarIcon = state.existingAvatarSvgContent;
      }

      final existingWorkReferenceImageUrls =
          _normalizeToHttpImageUrls(state.existingWorkReferenceImageUrls);
      final newWorkReferenceImageUrls = await Future.wait(
        state.referenceImages.map(_toDataBase64),
      );
      final workReferenceImageUrls = [
        ...existingWorkReferenceImageUrls,
        ...newWorkReferenceImageUrls,
      ];
      final isCheckedIn = LocationCheckInService().isCheckedIn;

      final updatedProfile = UserProfileData(
        userId: userId,
        name: (state.name ?? '').trim().isNotEmpty
            ? (state.name ?? '').trim()
            : (_userRepository.userName ?? ''),
        latitude: isCheckedIn ? _userRepository.latitude : null,
        longitude: isCheckedIn ? _userRepository.longitude : null,
        profileKeywordDataMap: keywordMap,
        selfDescription: (state.description ?? '').trim().isNotEmpty
            ? (state.description ?? '').trim()
            : null,
        profileAvatarIcon: profileAvatarIcon,
        workReferenceImageUrls: workReferenceImageUrls,
        activePostingIds: const [],
      );

      final updatedUserName = await _apiClient.updateProfileInfo(updatedProfile);
      _userRepository.invalidateCachedProfileInfo();
      _userRepository.setCachedProfileInfo(updatedProfile);
      if (updatedUserName.trim().isNotEmpty) {
        await _userRepository.setUserName(updatedUserName.trim());
      }

      emit(state.copyWith(
        isSaving: false,
        statusMessage: 'Profile updated successfully.',
      ));
    } on DioException catch (e) {
      final backendMessage = DioErrorHandler.extractBackendErrorMessage(e);
      emit(state.copyWith(
        isSaving: false,
        errorMessage: backendMessage?.trim().isNotEmpty == true
            ? backendMessage!.trim()
            : 'Failed to save profile. Please try again.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save profile. Please try again.',
      ));
    }
  }
}
