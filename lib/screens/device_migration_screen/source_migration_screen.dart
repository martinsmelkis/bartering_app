import 'dart:async';

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/screens/device_migration_screen/cubit/device_migration_cubit.dart';
import 'package:barter_app/screens/device_migration_screen/cubit/device_migration_state.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../configure_dependencies.dart';

/// Screen for source device to initiate and manage migration
class SourceMigrationScreen extends StatefulWidget {
  const SourceMigrationScreen({super.key});

  @override
  State<SourceMigrationScreen> createState() => _SourceMigrationScreenState();
}

class _SourceMigrationScreenState extends State<SourceMigrationScreen> {
  String? _sessionId; // 10-char session code for display
  String? _sessionIdUuid; // UUID for API calls
  DateTime? _expiresAt;
  String? _errorMessage;
  bool _isGenerating = false;
  bool _isSendingPayload = false;
  Timer? _expiryTimer;
  Duration _remainingTime = Duration.zero;
  
  // Store target device info when it joins
  String? _targetDeviceId;
  String? _targetPublicKey;

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }

  void _startExpiryTimer(DateTime expiresAt) {
    _expiryTimer?.cancel();
    setState(() {
      _expiresAt = expiresAt;
      _remainingTime = expiresAt.difference(DateTime.now());
    });

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = expiresAt.difference(DateTime.now());
      if (mounted) {
        setState(() {
          _remainingTime = remaining;
        });
        if (remaining.isNegative) {
          timer.cancel();
          _onSessionExpired();
        }
      }
    });
  }

  void _onSessionExpired() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _sessionId = null;
      _errorMessage = l10n.migrationCodeExpired;
    });
  }

  Future<void> _generateMigrationCode(BuildContext context) async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
      _sessionId = null;
    });

    final cubit = context.read<DeviceMigrationCubit>();
    final result = await cubit.initiateMigration();

    setState(() {
      _isGenerating = false;
    });

    if (result.success && result.sessionId != null) {
      setState(() {
        _sessionId = result.sessionId;
      });
      _startExpiryTimer(result.expiresAt!);
      
      // Start polling for target device in background
      _pollForTargetDevice(context, result.sessionId!);
    } else {
      setState(() {
        _errorMessage = result.errorMessage ?? 'Failed to generate migration code';
      });
    }
  }
  
  Future<void> _pollForTargetDevice(BuildContext context, String sessionCode) async {
    final cubit = context.read<DeviceMigrationCubit>();
    
    logDebug('⏳ Starting to poll for target device...');
    
    // Poll for target device (this will block until target joins or timeout)
    final targetInfo = await cubit.pollForTargetDeviceAndWait(sessionCode);
    
    if (targetInfo == null) {
      logDebug('⏳ Target device did not join in time');
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.targetDeviceTimeout;
      });
      return;
    }
    
    logDebug('✅ Target device joined: ${targetInfo['targetDeviceId']}');
    logDebug('   Session ID (UUID): ${targetInfo['sessionId']}');
    
    // Store UUID for payload API calls
    setState(() {
      _sessionIdUuid = targetInfo['sessionId'];
    });
    
    // Target device joined, emit state to show confirmation dialog
    cubit.emit(DeviceMigrationAwaitingConfirmation(
      targetDeviceId: targetInfo['targetDeviceId'],
      targetPublicKey: targetInfo['targetPublicKey'],
    ));
  }

  void _copyToClipboard() {
    if (_sessionId == null) return;
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: _sessionId!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.codeCopied),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get _formattedCode {
    if (_sessionId == null) return '';
    // Format as XXXX-XXXX-XX
    final code = _sessionId!;
    if (code.length >= 10) {
      return '${code.substring(0, 4)}-${code.substring(4, 8)}-${code.substring(8, 10)}';
    }
    return code;
  }

  String _formattedTime(AppLocalizations l10n) {
    if (_remainingTime.isNegative) return l10n.expired;
    final minutes = _remainingTime.inMinutes;
    final seconds = _remainingTime.inSeconds % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    return l10n.expiresIn(timeStr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fontScale = kIsWeb ? 1.5 : 1.0;

    return BlocProvider<DeviceMigrationCubit>(
      create: (context) => getIt<DeviceMigrationCubit>(),
      child: Builder(
        builder: (context) {
          return BlocListener<DeviceMigrationCubit, DeviceMigrationState>(
            listener: (context, state) {
              if (state is DeviceMigrationAwaitingConfirmation) {
                // Target device has joined, show confirmation dialog
                if (state.targetDeviceId != null && state.targetPublicKey != null) {
                  _showTargetDeviceJoinedDialog(
                    context,
                    state.targetDeviceId!,
                    state.targetPublicKey!,
                  );
                }
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text(l10n.migrateToNewDevice),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
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
                        // Icon
                        Container(
                          padding: EdgeInsets.all(24.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Icon(
                            Icons.phonelink_setup,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 32),
                        // Title
                        Text(
                          l10n.migrateYourAccount,
                          style: TextStyle(
                            fontSize: context.headingFontSize / fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        // Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            l10n.migrationCodeDescription,
                            style: TextStyle(
                              fontSize: context.bodyFontSize / fontScale,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40.h),
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
                        // Migration Code Display or Generate Button
                        if (_sessionId == null)
                          _buildGenerateButton(fontScale, context, l10n)
                        else
                          _buildCodeDisplay(fontScale, context, l10n),
                        SizedBox(height: 40.h),
                        // Instructions
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildInstructionStep(
                                '1',
                                l10n.migrationStep1,
                                fontScale,
                              ),
                              SizedBox(height: 12.h),
                              _buildInstructionStep(
                                '2',
                                l10n.migrationStep2,
                                fontScale,
                              ),
                              SizedBox(height: 12.h),
                              _buildInstructionStep(
                                '3',
                                l10n.migrationStep3,
                                fontScale,
                              ),
                              SizedBox(height: 12.h),
                              _buildInstructionStep(
                                '4',
                                l10n.migrationStep4,
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
      ),
    );
  }

  Widget _buildGenerateButton(double fontScale, BuildContext context, AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isGenerating ? null : () => _generateMigrationCode(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 48.w,
          vertical: 18.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        disabledBackgroundColor: Colors.grey.shade300,
      ),
      child: _isGenerating
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  l10n.generating,
                  style: TextStyle(
                    fontSize: context.buttonFontSize / fontScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Text(
              l10n.generateMigrationCode,
              style: TextStyle(
                fontSize: context.buttonFontSize / fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildCodeDisplay(double fontScale, BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                l10n.yourMigrationCode,
                style: TextStyle(
                  fontSize: context.bodyFontSize / fontScale,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16.h),
              // Code display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SelectableText(
                  _formattedCode,
                  style: TextStyle(
                    fontSize: 36 / fontScale,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 2,
                    fontFamily: 'Courier',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.h),
              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    size: 20,
                    color: _remainingTime.inMinutes < 2 ? Colors.red : AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _formattedTime(l10n),
                    style: TextStyle(
                      fontSize: context.bodyFontSize / fontScale,
                      color: _remainingTime.inMinutes < 2 ? Colors.red : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Copy button
              TextButton.icon(
                onPressed: _copyToClipboard,
                icon: Icon(
                  Icons.copy,
                  size: 20,
                ),
                label: Text(l10n.copyCode),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Regenerate button
        Builder(
          builder: (btnContext) => TextButton(
            onPressed: () => _generateMigrationCode(btnContext),
            child: Text(
              l10n.generateNewCode,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: context.bodyFontSize / fontScale,
              ),
            ),
          ),
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

  void _showTargetDeviceJoinedDialog(BuildContext context, String targetDeviceId, String targetPublicKey) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: kIsWeb,
      builder: (dialogContext) => PointerInterceptor(
        child: AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.phone_android,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(l10n.newDeviceDetected),
            ],
          ),
          content: Text(
            l10n.newDeviceDetectedMessage,
          ),
          actions: [
            PointerInterceptor(
              child: TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  // Deny migration - cancel the session
                  setState(() {
                    _errorMessage = l10n.migrationDenied;
                  });
                },
                child: Text(
                  l10n.deny,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            PointerInterceptor(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  // Allow migration - prepare and send data
                  setState(() {
                    _isSendingPayload = true;
                  });
                  
                  // Use sessionId (UUID) for API calls, not sessionCode
                  final sessionId = _sessionIdUuid ?? _sessionId;
                  
                  final cubit = context.read<DeviceMigrationCubit>();
                  final success = await cubit.prepareAndSendMigrationPayload(
                    targetDeviceId,
                    targetPublicKey,
                    sessionId!, // Use UUID for payload API call
                  );
                  
                  setState(() {
                    _isSendingPayload = false;
                  });
                  
                  if (success) {
                    // Show success message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.migrationCompleted),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    setState(() {
                      _errorMessage = l10n.failedToSendMigration;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(l10n.allow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
