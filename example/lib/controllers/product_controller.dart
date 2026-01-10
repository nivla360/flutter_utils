import 'package:flutter/foundation.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/models/example_models.dart';
import 'package:example/services/example_services.dart';

/// Demonstrates AsyncController with product data and filtering
class ProductController extends AsyncController<List<Product>> {
  final MockApiService _apiService = GetIt.instance<MockApiService>();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String? _selectedCategory;
  String _searchQuery = '';
  
  List<Product> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _allProducts;
  List<String> get categories => _allProducts.map((p) => p.category).toSet().toList();
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  
  @override
  void onReady() {
    super.onReady();
    loadProducts();
  }
  
  /// Load products with async state management
  Future<void> loadProducts({int limit = 30}) async {
    await executeAsync(
      () async {
        final products = await _apiService.getProducts(limit: limit);
        _allProducts = products;
        _applyFilters();
        return products;
      },
      onSuccess: (products) {
        if (kDebugMode) {
          print('✅ Loaded ${products.length} products successfully');
        }
      },
      onError: (error, stackTrace) {
        if (kDebugMode) {
          print('❌ Failed to load products: $error');
        }
      },
    );
  }
  
  /// Filter products by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }
  
  /// Search products by name or description
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }
  
  /// Get products in a specific price range
  List<Product> getProductsByPriceRange(double min, double max) {
    return _allProducts
        .where((product) => product.price >= min && product.price <= max)
        .toList();
  }
  
  /// Get products by availability
  List<Product> getAvailableProducts() {
    return _allProducts.where((product) => product.isAvailable && product.inStock).toList();
  }
  
  /// Get top-rated products
  List<Product> getTopRatedProducts({int limit = 10}) {
    final sortedProducts = List<Product>.from(_allProducts);
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedProducts.take(limit).toList();
  }
  
  /// Get product statistics
  Map<String, dynamic> getProductStats() {
    if (_allProducts.isEmpty) return {};
    
    final availableProducts = _allProducts.where((p) => p.isAvailable).length;
    final totalStock = _allProducts.fold<int>(0, (sum, product) => sum + product.stock);
    final averagePrice = _allProducts.fold<double>(0, (sum, product) => sum + product.price) / _allProducts.length;
    final averageRating = _allProducts.fold<double>(0, (sum, product) => sum + product.rating) / _allProducts.length;
    
    return {
      'total': _allProducts.length,
      'available': availableProducts,
      'categories': categories.length,
      'total_stock': totalStock,
      'average_price': averagePrice,
      'average_rating': averageRating,
    };
  }
  
  /// Sort products by different criteria
  void sortProducts(ProductSortOption sortOption) {
    List<Product> productsToSort = List.from(products);
    
    switch (sortOption) {
      case ProductSortOption.nameAsc:
        productsToSort.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.nameDesc:
        productsToSort.sort((a, b) => b.name.compareTo(a.name));
        break;
      case ProductSortOption.priceLowToHigh:
        productsToSort.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        productsToSort.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.ratingHighToLow:
        productsToSort.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    
    if (_filteredProducts.isNotEmpty) {
      _filteredProducts = productsToSort;
    } else {
      _allProducts = productsToSort;
    }
    
    notifyListeners();
  }
  
  /// Clear all filters
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
  
  /// Refresh products data
  Future<void> refreshProducts() async {
    _allProducts.clear();
    _filteredProducts.clear();
    _selectedCategory = null;
    _searchQuery = '';
    await loadProducts();
  }
  
  /// Apply current filters to products
  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);
    
    // Apply category filter
    if (_selectedCategory != null) {
      filtered = filtered.where((product) => product.category == _selectedCategory).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    _filteredProducts = filtered;
  }
}

enum ProductSortOption {
  nameAsc,
  nameDesc,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
}