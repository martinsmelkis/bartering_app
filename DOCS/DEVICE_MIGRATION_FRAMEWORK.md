# Device Migration Framework

## Overview

This document describes the **Secure Device Migration Framework** for the Barter App, enabling 
users to seamlessly transfer their profile data from one device to another while maintaining end-to-end encryption security.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Security Model](#security-model)
3. [Migration Flow](#migration-flow)
4. [Encryption Details](#encryption-details)
5. [Key Management](#key-management)
6. [Backend API Requirements](#backend-api-requirements)
7. [UI/UX Guidelines](#uiux-guidelines)
8. [Security Considerations](#security-considerations)
9. [Error Handling](#error-handling)

---

## Architecture Overview

### Core Principles

1. **Never Transfer Private Keys**: Private keys are generated uniquely on each device. Only public profile data is migrated.
2. **Ephemeral Encryption**: Each migration uses a one-time ephemeral key pair for ECDH key exchange.
3. **Device Binding**: Migration is tied to specific device fingerprints to prevent replay attacks.
4. **Time-Limited Sessions**: Migration sessions expire after 15 minutes.
5. **User Confirmation**: Both devices must actively participate in the migration process.

### Components

```
┌─────────────────────────────────────────────────────────────────┐
│                        SOURCE DEVICE                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐   ┌──────────────┐   ┌────────────────────┐   │
│  │ User Data    │   │ CryptoService│   │ MigrationService   │   │
│  │ (Secure      │──▶│ (Existing)   │──▶│ (NEW)              │   │
│  │  Storage)    │   │              │   │                    │   │
│  └──────────────┘   └──────────────┘   └────────────────────┘   │
│                                                  │              │
└──────────────────────────────────────────────────┼──────────────┘
                                                   │
                           Ephemeral ECDH + AES-GCM Encrypted Tunnel
                                                   │
┌──────────────────────────────────────────────────┼────────────┐
│                        TARGET DEVICE             │            │
├──────────────────────────────────────────────────┼────────────┤
│  ┌──────────────┐   ┌──────────────┐   ┌─────────▼──────────┐ │
│  │ User Data    │◄──│ CryptoService│◄──│ MigrationService   │ │
│  │ (Secure      │   │ (New Keypair)│   │ (NEW)              │ │
│  │  Storage)    │   │              │   │                    │ │
│  └──────────────┘   └──────────────┘   └────────────────────┘ │
│                                                               │
└───────────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │      BACKEND API       │
              │  (Session Coordination)│
              └────────────────────────┘
```

---

## Security Model

### Critical Security Decisions

#### 1. Private Key Handling

**❌ What We DON'T Do:**
- Transfer private keys between devices
- Encrypt private keys for transmission
- Store private keys on the backend

**✅ What We DO:**
- Generate fresh key pairs on each device
- Only migrate public profile data
- Use ephemeral keys for session encryption

#### 2. Ephemeral Key Exchange

```
Source Device:                    Target Device:
  ephemeral_keypair                 ephemeral_keypair
  (priv_A, pub_A)                   (priv_B, pub_B)

       ┌─────────────────────────────────────┐
       │ ECDH Key Agreement:                 │
       │ shared_secret = ECDH(priv_A, pub_B) │
       │                                     │
       │ shared_secret = ECDH(priv_B, pub_A) │
       └─────────────────────────────────────┘
                  ↓
       Symmetric Key Derivation (HKDF-SHA256)
                  ↓
       AES-256-GCM Encryption Key
```

#### 3. Signature Verification

All migration payloads are signed with the source device's **main signing key** (not the ephemeral key) to ensure authenticity.

---

## Migration Flow

### Phase 1: Initiation (Source Device)

```dart
// User selects "Migrate to New Device"
final result = await migrationService.initiateMigration();

if (result.success) {
  // Display 10-character code to user
  // Example: "Your migration code: X7B9K2M4P1"
  showDialog(
    title: "Migration Code",
    content: "Enter this code on your new device: ${result.sessionId}",
    expiresAt: result.expiresAt, // 15 minutes
  );
}
```

**Steps:**
1. User opens settings → "Migrate Account"
2. Service generates ephemeral ECDH key pair
3. 10-character alphanumeric session ID generated
4. Session stored locally with 15-minute expiry
5. Code displayed to user

### Phase 2: Join (Target Device)

```dart
// User enters migration code
final result = await migrationService.joinMigrationSession(
  enteredSessionId, // "X7B9K2M4P1"
);

if (result.success) {
  // Display confirmation to source device
  showConfirmationDialog(
    sourceDevice: result.sourceDeviceId,
    userId: result.userId,
  );
}
```

**Steps:**
1. User opens app → "Import Account"
2. Enters the 10-character session ID
3. Target generates its own ephemeral key pair
4. Target registers with backend API
5. Backend queues request, notifies source device

### Phase 3: Confirmation (Source Device)

```
Source Device Screen:
┌──────────────────────────────────────┐
│  📱 New Device Detected             │
│                                      │
│  A new device wants to import        │
│  your profile data:                  │
│                                      │
│  Device: iPhone 14 (Target Device)   │
│  Time: 2026-02-11 10:45              │
│                                      │
│  [ ❌ Deny ]      [ ✅ Allow ]       │
└──────────────────────────────────────┘
```

### Phase 4: Transfer

```dart
// Source device prepares payload
if (userConfirmed) {
  final payload = await migrationService.prepareMigrationPayload(
    targetDeviceId: targetDeviceId,
    targetPublicKey: targetPublicKey,
  );
  
  // Send to backend for relay to target
  await apiClient.sendMigrationPayload(payload);
}
```

**Data Structure:**
```json
{
  "userId": "user_abc123",
  "userName": "John Doe",
  "location": "New York, USA",
  "interests": [...],
  "offerings": [...],
  "profileKeywordDataMap": {...},
  "publicKey": "base64_public_key_for_reference",
  "timestamp": "2026-02-11T10:45:00Z",
  "deviceFingerprint": "hash_of_source_device"
}
```

### Phase 5: Reception (Target Device)

```dart
// Target device receives encrypted payload
final result = await migrationService.receiveMigrationData(encryptedPayload);

if (result.success) {
  // Import data to secure storage
  await userRepository.saveImportedData(result.data);
  
  // Generate new keypair for this device
  await cryptoService.generateNewKeypair();
  
  // Show success, navigate to home screen
  navigateToHomeScreen();
}
```

---

## Encryption Details

### Cipher Suite

| Component | Algorithm | Parameters |
|-----------|-----------|------------|
| Key Exchange | ECDH | P-256 (secp256r1) |
| Key Derivation | HKDF | SHA-256 |
| Symmetric Encryption | AES | 256-bit, GCM mode |
| Authentication Tag | GCM | 128-bit |
| IV Size | 96-bit | 12 bytes |
| Salt Size | 128-bit | 16 bytes |

### Payload Structure

```
Encrypted Payload:
┌────────────────────────────────────────────────────────────────┐
│ Salt (16 bytes) │ IV (12 bytes) │ Ciphertext + Auth Tag     │
└────────────────────────────────────────────────────────────────┘

Metadata (sent separately):
┌────────────────────────────────────────────────────────────────┐
│ session_id      │ "X7B9K2M4P1"                                │
│ ephemeral_pubkey│ base64 ephemeral ECDH public key              │
│ signature       │ ECDSA-SHA256 signature of encrypted payload   │
│ source_device_id│ Hash identifying source device                │
│ target_device_id│ Hash identifying target device                │
└────────────────────────────────────────────────────────────────┘
```

### Key Derivation

```
// 1. ECDH shared secret
shared_secret = ECDH(ephemeral_private_key, recipient_ephemeral_public_key)

// 2. HKDF key derivation
encryption_key = HKDF-SHA256(
    ikm: shared_secret,
    salt: random_16_bytes,
    info: "BarterApp Migration Key v1",
    length: 32 bytes
)

// 3. AES-GCM encryption
encrypted_data = AES-GCM-256(
    key: encryption_key,
    iv: random_12_bytes,
    plaintext: json_serialized_user_data,
    associated_data: ""
)
```

---

## Key Management

### Device Key Lifecycle

```
SOURCE DEVICE                    TARGET DEVICE
─────────────                    ─────────────
│                                │
│  1. MAIN KEYPAIR               │  1. Generate NEW keypair
│     (existing)                 │     (for this device only)
│                                │
│  2. EPHEMERAL KEYPAIR (temp)   │  2. EPHEMERAL KEYPAIR (temp)
│     - Generated for session    │     - Generated for session
│     - Used for ECDH            │     - Used for ECDH
│     - Deleted after session    │     - Deleted after session
│                                │
│  3. Keep MAIN KEYPAIR          │  3. Keep NEW KEYPAIR
│     (device continues          │     (becomes this device's identity)
│      operations)
│                                │
└────────────────────────────────┘
```

### Session Key Storage

```dart
// Ephemeral keys stored temporarily:
Key: "migration_nonce_{sessionId}_priv" → Ephemeral private key (hex)
Key: "migration_nonce_{sessionId}_pub"  → Ephemeral public key (base64)

// Auto-deleted after:
// - Successful migration
// - Session expiry (15 minutes)
// - Manual cleanup
```

---

## Backend API Requirements

### Required Endpoints

#### 1. `POST /api/migration/target`

Registers a target device for a migration session.

**Request:**
```json
{
  "session_id": "X7B9K2M4P1",
  "target_device_id": "hash_of_target",
  "target_public_key": "base64_ephemeral_pub_key"
}
```

**Response:**
```json
{
  "success": true,
  "source_device_id": "hash_of_source",
  "user_id": "user_abc123",
  "requires_confirmation": true
}
```

#### 2. `GET /api/migration/public-key`

Retrieves a device's signing public key for verification.

**Query Parameters:**
- `session_id` (string): Session identifier
- `device_id` (string): Device to query

**Response:**
```json
{
  "success": true,
  "public_key": "base64_signing_pub_key"
}
```

#### 3. `POST /api/migration/payload`

Relays encrypted migration payload from source to target.

**Request:**
```json
{
  "session_id": "X7B9K2M4P1",
  "encrypted_payload": {
    "encrypted_data": "base64_encrypted_data",
    "ephemeral_public_key": "base64_ephemeral_pub",
    "signature": "base64_ecdsa_signature",
    "source_device_id": "hash",
    "target_device_id": "hash",
    "session_id": "X7B9K2M4P1"
  }
}
```

**Response:**
```json
{
  "success": true
}
```

#### 4. `POST /api/migration/complete`

Confirms successful migration and invalidates session.

**Request:**
```json
{
  "session_id": "X7B9K2M4P1",
  "target_device_id": "hash_of_target"
}
```

**Response:**
```json
{
  "success": true
}
```

### Backend Responsibilities

1. **Session Management**: Store and track migration sessions
2. **Device Binding**: Validate device fingerprints
3. **Rate Limiting**: Prevent brute-force session ID attempts
4. **Expiration**: Auto-cleanup expired sessions
5. **Payload Relay**: Temporarily store encrypted payloads (max 5 min)
6. **Audit Logging**: Log migration events (not data content)

---

## UI/UX Guidelines

### Source Device Flow

```
Settings → Account → Migrate Device
            ↓
[Show Spinner: Generating secure migration...]
            ↓
┌──────────────────────────────────────────┐
│  🔐 Migration Code                       │
│                                          │
│  Enter this code on your new device:     │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │     X 7 B 9 K 2 M 4 P 1           │  │
│  └────────────────────────────────────┘  │
│                                          │
│  ⏱️ Expires in 14:59                     │
│                                          │
│  [ Copy ]  [ Share ]                     │
└──────────────────────────────────────────┘
            ↓
[Waiting for target device...]
            ↓
┌──────────────────────────────────────────┐
│  📱 New Device Request                   │
│                                          │
│  Device: iPhone 14                       │
│  Location: New York, USA                 │
│                                          │
│  Allow this device to access your data?  │
│                                          │
│  [ ❌ Deny ]    [ ✅ Allow ]             │
└──────────────────────────────────────────┘
            ↓
[Transferring data securely...]
            ↓
✅ Migration Complete!
```

### Target Device Flow

```
Welcome → Import Existing Account
            ↓
┌──────────────────────────────────────────┐
│  📥 Import Account                       │
│                                          │
│  Enter the migration code from your      │
│  other device:                           │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │  [X] [7] [B] [9] [K] [2] [4] [1] │  │
│  └────────────────────────────────────┘  │
│                                          │
│  [ Request Data ]                        │
└──────────────────────────────────────────┘
            ↓
[Contacting source device...]
            ↓
[Receiving and decrypting data...]
            ↓
✅ Account imported successfully!
[Continue to Home]
```

---

## Security Considerations

### Threat Model

| Threat | Mitigation |
|--------|------------|
| Session ID brute force | 10-character code = 36^10 possibilities, rate limiting on API |
| Man-in-the-middle | ECDH key exchange, ephemeral keys per session |
| Replay attacks | Device fingerprint binding, timestamp validation |
| Stolen session ID | Short expiry (15 min), requires source confirmation |
| Backend compromise | End-to-end encryption, backend never sees plaintext |
| Device impersonation | Signature verification with device-specific keys |

### Additional Protections

1. **Rate Limiting**: Max 5 attempts per session ID
2. **Device Validation**: Both devices must pass DeviceValidationService checks
3. **Session Expiry**: Automatic cleanup after 15 minutes
4. **One-Time Use**: Each session ID can only be used once
5. **Audit Trail**: Log events without sensitive data exposure

---

## Error Handling

### Common Errors

| Error | Cause | User Action |
|-------|-------|-------------|
| Session expired | >15 minutes passed | Generate new code |
| Invalid session ID | Wrong code entered | Try again |
| Source denied | User rejected on source | Contact device owner |
| Network failure | Connectivity issue | Retry |
| Device validation fail | Emulator/simulator detected | Use physical device |
| Decryption failure | Data tampering detected | Retry or generate new code |

### Recovery Flow

```dart
if (result.errorMessage?.contains('expired') == true) {
  showDialog(
    title: 'Migration Expired',
    content: 'The migration code has expired. Please generate a new one.',
    actions: [
      Button('Generate New Code', onTap: restartMigration),
    ],
  );
}
```

---

## Implementation Checklist

### Phase 1: Backend
- [ ] Implement migration session API endpoints
- [ ] Add rate limiting and validation
- [ ] Setup ephemeral payload relay
- [ ] Add device fingerprint validation
- [ ] Create audit logging

### Phase 2: Frontend (Source Device)
- [ ] Add "Migrate Device" button to settings
- [ ] Implement session initiation flow
- [ ] Add confirmation dialog
- [ ] Handle payload preparation

### Phase 3: Frontend (Target Device)
- [ ] Add "Import Account" to onboarding
- [ ] Implement session joining
- [ ] Add migration code input
- [ ] Handle data reception and import

### Phase 4: Testing
- [ ] Test happy path migration
- [ ] Test error scenarios
- [ ] Test security boundaries
- [ ] Performance testing with large profiles

---

## Questions?

For technical details, see:
- `lib/services/device_migration_service.dart` - Full implementation
- `lib/services/crypto/crypto_service.dart` - Cryptographic primitives
- `lib/services/secure_storage_service.dart` - Local data storage

For API specifications, see backend documentation.
