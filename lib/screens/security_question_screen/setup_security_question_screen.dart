import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/secure_storage_service.dart';
import '../../utils/security_utils.dart';
import '../../theme/app_colors.dart';

class SetupSecurityQuestionScreen extends StatefulWidget {
  final VoidCallback onSetupComplete;

  const SetupSecurityQuestionScreen({super.key, required this.onSetupComplete});

  @override
  State<SetupSecurityQuestionScreen> createState() => _SetupSecurityQuestionScreenState();
}

class _SetupSecurityQuestionScreenState extends State<SetupSecurityQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  final _secureStorage = SecureStorageService();
  
  String? _selectedQuestion;
  bool _isLoading = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  List<String> _getSecurityQuestions(AppLocalizations l10n) {
    return [
      l10n.securityQuestion1,
      l10n.securityQuestion2,
      l10n.securityQuestion3,
      l10n.securityQuestion4,
      l10n.securityQuestion5,
    ];
  }

  Future<void> _saveSecurityQuestion() async {
    if (!_formKey.currentState!.validate() || _selectedQuestion == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Hash the answer (case-insensitive, trimmed)
      final normalizedAnswer = _answerController.text.trim().toLowerCase();
      final hashedAnswer = SecurityUtils.hashText(normalizedAnswer);

      // Save question and hashed answer
      await _secureStorage.saveSecurityQuestion(_selectedQuestion!);
      await _secureStorage.saveSecurityAnswer(hashedAnswer);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.securityQuestionSaved),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSetupComplete();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final questions = _getSecurityQuestions(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setupSecurityQuestion),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.security,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.securityQuestionDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Question Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: l10n.selectSecurityQuestion,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.help_outline),
                  ),
                  value: _selectedQuestion,
                  isExpanded: true,
                  items: questions.map((question) {
                    return DropdownMenuItem(
                      value: question,
                      child: Text(
                        question,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedQuestion = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.pleaseSelectQuestion;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Answer Field
                TextFormField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: l10n.yourAnswer,
                    hintText: l10n.answerHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterAnswer;
                    }
                    if (value.trim().length < 2) {
                      return l10n.answerTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                Text(
                  l10n.securityAnswerNote,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveSecurityQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.saveSecurityQuestion,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
