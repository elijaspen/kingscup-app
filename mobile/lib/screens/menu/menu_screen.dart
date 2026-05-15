import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/product_selection_sheet.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Category>> _menuFuture;
  int? _selectedCategoryId;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _menuFuture = _apiService.getMenu();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts(List<Category> categories) {
    List<Product> allProducts = [];
    if (_selectedCategoryId == null) {
      allProducts = categories.expand((c) => c.products).toList();
    } else {
      try {
        allProducts = categories
            .firstWhere((c) => c.id == _selectedCategoryId)
            .products;
      } catch (_) {
        allProducts = [];
      }
    }

    if (_searchQuery.isNotEmpty) {
      allProducts = allProducts
          .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.webp',
              height: 28,
              width: 28,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.coffee,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "King's Cup Coffee",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        backgroundColor: AppColors.surface.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categories = snapshot.data ?? [];
          final filteredProducts = _getFilteredProducts(categories);

          return CustomScrollView(
            slivers: [
              // Search & Filter Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: const InputDecoration(
                            hintText: 'Search our coffee roast...',
                            prefixIcon: Icon(Icons.search, color: AppColors.outline),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Category Chips
                      _CategoryFilters(
                        categories: categories,
                        selectedId: _selectedCategoryId,
                        onSelected: (id) => setState(() => _selectedCategoryId = id),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Menu Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    mainAxisExtent: 400, // Increased to 400 to ensure no overlapping or cutting
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      // For demonstration of the design, we'll alternate badges
                      final isBestSeller = index == 0;
                      final isNew = index == 2;

                      return ProductCard(
                        product: product,
                        isBestSeller: isBestSeller,
                        isNew: isNew,
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId;
  final Function(int?) onSelected;

  const _CategoryFilters({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _CategoryChip(
            label: 'All Menu',
            icon: Icons.restaurant_menu,
            isSelected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          ...categories.map((category) {
            IconData icon;
            switch (category.name.toLowerCase()) {
              case 'coffee based':
                icon = Icons.coffee;
                break;
              case 'frappe':
                icon = Icons.icecream;
                break;
              case 'tea':
                icon = Icons.water_drop;
                break;
              case 'pastries':
              case 'cakes':
                icon = Icons.bakery_dining;
                break;
              case 'sandwiches':
              case 'pasta':
                icon = Icons.lunch_dining;
                break;
              default:
                icon = Icons.local_cafe;
            }
            return _CategoryChip(
              label: category.name,
              icon: icon,
              isSelected: selectedId == category.id,
              onTap: () => onSelected(category.id),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isSelected ? BorderSide.none : const BorderSide(color: AppColors.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isBestSeller;
  final bool isNew;

  const ProductCard({
    super.key,
    required this.product,
    this.isBestSeller = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final price = product.variations.isNotEmpty ? product.variations.first.price : '0';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D2B1F).withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => ProductSelectionSheet(product: product),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.surfaceContainerHigh,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.surfaceContainerHigh,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.coffee, size: 40, color: AppColors.secondary),
                                  SizedBox(height: 8),
                                  Text('Signature Roast', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.surfaceContainerHigh,
                            child: const Center(
                              child: Icon(Icons.coffee, size: 40, color: AppColors.secondary),
                            ),
                          ),
                  ),
                  if (isBestSeller)
                    _Badge(label: 'BEST SELLER', color: AppColors.secondaryContainer, textColor: AppColors.onSecondaryContainer),
                  if (isNew)
                    _Badge(label: 'NEW', color: const Color(0xFFEBE2C8), textColor: const Color(0xFF1F1C0B)),
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₱$price',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Badge({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
