import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/models.dart';
import '../menu/customize_drink_screen.dart'; // We'll navigate to detail screen for favorites

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock favorite products
    final favorites = [
      Product(
        id: 1,
        name: 'Salted Caramel Macchiato',
        description: 'Rich espresso with vanilla, milk, and a drizzle of salted caramel.',
        imageUrl: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?q=80&w=2574&auto=format&fit=crop',
        category: 'Signature Lattes',
        isAvailable: true,
        variations: [ProductVariation(id: 1, type: 'hot', price: '160.00')],
      ),
      Product(
        id: 2,
        name: 'Matcha Espresso Fusion',
        description: 'Premium Uji matcha layered with milk and our signature espresso.',
        imageUrl: 'https://images.unsplash.com/photo-1536622260034-927dcaf966ce?q=80&w=2674&auto=format&fit=crop',
        category: 'Signature Lattes',
        isAvailable: true,
        variations: [ProductVariation(id: 2, type: 'iced', price: '180.00')],
      ),
    ];

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
          "Your Favorites",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return _FavoriteProductCard(product: product);
              },
            ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  final Product product;

  const _FavoriteProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomizeDrinkScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imageUrl ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.primaryContainer, size: 20),
                      onPressed: () {
                        // Toggle favorite
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₱${product.variations.first.price}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
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
