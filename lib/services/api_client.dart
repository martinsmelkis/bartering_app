import 'dart:convert';
import 'dart:io';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/chat/file_metadata_dto.dart';
import 'package:barter_app/models/chat/file_upload_response.dart';
import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/models/postings/posting_data_response.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/relationships/user_relationships_response.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attributes_data.dart';
import 'package:barter_app/models/user/user_onboarding_data.dart';
import 'package:barter_app/models/user/user_registration_data.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart' as pc;
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart' as pc;
import 'package:pointycastle/export.dart' as pc;
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/map/point_of_interest.dart';
import '../repositories/user_repository.dart';
import 'crypto/crypto_service.dart';

part 'api_client.g.dart';

@injectable
@RestApi() // Base URL can be set here or when creating Dio instance
abstract class ApiClient {
  static String serviceBaseUrl = getIt<String>(instanceName: 'serviceBaseUrl');
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // --- Static method to create an instance, allowing mock switching ---
  @factoryMethod
  static ApiClient create() {
    final dio = Dio();

    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        // This line is for DEVELOPMENT on mobile only.
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.options.connectTimeout = Duration(seconds: 10);
    // Add interceptors for logging, auth, etc. if needed
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    // Example: Add an Auth Interceptor
    dio.interceptors.add(InterceptorsWrapper(

       onRequest:(options, handler) async {

         if (options.path.startsWith('/api/')) {
           // 1. Get dependencies for user ID and private key
           final userRepository = getIt<UserRepository>();
           final cryptoService = await CryptoService.create(); // Assumes CryptoService holds the session's private key

           final privateKey = await userRepository.getPrivateKey();
           final userId = await userRepository.getUserId();

           if (privateKey == null || userId == null) {
             return handler.reject(
               DioException(requestOptions: options, error:
                "Authentication error: Private key or User ID not available."),
               true,
             );
           }

           final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

           // Handle body encoding based on content type
           String body = "";
           if (options.data != null) {
             // Check if it's FormData (multipart request)
             if (options.data is FormData) {
               // For FormData, create a simple string representation
               // or skip body in signature for multipart requests
               final formData = options.data as FormData;
               final fields = formData.fields
                   .map((e) => '${e.key}=${e.value}')
                   .join('&');
               body = fields; // Use form fields for signature
             } else {
               // For JSON requests, encode normally
               body = jsonEncode(options.data);
             }
           }

           final challenge = '$timestamp.$body';

           final privateECKey = cryptoService.ecPrivateKeyFromString(privateKey);

           // Use HMAC for deterministic ECDSA (RFC 6979)
           final signer = pc.ECDSASigner(pc.SHA256Digest(), pc.HMac(pc.SHA256Digest(), 64));
           signer.init(true, pc.PrivateKeyParameter<pc.ECPrivateKey>(privateECKey));

           final challengeBytes = Uint8List.fromList(utf8.encode(challenge));

           final signature = signer.generateSignature(challengeBytes) as pc.ECSignature;

           // 4. Encode the signature
           final seq = pc.ASN1Sequence();
           seq.add(pc.ASN1Integer(signature.r));
           seq.add(pc.ASN1Integer(signature.s));
           seq.encode();

           final encodedSignature = base64.encode(seq.encodedBytes!);

           // 5. Add custom headers to the request
           options.headers['X-User-ID'] = userId;
           options.headers['X-Timestamp'] = timestamp;
           options.headers['X-Signature'] = encodedSignature;

           return handler.next(options); //continue
         }
         return handler.next(options);
       }

    ));

    return ApiClient(dio, baseUrl: serviceBaseUrl);
  }

  @POST('/api/v1/ai/parse-onboarding')
  Future<List<ParsedAttributeData>> getInterestsFromOnboardingData(
      @Body() UserOnboardingData userOnboardingData,
      @Header("Accept-Language") String languageCode);

  @POST('/api/v1/ai/parse-interests')
  Future<List<ParsedAttributeData>> parseInterestsToGetOfferings(
      @Body() UserAttributesData userInterestsData,
      @Header("Accept-Language") String languageCode);

  @POST('/api/v1/ai/parse-offerings')
  Future<String> parseOfferings(
      @Body() UserAttributesData userOffersData,
      @Header("Accept-Language") String languageCode);

  @POST('/api/v1/profile-create')
  Future<String> createProfile(@Body() UserRegistrationData user);

  @POST('/api/v1/profile-update')
  Future<String> updateProfileInfo(@Body() UserProfileData user);

  @POST('/api/v1/similar-profiles')
  Future<List<PointOfInterest>> findSimilarProfiles(@Body() String userId);

  @POST('/api/v1/complementary-profiles')
  Future<List<PointOfInterest>> findComplementaryProfiles(@Body() String userId);

  @POST('/api/v1/profile-info')
  Future<UserProfileData> getProfileInfo(@Body() String userId);

  //////////// POI ENDPOINTS ////////////

  @GET('/api/v1/profiles/nearby')
  Future<List<PointOfInterest>> getPointsOfInterest(
      @Query("lat") double latitude,
      @Query("lon") double longitude,
      @Query('radius') double? radius,
      @Query('excludeUserId') String? excludeUserId
  );

  @GET('/api/v1/profiles/search')
  Future<List<PointOfInterest>> getProfilesByKeyword(
      @Query("userId") String userId,
      @Query("q") String q,
      @Query("lat") String lat,
      @Query("lon") String lon,
      @Query("radius") double? radius,
      @Query("weight") int? weight,
  );

  @GET('/pois/{id}')
  Future<PointOfInterest> getPointOfInterestById(@Path('id') String id);

  ///////////// POSTINGS ////////////

  @POST('/api/v1/postings')
  @MultiPart()
  Future<UserPostingData?> createPosting(@Part(name: 'userId') String userId,
      @Part(name: 'title') String title,
      @Part(name: 'description') String description,
      @Part(name: 'isOffer') String isOffer,
      @Part(name: 'value') String? value,
      @Part(name: 'expiresAt') int? expiresAt,
      @Part(name: 'images') List<MultipartFile>? images,);

  @GET('/api/v1/postings/{postingId}')
  Future<UserPostingData?> getPostingById(@Path('postingId') String id);

  @DELETE('/api/v1/postings/{postingId}')
  Future<void> deletePosting(@Path('postingId') String id);

  @PUT('/api/v1/postings/{postingId}')
  @MultiPart()
  Future<UserPostingData?> updatePosting(
      @Path('postingId') String id,
      @Part(name: 'userId') String userId,
      @Part(name: 'title') String title,
      @Part(name: 'description') String description,
      @Part(name: 'isOffer') String isOffer,
      @Part(name: 'value') String? value,
      @Part(name: 'expiresAt') int? expiresAt,
      @Part(name: 'images') List<MultipartFile>? images,);

  ///////////// RELATIONSHIPS ////////////

  @GET('/api/v1/relationships/{userId}')
  Future<UserRelationshipsResponse> getRelationships(
      @Path('userId') String userId);

  @POST('/api/v1/relationships/create')
  Future<void> createRelationship(
      @Body() Map<String, String> relationshipRequest);

  @POST('/api/v1/relationships/remove')
  Future<void> removeRelationship(@Body() Map<String, String> relationshipRequest);

  @GET('/api/v1/relationships/favorites/profiles/{userId}')
  Future<List<UserProfileData>> findFavoriteProfiles(@Path('userId') String userId);

  ///////////// FILE TRANSFERS ////////////

  /// Upload an encrypted file
  @POST('/chat/files/upload')
  @MultiPart()
  Future<FileUploadResponse> uploadEncryptedFile(@Part(name: 'senderId') String senderId,
      @Part(name: 'recipientId') String recipientId,
      @Part(name: 'filename') String filename,
      @Part(name: 'mimeType') String mimeType,
      @Part(name: 'ttlHours') String ttlHours,
      @Part(name: 'file') MultipartFile file,);

  /// Download an encrypted file
  @GET('/chat/files/download/{fileId}')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadEncryptedFile(@Path('fileId') String fileId,
      @Query('userId') String userId,);

  /// Get pending files for a user
  @GET('/chat/files/pending')
  Future<List<FileMetadataDto>> getPendingFiles(@Query('userId') String userId,);

  ///////////// NOTIFICATIONS ////////////

  // Get user's notification contacts | Returns UserContactsResponse wrapper
  @GET('/api/v1/notifications/contacts')
  Future<UserContactsResponse> getNotificationContacts();

  // Update user's notification contacts | Returns UserContactsResponse wrapper with updated contacts
  @PUT('/api/v1/notifications/contacts')
  Future<UserContactsResponse> updateNotificationContacts(
      @Body() UpdateUserNotificationContactsRequest request);

  /// Add push token
  @POST('/api/v1/notifications/contacts/push-tokens')
  Future<NotificationPreferencesResponse> addPushToken(
      @Body() AddPushTokenRequest request);

  /// Remove push token
  @DELETE('/api/v1/notifications/contacts/push-tokens/{token}')
  Future<NotificationPreferencesResponse> removePushToken(
      @Path('token') String token);

  /// Get all attribute preferences for user
  /// Returns AttributePreferencesListResponse with preferences list and total count
  @GET('/api/v1/notifications/attributes')
  Future<AttributePreferencesListResponse> getAllAttributePreferences();

  /// Get specific attribute preference
  /// Returns AttributePreferenceResponse wrapper
  @GET('/api/v1/notifications/attributes/{attributeId}')
  Future<AttributePreferenceResponse> getAttributePreference(
      @Path('attributeId') String attributeId);

  /// Create/update preference for specific attribute
  /// Returns AttributePreferenceResponse wrapper
  @PUT('/api/v1/notifications/attributes/{attributeId}')
  Future<AttributePreferenceResponse> updateAttributePreference(
      @Path('attributeId') String attributeId,
      @Body() UpdateAttributeNotificationPreferenceRequest request);

  /// Delete attribute preference
  @DELETE('/api/v1/notifications/attributes/{attributeId}')
  Future<NotificationPreferencesResponse> deleteAttributePreference(
      @Path('attributeId') String attributeId);

  /// Batch create (enable notifications for multiple attributes at once)
  /// Returns BatchAttributePreferencesResponse with created/skipped counts
  @POST('/api/v1/notifications/attributes/batch')
  Future<BatchAttributePreferencesResponse> batchCreateAttributePreferences(
      @Body() AttributeBatchRequest request);

  // Posting Notification Preferences

  /// Get preference for specific posting | Returns PostingPreferenceResponse wrapper
  @GET('/api/v1/notifications/postings/{postingId}')
  Future<PostingPreferenceResponse> getPostingPreference(
      @Path('postingId') String postingId);

  /// Create/update preference for posting | Returns PostingPreferenceResponse wrapper
  @PUT('/api/v1/notifications/postings/{postingId}')
  Future<PostingPreferenceResponse> updatePostingPreference(
      @Path('postingId') String postingId,
      @Body() UpdatePostingNotificationPreferenceRequest request);

  /// Delete posting preference
  @DELETE('/api/v1/notifications/postings/{postingId}')
  Future<NotificationPreferencesResponse> deletePostingPreference(
      @Path('postingId') String postingId);

  // Match History

  /// Get user's match history
  @GET('/api/v1/notifications/matches')
  Future<MatchHistoryResponse> getMatchHistory(
      @Query('unviewedOnly') bool? unviewedOnly,
      @Query('limit') int? limit);

  /// Mark match as viewed
  @POST('/api/v1/notifications/matches/{matchId}/viewed')
  Future<NotificationPreferencesResponse> markMatchViewed(
      @Path('matchId') String matchId);

  /// Dismiss match
  @POST('/api/v1/notifications/matches/{matchId}/dismiss')
  Future<NotificationPreferencesResponse> dismissMatch(@Path('matchId') String matchId);

  ///////////// MISC ///////////////

  @GET('/public-api/v1/healthCheck')
  Future<void> healthCheck();

  ///////////// AUTHENTICATION ///////////////

  @DELETE('/api/v1/authentication/user/{userId}')
  Future<void> deleteUser(@Path('userId') String userId);

}