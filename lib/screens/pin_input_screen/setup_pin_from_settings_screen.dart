import 'package:barter_app/utils/security_utils.dart';
import 'package:flutter/material.dart';
import 'package:barter_app/services/secure_storage_service.dart';
import 'package:barter_app/services/settings_service.dart';
import '../../configure_dependencies.dart';
import '../../l10n/app_localizations.dart';

class SetupPinFromSettingsScreen extends StatefulWidget {
  final VoidCallback onPinSet;

  const SetupPinFromSettingsScreen({super.key, required this.onPinSet});

  @override
  State<SetupPinFromSettingsScreen> createState() => _SetupPinFromSettingsScreenState();
}

class _SetupPinFromSettingsScreenState extends State<SetupPinFromSettingsScreen> {
  final int _pinLength = 5;
  String _pin = "";
  bool _isSettingPin = false;

  void _onNumberPressed(String number) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += number;
      });

      if (_pin.length == _pinLength) {
        _savePin();
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty && !_isSettingPin) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Future<void> _savePin() async {
    if (_isSettingPin) return;
    
    setState(() {
      _isSettingPin = true;
    });

    try {
      final hashedPin = SecurityUtils.hashText(_pin);
      await SecureStorageService().savePIN(hashedPin);
      await getIt<SettingsService>().setPinEnabled(true);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pinSetSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
        widget.onPinSet();
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
        setState(() {
          _pin = "";
          _isSettingPin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setPinTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.create5DigitPin,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _buildPinIndicators(),
          const SizedBox(height: 60),
          _buildNumpad(),
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
            color: index < _pin.length 
                ? Theme.of(context).primaryColor 
                : Colors.grey[300],
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
            const SizedBox(width: 72, height: 72),
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
        onPressed: _isSettingPin ? null : () => _onNumberPressed(number),
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
        onPressed: _isSettingPin ? null : _onBackspacePressed,
        iconSize: 32,
      ),
    );
  }
}
