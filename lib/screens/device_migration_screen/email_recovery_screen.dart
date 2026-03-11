import 'dart:async';

import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/screens/device_migration_screen/cubit/device_migration_cubit.dart';
import 'package:barter_app/theme/app_colors.dart';
import 'package:barter_app/utils/debug_utils.dart';
import 'package:barter_app/utils/responsive_breakpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../configure_dependencies.dart';

/// Screen for email-based migration when source device is lost/broken
/// User enters their email to receive a recovery code
class EmailRecoveryScreen extends StatefulWidget {
  const EmailRecoveryScreen({super.key});

  @override
  State<EmailRecoveryScreen> createState() => _EmailRecoveryScreenState();
}

class _EmailRecoveryScreenState extends State<EmailRecoveryScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _codeFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isSubmitting = false;
  bool _isCodeSent = false;
  String? _errorMessage;
  String? _maskedEmail;
  Timer? _resendTimer;
  int _resendSeconds = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final focusNode in _codeFocusNodes) {
      focusNode.dispose();
    }
    _resendTimer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendSeconds = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendSeconds--;
        });
        if (_resendSeconds <= 0) {
          timer.cancel();
        }
      }
    });
  }

  Future<void> _sendRecoveryCode(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _errorMessage = 'Please enter a valid email address';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final cubit = context.read<DeviceMigrationCubit>();

    try {
      final result = await cubit.initiateEmailRecovery(email);

      setState(() {
        _isSubmitting = false;
      });

      if (result.success) {
        setState(() {
          _isCodeSent = true;
          _maskedEmail = result.maskedEmail;
        });
        _startResendTimer();
        logDebug('✅ Recovery code sent to: ${result.maskedEmail}');
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'Failed to send recovery code';
        });
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Failed to send recovery code';
      });
    }
  }

  Future<void> _verifyAndRecover(BuildContext context) async {
    final code = _codeControllers.map((c) => c.text).join();
    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit code';
      });
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final cubit = context.read<DeviceMigrationCubit>();

    try {
      final result = await cubit.verifyRecoveryCodeAndRecover(code);

      setState(() {
        _isSubmitting = false;
      });

      if (result.success) {
        logDebug('✅ Recovery successful!');
        if (!mounted) return;

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(l10n.recoverySuccess),
            content: Text(l10n.recoverySuccessMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/map');
                },
                child: Text(l10n.continueButton),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? l10n.invalidCode;
        });
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = l10n.recoveryFailed;
      });
    }
  }

  void _onCodeCharacterChanged(int index, String value) {
    setState(() {
      _errorMessage = null;
    });

    if (value.isNotEmpty && index < 5) {
      _codeFocusNodes[index + 1].requestFocus();
    }
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
          child: Stack(
            children: [
              // Back button at top-left
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  onPressed: () => context.go('/welcome'),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.primary,
                  ),
                ),
              ),
              // Centered content
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveBreakpoints.getPadding(context),
                    vertical: ResponsiveBreakpoints.getPadding(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 48.h), // Space for back button
                      // Icon
                      Container(
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                  SizedBox(height: 32),
                  // Title
                  Text(
                    l10n.recoverAccount,
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
                    l10n.recoverAccountDescription,
                    style: TextStyle(
                      fontSize: context.bodyFontSize / fontScale,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  if (!_isCodeSent) ...[
                    // Email input
                    _buildEmailInput(fontScale),
                    SizedBox(height: 32.h),
                  ] else ...[
                    // Code sent message
                    Container(
                      padding: EdgeInsets.all(16.r),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 21,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              l10n.codeSentTo(_maskedEmail ?? 'your email'),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: context.bodyFontSize / fontScale,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Code input
                    _buildCodeInput(fontScale),
                    SizedBox(height: 24.h),
                    // Resend option
                    if (_resendSeconds > 0)
                      Text(
                        l10n.resendCodeIn(_resendSeconds),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: context.bodyFontSize / fontScale,
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () => _sendRecoveryCode(context),
                        child: Text(l10n.resendCode),
                      ),
                    SizedBox(height: 32.h),
                  ],
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
                  if (!_isCodeSent)
                    Builder(
                      builder: (btnContext) => ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _sendRecoveryCode(btnContext),
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
                                l10n.sendRecoveryCode,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  else
                    Builder(
                      builder: (btnContext) => ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => _verifyAndRecover(btnContext),
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
                                l10n.verifyAndRecover,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildEmailInput(double fontScale) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      style: TextStyle(
        fontSize: context.bodyFontSize / fontScale,
      ),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'your.email@example.com',
        prefixIcon: Icon(Icons.email_outlined),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(double fontScale) {
    // Check if we're on a mobile-sized screen
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final sizeMultiplier = isMobile ? 1.25 : 1.0;

    final boxWidth = 48 * sizeMultiplier;
    final boxHeight = 55 * sizeMultiplier;
    final inputFontSize = (21 / fontScale) * sizeMultiplier;

    // Helper to build a single code box
    Widget buildCodeBox(int index) {
      final isFilled = _codeControllers[index].text.isNotEmpty;
      return SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: TextField(
          controller: _codeControllers[index],
          focusNode: _codeFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: inputFontSize,
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
          onChanged: (value) {
            _onCodeCharacterChanged(index, value);
            // Trigger rebuild to update field styling
            setState(() {});
            // Handle backspace when field is cleared
            if (value.isEmpty && index > 0) {
              _codeFocusNodes[index - 1].requestFocus();
            }
          },
        ),
      );
    }

    // Build row of 3 boxes with spacing
    Widget buildRow(int startIndex) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCodeBox(startIndex),
          SizedBox(width: 8.w),
          buildCodeBox(startIndex + 1),
          SizedBox(width: 8.w),
          buildCodeBox(startIndex + 2),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildRow(0),
        SizedBox(height: 12.h),
        buildRow(3),
      ],
    );
  }
}
