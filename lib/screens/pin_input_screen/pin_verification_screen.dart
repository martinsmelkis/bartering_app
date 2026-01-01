import 'package:barter_app/services/firebase_service.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/utils/security_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

/// PIN verification screen for go_router
/// Shows a PIN input screen and navigates to the target route on success
class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final int _pinLength = 5;
  String _pin = "";
  bool _isVerifying = false;

  void _onNumberPressed(String number) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == _pinLength) {
        _verifyPin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _verifyPin() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      final storedPin = await SecureStorageService().getPIN("");
      final verifiedPIN = SecurityUtils.verifyHash(_pin, storedPin ?? "");

      if (mounted) {
        if (verifiedPIN) {
          print('@@@@@@@@@ PIN verification successful - navigating to map');
          // PIN correct - navigate to map
          context.go('/map');
          
          // Handle any pending notification after successful PIN verification
          // Use a delay to ensure map screen is fully mounted and router is ready
          Future.delayed(const Duration(milliseconds: 1000), () {
            print('🔐 PIN verified, map should be mounted, handling pending messages...');
            FirebaseService().handlePendingInitialMessage();
          });
        } else {
          print('@@@@@@@@@ PIN verification failed');
          final l10n = AppLocalizations.of(context)!;
          
          // Clear PIN
          setState(() {
            _pin = "";
            _isVerifying = false;
          });

          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.pinErrorIncorrect(1)),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('@@@@@@@@@ PIN verification error: $e');
      if (mounted) {
        setState(() {
          _pin = "";
          _isVerifying = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error verifying PIN'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.enterYourPin),
        automaticallyImplyLeading: false, // Don't show back button
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          _buildPinIndicators(),
          const SizedBox(height: 60),
          _isVerifying
              ? const CircularProgressIndicator()
              : _buildNumpad(),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _isVerifying ? null : () {
              context.push('/forgot-password');
            },
            child: Text(l10n.forgotPin),
          )
        ],
      ),
    );
  }

  Widget _buildPinIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _pin.length ? Theme.of(context).primaryColor : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((n) => _buildNumberButton(n)).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((n) => _buildNumberButton(n)).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((n) => _buildNumberButton(n)).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72, height: 72), // Placeholder for alignment
            _buildNumberButton('0'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 72,
      height: 72,
      child: ElevatedButton(
        onPressed: () => _onNumberPressed(number),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        child: Text(number, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return SizedBox(
      width: 72,
      height: 72,
      child: IconButton(
        icon: const Icon(Icons.backspace_outlined),
        onPressed: _onBackspacePressed,
        iconSize: 32,
      ),
    );
  }
}
