import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../services/api_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<dynamic> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _apiService.getOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Your Orders",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primaryContainer,
          tabs: const [
            Tab(text: "All Orders"),
            Tab(text: "Subscriptions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Orders
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _orders.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return _OrderCard(
                            orderId: '#${order['id'] ?? 'N/A'}',
                            date: order['created_at'] ?? 'Unknown', // Need formatting
                            status: order['status'] ?? 'pending',
                            total: order['total_price']?.toString() ?? '0.00',
                            items: (order['items'] as List?)?.length ?? 0,
                          );
                        },
                      ),
                    ),
          
          // Subscriptions
          _buildEmptyState(message: "No active subscriptions"),
        ],
      ),
    );
  }

  Widget _buildEmptyState({String message = "No orders found"}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 64, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final String total;
  final int items;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBgColor;
    
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        statusColor = Colors.green[800]!;
        statusBgColor = Colors.green[100]!;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusBgColor = AppColors.errorContainer;
        break;
      default:
        statusColor = AppColors.primary;
        statusBgColor = AppColors.surfaceContainer;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ordered on $date",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.coffee, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      "$items items",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurface,
                          ),
                    ),
                  ],
                ),
                Text(
                  "₱$total",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: const Text("View Details"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                    ),
                    child: const Text("Re-order"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
