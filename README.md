# Flutter Structure Template

A comprehensive Flutter project template featuring clean architecture, BLoC state management, and modern development practices.

## 🚀 Features

- **Clean Architecture**: Domain, Data, and Presentation layers
- **BLoC State Management**: Using flutter_bloc for predictable state management
- **Dependency Injection**: Using get_it for clean dependency management
- **Navigation**: Go Router for declarative routing
- **Storage Solutions**: Hive, SharedPreferences, and Secure Storage
- **Network Layer**: Dio with interceptors and error handling
- **Theme Management**: Dynamic theming with Cubit
- **Error Handling**: Comprehensive error logging and handling
- **Internationalization**: Multi-language support ready
- **Testing**: Unit, widget, and integration test setup
- **Code Generation**: Build runner setup for code generation

## 📁 Project Structure

```
lib/
├── app/                              # 🎯 Application Layer
│   ├── app.dart                     # Main app widget (wraps with BlocProvider)
│   ├── app_config.dart              # Environment configuration
│   ├── app_initializer.dart         # App initialization (includes Bloc setup)
│   └── app_lifecycle.dart           # App lifecycle management
├── bootstrap/                        # 🚀 App Bootstrap
│   ├── bootstrap.dart               # Main bootstrap logic (runs DI, BlocObserver)
│   ├── environment_config.dart      # Environment setup
│   └── dependency_setup.dart        # DI setup (registers Blocs/Cubits)
├── core/                            # 🔧 Core Infrastructure
│   ├── architecture/                # Architecture base classes
│   ├── di/                         # Dependency Injection
│   ├── errors/                     # Error Management
│   ├── network/                    # Network Layer
│   ├── storage/                    # Storage Services
│   ├── services/                   # Core Services
│   ├── navigation/                 # Navigation System
│   ├── theme/                      # Theming System
│   ├── utils/                      # Utility Classes
│   ├── extensions/                 # Extension Methods
│   ├── mixins/                     # Reusable Mixins
│   ├── contracts/                  # Interface Contracts
│   └── bloc/                       # App-wide Bloc support
├── features/                        # 🎯 Feature Modules (Clean Architecture)
│   ├── onboarding/                 # User Onboarding
│   ├── auth/                       # Authentication & Authorization
│   ├── travel/                     # Travel Core Features (Example)
│   ├── booking/                    # Booking Management
│   ├── payment/                    # Payment Processing
│   ├── notifications/              # Notification Management
│   └── settings/                   # App Settings
├── shared/                          # 🔄 Shared Components
│   ├── components/                 # Reusable Business Components
│   ├── widgets/                    # UI Widgets
│   ├── screens/                    # Common Screens
│   ├── models/                     # Shared Models
│   └── constants/                  # Shared Constants
├── l10n/                           # 🌍 Internationalization
└── main.dart                       # 🚀 Application Entry Point
```

## 🛠️ Tech Stack

### Core
- **Flutter SDK**: ^3.8.1
- **Dart**: ^3.8.1

### State Management
- **flutter_bloc**: ^8.1.6 - BLoC pattern implementation
- **bloc**: ^8.1.4 - Core BLoC library
- **equatable**: ^2.0.5 - Value equality without boilerplate

### Dependency Injection
- **get_it**: ^8.0.0 - Service locator
- **injectable**: ^2.4.4 - Code generation for dependency injection

### Networking
- **dio**: ^5.7.0 - HTTP client
- **retrofit**: ^4.4.1 - Type-safe HTTP client
- **connectivity_plus**: ^6.0.5 - Network connectivity checking

### Storage
- **shared_preferences**: ^2.3.2 - Simple key-value storage
- **flutter_secure_storage**: ^9.2.2 - Secure storage
- **hive**: ^2.2.3 - Fast NoSQL database
- **sqflite**: ^2.3.3+2 - SQLite database

### Navigation
- **go_router**: ^14.2.7 - Declarative routing

### UI/UX
- **cached_network_image**: ^3.4.1 - Image caching
- **shimmer**: ^3.0.0 - Loading animations
- **lottie**: ^3.1.2 - Animation library
- **fl_chart**: ^0.69.0 - Chart library

### Device Features
- **permission_handler**: ^11.3.1 - Permission management
- **device_info_plus**: ^10.1.2 - Device information
- **geolocator**: ^13.0.1 - Location services
- **image_picker**: ^1.1.2 - Image selection
- **local_auth**: ^2.3.0 - Biometric authentication

### Firebase
- **firebase_core**: ^3.6.0 - Firebase core
- **firebase_analytics**: ^11.3.3 - Analytics
- **firebase_crashlytics**: ^4.1.3 - Crash reporting
- **firebase_messaging**: ^15.1.3 - Push notifications

### Development Tools
- **flutter_lints**: ^5.0.0 - Linting rules
- **very_good_analysis**: ^6.0.0 - Additional linting
- **build_runner**: ^2.4.13 - Code generation
- **logger**: ^2.4.0 - Logging

### Testing
- **bloc_test**: ^9.1.7 - BLoC testing utilities
- **mocktail**: ^1.0.4 - Mocking framework

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart 3.8.1 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd flutter_structure
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment**
   ```bash
   cp .env .env.local
   # Edit .env.local with your actual values
   ```

4. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

### Domain Layer
- **Entities**: Core business objects
- **Use Cases**: Business logic implementation
- **Repository Interfaces**: Contracts for data access

### Data Layer
- **Models**: Data transfer objects
- **Repositories**: Implementation of domain repository interfaces
- **Data Sources**: Remote and local data access

### Presentation Layer
- **BLoCs/Cubits**: State management
- **Screens**: UI pages
- **Widgets**: UI components

## 🎯 BLoC Pattern

This template uses the BLoC (Business Logic Component) pattern for state management:

### Key Concepts
- **Events**: Input to the BLoC
- **States**: Output from the BLoC
- **BLoC**: Transforms events into states
- **Cubit**: Simplified BLoC for simple state management

### Example Usage
```dart
// In your widget
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    if (state is AuthSuccess) {
      return HomeScreen();
    }
    return LoginScreen();
  },
)
```

## 🔧 Configuration

### Environment Variables
Create a `.env.local` file with your configurations:

```env
# API Configuration
API_BASE_URL=https://your-api.com
API_VERSION=v1

# Firebase
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id

# Third-party Services
GOOGLE_MAPS_API_KEY=your_maps_key
STRIPE_PUBLISHABLE_KEY=your_stripe_key
```

### Feature Implementation

To add a new feature:

1. **Create feature folder structure**
   ```
   features/your_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── blocs/
       ├── screens/
       └── widgets/
   ```

2. **Register dependencies** in `core/di/dependency_injection.dart`

3. **Add routes** in `core/navigation/app_router.dart`

4. **Create BLoC** and register in `bootstrap/dependency_setup.dart`

## 🧪 Testing

### Running Tests
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/
```

### Test Structure
- **Unit Tests**: Test business logic and use cases
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Code Generation

This project uses code generation for:

- **Injectable**: Dependency injection
- **Retrofit**: API client generation
- **JSON Serializable**: JSON serialization
- **Freezed**: Immutable data classes
- **Hive**: Database models

Run code generation:
```bash
flutter packages pub run build_runner build
# Or for watching changes
flutter packages pub run build_runner watch
```

## 🎨 Theming

The app supports dynamic theming with:
- Light theme
- Dark theme
- System theme (follows device setting)

Theme is managed by `ThemeCubit` in `core/theme/`.

## 🌍 Internationalization

The project is set up for internationalization:

1. Add translations in `lib/l10n/`
2. Generate localization files
3. Use in widgets: `context.l10n.yourStringKey`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you have any questions or need help with this template:

1. Check the [documentation](docs/)
2. Search existing [issues](https://github.com/your-repo/issues)
3. Create a new issue if needed

---

**Happy Coding! 🚀**
