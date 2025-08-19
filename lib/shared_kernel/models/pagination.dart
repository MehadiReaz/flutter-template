import 'package:equatable/equatable.dart';

/// Pagination model that can be reused across all features
class Pagination extends Equatable {
  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Number of items per page
  final int itemsPerPage;

  /// Whether there is a next page
  final bool hasNext;

  /// Whether there is a previous page
  final bool hasPrevious;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Creates pagination from JSON
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      totalItems: json['totalItems'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );
  }

  /// Converts pagination to JSON
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }

  /// Creates an empty pagination
  factory Pagination.empty() => const Pagination(
    currentPage: 1,
    totalPages: 0,
    totalItems: 0,
    itemsPerPage: 0,
    hasNext: false,
    hasPrevious: false,
  );

  /// Creates pagination with default values
  factory Pagination.first({int itemsPerPage = 20}) => Pagination(
    currentPage: 1,
    totalPages: 1,
    totalItems: 0,
    itemsPerPage: itemsPerPage,
    hasNext: false,
    hasPrevious: false,
  );

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    totalItems,
    itemsPerPage,
    hasNext,
    hasPrevious,
  ];
}
