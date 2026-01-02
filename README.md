# Bartering App

A peer-to-peer exchange (physical goods, skills, services, knowledge) client app for built with Flutter. 
Uses a barter backend system based on User interests/needs and offers/needs, which are semantically 
matched using an AI embedding model.
Chat and connect with others based on shared interests, skills, and location to barter services, 
share knowledge, or trade items.

Use together with [bartering_app_backend](https://github.com/martinsmelkis/bartering_app_backend).

<img width="555" height="1239" alt="Ekrānuzņēmums 2026-01-02 143619" src="https://github.com/user-attachments/assets/ed4323f5-feb7-41ef-8dec-fe30774a9772" /> <img width="554" height="1239" alt="Ekrānuzņēmums 2026-01-02 143445" src="https://github.com/user-attachments/assets/dc41a7cc-ce14-4c42-b7cd-a996062b2056" /> <img width="555" height="1239" alt="Ekrānuzņēmums 2026-01-02 143514" src="https://github.com/user-attachments/assets/2647bc81-3310-4a87-ac42-32c2207b7842" />


### Key Features

- **🗺️ Location-Based Discovery**: Interactive map interface to find barter opportunities near you.
- Search is based on embedding models, to find contextually relevant matches.
- **🔐 End-to-End Encrypted Chat**: Secure, private messaging with ECC encryption
- **👤 Rich User Profiles**: Showcase your skills, interests, and what you're looking for
- **📋 Posting System**: Create detailed offers and requests for services or items
- **🔔 Smart Notifications**: Real-time alerts for matches, messages, and opportunities
- **🔒 Privacy-First Design**: Local encrypted storage with security questions and PIN protection
- **🌐 Cross-Platform**: Runs on Android, iOS, and Web

## 🎯 Use Cases

### Service Exchange
- **Skill Trading**: Exchange language lessons for music tutoring, coding lessons for art classes
- **Professional Services**: Swap photography sessions for graphic design work, legal advice for accounting help
- **Home Services**: Trade plumbing expertise for electrical work, gardening for home repairs

### Knowledge Sharing
- **Mentorship**: Connect experienced professionals with those learning new skills
- **Study Groups**: Find partners for language exchange or academic collaboration
- **Hobby Communities**: Share expertise in crafts, cooking, photography, or any passion

### Item Trading
- **Equipment Lending**: Borrow tools, sports equipment, or specialized gear
- **Item Exchange**: Trade books, games, clothing, or household items
- **Resource Sharing**: Share access to workspaces, equipment, or facilities

### Community Building
- **Local Networks**: Build neighborhood relationships through mutual assistance
- **Special Interest Groups**: Connect with people who share niche hobbies or interests
- **Event Collaboration**: Find partners for projects, events, or creative endeavors

## 📱 Application Screens

### Authentication & Onboarding Flow
- **Initialize Screen**: App startup and authentication check
- **Welcome Screen**: Login and registration entry point
- **Onboarding Screen**: Multi-step profile setup with interests, skills, and preferences
- **Interests Screen**: Select categories and specific interests for matching
- **Offers Screen**: Define what services/items you can offer
- **Security Setup**: PIN creation and security question configuration
- **Forgot Password Screen**: Account recovery flow

### Core Application Screens
- **Map Screen** (Main Hub): 
  - Interactive OpenStreetMap interface showing nearby users and opportunities
  - Filter by interests, distance, and availability
  - Tap markers to view user profiles and postings
  - Real-time location-based matching

- **User Profile Screen**:
  - View your profile and others' profiles
  - Display interests, skills, and active postings
  - Manage personal information and preferences
  - Avatar with color-based identification

- **Chat Screen**:
  - End-to-end encrypted private messaging
  - File sharing with encryption
  - Adaptive layout for different screen sizes
  - Real-time message status and delivery confirmation
  - Media preview and download capabilities

- **Chats List Screen**:
  - Overview of all active conversations
  - Unread message indicators
  - Search and filter conversations
  - Quick access to recent chats

### Posting & Matching
- **Create Posting Screen**:
  - Create new offers (what you provide) or requests (what you seek)
  - Attach images and detailed descriptions
  - Set location and availability
  - Tag relevant interests and categories

- **Manage Postings Screen**:
  - View, edit, and delete your active postings
  - Track engagement and responses
  - Quick posting statistics

- **Match History Screen**:
  - Browse past matches and connections
  - Filter by date and interaction type
  - Review match compatibility scores

### System & Settings
- **Notifications Screen**:
  - UI Interface for different notification types
  - Match suggestions and new connection alerts
  - Message notifications and system updates
  - Activity history and engagement tracking

- **Settings Screen**:
  - Account management and preferences
  - Privacy controls and security settings
  - Notification preferences
  - Language and display options
  - Data management and export

- **Location Picker Screen**:
  - OpenStreetMap-based location selector
  - Search for addresses and places
  - Set home location and preferred search radius

## 🏗️ Architecture

### Design Pattern
The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── screens/          # UI layer (Presentation)
│   ├── *_screen/     # Feature-specific screens
│   └── cubit/        # BLoC/Cubit state management
├── services/         # Business logic layer
│   ├── api_client.dart
│   ├── crypto/       # Encryption services
│   ├── firebase_service.dart
│   └── secure_storage_service.dart
├── repositories/     # Data access layer
├── models/           # Data models and DTOs
│   ├── chat/
│   ├── postings/
│   ├── profile/
│   └── notifications/
├── data/             # Local persistence
│   └── local/        # Drift database
├── widgets/          # Reusable UI components
├── utils/            # Helper functions
└── router/           # Navigation configuration
```

### State Management
- **BLoC/Cubit Pattern**: Used throughout the app for predictable state management
- **Dependency Injection**: Injectable package for clean dependency management
- **Reactive Programming**: Stream-based communication for real-time updates

### Key Architectural Components

#### 1. **Service Layer**
- **API Client**: Retrofit-based REST API communication with the backend
- **Crypto Service**: ECC (Elliptic Curve Cryptography) for end-to-end encryption
- **Firebase Service**: Push notifications and Firebase Cloud Messaging integration
- **Secure Storage Service**: Encrypted local key storage using Flutter Secure Storage
- **Chat Notification Service**: Real-time notification handling for messages
- **Local Notification Service**: System notification management

#### 2. **Data Layer**
- **Drift Database**: Type-safe SQL database for local data persistence
- **SQLCipher Integration**: Encrypted database storage
- **Repository Pattern**: Clean abstraction over data sources
  - `UserRepository`: User profile and authentication data
  - `ChatRepository`: Message history and conversation management

#### 3. **Security Features**
- **End-to-End Encryption**: ECC-based message encryption with Perfect Forward Secrecy
- **Secure Key Management**: Keys stored in device-level secure storage
- **Certificate Pinning**: Additional protection for API communications
- **Distributed Security**: Multi-layered security architecture
- **Integrity Checker**: Code and data integrity verification
- **PIN Protection**: Optional PIN-based app access

#### 4. **Real-Time Communication**
- **WebSocket Integration**: Live chat messaging via `web_socket_channel`
- **Push Notifications**: Firebase Cloud Messaging for instant alerts
- **Background Processing**: Message queuing and synchronization

## 🛠️ Technology Stack

### Core Framework
- **Flutter 3.8+**: Cross-platform UI framework
- **Dart 3.8+**: Programming language

### State Management & Architecture
- **flutter_bloc (8.1.6)**: BLoC pattern implementation
- **injectable (2.0.0)**: Dependency injection
- **freezed_annotation (2.0.0)**: Immutable data classes
- **equatable (2.0.5)**: Value equality for objects

### Networking & API
- **retrofit (4.1.0)**: Type-safe REST client
- **dio (5.4.3)**: HTTP client with interceptors
- **web_socket_channel (3.0.3)**: WebSocket support

### Security & Encryption
- **pointycastle (3.7.3)**: Cryptographic algorithms (ECC, AES)
- **openpgp (3.3.0)**: PGP encryption support
- **flutter_secure_storage (9.0.0)**: Secure key storage
- **crypto (3.0.3)**: Cryptographic hash functions
- **jwt_decoder (2.0.1)**: JWT token handling

### Local Storage
- **drift (2.28.2)**: Type-safe SQL database
- **sqlcipher_flutter_libs (0.6.0)**: Encrypted SQLite
- **shared_preferences (2.3.3)**: Simple key-value storage

### Maps & Location
- **flutter_osm_plugin (1.4.3)**: OpenStreetMap integration
- **routing_client_dart (0.5.5)**: Route calculation

### Firebase Integration
- **firebase_core (3.6.0)**: Firebase initialization
- **firebase_messaging (15.1.3)**: Push notifications
- **firebase_auth**: User authentication

### UI & Media
- **flutter_screenutil (5.9.0)**: Responsive UI scaling
- **flutter_svg (2.0.10)**: SVG rendering
- **image_picker (1.2.1)**: Camera and gallery access
- **photo_view (0.15.0)**: Image zoom and pan
- **rive (0.13.4)**: Interactive animations
- **expandable (5.0.1)**: Expandable widgets

### Utilities
- **go_router (13.0.0)**: Declarative routing
- **intl (0.20.2)**: Internationalization
- **uuid (4.4.0)**: Unique ID generation
- **connectivity_plus (6.1.3)**: Network status monitoring
- **open_filex (4.7.0)**: File handling

### Development Tools
- **build_runner (2.7.1)**: Code generation
- **drift_dev (2.28.2)**: Database code generation
- **retrofit_generator (10.1.1)**: API client generation
- **json_serializable (6.8.0)**: JSON serialization
- **intl_utils (2.8.8)**: Localization utilities
- **flutter_launcher_icons (0.13.1)**: App icon generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / Xcode (for mobile development)
- A running instance of the Barter App backend server
- FCM Project Configuration

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/martinsmelkis/bartering_app.git
cd bartering_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add your Android/iOS/Web apps to the project
   - Download configuration files:
     - Android: `google-services.json` → `android/app/`
     - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Run FlutterFire CLI to generate `firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

4. **Configure Backend URL**
   
   Edit `lib/services/app_module.dart` and update the `serviceBaseUrl`:
   ```dart
   @Named('serviceBaseUrl')
   String get serviceBaseUrl {
     return 'http://YOUR_BACKEND_URL:PORT';
   }
   ```

5. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. **Run the app**
```bash
# For debug mode
flutter run

# For specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### Building for Production

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 🔒 Security Considerations

This application implements multiple layers of security:

- **Client-side encryption**: All messages are encrypted before transmission
- **Secure key storage**: Cryptographic keys stored in platform secure storage
- **Certificate pinning**: Prevents man-in-the-middle attacks
- **Database encryption**: Local data encrypted with SQLCipher
- **JWT authentication**: Secure token-based API authentication

**Important**: For production deployment, ensure:
- All API keys are properly secured and restricted
- Firebase security rules are properly configured
- Backend server uses HTTPS with valid certificates
- Rate limiting and abuse prevention are enabled

## 🤝 Contributing

Contributions are welcome! Please read the contributing guidelines before submitting pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

```
Copyright 2026 Barter App Contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## 🙏 Acknowledgments

- [flutter_osm_plugin](https://pub.dev/packages/flutter_osm_plugin) - OpenStreetMap integration
- Flutter and Dart communities for excellent packages and support
- OpenStreetMap contributors for map data

## 📞 Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Contact the development team

---

**Note**: This is project under development. Before deploying to production or open-sourcing, ensure all sensitive credentials are removed and security best practices are followed.
