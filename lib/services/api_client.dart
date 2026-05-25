import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:barter_app/configure_dependencies.dart';
import 'package:barter_app/models/chat/file_metadata_dto.dart';
import 'package:barter_app/models/chat/file_upload_response.dart';
import 'package:barter_app/models/notifications/notification_models.dart';
import 'package:barter_app/models/postings/posting_data_response.dart';
import 'package:barter_app/models/profile/user_consent_update_request.dart';
import 'package:barter_app/models/profile/user_profile_data.dart';
import 'package:barter_app/models/relationships/user_relationships_response.dart';
import 'package:barter_app/models/reviews/reputation_response.dart';
import 'package:barter_app/models/reviews/review_eligibility.dart';
import 'package:barter_app/models/reviews/review_response.dart';
import 'package:barter_app/models/reviews/review_submission.dart';
import 'package:barter_app/models/reviews/transaction_response.dart';
import 'package:barter_app/models/user/parsed_attribute_data.dart';
import 'package:barter_app/models/user/user_attributes_data.dart';
import 'package:barter_app/models/user/user_onboarding_data.dart';
import 'package:barter_app/models/user/user_registration_data.dart';
import 'package:barter_app/models/wallet/wallet_models.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart' as pc;
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart' as pc;
import 'package:pointycastle/export.dart' as pc;
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/auth/device_management_models.dart';
import '../models/map/point_of_interest.dart';
import '../repositories/user_repository.dart';
import 'crypto/crypto_service.dart';
import 'interceptors/review_risks_interceptor.dart';

part 'api_client.g.dart';

@injectable
@RestApi() // Base URL can be set here or when creating Dio instance
abstract class ApiClient {
  static String? _serviceBaseUrl;
  static String get serviceBaseUrl {
    _serviceBaseUrl ??= kIsWeb ?
      dotenv.env['SERVICE_BASE_URL_WEB'] ?? 'http://localhost:8081'
    :
      dotenv.env['SERVICE_BASE_URL_MOBILE'] ?? 'http://10.0.2.2:8081';
    ;
    return _serviceBaseUrl!;
  }
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // --- Static method to create an instance, allowing mock switching ---
  @factoryMethod
  static ApiClient create() {
    final dio = Dio();

    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        // Allow invalid certificates only in debug/profile builds for local dev.
        if (!kReleaseMode) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        }
        return client;
      };
    }

    dio.options.connectTimeout = Duration(seconds: 10);
    // Add interceptors for logging, auth, etc. if needed
    if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }
    dio.interceptors.add(ReviewRiskTrackingInterceptor());
    dio.interceptors.add(InterceptorsWrapper(

       onRequest:(options, handler) async {

         final isPublicAccountDeletionEndpoint =
             options.path == '/api/v1/authentication/account-deletion/request' ||
             options.path == '/api/v1/authentication/account-deletion/confirm';

         if (options.path.startsWith('/api/') && !isPublicAccountDeletionEndpoint) {
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

  @POST('/api/v1/profile-consent-update')
  Future<void> updateUserConsent(
      @Body() UserConsentUpdateRequest request);

  @GET('/api/v1/similar-profiles')
  Future<List<PointOfInterest>> findSimilarProfiles(
      @Query("userId") String userId,
      @Query("lat") double? latitude,
      @Query("lon") double? longitude,
      @Query('radius') double? radius,
  );

  @GET('/api/v1/complementary-profiles')
  Future<List<PointOfInterest>> findComplementaryProfiles(
      @Query("userId") String userId,
      @Query("lat") double? latitude,
      @Query("lon") double? longitude,
      @Query('radius') double? radius,
  );

  @POST('/api/v1/profile-info')
  Future<UserProfileData> getProfileInfo(@Body() String userId);

  @POST('/api/v1/profile-info-extended')
  Future<PointOfInterest> getProfileInfoExtended(@Body() String userId);

  //////////// POI ENDPOINTS ////////////

  @GET('/api/v1/profiles/nearby')
  Future<List<PointOfInterest>> getPointsOfInterest(
      @Query("lat") double latitude,
      @Query("lon") double longitude,
      @Query('radius') double? radius,
      @Query('excludeUserId') String? excludeUserId
  );

  @GET('/api/v1/profiles/nearby')
  Future<List<PointOfInterest>> getPointsOfInterestNoGeo(
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
      @Query("seeking") String? seeking,
      @Query("offering") String? offering,
  );

  @GET('/api/v1/profiles/search')
  Future<List<PointOfInterest>> getProfilesByKeywordNoGeo(
      @Query("userId") String userId,
      @Query("q") String q,
      @Query("weight") int? weight,
      @Query("seeking") String? seeking,
      @Query("offering") String? offering,
  );

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

  ///////////// BLOCKING & REPORTING ////////////

  @POST('/api/v1/users/block')
  Future<String> blockUser(@Body() Map<String, dynamic> request);

  @POST('/api/v1/users/unblock')
  Future<String> unblockUser(@Body() Map<String, dynamic> request);

  @GET('/api/v1/users/isBlocked')
  Future<bool> isUserBlocked(
      @Query('fromUserId') String fromUserId,
      @Query('toUserId') String toUserId);

  @GET('/api/v1/users/blocked/{userId}')
  Future<List<UserProfileData>> getBlockedUsers(@Path('userId') String userId);

  @POST('/api/v1/reports/create')
  Future<String> createReport(@Body() Map<String, dynamic> request);

  @GET('/api/v1/reports/check')
  Future<bool> checkReport(
      @Query('reporterUserId') String reporterUserId,
      @Query('reportedUserId') String reportedUserId);

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

  /// Public unsubscribe endpoint used by email deep links
  @GET('/api/v1/notifications/unsubscribe')
  Future<NotificationPreferencesResponse> unsubscribeFromEmails(
      @Query('token') String token);

  /// Remove push token
  @DELETE('/api/v1/notifications/contacts/push-tokens/{token}')
  Future<NotificationPreferencesResponse> removePushToken(
      @Path('token') String token);

  /// Read nearby users alert state
  @GET('/api/v1/notifications/nearby-users-alert')
  Future<Map<String, dynamic>> getNearbyUsersAlert();

  /// Create/update nearby users alert
  @POST('/api/v1/notifications/nearby-users-alert')
  Future<Map<String, dynamic>> createOrUpdateNearbyUsersAlert(
      @Body() Map<String, dynamic> request);

  /// Enable/disable nearby users alert
  @PATCH('/api/v1/notifications/nearby-users-alert')
  Future<Map<String, dynamic>> updateNearbyUsersAlert(
      @Body() Map<String, dynamic> request);

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

  // Transaction Endpoints

  /// Create a new barter transaction between two users
  /// Returns CreateTransactionResponse with success status and transaction ID
  @POST('/api/v1/transactions/create')
  Future<CreateTransactionResponse> createTransaction(
      @Body() CreateTransactionRequest request);

  /// Update transaction status (e.g., mark as "done")
  /// Valid statuses: pending, done, cancelled, expired, no_deal, scam, disputed
  /// Returns SuccessResponse
  @PUT('/api/v1/transactions/{id}/status')
  Future<SuccessResponse> updateTransactionStatus(
      @Path('id') String transactionId,
      @Body() UpdateTransactionStatusRequest request);

  // Reviews API
  
  /// Check if user can review another user (for conversation deletion flow)
  /// Returns ReviewEligibilityResponse with eligibility status and transaction info
  @GET('/api/v1/reviews/eligibility/{userId}/with/{otherUserId}')
  Future<ReviewEligibilityResponse> checkReviewEligibility(
      @Path('userId') String userId,
      @Path('otherUserId') String otherUserId);

  /// Submit a review for a completed transaction
  /// Request body should include: transactionId, reviewerId, targetUserId, 
  /// rating (1-5), reviewText (optional, max 500 chars), transactionStatus
  /// Returns SubmitReviewResponse with success status and review ID
  @POST('/api/v1/reviews/submit')
  Future<SubmitReviewResponse> submitReview(@Body() SubmitReviewRequest reviewRequest);

  /// Submit an appeal for an existing review
  /// Request body should include: reviewId, appealedBy, reason, evidenceItems (optional)
  /// Returns SubmitReviewAppealResponse with success status and appeal ID
  @POST('/api/v1/reviews/appeal')
  Future<SubmitReviewAppealResponse> submitReviewAppeal(
      @Body() SubmitReviewAppealRequest appealRequest);

  /// Get all visible reviews for a user
  /// Returns UserReviewsResponse with reviews list, totalCount, and averageRating
  @GET('/api/v1/reviews/user/{userId}')
  Future<UserReviewsResponse> getUserReviews(@Path('userId') String userId);

  // Reputation Endpoints
  
  /// Get comprehensive reputation score for a user
  /// Returns ReputationResponse with averageRating, totalReviews, trustLevel, badges, etc.
  @GET('/api/v1/reputation/{userId}')
  Future<ReputationResponse> getReputation(@Path('userId') String userId);

  /// Get detailed badge information for a user
  /// Returns UserBadgesResponse with list of earned badges
  @GET('/api/v1/reputation/{userId}/badges')
  Future<UserBadgesResponse> getUserBadges(@Path('userId') String userId);

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

  @DELETE('/api/v1/notifications/matches')
  Future<NotificationPreferencesResponse> deleteAllMatches();

  ///////////// AUTHENTICATION ///////////////

  @DELETE('/api/v1/authentication/user/{userId}')
  Future<void> deleteUser(@Path('userId') String userId);

  /// Public endpoint: request account deletion by email
  @POST('/api/v1/authentication/account-deletion/request')
  Future<AccountDeletionByEmailResponse> requestAccountDeletionByEmail(
    @Body() Map<String, dynamic> request,
  );

  /// Public endpoint: confirm account deletion using email link token
  @POST('/api/v1/authentication/account-deletion/confirm')
  Future<AccountDeletionByEmailResponse> confirmAccountDeletionByToken(
    @Body() Map<String, dynamic> request,
  );

  /// Request GDPR data export for authenticated user
  @POST('/api/v1/profile/export-data')
  Future<ExportResult> requestGdprDataExport();

  ///////////// DEVICE MIGRATION ///////////////

  /// Initiates a device-to-device migration session (source device)
  @POST('/api/v1/migration/device/initiate')
  Future<InitiateMigrationResponse> initiateDeviceMigration(
    @Body() Map<String, dynamic> request,
  );

  /// Registers a target device for a migration session
  @POST('/api/v1/migration/device/target')
  Future<RegisterMigrationTargetResponse> registerMigrationTarget(
    @Body() Map<String, dynamic> request,
  );

  /// Sends encrypted migration payload from source device
  @POST('/api/v1/migration/device/payload')
  Future<ConfirmMigrationResponse> sendMigrationPayload(
    @Body() Map<String, dynamic> request,
  );

  /// Retrieves the encrypted migration payload (for target device)
  @GET('/api/v1/migration/payload')
  Future<EncryptedMigrationPayloadResponse> getMigrationPayload(
    @Query('sessionId') String sessionId,
  );

  /// Completes migration and registers the new device
  @POST('/api/v1/migration/complete')
  Future<CompleteMigrationResponse> completeMigration(
    @Body() Map<String, dynamic> request,
  );

  /// Gets migration session status (for polling)
  @GET('/api/v1/migration/status')
  Future<MigrationStatusResponse> getMigrationStatus(
    @Query('sessionId') String sessionId,
  );

  /// Cancels an active migration session
  @POST('/api/v1/migration/cancel')
  Future<CancelMigrationResponse> cancelMigration(
    @Body() Map<String, dynamic> request,
  );

  ///////////// EMAIL RECOVERY ///////////////

  /// Initiates email recovery when source device is broken/lost
  @POST('/api/v1/migration/recovery/initiate')
  Future<InitiateRecoveryResponse> initiateEmailRecovery(
    @Body() Map<String, dynamic> request,
  );

  /// Verifies recovery code sent via email
  @POST('/api/v1/migration/recovery/verify')
  Future<VerifyRecoveryCodeResponse> verifyRecoveryCode(
    @Body() Map<String, dynamic> request,
  );

  ///////////// WALLET ///////////////

  /// Get wallet summary for authenticated user
  @GET('/api/v1/wallet')
  Future<WalletResponse> getWallet();

  /// Get wallet transactions for authenticated user
  @GET('/api/v1/wallet/transactions')
  Future<List<WalletTransactionResponse>> getWalletTransactions(
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  /// Transfer coins between users
  @POST('/api/v1/wallet/transfer')
  Future<WalletOperationResponse> transferCoins(
    @Body() TransferCoinsRequest request,
  );

  /// Claim wallet award for a user
  @POST('/api/v1/wallet/awards/claim')
  Future<ClaimAwardResponse> claimWalletAward(
    @Body() ClaimAwardRequest request,
  );

  ///////////// PURCHASES ///////////////

  /// Force immediate premium sync from RevenueCat for authenticated user
  @POST('/api/v1/purchases/premium/sync-now')
  Future<void> syncPremiumNow();

  /// Get premium status for authenticated user
  @GET('/api/v1/purchases/premium/status')
  Future<PremiumStatusResponse> getPremiumStatus();

  /// Get purchase history for authenticated user
  @GET('/api/v1/purchases/history')
  Future<List<PurchaseResponse>> getPurchaseHistory(
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  /// Purchase premium lifetime plan
  @POST('/api/v1/purchases/premium/lifetime')
  Future<PurchaseOperationResponse> purchasePremiumLifetime(
    @Body() PurchasePremiumLifetimeRequest request,
  );

  /// Purchase a coin pack
  @POST('/api/v1/purchases/coins')
  Future<PurchaseOperationResponse> purchaseCoinPack(
    @Body() PurchaseCoinPackRequest request,
  );

  /// Purchase a visibility boost
  @POST('/api/v1/purchases/boosts/visibility')
  Future<PurchaseOperationResponse> purchaseVisibilityBoost(
    @Body() PurchaseVisibilityBoostRequest request,
  );

  /// Purchase an avatar icon unlock
  @POST('/api/v1/purchases/avatar-icon')
  Future<PurchaseOperationResponse> purchaseAvatarIcon(
    @Body() PurchaseAvatarIconRequest request,
  );

  /// Get avatar icon ownership status for authenticated user
  @GET('/api/v1/purchases/avatar-icons')
  Future<AvatarIconOwnershipStatusResponse> getAvatarIconOwnershipStatus();

  /// Equip avatar icon for authenticated user
  @POST('/api/v1/profile/avatar/equip')
  Future<EquipAvatarIconResponse> equipAvatarIcon(
    @Body() EquipAvatarIconRequest request,
  );

  ///////////// DEVICE MANAGEMENT ///////////////

  /// Registers a new device for the authenticated user
  @POST('/api/v1/devices/register')
  Future<RegisterDeviceResponse> registerDevice(
    @Body() Map<String, dynamic> request,
  );

  /// Lists all devices for the authenticated user
  @GET('/api/v1/devices')
  Future<UserDevicesResponse> getUserDevices();

  /// Revokes/deactivates a device
  @POST('/api/v1/devices/revoke')
  Future<RevokeDeviceResponse> revokeDevice(
    @Body() Map<String, dynamic> request,
  );

  /// Updates device information (name, etc.)
  @POST('/api/v1/devices/update')
  Future<UpdateDeviceResponse> updateDevice(
    @Body() Map<String, dynamic> request,
  );

  ///////////// MISC ///////////////

  @GET('/public-api/v1/healthCheck')
  Future<void> healthCheck();

}