import 'dart:math';

import 'package:barter_app/utils/security_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart' as pc;
import 'dart:typed_data';
import 'dart:convert';

import 'package:barter_app/screens/pin_input_screen/pin_input_screen.dart';
import 'package:barter_app/services/secure_storage_service.dart';

import '../../l10n/app_localizations.dart';
import '../map_screen/map_screen.dart';

class CryptoWalletGeneratorScreen extends StatefulWidget {
  const CryptoWalletGeneratorScreen({super.key});

  @override
  State<CryptoWalletGeneratorScreen> createState() =>
      _CryptoWalletGeneratorScreenState();
}

class _CryptoWalletGeneratorScreenState
    extends State<CryptoWalletGeneratorScreen> {
  String? _publicKey;
  String? _privateKey;
  bool _isGenerating = false;

  Future<void> _generateWallet() async {
    setState(() {
      _isGenerating = true;
    });

    final keyPair = await _generateEcKeyPair();

    setState(() {
      _publicKey = _encodeKey(keyPair.publicKey as pc.ECPublicKey);
      _privateKey = _encodeKey(keyPair.privateKey as pc.ECPrivateKey);
      _isGenerating = false;
    });
  }

  Future<pc.AsymmetricKeyPair<pc.PublicKey, pc.PrivateKey>>
      _generateEcKeyPair() async {
    final keyGen = pc.ECKeyGenerator();

    final curveName = 'secp256r1';
    final domainParams = pc.ECDomainParameters(curveName);

    final secureRandom = pc.FortunaRandom();
    final random = Random.secure();
    final seed = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(pc.KeyParameter(Uint8List.fromList(seed)));

    keyGen.init(pc.ParametersWithRandom(pc.ECKeyGeneratorParameters(domainParams), secureRandom));

    return keyGen.generateKeyPair();
  }

  String _encodeKey(pc.AsymmetricKey key) {
    if (key is pc.ECPublicKey) {
      return base64.encode(key.Q!.getEncoded(false));
    } else if (key is pc.ECPrivateKey) {
      return base64.encode(key.d!.toRadixString(16).codeUnits);
    }
    return "";
  }

  void _copyToClipboard(String text) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.generateCryptoWallet),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isGenerating)
              const Center(child: CircularProgressIndicator())
            else
              if (_publicKey == null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.generating_tokens),
                  label: Text(l10n.generateWallet),
                  onPressed: _generateWallet,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                )
              else
                Column(
                  children: [
                    _buildKeyDisplay(l10n.publicKey, _publicKey!),
                    const SizedBox(height: 20),
                    _buildKeyDisplay(l10n.privateKey, _privateKey!),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      child: Text(l10n.done),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PinInputScreen(
                            onPinCompleted: (pin) async {
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => const MapScreenV2()),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildKeyDisplay(String title, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  key,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(key),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
