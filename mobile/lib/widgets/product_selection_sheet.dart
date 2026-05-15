import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../theme.dart';
import '../../services/api_service.dart';

class ProductSelectionSheet extends StatefulWidget {
  final Product product;

  const ProductSelectionSheet({super.key, required this.product});

  @override
  State<ProductSelectionSheet> createState() => _ProductSelectionSheetState();
}

class _ProductSelectionSheetState extends State<ProductSelectionSheet> {
  late ProductVariation _selectedVariation;
  final List<Modifier> _selectedModifiers = [];
  final ApiService _apiService = ApiService();
  late Future<List<Modifier>> _modifiersFuture;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.variations.isNotEmpty) {
      _selectedVariation = widget.product.variations.first;
    } else {
      // Fallback for safety, though products should ideally have variations
      _selectedVariation = ProductVariation(id: -1, type: 'Default', price: '0');
    }
    _modifiersFuture = _apiService.getModifiers();
  }

  double get _totalPrice {
    double price = _selectedVariation.priceDouble;
    price += _selectedModifiers.fold(0.0, (sum, m) => sum + m.priceDouble);
    return price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Top App Bar like area
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                border: const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                  ),
                  Flexible(
                    child: Text(
                      "₱${_selectedVariation.price}",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: const Icon(Icons.shopping_bag, color: AppColors.primary),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.product.imageUrl!,
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
                                child: const Center(
                                  child: Icon(Icons.coffee, size: 64, color: AppColors.secondary),
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.surfaceContainerHigh,
                              child: const Center(
                                child: Icon(Icons.coffee, size: 64, color: AppColors.secondary),
                              ),
                            ),
                    ),

                    // Product Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                if (widget.product.description != null && widget.product.description!.isNotEmpty)
                                  Text(
                                    widget.product.description!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "₱${_selectedVariation.price}",
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Configuration Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          
                          // Variation
                          if (widget.product.variations.isNotEmpty) ...[
                            Text(
                              "VARIATION",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: widget.product.variations.map((v) {
                                final isSelected = _selectedVariation.id == v.id;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedVariation = v),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                                          border: Border.all(
                                            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              v.type.toLowerCase() == 'hot' ? Icons.coffee : Icons.ac_unit,
                                              size: 18,
                                              color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              v.type.toUpperCase(),
                                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                    color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Personalize Your Cup
                          Text(
                            "PERSONALIZE YOUR CUP",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.primary,
                                  letterSpacing: 2,
                                ),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<List<Modifier>>(
                            future: _modifiersFuture,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const LinearProgressIndicator(color: AppColors.primaryContainer);
                              
                              return Column(
                                children: snapshot.data!.map((m) {
                                  final isSelected = _selectedModifiers.contains(m);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedModifiers.remove(m);
                                        } else {
                                          _selectedModifiers.add(m);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                                              border: Border.all(
                                                color: isSelected ? AppColors.primary : AppColors.outline,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: isSelected
                                                ? const Icon(Icons.check, size: 16, color: AppColors.onPrimaryContainer)
                                                : null,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              m.name,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ),
                                          Text(
                                            "+₱${m.price}",
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                  color: AppColors.onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Footer
            Container(
              height: 96,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(top: BorderSide(color: AppColors.outlineVariant)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_quantity > 1) setState(() => _quantity--);
                          },
                          icon: const Icon(Icons.remove, color: AppColors.primary),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            "$_quantity",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _quantity++),
                          icon: const Icon(Icons.add, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add to Cart
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = context.read<CartProvider>();
                        for (int i = 0; i < _quantity; i++) {
                          cart.addItem(
                            widget.product,
                            _selectedVariation,
                            _selectedModifiers,
                          );
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added $_quantity to your bag')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Add to Cart — ₱${_totalPrice.toStringAsFixed(2)}'),
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
