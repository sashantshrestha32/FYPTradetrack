import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../utils/constant/color_constants.dart';
import '../outlet/model/outlist_model.dart';
import '../product/provider/product_provider.dart';
import '../product/model/product_model.dart';
import 'provider/order_provider.dart';
import '../../core/faildialog.dart';

class CreateOrderScreen extends StatefulWidget {
  final Outlatedata outlet;

  const CreateOrderScreen({super.key, required this.outlet});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // Map of productId -> quantity
  final Map<int, int> _cart = {};

  @override
  void initState() {
    super.initState();
    // Fetch products if not already loaded or to refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Calculate subtotal
  double _calculateSubtotal(List<ProductData> products) {
    double total = 0;
    _cart.forEach((id, quantity) {
      final product = products.firstWhere(
        (p) => p.id == id,
        orElse: () => ProductData(id: 0, name: '', price: 0, isActive: false),
      ); // Should handle gracefully
      if (product.id != 0) {
        total += product.price * quantity;
      }
    });
    return total;
  }

  // Format currency
  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(amount);
  }

  // Handle confirm order
  Future<void> _confirmOrder(List<ProductData> products) async {
    if (_cart.isEmpty) {
      MessagePresenter.show(
        context: context,
        message: "Please add items to cart",
        level: MessageLevel.warning,
        mode: MessageMode.snackbar,
      );
      return;
    }

    final subtotal = _calculateSubtotal(products);
    final discount = subtotal * 0.05;
    final total = subtotal - discount;

    // Prepare items list
    final items = <Map<String, dynamic>>[];
    _cart.forEach((id, quantity) {
      final product = products.firstWhere((p) => p.id == id);
      items.add({"productId": product.id, "quantity": quantity});
    });

    // Prepare order data
    final orderData = {
      "outletId": widget.outlet.id,
      "orderItems": items,
      "notes": "Order created from mobile app",
    };

    final orderProvider = context.read<OrderProvider>();
    final success = await orderProvider.createOrder(orderData);

    if (mounted) {
      if (success) {
        MessagePresenter.show(
          context: context,
          message: "Order placed successfully!",
          level: MessageLevel.success,
          mode: MessageMode.dialog,
          onAction: () {
            Navigator.of(context).pop(); // Close dialog
            context.pop(); // Go back to outlet detail
          },
        );
      } else {
        MessagePresenter.show(
          context: context,
          message: orderProvider.errorMessage ?? "Failed to place order",
          level: MessageLevel.error,
          mode: MessageMode.dialog,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'New Order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<ProductProvider>().fetchProducts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Outlet Info Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Party",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      widget.outlet.outletName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.green.shade50,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${_cart.length}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Product List
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                final products = provider.getFilteredProducts(_searchQuery);

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      "No products found",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final quantity = _cart[product.id] ?? 0;
                    return _buildProductItem(product, quantity);
                  },
                );
              },
            ),
          ),
          // Bottom Summary
          Consumer2<ProductProvider, OrderProvider>(
            builder: (context, productProvider, orderProvider, child) {
              final subtotal = _calculateSubtotal(productProvider.productList);
              final discount = subtotal * 0.05;
              final total = subtotal - discount;
              final totalItems = _cart.values.fold(0, (sum, qty) => sum + qty);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[50], // Light background for stats
                      child: Column(
                        children: [
                          _buildSummaryRow("Subtotal", subtotal),
                          const SizedBox(height: 8),
                          _buildSummaryRow(
                            "Discount (5%)",
                            -discount,
                            isDiscount: true,
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatCurrency(total),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: orderProvider.isLoading
                              ? null
                              : () =>
                                    _confirmOrder(productProvider.productList),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryColor, // Dark blue
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: orderProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                          label: Text(
                            "CONFIRM ORDER ($totalItems items)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductData product, int quantity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: quantity > 0 ? AppColors.primaryColor : Colors.grey.shade300,
          width: quantity > 0 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey[600],
            ), // Placeholder
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _formatCurrency(product.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor, // Blue color
                      ),
                    ),
                    if (quantity > 0) ...[
                      Text(
                        " x $quantity = ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        _formatCurrency(product.price * quantity),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQtyButton(Icons.remove, () {
                  if (quantity > 0) {
                    setState(() {
                      _cart[product.id] = quantity - 1;
                      if (_cart[product.id] == 0) {
                        _cart.remove(product.id);
                      }
                    });
                  }
                }),
                Container(
                  constraints: const BoxConstraints(minWidth: 32),
                  alignment: Alignment.center,
                  child: Text(
                    "$quantity",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _buildQtyButton(Icons.add, () {
                  setState(() {
                    _cart[product.id] = quantity + 1;
                  });
                }, isAdd: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(
    IconData icon,
    VoidCallback onTap, {
    bool isAdd = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 16, color: isAdd ? Colors.green : Colors.red),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDiscount ? Colors.green : Colors.grey[600],
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDiscount ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }
}
