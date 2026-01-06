import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/repositories/user_repository.dart';
import 'package:dio/dio.dart';

import '../device_fingerprint_service.dart';

class ReviewRiskTrackingInterceptor extends Interceptor {
  final DeviceFingerprintService _deviceService = DeviceFingerprintService();
  final UserRepository _userRepository = getIt<UserRepository>();

  /// Actions that should include risk tracking headers
  final _trackedActions = {
    '/api/v1/reviews/submit',
    '/api/v1/transactions/create',
    '/api/v1/auth/login',
    '/api/v1/auth/register',
  };

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Check if this endpoint needs risk tracking
    final needsTracking = _trackedActions.any(
          (action) => options.path.contains(action),
    );

    if (needsTracking) {
      // Add device fingerprint
      final fingerprint = await _deviceService.getDeviceFingerprint();
      options.headers['X-Device-Fingerprint'] = fingerprint;

      options.headers['X-Latitude'] = _userRepository.latitude;
      options.headers['X-Longitude'] = _userRepository.longitude;

      // User agent is automatically added by Dio
      // but we can enhance it with app version
      options.headers['X-App-Version'] = '1.0.0'; // From package info
    }

    handler.next(options);
  }
}