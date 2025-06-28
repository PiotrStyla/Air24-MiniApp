# Flight Compensation App

A comprehensive Flutter application for managing flight compensation claims, supporting multiple languages and platforms.

## Features

- **Multilingual Support**: Full localization in English and Polish, with partial support for German, Spanish, French, and Portuguese
- **Cross-Platform**: Optimized for Web, Android, and iOS
- **Two-Step Verification**: Enhanced claim submission with review and confirmation process
- **Claim Management**: Create, track, and manage flight compensation claims
- **Email Integration**: Automatic airline email detection and email composition
- **User Authentication**: Secure login and profile management
- **EU Flight Regulations**: Built around EU 261/2004 regulation requirements

## Mobile-Specific Features

- **Responsive UI**: Optimized for various mobile screen sizes and orientations
- **Native Feel**: Platform-specific UI elements and behaviors
- **Offline Capability**: Store data locally and sync when connected
- **Low Resource Consumption**: Optimized for mobile battery life and memory usage
- **Push Notifications**: Claim status updates and important alerts
- **Mobile Camera Integration**: Document scanning and attachment
- **Email App Integration**: Seamless integration with device email clients

## Technical Implementation

- Flutter SDK 3.32.5
- MVVM Architecture with Provider for state management
- GetIt for dependency injection
- Flutter Localization with ARB files
- Firebase Authentication and Firestore
- Material Design components with custom theming

## Getting Started

### Prerequisites

- Flutter SDK 3.32.0 or higher
- Android Studio / VS Code with Flutter plugins
- Firebase project (for authentication and database)

### Installation

```bash
# Clone the repository
git clone https://github.com/PiotrStyla/FlightCompensation.git

# Navigate to project directory
cd f35_flight_compensation

# Get dependencies
flutter pub get

# Run the application
flutter run
```

### Mobile Deployment

For Android devices:
```bash
flutter build apk --release
```

For iOS devices:
```bash
flutter build ios --release
```

## Recent Updates

- Fixed localization issues across all screens
- Added two-step verification for claim submissions
- Improved email handling and airline detection
- Enhanced responsive design for mobile devices
