import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import 'inventory_management_screen.dart';

class BaristaDashboardScreen extends StatefulWidget {
  const BaristaDashboardScreen({super.key});

  @override
  State<BaristaDashboardScreen> createState() => _BaristaDashboardScreenState();
}

class _BaristaDashboardScreenState extends State<BaristaDashboardScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _orders = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  double _totalRevenue = 0;
  int _completedToday = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _apiService.getOrders();
      if (mounted) {
        setState(() {
          // Real-time Active Queue (Pending, Preparing, Delivering/Ready)
          _orders = orders.where((o) => !['completed', 'cancelled'].contains(o['status'])).toList();
          
          // KPI: Revenue and Completed Today
          _totalRevenue = orders
              .where((o) => o['status'] == 'completed')
              .fold(0.0, (sum, o) => sum + (double.tryParse(o['total_price']?.toString() ?? '0') ?? 0));
          
          _completedToday = orders.where((o) => o['status'] == 'completed').length;
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(int orderId, String newStatus) async {
    try {
      await _apiService.updateOrderStatus(orderId, newStatus);
      if (mounted) {
        _fetchOrders();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        Widget mainContent = Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            centerTitle: false,
            surfaceTintColor: Colors.transparent,
            shape: const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
            title: Row(
              mainAxisSize: MainAxisSize.min, // Prevents row from taking full width and causing overflow
              children: [
                Image.asset('assets/images/logo.webp', width: 32, height: 32, fit: BoxFit.contain),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    "Barista Dashboard",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.primary),
                onPressed: _fetchOrders,
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.primary),
                onPressed: () => auth.logout(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : RefreshIndicator(
                  onRefresh: _fetchOrders,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isDesktop ? 40 : 16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KPI Cards with Real Data
                        GridView.count(
                          crossAxisCount: isDesktop ? 4 : 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: isDesktop ? 2.5 : 1.8,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _StatCard(title: "Active Queue", value: "${_orders.length}", unit: "Orders"),
                            _StatCard(title: "Completed", value: "$_completedToday", unit: "Today"),
                            _StatCard(title: "Total Revenue", value: "₱${_totalRevenue.toStringAsFixed(0)}", unit: "PHP"),
                            _StatCard(
                              title: "System Status",
                              value: "Online",
                              unit: "",
                              icon: Icons.check_circle,
                              isHighlight: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Active Queue Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Active Queue", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22, color: AppColors.onBackground, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text("${_orders.length} ACTIVE", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ),
                              ],
                            ),
                            const Row(
                              children: [
                                Icon(Icons.circle, size: 8, color: Colors.green),
                                SizedBox(width: 8),
                                Text("LIVE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary, letterSpacing: 1)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Order Grid
                        if (_orders.isEmpty)
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.hourglass_empty, size: 40, color: AppColors.outlineVariant),
                                  SizedBox(height: 8),
                                  Text("AWAITING NEXT ORDER", style: TextStyle(fontSize: 10, color: AppColors.outline, letterSpacing: 2)),
                                ],
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 3 : 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              mainAxisExtent: 250,
                            ),
                            itemCount: _orders.length,
                            itemBuilder: (context, index) {
                              return _OrderQueueCard(
                                order: _orders[index],
                                onStatusUpdate: (status) => _updateStatus(_orders[index]['id'], status),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: isDesktop
              ? null
              : BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryManagementScreen()));
                    } else {
                      setState(() => _currentIndex = index);
                    }
                  },
                  backgroundColor: AppColors.surface,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "QUEUE"),
                    BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "STOCK"),
                    BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "STATS"),
                    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "SETTINGS"),
                  ],
                ),
        );

        return mainContent;
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData? icon;
  final bool isHighlight;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    this.icon,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.primary : AppColors.surfaceContainerLowest,
        border: Border.all(color: isHighlight ? AppColors.primary : AppColors.outlineVariant),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(
            color: isHighlight ? Colors.white70 : AppColors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          )),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: TextStyle(
                    color: isHighlight ? Colors.white : AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
                  const SizedBox(width: 4),
                  Text(unit, style: TextStyle(
                    color: isHighlight ? Colors.white70 : AppColors.onSurfaceVariant,
                    fontSize: 10,
                  )),
                ],
              ),
              if (icon != null)
                Icon(icon, color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderQueueCard extends StatelessWidget {
  final dynamic order;
  final Function(String) onStatusUpdate;

  const _OrderQueueCard({required this.order, required this.onStatusUpdate});

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'pending';
    final items = (order['items'] as List?) ?? [];
    final customer = order['customer'] ?? {};

    Color borderColor = AppColors.outlineVariant;
    Color headerBg = AppColors.surfaceContainerLowest;
    String badgeText = "STANDARD";
    Color badgeBg = AppColors.surfaceContainer;
    Color badgeTextCol = AppColors.onSurfaceVariant;
    Widget actionButton = const SizedBox.shrink();

    if (status == 'pending') {
      borderColor = AppColors.primary;
      headerBg = AppColors.primaryContainer.withValues(alpha: 0.1);
      badgeText = "NEW ORDER";
      badgeBg = AppColors.primary;
      badgeTextCol = Colors.white;
      actionButton = ElevatedButton(
        onPressed: () => onStatusUpdate('preparing'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("START PREPARING", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (status == 'preparing') {
      borderColor = Colors.orange;
      headerBg = Colors.orange.withValues(alpha: 0.05);
      badgeText = "PREPARING";
      badgeBg = Colors.orange;
      badgeTextCol = Colors.white;
      actionButton = ElevatedButton(
        onPressed: () => onStatusUpdate('delivering'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("MARK AS READY", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (status == 'delivering' || status == 'ready') {
      borderColor = Colors.green;
      headerBg = Colors.green.withValues(alpha: 0.05);
      badgeText = "READY";
      badgeBg = Colors.green;
      badgeTextCol = Colors.white;
      actionButton = ElevatedButton(
        onPressed: () => onStatusUpdate('completed'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("MARK COMPLETED", style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerBg,
              border: const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ORDER #KC-${order['id'] ?? '??'}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                      Text(customer['name'] ?? 'Guest Customer', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(badgeText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextCol)),
                ),
              ],
            ),
          ),
          
          // Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, idx) {
                final item = items[idx];
                final productName = item['variation']?['product']?['name'] ?? 'Unknown Item';
                final variationType = item['variation']?['type'] ?? 'Standard';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("${item['quantity']}x", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$productName ($variationType)",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                            ),
                            if (item['modifiers'] != null && (item['modifiers'] as List).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  "• ${(item['modifiers'] as List).map((m) => m['name']).join(', ')}",
                                  style: const TextStyle(fontSize: 11, color: AppColors.secondary),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: actionButton,
          ),
        ],
      ),
    );
  }
}
