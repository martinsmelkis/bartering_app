// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_migration_api_extension.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterMigrationTargetResponse _$RegisterMigrationTargetResponseFromJson(
  Map<String, dynamic> json,
) => RegisterMigrationTargetResponse(
  success: json['success'] as bool,
  sourceDeviceId: json['sourceDeviceId'] as String?,
  userId: json['userId'] as String?,
  requiresConfirmation: json['requiresConfirmation'] as bool? ?? true,
  errorMessage: json['errorMessage'] as String?,
  expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$RegisterMigrationTargetResponseToJson(
  RegisterMigrationTargetResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'sourceDeviceId': instance.sourceDeviceId,
  'userId': instance.userId,
  'requiresConfirmation': instance.requiresConfirmation,
  'errorMessage': instance.errorMessage,
  'expiresInSeconds': instance.expiresInSeconds,
};

GetMigrationPublicKeyResponse _$GetMigrationPublicKeyResponseFromJson(
  Map<String, dynamic> json,
) => GetMigrationPublicKeyResponse(
  success: json['success'] as bool,
  publicKey: json['publicKey'] as String?,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$GetMigrationPublicKeyResponseToJson(
  GetMigrationPublicKeyResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'publicKey': instance.publicKey,
  'errorMessage': instance.errorMessage,
};

ConfirmMigrationResponse _$ConfirmMigrationResponseFromJson(
  Map<String, dynamic> json,
) => ConfirmMigrationResponse(
  success: json['success'] as bool,
  errorMessage: json['errorMessage'] as String?,
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$ConfirmMigrationResponseToJson(
  ConfirmMigrationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'errorMessage': instance.errorMessage,
  'completedAt': instance.completedAt?.toIso8601String(),
};

MigrationStatusResponse _$MigrationStatusResponseFromJson(
  Map<String, dynamic> json,
) => MigrationStatusResponse(
  success: json['success'] as bool,
  sessionId: json['sessionId'] as String?,
  status: json['status'] as String?,
  sourceDeviceId: json['sourceDeviceId'] as String?,
  targetDeviceId: json['targetDeviceId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$MigrationStatusResponseToJson(
  MigrationStatusResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'sessionId': instance.sessionId,
  'status': instance.status,
  'sourceDeviceId': instance.sourceDeviceId,
  'targetDeviceId': instance.targetDeviceId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'errorMessage': instance.errorMessage,
};

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _DeviceMigrationApiClient implements DeviceMigrationApiClient {
  _DeviceMigrationApiClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<RegisterMigrationTargetResponse> registerMigrationTarget(
    RegisterMigrationTargetRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<RegisterMigrationTargetResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/migration/target',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RegisterMigrationTargetResponse _value;
    try {
      _value = RegisterMigrationTargetResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetMigrationPublicKeyResponse> getMigrationPublicKey(
    String sessionId,
    String deviceId,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'session_id': sessionId,
      r'device_id': deviceId,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetMigrationPublicKeyResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/migration/public-key',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late GetMigrationPublicKeyResponse _value;
    try {
      _value = GetMigrationPublicKeyResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ConfirmMigrationResponse> sendMigrationPayload(
    SendMigrationPayloadRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ConfirmMigrationResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/migration/payload',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ConfirmMigrationResponse _value;
    try {
      _value = ConfirmMigrationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ConfirmMigrationResponse> confirmMigrationComplete(
    ConfirmMigrationRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<ConfirmMigrationResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/migration/complete',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late ConfirmMigrationResponse _value;
    try {
      _value = ConfirmMigrationResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<MigrationStatusResponse> getMigrationStatus(String sessionId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<MigrationStatusResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/migration/status/${sessionId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late MigrationStatusResponse _value;
    try {
      _value = MigrationStatusResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
