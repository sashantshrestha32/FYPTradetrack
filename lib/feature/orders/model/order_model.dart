import 'dart:convert';

OrderListResponse orderListResponseFromJson(String str) =>
    OrderListResponse.fromJson(json.decode(str));

String orderListResponseToJson(OrderListResponse data) =>
    json.encode(data.toJson());

class OrderListResponse {
  bool success;
  String message;
  List<OrderData> data;

  OrderListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      OrderListResponse(
        success: json["success"] ?? true,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<OrderData>.from(
                json["data"].map((x) => OrderData.fromJson(x)),
              )
            : [],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderData {
  int id;
  String? orderId;
  String? outletName;
  String? storeName;
  String? customerName;
  double totalAmount;
  String status;
  DateTime? orderDate;
  DateTime? createdAt;
  String? address;
  String? phone;
  List<OrderItem>? items;
  int? itemCount;

  OrderData({
    required this.id,
    this.orderId,
    this.outletName,
    this.storeName,
    this.customerName,
    required this.totalAmount,
    required this.status,
    this.orderDate,
    this.createdAt,
    this.address,
    this.phone,
    this.items,
    this.itemCount,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id: json["id"] ?? "",
    orderId: json["orderId"] ?? json["orderNumber"] ?? "ORD-${json["id"]}",
    outletName: json["outletName"],
    storeName: json["storeName"] ?? json["outletName"],
    customerName: json["customerName"],
    totalAmount: (json["totalAmount"] ?? json["amount"] ?? 0).toDouble(),
    status: json["status"] ?? "Pending",
    orderDate: json["orderDate"] != null
        ? DateTime.parse(json["orderDate"])
        : null,
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : null,
    address: json["address"],
    phone: json["phone"],
    items: (json["items"] ?? json["orderItems"]) != null
        ? List<OrderItem>.from(
            (json["items"] ?? json["orderItems"]).map(
              (x) => OrderItem.fromJson(x),
            ),
          )
        : null,
    itemCount:
        json["itemCount"] ?? (json["items"] ?? json["orderItems"])?.length,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "outletName": outletName,
    "storeName": storeName,
    "customerName": customerName,
    "totalAmount": totalAmount,
    "status": status,
    "orderDate": orderDate?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "address": address,
    "phone": phone,
    "items": items?.map((x) => x.toJson()).toList(),
    "itemCount": itemCount,
  };

  // Helper to get display name
  String get displayName =>
      storeName ?? outletName ?? customerName ?? "Unknown";

  // Helper to get order date for display
  DateTime get displayDate => orderDate ?? createdAt ?? DateTime.now();
}

class OrderItem {
  int? id;
  String? productName;
  int quantity;
  double price;
  double? total;

  OrderItem({
    this.id,
    this.productName,
    required this.quantity,
    required this.price,
    this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    productName:
        json["productName"] ?? json["name"] ?? json["product"]?["name"],
    quantity: json["quantity"] ?? 0,
    price:
        (json["price"] ?? json["unitPrice"] ?? json["product"]?["price"] ?? 0)
            .toDouble(),
    total: (json["total"] ?? json["amount"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productName": productName,
    "quantity": quantity,
    "price": price,
    "total": total,
  };
}
