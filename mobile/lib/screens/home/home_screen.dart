import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/product_selection_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Category>> _menuFuture;
  late Future<List<Product>> _popularFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = _apiService.getMenu();
    _popularFuture = _loadPopularProducts();
  }

  Future<List<Product>> _loadPopularProducts() async {
    final categories = await _apiService.getMenu();
    List<Product> popular = [];
    if (categories.isNotEmpty) {
      for (var cat in categories) {
        if (cat.products.isNotEmpty) {
          popular.add(cat.products.first);
        }
        if (popular.length >= 5) break;
      }
    }
    return popular;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.webp',
              height: 32,
              width: 32,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.local_cafe,
                color: AppColors.primaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "King's Cup Coffee",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: AppColors.primaryContainer, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  "Antique, PH",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryContainer,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _menuFuture = _apiService.getMenu();
            _popularFuture = _loadPopularProducts();
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                "Good Day, ${user?.name.split(' ').first ?? 'Alex'}",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.near_me, size: 16, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    "Delivering to ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "San Jose, Antique",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search your favorite brew...",
                  prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                  fillColor: AppColors.surfaceContainerLowest,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Hero Section
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=2670&auto=format&fit=crop',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "THE MORNING RITUAL",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rich, Bold, Signature.",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Category>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 44,
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    );
                  }
                  final categories = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        const _CategoryChip(title: "All", icon: Icons.restaurant_menu, isSelected: true),
                        ...categories.map((c) => _CategoryChip(
                              title: c.name,
                              icon: _getCategoryIcon(c.name),
                            )),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Popular Selection
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Popular Selection",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: Text(
                      "HANDCRAFTED",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Product>>(
                future: _popularFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(height: 380, child: Center(child: CircularProgressIndicator()));
                  }
                  final products = snapshot.data!;
                  return SizedBox(
                    height: 380,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _PopularCard(product: products[index], isBestseller: index == 0);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'coffee based':
        return Icons.coffee;
      case 'frappe':
        return Icons.icecream;
      case 'non-coffee based':
        return Icons.local_drink;
      case 'tea':
        return Icons.water_drop;
      case 'pasta':
        return Icons.lunch_dining;
      case 'sandwiches':
        return Icons.bakery_dining;
      case 'cakes':
        return Icons.cake;
      default:
        return Icons.local_cafe;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;

  const _CategoryChip({
    required this.title,
    required this.icon,
    this.isSelected = false,
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
          onTap: () {},
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
                  title,
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

class _PopularCard extends StatelessWidget {
  final Product product;
  final bool isBestseller;

  const _PopularCard({
    required this.product,
    this.isBestseller = false,
  });

  @override
  Widget build(BuildContext context) {
    final price = product.variations.isNotEmpty ? product.variations.first.price : '0';
    
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl ?? 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?q=80&w=2787&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.coffee, size: 48, color: AppColors.secondary),
                    ),
                  ),
                  if (isBestseller)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "BESTSELLER",
                          style: TextStyle(
                            color: AppColors.onSecondaryContainer,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 18,
                                height: 1.2,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "₱$price",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: Text(
                      product.description ?? "Experience our signature coffee roast, handcrafted with precision.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ProductSelectionSheet(product: product),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Order Now", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.favorite_border, size: 20, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
