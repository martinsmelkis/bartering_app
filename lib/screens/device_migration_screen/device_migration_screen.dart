import 'dart:async';

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/models/auth/device_management_models.dart';
import 'package:barter_app/screens/device_migration_screen/cubit/device_migration_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../configure_dependencies.dart';

/// Screen for entering migration code to import user data from another device
class DeviceMigrationScreen extends StatefulWidget {
  const DeviceMigrationScreen({super.key});

  @override
  State<DeviceMigrationScreen> createState() => _DeviceMigrationScreenState();
}

class _DeviceMigrationScreenState extends State<DeviceMigrationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    10,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    10,
    (index) => FocusNode(),
  );
  final List<String?> _characters = List.generate(10, (index) => null);

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _sessionId {
    return _characters.where((c) => c != null).join().toUpperCase();
  }

  bool get _isComplete {
    return _characters.every((c) => c != null && c.isNotEmpty);
  }

  void _onCharacterChanged(int index, String value) {
    setState(() {
      _errorMessage = null;
      _characters[index] = value.isNotEmpty ? value : null;
    });

    if (value.isNotEmpty && index < 9) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[index - 1].text.length),
        );
      }
    }
  }

  Future<void> _submitMigrationCode(BuildContext context) async {
    if (!_isComplete || _isSubmitting) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final sessionId = _sessionId;
    final cubit = context.read<DeviceMigrationCubit>();

    // Step 1: Join the migration session
    final joinResult = await cubit.joinMigrationSession(sessionId);

    if (!joinResult.success) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = joinResult.errorMessage ?? l10n.failedToJoinMigration;
      });
      return;
    }

    // Step 2: Poll for and receive migration payload from backend
    // The source device sends the payload via sendMigrationPayload endpoint
    // We poll the getMigrationPayload endpoint to retrieve it
    EncryptedMigrationPayloadResponse? payload;
    int pollAttempts = 0;
    const maxPollAttempts = 30; // Poll for up to 5 minutes (10 seconds * 30)

    while (payload == null && pollAttempts < maxPollAttempts) {
      await Future.delayed(const Duration(seconds: 10));

      if (!mounted) return;

      try {
        final response = await cubit.getMigrationPayload(sessionId);
        // If we got here without exception, we have the payload
        payload = response;
        break;
      } catch (e) {
        // Payload not ready yet, continue polling
        logDebug('⏳ Payload not ready yet, attempt ${pollAttempts + 1}/$maxPollAttempts');
      }

      pollAttempts++;
    }

    if (payload == null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = l10n.migrationTimedOut;
      });
      return;
    }

    // Step 3: Decrypt and import the migration data
    final receiveResult = await cubit.receiveMigrationData(payload);

    setState(() {
      _isSubmitting = false;
    });

    if (!receiveResult.success) {
      setState(() {
        _errorMessage = receiveResult.errorMessage ?? l10n.failedToProcessMigration;
      });
      return;
    }

    // Step 4: Confirm migration completion
    try {
      await cubit.confirmMigrationComplete(sessionId);
    } catch (e) {
      logDebugError('Error confirming migration: $e');
      // Continue even if confirmation fails - data is already imported
    }

    if (!mounted) return;

    // Navigate to map screen after successful migration
    context.go('/map');
  }

  void _clearAll() {
    setState(() {
      for (int i = 0; i < 10; i++) {
        _controllers[i].clear();
        _characters[i] = null;
      }
      _errorMessage = null;
    });
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = kIsWeb ? 1.5 : 1.0;

    return BlocProvider(
      create: (context) => getIt<DeviceMigrationCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveBreakpoints.getPadding(context),
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => context.go('/welcome'),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Icon
                  Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Icon(
                      Icons.phone_android,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 32),
                  // Title
                  Text(
                    l10n.importAccount,
                    style: TextStyle(
                      fontSize: context.headingFontSize / fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  // Description
                  Text(
                    l10n.importAccountDescription,
                    style: TextStyle(
                      fontSize: context.bodyFontSize / fontScale,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  // Code input boxes
                  _buildCodeInput(fontScale),
                  SizedBox(height: 32.h),
                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(16.r),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 21,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: context.bodyFontSize / fontScale,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Submit button
                  Builder(
                    builder: (btnContext) => ElevatedButton(
                      onPressed: _isComplete ? () => _submitMigrationCode(btnContext) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 4,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.importAccount,
                              style: TextStyle(
                                fontSize: context.buttonFontSize / fontScale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Clear button
                  TextButton(
                    onPressed: _clearAll,
                    child: Text(
                      l10n.clear,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: context.bodyFontSize / fontScale,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Instructions
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInstructionStep(
                          '1',
                          l10n.targetStep1,
                          fontScale,
                        ),
                        SizedBox(height: 12.h),
                        _buildInstructionStep(
                          '2',
                          l10n.targetStep2,
                          fontScale,
                        ),
                        SizedBox(height: 12.h),
                        _buildInstructionStep(
                          '3',
                          l10n.targetStep3,
                          fontScale,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(double fontScale) {
    return Column(
      children: [
        // First row: characters 0-4
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final isFilled = _characters[index] != null;
            return Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 55,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(skipTraversal: true),
                    onKey: (event) => _onKeyPressed(index, event),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 21 / fontScale,
                        fontWeight: FontWeight.bold,
                        color: isFilled ? AppColors.primary : Colors.grey,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: isFilled
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: isFilled
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onCharacterChanged(index, value),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      ],
                    ),
                  ),
                ),
                // Add spacing after each box (except last)
                if (index < 4) SizedBox(width: index % 2 == 1 ? 12.w : 4.w),
              ],
            );
          }),
        ),
        SizedBox(height: 12.h),
        // Second row: characters 5-9
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (subIndex) {
            final index = subIndex + 5;
            final isFilled = _characters[index] != null;
            return Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 55,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(skipTraversal: true),
                    onKey: (event) => _onKeyPressed(index, event),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: 21 / fontScale,
                        fontWeight: FontWeight.bold,
                        color: isFilled ? AppColors.primary : Colors.grey,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: isFilled
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: isFilled
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onCharacterChanged(index, value),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      ],
                    ),
                  ),
                ),
                // Add spacing after each box (except last)
                if (subIndex < 4) SizedBox(width: subIndex % 2 == 1 ? 12.w : 4.w),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String number, String text, double fontScale) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: context.bodyFontSize / fontScale,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: context.bodyFontSize / fontScale,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
