import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/secure_storage_service.dart';
import '../../utils/security_utils.dart';
import '../pin_input_screen/setup_pin_from_settings_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = SecureStorageService();
  
  String? _securityQuestion;
  bool _isLoading = true;
  bool _hasSecurityQuestion = false;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _loadSecurityQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadSecurityQuestion() async {
    final hasQuestion = await _secureStorage.hasSecurityQuestion();
    if (hasQuestion) {
      final question = await _secureStorage.getSecurityQuestion();
      setState(() {
        _securityQuestion = question;
        _hasSecurityQuestion = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _hasSecurityQuestion = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyAndResetPin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Get stored answer hash
      final storedAnswerHash = await _secureStorage.getSecurityAnswer();
      
      // Hash the entered answer (normalized: trimmed and lowercase)
      final normalizedAnswer = _answerController.text.trim().toLowerCase();
      final hashCorrect = SecurityUtils.verifyHash(normalizedAnswer, storedAnswerHash ?? "");

      if (hashCorrect) {
        // Answer correct - navigate to PIN setup
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) => SetupPinFromSettingsScreen(
              onPinSet: () {
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.pinResetSuccessfully),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        );
      } else {
        // Answer incorrect
        setState(() {
          _failedAttempts++;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.securityAnswerIncorrect(_failedAttempts)),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.forgotPin),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasSecurityQuestion) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.forgotPin),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.noSecurityQuestionSet,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.contactSupportForPinReset,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forgotPin),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.help_outline,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.answerSecurityQuestion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // Display security question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _securityQuestion ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              
              // Answer field
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: l10n.yourAnswer,
                  hintText: l10n.enterYourAnswer,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterAnswer;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _verifyAndResetPin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(l10n.verifyAndResetPin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
