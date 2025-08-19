# Flutter Structure Template - Developer Guide

This guide will help you understand and use the Flutter Structure Template effectively.

## 📋 Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture Overview](#architecture-overview)
3. [Adding New Features](#adding-new-features)
4. [State Management with BLoC](#state-management-with-bloc)
5. [Navigation](#navigation)
6. [Storage](#storage)
7. [API Integration](#api-integration)
8. [Testing](#testing)
9. [Code Generation](#code-generation)
10. [Best Practices](#best-practices)

## 🚀 Quick Start

### 1. Setup Environment
```bash
# Copy environment file
cp .env .env.local

# Edit .env.local with your configuration
# API_BASE_URL=https://your-api.com
# FIREBASE_API_KEY=your_key
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
flutter packages pub run build_runner build
```

### 4. Run the App
```bash
flutter run
```

## 🏗️ Architecture Overview

This template follows **Clean Architecture** with three main layers:

### Domain Layer
Contains business logic and entities:
```
features/feature_name/domain/
├── entities/          # Business objects
├── repositories/      # Repository interfaces
├── usecases/         # Business logic
└── failures/         # Domain-specific errors
```

### Data Layer
Handles data access and external sources:
```
features/feature_name/data/
├── datasources/      # Remote/Local data sources
├── models/           # Data transfer objects
├── repositories/     # Repository implementations
└── mappers/          # Convert models to entities
```

### Presentation Layer
UI and state management:
```
features/feature_name/presentation/
├── blocs/            # BLoC/Cubit classes
├── screens/          # UI screens
├── widgets/          # Feature-specific widgets
└── bindings/         # Dependency injection bindings
```

## ➕ Adding New Features

### Step 1: Create Feature Structure
```bash
mkdir -p lib/features/my_feature/{data/{datasources,models,repositories,mappers},domain/{entities,repositories,usecases,failures},presentation/{blocs,screens,widgets,bindings}}
```

### Step 2: Define Domain Layer

**Entity Example:**
```dart
// lib/features/my_feature/domain/entities/my_entity.dart
class MyEntity extends Equatable {
  const MyEntity({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
```

**Repository Interface:**
```dart
// lib/features/my_feature/domain/repositories/my_repository.dart
abstract class MyRepository {
  Future<Either<Failure, List<MyEntity>>> getItems();
  Future<Either<Failure, MyEntity>> getItem(String id);
}
```

**Use Case:**
```dart
// lib/features/my_feature/domain/usecases/get_items_usecase.dart
class GetItemsUseCase {
  GetItemsUseCase(this.repository);

  final MyRepository repository;

  Future<Either<Failure, List<MyEntity>>> call() {
    return repository.getItems();
  }
}
```

### Step 3: Implement Data Layer

**Model:**
```dart
// lib/features/my_feature/data/models/my_model.dart
@JsonSerializable()
class MyModel extends Equatable {
  const MyModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory MyModel.fromJson(Map<String, dynamic> json) => 
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  MyEntity toEntity() => MyEntity(id: id, name: name);

  @override
  List<Object> get props => [id, name];
}
```

**Data Source:**
```dart
// lib/features/my_feature/data/datasources/my_remote_datasource.dart
abstract class MyRemoteDataSource {
  Future<List<MyModel>> getItems();
}

@Injectable(as: MyRemoteDataSource)
class MyRemoteDataSourceImpl implements MyRemoteDataSource {
  MyRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<MyModel>> getItems() async {
    final response = await apiClient.get('/items');
    return (response.data as List)
        .map((json) => MyModel.fromJson(json))
        .toList();
  }
}
```

### Step 4: Create BLoC

**Events:**
```dart
// lib/features/my_feature/presentation/blocs/my_event.dart
abstract class MyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadItems extends MyEvent {}
```

**States:**
```dart
// lib/features/my_feature/presentation/blocs/my_state.dart
abstract class MyState extends Equatable {
  @override
  List<Object> get props => [];
}

class MyInitial extends MyState {}
class MyLoading extends MyState {}
class MyLoaded extends MyState {
  MyLoaded(this.items);
  final List<MyEntity> items;
  
  @override
  List<Object> get props => [items];
}
class MyError extends MyState {
  MyError(this.message);
  final String message;
  
  @override
  List<Object> get props => [message];
}
```

**BLoC:**
```dart
// lib/features/my_feature/presentation/blocs/my_bloc.dart
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc(this.getItemsUseCase) : super(MyInitial()) {
    on<LoadItems>(_onLoadItems);
  }

  final GetItemsUseCase getItemsUseCase;

  Future<void> _onLoadItems(LoadItems event, Emitter<MyState> emit) async {
    emit(MyLoading());
    
    final result = await getItemsUseCase();
    
    result.fold(
      (failure) => emit(MyError(failure.message)),
      (items) => emit(MyLoaded(items)),
    );
  }
}
```

### Step 5: Register Dependencies
```dart
// In lib/core/di/dependency_injection.dart
@module
abstract class MyFeatureModule {
  @Injectable(as: MyRemoteDataSource)
  MyRemoteDataSourceImpl get myRemoteDataSource;

  @Injectable(as: MyRepository)
  MyRepositoryImpl get myRepository;

  @injectable
  GetItemsUseCase get getItemsUseCase;

  @injectable
  MyBloc get myBloc;
}
```

### Step 6: Create Screen
```dart
// lib/features/my_feature/presentation/screens/my_screen.dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyBloc>()..add(LoadItems()),
      child: Scaffold(
        appBar: AppBar(title: Text('My Feature')),
        body: BlocBuilder<MyBloc, MyState>(
          builder: (context, state) {
            if (state is MyLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is MyError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is MyLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(title: Text(item.name));
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
```

## 🎯 State Management with BLoC

### BLoC vs Cubit

**Use BLoC when:**
- Complex state management
- Multiple events trigger state changes
- Need detailed event tracking

**Use Cubit when:**
- Simple state management
- Direct method calls
- Less boilerplate needed

### BLoC Example
```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}
```

### Cubit Example
```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

## 🧭 Navigation

### Using App Router
```dart
// Navigate to a route
context.pushNamed('profile');

// Navigate with parameters
context.pushNamed('user-detail', pathParameters: {'id': '123'});

// Navigate and replace
context.goNamed('home');
```

### Programmatic Navigation
```dart
// Using navigation service
final navigationService = getIt<NavigationService>();
navigationService.pushNamed('profile');
```

## 💾 Storage

### Using Storage Manager
```dart
final storageManager = getIt<StorageManager>();

// Save regular data
await storageManager.save('user_preference', 'dark_mode');

// Save sensitive data
await storageManager.save('auth_token', token, secure: true);

// Read data
final preference = await storageManager.read<String>('user_preference');
final token = await storageManager.read<String>('auth_token', secure: true);
```

## 🌐 API Integration

### Using API Client
```dart
final apiClient = getIt<ApiClient>();

// GET request
final response = await apiClient.get<List<dynamic>>('/users');

// POST request
final response = await apiClient.post<Map<String, dynamic>>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
);
```

### Error Handling
```dart
try {
  final response = await apiClient.get('/users');
  // Handle success
} on TimeoutException catch (e) {
  // Handle timeout
} on ServerException catch (e) {
  // Handle server error
} on ConnectionException catch (e) {
  // Handle connection error
}
```

## 🧪 Testing

### Unit Testing
```dart
// test/features/my_feature/domain/usecases/get_items_usecase_test.dart
void main() {
  late GetItemsUseCase useCase;
  late MockMyRepository mockRepository;

  setUp(() {
    mockRepository = MockMyRepository();
    useCase = GetItemsUseCase(mockRepository);
  });

  test('should return items when repository call is successful', () async {
    // arrange
    final items = [MyEntity(id: '1', name: 'Test')];
    when(() => mockRepository.getItems())
        .thenAnswer((_) async => Right(items));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(items));
    verify(() => mockRepository.getItems());
  });
}
```

### BLoC Testing
```dart
// test/features/my_feature/presentation/blocs/my_bloc_test.dart
void main() {
  late MyBloc bloc;
  late MockGetItemsUseCase mockGetItemsUseCase;

  setUp(() {
    mockGetItemsUseCase = MockGetItemsUseCase();
    bloc = MyBloc(mockGetItemsUseCase);
  });

  blocTest<MyBloc, MyState>(
    'emits [MyLoading, MyLoaded] when LoadItems is successful',
    build: () {
      when(() => mockGetItemsUseCase())
          .thenAnswer((_) async => Right([MyEntity(id: '1', name: 'Test')]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadItems()),
    expect: () => [
      MyLoading(),
      MyLoaded([MyEntity(id: '1', name: 'Test')]),
    ],
  );
}
```

## 🔧 Code Generation

### Available Generators

1. **Injectable** - Dependency injection
2. **JSON Serializable** - JSON serialization
3. **Retrofit** - API client generation
4. **Freezed** - Immutable classes
5. **Hive** - Database models

### Running Code Generation
```bash
# One-time generation
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📋 Best Practices

### 1. Naming Conventions
- **Files**: snake_case
- **Classes**: PascalCase
- **Variables/Methods**: camelCase
- **Constants**: UPPER_SNAKE_CASE

### 2. Project Structure
- Keep features independent
- Use barrel exports for cleaner imports
- Group related files together

### 3. State Management
- Use BLoC for complex state logic
- Use Cubit for simple state changes
- Keep state immutable

### 4. Error Handling
- Define custom exceptions
- Use Either for error handling
- Provide meaningful error messages

### 5. Testing
- Write tests for business logic
- Mock external dependencies
- Use BLoC testing utilities

### 6. Performance
- Use const constructors
- Implement proper disposal
- Avoid rebuilding widgets unnecessarily

## 🔧 Common Tasks

### Adding a New Route
```dart
// In app_router.dart
GoRoute(
  path: '/my-route',
  name: 'my-route',
  builder: (context, state) => MyScreen(),
)
```

### Adding a New Storage Key
```dart
// In storage_keys.dart
class StorageKeys {
  static const String myKey = 'my_key';
}
```

### Adding Environment Variable
```dart
// In .env
MY_API_KEY=your_key_here

// In environment_config.dart
static String get myApiKey => dotenv.env['MY_API_KEY'] ?? '';
```

### Customizing Theme
```dart
// In app_colors.dart
static const Color myCustomColor = Color(0xFF123456);

// In app_theme.dart
// Add custom theme properties
```

This template provides a solid foundation for building scalable Flutter applications. Customize it according to your specific needs and follow the established patterns for consistency.
