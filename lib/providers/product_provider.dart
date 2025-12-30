
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

enum SortType {
  none,
  priceLowHigh,
  priceHighLow,
  nameAZ,
}

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _allProducts = [];
  List<Product> _displayProducts = []; 
  List<Category> _categories = [];
  final List<Product> _favorites = [];
  
  bool _isLoading = false;
  String? _error;

  // Filter States
  String _searchQuery = '';
  Category? _selectedCategory;
  SortType _currentSort = SortType.none;

  List<Product> get products => _displayProducts;
  List<Category> get categories => _categories;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Category? get selectedCategory => _selectedCategory;
  SortType get currentSort => _currentSort;

  void toggleFavorite(Product product) {
    if (_favorites.any((p) => p.id == product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
      product.isFavorite = false;
    } else {
      _favorites.add(product);
      product.isFavorite = true;
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.fetchProducts(),
        _apiService.fetchCategories(),
      ]);
      
      _allProducts = results[0] as List<Product>;
      _categories = results[1] as List<Category>;
      _displayProducts = List.from(_allProducts);
      
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(Category? category) {
    if (_selectedCategory == category) {
      _selectedCategory = null; // Toggle off
    } else {
      _selectedCategory = category;
    }
    _applyFilters();
  }

  void sort(SortType type) {
    _currentSort = type;
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> filtered = _allProducts;

    // 1. Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // 2. Category
    if (_selectedCategory != null) {
      filtered = filtered.where((p) => 
        p.category.id == _selectedCategory!.id
      ).toList();
    }

    // 3. Sort
    switch (_currentSort) {
      case SortType.priceLowHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceHighLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.nameAZ:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.none:
      default:
        // No specific sort (or could revert to ID/original order)
        break;
    }

    _displayProducts = filtered;
    notifyListeners();
  }
}
