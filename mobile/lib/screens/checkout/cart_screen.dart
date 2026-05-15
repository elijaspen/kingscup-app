import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import 'order_status_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _addressController = TextEditingController();
  Barangay? _selectedBarangay;
  List<Barangay> _barangays = [];
  bool _isPlacingOrder = false;
  String _selectedPaymentMethod = 'gcash';

  @override
  void initState() {
    super.initState();
    _loadBarangays();
  }

  Future<void> _loadBarangays() async {
    final barangays = await _apiService.getBarangays();
    setState(() => _barangays = barangays);
  }

  Future<void> _placeOrder() async {
    if (_selectedBarangay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Barangay')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final cart = context.read<CartProvider>();
      final fullAddress = "${_selectedBarangay!.name}, ${_addressController.text}";
      
      final response = await _apiService.placeOrder(
        items: cart.toApiJson(),
        addressText: fullAddress,
      );

      final orderId = response['order']['id'];
      cart.clear();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderStatusScreen(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Checkout', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.secondary),
              const SizedBox(height: 16),
              Text('Your bag is empty', style: Theme.of(context).textTheme.bodyLarge),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go back to Menu'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
              ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "Step 2 of 3",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 800;

          Widget mainContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Address", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                  TextButton(onPressed: () {}, child: const Text("Edit")),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Customer Name", style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<Barangay>(
                            initialValue: _selectedBarangay,
                            hint: const Text('Select Barangay'),                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                              border: InputBorder.none,
                            ),
                            items: _barangays.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(),
                            onChanged: (val) => setState(() => _selectedBarangay = val),
                          ),
                          TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              hintText: 'House No. / Street / Landmark',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDMfE6wEi2UEfuq9wKu9F8uv6Ct8N0wNmuln-di_4GAJX6g7N9sqhrZu2PG3wti_qSU-k47lxQvbZvHZ3uHHzJQLdfVqFnbgtF78XSsqQWdrrCeVnxZtfh0jCdqRKxxffIXyyM4DtUaEXDl-wCI5WwoGDYAEf0tHk3o9gByRMhUQGA7E5s13xBk1MBSaxKVYRPVYi5aSs6rim5J-r762WZlo8WJCW5VzY-dKV6sykronSPW_miBNBEBFIp_GIadaYo9rKRFtOT_QygC',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Order Summary Section
              Text("Order Summary", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.outlineVariant),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl ?? 'https://via.placeholder.com/150',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: Theme.of(context).textTheme.labelMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text("₱${item.totalPrice.toStringAsFixed(2)}", style: Theme.of(context).textTheme.labelMedium),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...item.selectedModifiers.map((m) => Row(
                                      children: [
                                        const Icon(Icons.add_circle, size: 16, color: AppColors.onSurfaceVariant),
                                        const SizedBox(width: 4),
                                        Text(m.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                                      ],
                                    )),
                                const SizedBox(height: 8),
                                Text("Qty: ${item.quantity}", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Payment Method Section
              Text("Payment Method", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _PaymentOptionCard(
                      title: 'GCash',
                      icon: Icons.account_balance_wallet,
                      isSelected: _selectedPaymentMethod == 'gcash',
                      onTap: () => setState(() => _selectedPaymentMethod = 'gcash'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PaymentOptionCard(
                      title: 'Credit Card',
                      icon: Icons.credit_card,
                      isSelected: _selectedPaymentMethod == 'card',
                      onTap: () => setState(() => _selectedPaymentMethod = 'card'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PaymentOptionCard(
                      title: 'Cash',
                      icon: Icons.payments,
                      isSelected: _selectedPaymentMethod == 'cash',
                      onTap: () => setState(() => _selectedPaymentMethod = 'cash'),
                    ),
                  ),
                ],
              ),
            ],
          );

          Widget totalsContent = Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border.all(color: AppColors.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Final Totals", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                const Divider(height: 32, color: AppColors.outlineVariant),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                    Text("₱${cart.subtotal.toStringAsFixed(2)}", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Fee", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                    Text("Free", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Discounts", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                    Text("- ₱0.00", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.error)),
                  ],
                ),
                const Divider(height: 32, color: AppColors.outlineVariant),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                    Text("₱${cart.subtotal.toStringAsFixed(2)}", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 20, color: AppColors.onTertiaryFixedVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Prices include VAT and municipal taxes where applicable.",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onTertiaryFixedVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: isLargeScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: mainContent),
                            const SizedBox(width: 32),
                            Expanded(flex: 1, child: totalsContent),
                          ],
                        )
                      : Column(
                          children: [
                            mainContent,
                            const SizedBox(height: 32),
                            totalsContent,
                          ],
                        ),
                ),
              ),
              // Sticky Footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: const Border(top: BorderSide(color: AppColors.outlineVariant)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      if (!isLargeScreen)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Paying with ${_selectedPaymentMethod == 'gcash' ? 'GCash' : _selectedPaymentMethod == 'card' ? 'Credit Card' : 'Cash'}",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                              ),
                              Text(
                                "Total: ₱${cart.subtotal.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: isLargeScreen ? double.infinity : 200,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _isPlacingOrder ? null : _placeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: _isPlacingOrder ? const SizedBox.shrink() : const Icon(Icons.receipt_long),
                          label: _isPlacingOrder
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text("PLACE ORDER"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest,
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: -8,
                right: -4,
                child: const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
