import 'package:flutter/material.dart';
import '../../theme.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _coffeeRoasts = [
    {'name': 'King\'s Cup Signature Blend', 'type': 'Espresso Base', 'stock': 45, 'status': 'In Stock', 'isActive': true},
    {'name': 'Single Origin Ethiopia Yirgacheffe', 'type': 'Pour Over', 'stock': 12, 'status': 'Low Stock', 'isActive': true},
    {'name': 'Decaf Colombian Supremo', 'type': 'Decaf Options', 'stock': 0, 'status': 'Out of Stock', 'isActive': false},
  ];

  final List<Map<String, dynamic>> _milks = [
    {'name': 'Whole Milk', 'type': 'Dairy', 'stock': 24, 'status': 'In Stock', 'isActive': true},
    {'name': 'Oat Milk (Oatly Barista)', 'type': 'Alternative', 'stock': 8, 'status': 'Low Stock', 'isActive': true},
    {'name': 'Almond Milk', 'type': 'Alternative', 'stock': 15, 'status': 'In Stock', 'isActive': true},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Inventory Management",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            Tab(text: "Coffee Roasts"),
            Tab(text: "Milk & Alt"),
            Tab(text: "Pastries"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(child: _buildStatItem("Total Items", "124", Icons.inventory_2)),
                Expanded(child: _buildStatItem("Low Stock", "8", Icons.warning, color: Colors.orange)),
                Expanded(child: _buildStatItem("Out of Stock", "3", Icons.error, color: AppColors.error)),
                Expanded(child: _buildStatItem("Updated", "10m ago", Icons.update)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInventoryList(_coffeeRoasts),
                _buildInventoryList(_milks),
                const Center(child: Text("No pastries available")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.onSurface,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 10,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInventoryList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _InventoryItemCard(
          name: item['name'],
          type: item['type'],
          stock: item['stock'],
          status: item['status'],
          isActive: item['isActive'],
          onToggle: (val) {
            setState(() {
              item['isActive'] = val;
            });
          },
        );
      },
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  final String name;
  final String type;
  final int stock;
  final String status;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const _InventoryItemCard({
    required this.name,
    required this.type,
    required this.stock,
    required this.status,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    Color badgeBgColor;

    if (status == 'In Stock') {
      badgeColor = Colors.green[800]!;
      badgeBgColor = Colors.green[100]!;
    } else if (status == 'Low Stock') {
      badgeColor = Colors.orange[800]!;
      badgeBgColor = Colors.orange[100]!;
    } else {
      badgeColor = AppColors.error;
      badgeBgColor = AppColors.errorContainer;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        status,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Stock: $stock",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch(
                value: isActive,
                onChanged: onToggle,
                activeColor: AppColors.primaryContainer,
                activeTrackColor: AppColors.primary,
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: AppColors.onSurfaceVariant,
                onPressed: () {},
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
