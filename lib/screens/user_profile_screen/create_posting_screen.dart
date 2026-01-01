import 'dart:io';
import 'package:barter_app/models/postings/posting_data_response.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/widgets/full_screen_image_viewer.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/user_repository.dart';
import '../../services/chat_notification_service.dart';
import '../../theme/app_colors.dart';

class CreatePostingScreen extends StatefulWidget {
  final bool? isOffer;
  final UserPostingData? existingPosting;

  const CreatePostingScreen({
    super.key,
    this.isOffer,
    this.existingPosting,
  }) : assert(isOffer != null || existingPosting != null, 
              'Either isOffer or existingPosting must be provided');

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();

  DateTime? _selectedExpirationDate;
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  bool get _isEditing => widget.existingPosting != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingPosting != null) {
      _titleController.text = widget.existingPosting!.title;
      _descriptionController.text = widget.existingPosting!.description;
      if (widget.existingPosting!.value != null) {
        _valueController.text = widget.existingPosting!.value.toString();
      }
      _selectedExpirationDate = widget.existingPosting!.expiresAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.maxImagesReached),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Widget _buildImagePreview(XFile imageFile) {
    if (kIsWeb) {
      // On web, use Image.network with the XFile path (which is a blob URL)
      return Image.network(
        imageFile.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      // On mobile, use Image.file
      return Image.file(
        File(imageFile.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Future<void> _selectExpirationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedExpirationDate = picked;
      });
    }
  }

  Future<void> _submitPosting() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userRepository = getIt<UserRepository>();
      final apiClient = getIt<ApiClient>();

      // Prepare multipart files from selected images
      List<dio.MultipartFile>? imageFiles;
      if (_selectedImages.isNotEmpty) {
        imageFiles = [];
        for (final xFile in _selectedImages) {
          dio.MultipartFile multipartFile;

          if (kIsWeb) {
            // On web, read bytes directly from XFile
            final bytes = await xFile.readAsBytes();
            multipartFile = dio.MultipartFile.fromBytes(
              bytes,
              filename: xFile.name,
            );
          } else {
            // On mobile, use file path
            final file = File(xFile.path);
            multipartFile = await dio.MultipartFile.fromFile(
              file.path,
              filename: xFile.name,
            );
          }

          imageFiles.add(multipartFile);
        }
      }

      // Call the appropriate API (create or update)
      if (_isEditing && widget.existingPosting!.id != null) {
        // Update existing posting
        await apiClient.updatePosting(
          widget.existingPosting!.id!,
          userRepository.userId!,
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          (widget.existingPosting!.isOffer).toString(),
          _valueController.text.isNotEmpty ? _valueController.text : null,
          _selectedExpirationDate?.millisecondsSinceEpoch,
          imageFiles,
        );
      } else {
        // Create new posting
        await apiClient.createPosting(
          userRepository.userId!,
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          (widget.isOffer ?? false).toString(),
          _valueController.text.isNotEmpty ? _valueController.text : null,
          _selectedExpirationDate?.millisecondsSinceEpoch,
          imageFiles,
        );
      }

      if (mounted) {
        try {
          final notificationService = getIt<ChatNotificationService>();
          await notificationService.requestNotificationPermission();
        } catch (e) {
          // Service might not be registered yet
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing 
                ? AppLocalizations.of(context)!.postingUpdatedSuccess
                : AppLocalizations.of(context)!.postingCreatedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showImageSourceDialog() {
    // On web, camera is not typically available, so directly open gallery
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                      Icons.camera_alt, color: AppColors.primary),
                  title: Text(AppLocalizations.of(context)!.takePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                      Icons.photo_library, color: AppColors.primary),
                  title: Text(AppLocalizations.of(context)!.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing 
            ? l10n.editPosting 
            : (widget.isOffer ?? widget.existingPosting!.isOffer) 
                ? l10n.createOfferPosting 
                : l10n.createInterestPosting),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.postingTitle,
                  hintText: l10n.postingTitleHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return l10n.postingTitleRequired;
                  }
                  if (value
                      .trim()
                      .length < 3) {
                    return l10n.postingTitleTooShort;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.postingDescription,
                  hintText: l10n.postingDescriptionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return l10n.postingDescriptionRequired;
                  }
                  if (value
                      .trim()
                      .length < 10) {
                    return l10n.postingDescriptionTooShort;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Value Field (Optional)
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: l10n.postingValue,
                  hintText: l10n.postingValueHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: l10n.optionalField,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 0) {
                      return l10n.postingValueInvalid;
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Expiration Date
              Card(
                elevation: 1,
                child: InkWell(
                  onTap: _selectExpirationDate,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.expirationDate,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _selectedExpirationDate != null
                                    ? '${_selectedExpirationDate!
                                    .day}/${_selectedExpirationDate!
                                    .month}/${_selectedExpirationDate!.year}'
                                    : l10n.tapToSelectDate,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: _selectedExpirationDate != null
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: _selectedExpirationDate != null
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Images Section
              Text(
                l10n.postingImages,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                l10n.postingImagesHint,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),

              // Image Grid
              if (_selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Open full-screen preview of selected images
                            final imageUrls = _selectedImages
                                .map((xFile) => xFile.path)
                                .toList();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageViewer(
                                  imageUrls: imageUrls,
                                  initialIndex: index,
                                  heroTag: 'create_posting_image',
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'create_posting_image_$index',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: _buildImagePreview(_selectedImages[index]),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              SizedBox(height: 12.h),

              // Add Image Button
              if (_selectedImages.length < 3)
                OutlinedButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(l10n.addImage),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              SizedBox(height: 24.h),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPosting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  _isEditing ? l10n.updatePosting : l10n.createPosting,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
