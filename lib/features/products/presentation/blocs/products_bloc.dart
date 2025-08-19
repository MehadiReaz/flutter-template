import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsLoadRequested extends ProductsEvent {
  const ProductsLoadRequested();
}

class ProductsLoadMore extends ProductsEvent {
  const ProductsLoadMore();
}

class ProductsSearchRequested extends ProductsEvent {
  const ProductsSearchRequested({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

class ProductsRefreshRequested extends ProductsEvent {
  const ProductsRefreshRequested();
}

// States
abstract class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.searchQuery = '',
  });

  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;
  final String searchQuery;

  @override
  List<Object> get props => [products, hasReachedMax, currentPage, searchQuery];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading({
    super.products,
    super.hasReachedMax,
    super.currentPage,
    super.searchQuery,
  });
}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required super.products,
    super.hasReachedMax,
    super.currentPage,
    super.searchQuery,
  });
}

class ProductsError extends ProductsState {
  const ProductsError({
    required this.message,
    super.products,
    super.hasReachedMax,
    super.currentPage,
    super.searchQuery,
  });

  final String message;

  @override
  List<Object> get props => [
    message,
    products,
    hasReachedMax,
    currentPage,
    searchQuery,
  ];
}

// Product Model
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    this.category,
    this.rating,
    this.stock = 0,
    this.isActive = true,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final String? category;
  final double? rating;
  final int stock;
  final bool isActive;

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    description,
    imageUrl,
    category,
    rating,
    stock,
    isActive,
  ];

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    String? category,
    double? rating,
    int? stock,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
    );
  }
}

// BLoC
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(const ProductsInitial()) {
    on<ProductsLoadRequested>(_onProductsLoadRequested);
    on<ProductsLoadMore>(_onProductsLoadMore);
    on<ProductsSearchRequested>(_onProductsSearchRequested);
    on<ProductsRefreshRequested>(_onProductsRefreshRequested);
  }

  static const int _pageSize = 10;

  Future<void> _onProductsLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      ProductsLoading(
        products: state.products,
        hasReachedMax: state.hasReachedMax,
        currentPage: state.currentPage,
        searchQuery: state.searchQuery,
      ),
    );

    try {
      final products = await _fetchProducts(page: 1, query: state.searchQuery);

      emit(
        ProductsLoaded(
          products: products,
          hasReachedMax: products.length < _pageSize,
          currentPage: 1,
          searchQuery: state.searchQuery,
        ),
      );
    } catch (e) {
      emit(
        ProductsError(
          message: e.toString(),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
          searchQuery: state.searchQuery,
        ),
      );
    }
  }

  Future<void> _onProductsLoadMore(
    ProductsLoadMore event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    emit(
      ProductsLoading(
        products: state.products,
        hasReachedMax: state.hasReachedMax,
        currentPage: state.currentPage,
        searchQuery: state.searchQuery,
      ),
    );

    try {
      final newProducts = await _fetchProducts(
        page: state.currentPage + 1,
        query: state.searchQuery,
      );

      emit(
        ProductsLoaded(
          products: [...state.products, ...newProducts],
          hasReachedMax: newProducts.length < _pageSize,
          currentPage: state.currentPage + 1,
          searchQuery: state.searchQuery,
        ),
      );
    } catch (e) {
      emit(
        ProductsError(
          message: e.toString(),
          products: state.products,
          hasReachedMax: state.hasReachedMax,
          currentPage: state.currentPage,
          searchQuery: state.searchQuery,
        ),
      );
    }
  }

  Future<void> _onProductsSearchRequested(
    ProductsSearchRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(
      ProductsLoading(
        products: const [],
        hasReachedMax: false,
        currentPage: 1,
        searchQuery: event.query,
      ),
    );

    try {
      final products = await _fetchProducts(page: 1, query: event.query);

      emit(
        ProductsLoaded(
          products: products,
          hasReachedMax: products.length < _pageSize,
          currentPage: 1,
          searchQuery: event.query,
        ),
      );
    } catch (e) {
      emit(
        ProductsError(
          message: e.toString(),
          products: const [],
          hasReachedMax: false,
          currentPage: 1,
          searchQuery: event.query,
        ),
      );
    }
  }

  Future<void> _onProductsRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsInitial());
    add(const ProductsLoadRequested());
  }

  // Mock API call - replace with actual API service
  Future<List<Product>> _fetchProducts({
    required int page,
    String query = '',
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock products data
    final allProducts = _generateMockProducts();

    // Filter by search query if provided
    List<Product> filteredProducts = allProducts;
    if (query.isNotEmpty) {
      filteredProducts = allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    // Paginate results
    final startIndex = (page - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;

    if (startIndex >= filteredProducts.length) {
      return [];
    }

    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  List<Product> _generateMockProducts() {
    return List.generate(50, (index) {
      final categories = ['Electronics', 'Clothing', 'Home', 'Books', 'Sports'];
      final category = categories[index % categories.length];

      return Product(
        id: 'product_${index + 1}',
        name: _getProductName(category, index),
        price: 19.99 + (index * 15.0),
        description:
            'High-quality $category product with excellent features and great value for money.',
        imageUrl: 'https://picsum.photos/300/300?random=${index + 1}',
        category: category,
        rating: 3.5 + (index % 3),
        stock: 10 + (index % 20),
      );
    });
  }

  String _getProductName(String category, int index) {
    switch (category) {
      case 'Electronics':
        final products = [
          'Smartphone',
          'Laptop',
          'Headphones',
          'Tablet',
          'Camera',
        ];
        return '${products[index % products.length]} Pro ${index + 1}';
      case 'Clothing':
        final products = ['T-Shirt', 'Jeans', 'Sneakers', 'Jacket', 'Dress'];
        return 'Premium ${products[index % products.length]} ${index + 1}';
      case 'Home':
        final products = [
          'Coffee Maker',
          'Vacuum Cleaner',
          'Lamp',
          'Chair',
          'Table',
        ];
        return 'Modern ${products[index % products.length]} ${index + 1}';
      case 'Books':
        final products = [
          'Novel',
          'Cookbook',
          'Biography',
          'Textbook',
          'Comic',
        ];
        return 'Best-selling ${products[index % products.length]} ${index + 1}';
      case 'Sports':
        final products = [
          'Basketball',
          'Tennis Racket',
          'Running Shoes',
          'Yoga Mat',
          'Dumbbell',
        ];
        return 'Professional ${products[index % products.length]} ${index + 1}';
      default:
        return 'Product ${index + 1}';
    }
  }
}
