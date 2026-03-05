import 'dart:developer';
import 'package:flutter/material.dart';
import '../model/order_model.dart';
import '../service/service.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderData> _orderList = [];
  List<OrderData> get orderList => _orderList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Fetch orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await OrderService().fetchOrders();
      if (response != null) {
        _orderList = response.data;
        log("Order List fetched: ${_orderList.length} orders");
      } else {
        _errorMessage = "Failed to load orders";
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

  // Search orders by order ID, store name, or status
  List<OrderData> searchOrders(String query) {
    if (query.isEmpty) return _orderList;
    final lowerQuery = query.toLowerCase();
    return _orderList.where((order) {
      return (order.orderId?.toLowerCase().contains(lowerQuery) ?? false) ||
          (order.displayName.toLowerCase().contains(lowerQuery)) ||
          order.status.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter orders by status
  List<OrderData> filterByStatus(String status) {
    if (status.isEmpty || status.toLowerCase() == 'all') return _orderList;
    return _orderList
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get order counts by status
  int get deliveredCount =>
      _orderList.where((o) => o.status.toLowerCase() == 'delivered').length;
  int get pendingCount =>
      _orderList.where((o) => o.status.toLowerCase() == 'pending').length;
  int get cancelledCount =>
      _orderList.where((o) => o.status.toLowerCase() == 'cancelled').length;

  // Get total order amount
  double get totalOrderAmount =>
      _orderList.fold(0.0, (sum, order) => sum + order.totalAmount);
  // Create order
  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await OrderService().createOrder(orderData);
      if (success) {
        // Refresh orders list if needed
        await fetchOrders();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Failed to create order";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
