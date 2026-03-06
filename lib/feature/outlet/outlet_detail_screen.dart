import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../utils/constant/color_constants.dart';
import 'model/outlist_model.dart';
import 'provider/outlate_provider.dart';

class OutletDetailScreen extends StatefulWidget {
  final Outlatedata outlet;

  const OutletDetailScreen({super.key, required this.outlet});

  @override
  State<OutletDetailScreen> createState() => _OutletDetailScreenState();
}

class _OutletDetailScreenState extends State<OutletDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _orders = [];
  bool _isLoadingOrders = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoadingOrders = true;
    });
    final provider = context.read<OutlateProvider>();
    final orders = await provider.getOrderByOutlet(widget.outlet.id);
    if (mounted) {
      setState(() {
        _orders = orders;
        _isLoadingOrders = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.outlet.outletName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Handle edit outlet
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Contact Info Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildContactRow(
                  Icons.phone_outlined,
                  "Contact",
                  "+91 ${widget.outlet.phone}",
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.email_outlined,
                  "Email",
                  widget.outlet.email,
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.location_on_outlined,
                  "Address",
                  widget.outlet.address,
                ),
                const Divider(height: 24),
                _buildContactRow(
                  Icons.credit_card_outlined,
                  "PAN",
                  "PAN-1347655",
                ), // Placeholder
              ],
            ),
          ),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: "Orders"),
                Tab(text: "Activity"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Orders Tab
                _buildOrdersTab(),
                // Activity Tab
                const Center(child: Text("Activity logs coming soon...")),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
        child: ElevatedButton(
          onPressed: () {
            context.push('/create_order', extra: widget.outlet);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "CREATE NEW ORDER",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }

  Widget _buildOrdersTab() {
    if (_isLoadingOrders) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No orders found",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID #${order['id'] ?? '---'}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price \u{20B9}${order['total'] ?? '0.00'}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Text(
                "\u{20B9}${order['totalAmount'] ?? order['total'] ?? '0.00'}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
