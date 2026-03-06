import 'dart:developer';
import 'package:flutter/widgets.dart';
import '../model/outlist_model.dart';
import '../../orders/model/order_model.dart';
import '../service/outlate_service.dart';

class OutlateProvider extends ChangeNotifier {
  List<Outlatedata> _outletList = [];
  List<Outlatedata> get outletList => _outletList;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getOutlet() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await OutlateService().getOutlet();
      if (response != null) {
        _outletList = response.data;
        log("Outlet List: $_outletList");
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // add outlate
  Future<bool> addOutlet(
    String name,
    String ownername,
    String phone,
    String email,
    String location,
    String address,
    double latitude,
    double longitude,
  ) async {
    try {
      var response = await OutlateService().addOutlet(
        name,
        ownername,
        phone,
        email,
        location,
        address,
        latitude,
        longitude,
      );
      if (!response) return false;
      getOutlet();
      return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  // Search outlets by name, owner name, or address
  List<Outlatedata> searchOutlets(String query) {
    if (query.isEmpty) return outletList;
    final lowerQuery = query.toLowerCase();
    return outletList.where((outlet) {
      return outlet.outletName.toLowerCase().contains(lowerQuery) ||
          outlet.ownerName.toLowerCase().contains(lowerQuery) ||
          outlet.address.toLowerCase().contains(lowerQuery) ||
          outlet.location.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // take order by outlet
  Future<List<OrderData>> getOrderByOutlet(int outletId) async {
    try {
      final response = await OutlateService().getOrderByOutlet(outletId);
      return response;
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  // Get active outlets count
  int get activeOutletsCount => outletList.where((o) => o.isActive).length;

  // Get inactive outlets count
  int get inactiveOutletsCount => outletList.where((o) => !o.isActive).length;
}
