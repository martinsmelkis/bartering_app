import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/l10n/app_localizations.dart';
import 'package:barter_app/services/api_client.dart';
import 'package:barter_app/utils/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  const PurchaseSuccessScreen({super.key});

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {
  bool _isRefreshing = true;
  bool _isPremium = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshPremiumStatus();
  }

  Future<void> _refreshPremiumStatus() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = null;
    });

    try {
      final apiClient = getIt<ApiClient>();
      await apiClient.syncPremiumNow();
      final premiumStatus = await apiClient.getPremiumStatus();
      if (!mounted) return;

      setState(() {
        _isPremium = premiumStatus.isPremium;
        _isRefreshing = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isRefreshing = false;
        _errorMessage = DioErrorHandler.getLocalizedApiErrorMessage(
          e,
          l10n,
          fallbackMessage: l10n.apiErrorServer,
        );
      });
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _isRefreshing = false;
        _errorMessage = l10n.apiErrorServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.buyPremium)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 72),
                const SizedBox(height: 16),
                Text(
                  _isPremium
                      ? l10n.inAppPremiumActivatedSuccessfully
                      : l10n.inAppPurchaseCompletedEntitlementNotActiveYet,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (_isRefreshing)
                  const CircularProgressIndicator()
                else if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go('/map'),
                  child: Text(l10n.done),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
