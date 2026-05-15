import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme.dart';

class OrderStatusScreen extends StatefulWidget {
  final int orderId;

  const OrderStatusScreen({super.key, required this.orderId});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _order;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    try {
      final orders = await _apiService.getOrders();
      final order = orders.firstWhere((o) => o['id'] == widget.orderId);
      setState(() {
        _order = order;
        _isLoading = false;
      });
      
      // Auto-refresh every 10 seconds if not completed
      if (_order!['status'] != 'completed' && mounted) {
        Future.delayed(const Duration(seconds: 10), _fetchOrder);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary)));
    }

    if (_order == null) {
      return const Scaffold(body: Center(child: Text('Order not found')));
    }

    final status = _order!['status'];
    final barista = _order!['barista'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracker', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _StatusStep(
                    label: 'Order Received',
                    isActive: true,
                    isCompleted: true,
                  ),
                  _StatusStep(
                    label: 'Preparing Your Coffee',
                    isActive: status == 'preparing',
                    isCompleted: ['preparing', 'delivering', 'completed'].contains(status),
                  ),
                  _StatusStep(
                    label: 'Out for Delivery',
                    isActive: status == 'delivering',
                    isCompleted: ['delivering', 'completed'].contains(status),
                  ),
                  _StatusStep(
                    label: 'Enjoy!',
                    isActive: status == 'completed',
                    isCompleted: status == 'completed',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (barista != null) ...[
              Text('Your Barista', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(barista['name'], style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: const Text('Is delivering your order'),
              ),
              const SizedBox(height: 32),
            ],
            Text('Order Details', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            Text('Address: ${_order!['address_text']}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Total: ₱${_order!['total_price']}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  const _StatusStep({
    required this.label,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? AppColors.primary : Colors.grey[300];
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.white,
                border: Border.all(color: color!, width: 2),
                shape: BoxShape.circle,
              ),
              child: isCompleted ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: color,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted ? AppColors.espressoDark : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
