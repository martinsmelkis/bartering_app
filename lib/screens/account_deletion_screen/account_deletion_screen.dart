import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class AccountDeletionScreen extends StatefulWidget {
  final String? token;

  const AccountDeletionScreen({super.key, this.token});

  @override
  State<AccountDeletionScreen> createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  bool _isCompleted = false;
  String? _errorMessage;
  String? _resultMessage;

  bool get _isTokenFlow => widget.token != null && widget.token!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_isTokenFlow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confirmDeletionByToken();
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _requestDeletion() async {
    if (_isSubmitting || _isCompleted) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _resultMessage = null;
    });

    try {
      final response = await getIt<ApiClient>().requestAccountDeletionByEmail({
        'email': _emailController.text.trim(),
      });

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isCompleted = response.success;
        _errorMessage = response.success ? null : (response.message ?? l10n.anUnknownErrorOccurred);
        _resultMessage = response.message;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      final backendMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString())
          : null;
      setState(() {
        _isSubmitting = false;
        _errorMessage = backendMessage ?? e.message ?? l10n.anUnknownErrorOccurred;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _confirmDeletionByToken() async {
    if (_isSubmitting || _isCompleted || !_isTokenFlow) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _resultMessage = null;
    });

    try {
      final response = await getIt<ApiClient>().confirmAccountDeletionByToken({
        'token': widget.token!.trim(),
      });

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isCompleted = response.success;
        _errorMessage = response.success ? null : (response.message ?? l10n.anUnknownErrorOccurred);
        _resultMessage = response.message;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      final backendMessage = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString())
          : null;
      setState(() {
        _isSubmitting = false;
        _errorMessage = backendMessage ?? e.message ?? l10n.anUnknownErrorOccurred;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountDeletionTitle),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountDeletionHeader,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isTokenFlow ? l10n.accountDeletionTokenInfo : l10n.accountDeletionInfo,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  if (!_isTokenFlow) ...[
                    const SizedBox(height: 10),
                    Text(
                      l10n.accountDeletionSteps,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    (_isTokenFlow && _isCompleted)
                        ? l10n.accountDeletionDataDeletedTitleAfterConfirmed
                        : l10n.accountDeletionDataDeletedTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.accountDeletionDataDeletedItems,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Text(
                      '${l10n.error}: $_errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_resultMessage != null && !_isCompleted) ...[
                    Text(_resultMessage!),
                    const SizedBox(height: 12),
                  ],
                  if (_isCompleted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        _resultMessage ?? l10n.accountDeletionSuccessMessage,
                        style: const TextStyle(height: 1.5),
                      ),
                    )
                  else if (_isTokenFlow)
                    FilledButton(
                      onPressed: _isSubmitting ? null : _confirmDeletionByToken,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.accountDeletionConfirmButton),
                    )
                  else ...[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.accountDeletionEmailLabel,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) {
                          return l10n.emailRequired;
                        }
                        if (!email.contains('@') || !email.contains('.')) {
                          return l10n.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _requestDeletion,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.accountDeletionSendCodeButton),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
