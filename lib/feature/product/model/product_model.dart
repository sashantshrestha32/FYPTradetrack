import 'dart:convert';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

String productListResponseToJson(ProductListResponse data) =>
    json.encode(data.toJson());

class ProductListResponse {
  bool success;
  String message;
  List<ProductData> data;

  ProductListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      ProductListResponse(
        success: json["success"] ?? true,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<ProductData>.from(
                json["data"].map((x) => ProductData.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductData {
  int id;
  String name;
  String? description;
  String? category;
  String? type;
  double price;
  String? unit;
  int? quantity;
  int? stock;
  String? imageUrl;
  bool isActive;
  DateTime? createdAt;

  ProductData({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.type,
    required this.price,
    this.unit,
    this.quantity,
    this.stock,
    this.imageUrl,
    this.isActive = true,
    this.createdAt,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"] ?? 0,
        name: json["name"] ?? json["productName"] ?? "Unknown",
        description: json["description"],
        category: json["category"] ?? json["categoryName"],
        type: json["type"] ?? json["productType"],
        price: (json["price"] ?? json["unitPrice"] ?? 0).toDouble(),
        unit: json["unit"] ?? json["uom"],
        quantity: json["quantity"],
        stock: json["stock"] ?? json["stockQuantity"],
        imageUrl: json["imageUrl"] ?? json["image"],
        isActive: json["isActive"] ?? true,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "type": type,
        "price": price,
        "unit": unit,
        "quantity": quantity,
        "stock": stock,
        "imageUrl": imageUrl,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
      };

  // Helper to get formatted price
  String get formattedPrice => "₹ ${price.toStringAsFixed(2)}${unit != null ? '/$unit' : ''}";

  // Helper to get display category
  String get displayCategory => category ?? type ?? "General";
}
