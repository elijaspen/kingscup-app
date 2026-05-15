import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/api_service.dart';
import '../../theme.dart';

class CustomizeDrinkScreen extends StatefulWidget {
  final Product product;
  final ProductVariation? initialVariation;

  const CustomizeDrinkScreen({
    super.key,
    required this.product,
    this.initialVariation,
  });

  @override
  State<CustomizeDrinkScreen> createState() => _CustomizeDrinkScreenState();
}

class _CustomizeDrinkScreenState extends State<CustomizeDrinkScreen> {
  late ProductVariation _selectedVariation;
  final Set<Modifier> _selectedModifiers = {};
  int _quantity = 1;
  final ApiService _apiService = ApiService();
  late Future<List<Modifier>> _modifiersFuture;

  @override
  void initState() {
    super.initState();
    _selectedVariation = widget.initialVariation ??
        (widget.product.variations.isNotEmpty ? widget.product.variations.first : ProductVariation(id: 0, type: 'hot', price: '0'));
    _modifiersFuture = _apiService.getModifiers();
  }

  void _toggleModifier(Modifier modifier) {
    setState(() {
      if (_selectedModifiers.contains(modifier)) {
        _selectedModifiers.remove(modifier);
      } else {
        _selectedModifiers.add(modifier);
      }
    });
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(
          widget.product,
          _selectedVariation,
          _selectedModifiers.toList(),
        );
    
    // Add multiple if quantity > 1
    for (int i = 1; i < _quantity; i++) {
      context.read<CartProvider>().addItem(
          widget.product,
          _selectedVariation,
          _selectedModifiers.toList(),
      );
    }
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Customize Drink",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768;
          
          Widget imageSection = AspectRatio(
            aspectRatio: isDesktop ? 1 : 16/9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: isDesktop ? BorderRadius.circular(16) : BorderRadius.zero,
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl ?? 'https://via.placeholder.com/400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

          Widget customizationSection = FutureBuilder<List<Modifier>>(
            future: _modifiersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allModifiers = snapshot.data ?? [];
              final milkModifiers = allModifiers.where((m) => m.name.toLowerCase().contains('milk') || m.name.toLowerCase().contains('oat') || m.name.toLowerCase().contains('soy')).toList();
              final syrupModifiers = allModifiers.where((m) => m.name.toLowerCase().contains('syrup') || m.name.toLowerCase().contains('caramel') || m.name.toLowerCase().contains('vanilla')).toList();
              final espressoModifiers = allModifiers.where((m) => m.name.toLowerCase().contains('shot') || m.name.toLowerCase().contains('espresso')).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
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
                    Text(
                      widget.product.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    
                    // Variations (Size/Temp)
                    if (widget.product.variations.isNotEmpty) ...[
                      const _SectionTitle(title: "Size & Temperature"),
                      const SizedBox(height: 12),
                      Row(
                        children: widget.product.variations.map((v) {
                          final isSelected = _selectedVariation.id == v.id;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedVariation = v),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        v.type.toLowerCase() == 'iced' ? Icons.ac_unit : Icons.local_fire_department,
                                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        v.type.toUpperCase(),
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₱${v.price}",
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
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
                      const SizedBox(height: 32),
                    ],

                    // Milks
                    if (milkModifiers.isNotEmpty) ...[
                      const _SectionTitle(title: "Milk Options"),
                      const SizedBox(height: 12),
                      _buildModifierGrid(milkModifiers),
                      const SizedBox(height: 32),
                    ],

                    // Syrups
                    if (syrupModifiers.isNotEmpty) ...[
                      const _SectionTitle(title: "Flavor Syrups"),
                      const SizedBox(height: 12),
                      _buildModifierGrid(syrupModifiers),
                      const SizedBox(height: 32),
                    ],

                    // Espresso
                    if (espressoModifiers.isNotEmpty) ...[
                      const _SectionTitle(title: "Espresso Shots"),
                      const SizedBox(height: 12),
                      _buildModifierGrid(espressoModifiers),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              );
            }
          );

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: imageSection,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: customizationSection,
                ),
              ],
            );
          }

          return Column(
            children: [
              imageSection,
              Expanded(child: customizationSection),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      double basePrice = double.tryParse(_selectedVariation.price) ?? 0;
                      double modifiersTotal = _selectedModifiers.fold(0, (sum, m) => sum + (double.tryParse(m.price) ?? 0));
                      double total = (basePrice + modifiersTotal) * _quantity;
                      return Text(
                        "Add to Cart - ₱${total.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModifierGrid(List<Modifier> modifiers) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: modifiers.length,
      itemBuilder: (context, index) {
        final modifier = modifiers[index];
        final isSelected = _selectedModifiers.contains(modifier);
        
        return InkWell(
          onTap: () => _toggleModifier(modifier),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryContainer : AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        modifier.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primary : AppColors.onSurface,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (double.parse(modifier.price) > 0)
                        Text(
                          "+₱${modifier.price}",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isSelected ? AppColors.primary : AppColors.secondary,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
