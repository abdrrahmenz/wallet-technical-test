# Wallet Test - Flutter Project Summary

## 📱 Project Overview

**Wallet Test** is a Flutter application built with **Clean Architecture** principles, featuring a comprehensive JWT-based authentication system and wallet management functionality. The project follows a modular approach with strict architectural patterns and reusable component systems.

## 🏗️ Architecture & Structure

### Clean Architecture Layers
- **Presentation Layer**: UI components, pages, and BLoC state management
- **Domain Layer**: Business entities, use cases, and repository interfaces  
- **Data Layer**: Models, repository implementations, and data sources

### Key Features
- 🔐 **JWT Authentication System** (Login/Register/Logout)
- 💰 **Wallet Management** with transaction tracking
- 🎨 **Atomic Design Pattern** for reusable UI components
- 🌍 **Multi-language Support** (i18n/l10n)
- 🔄 **BLoC State Management**
- 📱 **Multi-flavor Support** (dev/staging/prod)

### Project Structure
```
lib/
├── app/                    # App configuration, routing, and DI
│   ├── app.dart           # Main app widget with providers
│   ├── config.dart        # Environment configuration
│   ├── flavor.dart        # Build flavors (dev, staging, prod)
│   ├── locator.dart       # Dependency injection setup
│   └── modules.dart       # Feature modules registration
├── core/                   # Shared utilities and components
│   ├── components/        # Reusable UI components (atomic design)
│   ├── data/             # Core data utilities
│   ├── helpers/          # Helper classes (JWT interceptor)
│   └── networks/         # Network connectivity
├── features/              # Feature modules
│   ├── auth/             # Authentication feature
│   ├── wallet/           # Wallet management
│   ├── home/             # Main navigation
│   └── settings/         # User preferences
└── l10n/                 # Localization files
```

## 🚀 How to Run the Project

### Prerequisites
- Flutter SDK (>=3.4.3)
- Dart SDK
- Android Studio/VS Code
- iOS development tools (for iOS builds)

### Installation Steps

1. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd wallet_test
   flutter pub get
   ```

2. **Generate Localization Files**
   ```bash
   flutter gen-l10n
   ```

3. **Run the Application**

   **Development Build:**
   ```bash
   flutter run --flavor dev -t lib/main_dev.dart
   ```

   **Staging Build:**
   ```bash
   flutter run --flavor stag -t lib/main_stag.dart
   ```

   **Production Build:**
   ```bash
   flutter run --flavor prod -t lib/main_prod.dart
   ```

   **Default Run (Development):**
   ```bash
   flutter run
   ```

### 🏗️ Build Commands

**Android APK:**
```bash
flutter build apk --flavor dev -t lib/main_dev.dart
flutter build apk --flavor prod -t lib/main_prod.dart
```

**iOS ❌ Not Yet Configured:**
```bash
flutter build ios --flavor dev -t lib/main_dev.dart
flutter build ios --flavor prod -t lib/main_prod.dart
```

## 🔧 Configuration

### Build Flavors
- **dev**: Development environment with debug features
- **stag**: Staging environment for testing
- **prod**: Production environment

### Key Dependencies
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `dio`: HTTP client
- `hive`: Local storage
- `flutter_easyloading`: Loading indicators
- `cached_network_image`: Image caching

## 🧪 Development Guidelines

### State Management
- Uses **BLoC pattern** with events and states
- All BLoCs are registered in `app/app.dart`

### Navigation
- Modular routing system via `app/modules.dart`
- Main navigation handled in `features/home/presentation/pages/main/page.dart`

### Styling
- Atomic design components in `core/components/`
- Use `.withAlpha()` instead of `.withOpacity()`
- Spacing via `Dimens.dpXX.width/.height`

### Error Handling
- Global error capture via `CaptureErrorUseCase`
- Comprehensive error logging and monitoring

## 📱 Entry Points

- **Main**: `lib/main.dart` → delegates to dev
- **Development**: `lib/main_dev.dart`
- **Production**: `lib/main_prod.dart`

The application initializes dependency injection via `setupLocator()` and sets up global error handling before launching the main `App` widget.

## 🔐 Authentication Features

### JWT Authentication System
- **POST /auth/register**
  - Email: string (required)
  - Password: string (required, min 8 characters)
  - Name: string (optional)

- **POST /auth/login**
  - Email: string (required)
  - Password: string (required)

### Security Features
- Automatic JWT token management
- Secure local token storage using Hive
- HTTP interceptor for automatic token injection
- Token expiration handling
- Logout with complete token cleanup

## 🎨 UI Components

### Atomic Design System
- **Atoms**: Basic UI elements (TextTitle, RegularInput, ArrowButton)
- **Molecules**: Combined atoms (SearchTextInput, DropdownInput)
- **Organisms**: Complex UI sections (CardShadow, Skeleton animations)

### Premium Design Guidelines
- Mobile-first responsive design
- Elegant spacing and typography
- Smooth animations and loading states
- Consistent color scheme with alpha transparency
