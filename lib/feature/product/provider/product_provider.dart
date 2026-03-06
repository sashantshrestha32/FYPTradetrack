import 'dart:developer';
import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../service/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductData> _productList = [];
  List<ProductData> get productList => _productList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  // Fetch product list
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ProductService().fetchProducts();
      if (response != null) {
        _productList = response.data;
        log("Product List fetched: ${_productList.length} products");
      } else {
        _errorMessage = "Failed to load products";
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // add product
  Future<void> addproduct(
    int id,
    String name,
    String code,
    String unitprice,
    String currentstock,
    bool isactive,
    String createdAt,
  ) async {
    final response = await ProductService().addproduct(
      id,
      name,
      code,
      unitprice,
      currentstock,
      isactive,
      createdAt,
    );

    if (response == null) {
      throw Exception('Failed to add product');
    }
    fetchProducts();
    notifyListeners();
  }

  // Set selected category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get unique categories
  List<String> get categories {
    final cats = _productList.map((p) => p.displayCategory).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  // Search products by name or category
  List<ProductData> searchProducts(String query) {
    if (query.isEmpty) return _productList;
    final lowerQuery = query.toLowerCase();
    return _productList.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          (product.category?.toLowerCase().contains(lowerQuery) ?? false) ||
          (product.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  // Filter products by category
  List<ProductData> filterByCategory(String category) {
    if (category == 'All') return _productList;
    return _productList
        .where((p) => p.displayCategory.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get filtered and searched products
  List<ProductData> getFilteredProducts(String searchQuery) {
    List<ProductData> products = _productList;

    // Apply category filter
    if (_selectedCategory != 'All') {
      products = filterByCategory(_selectedCategory);
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      final lowerQuery = searchQuery.toLowerCase();
      products = products.where((product) {
        return product.name.toLowerCase().contains(lowerQuery) ||
            (product.category?.toLowerCase().contains(lowerQuery) ?? false) ||
            (product.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    return products;
  }

  // Get product count by category
  int getCountByCategory(String category) {
    if (category == 'All') return _productList.length;
    return _productList
        .where((p) => p.displayCategory.toLowerCase() == category.toLowerCase())
        .length;
  }
}
