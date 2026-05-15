class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final int loyaltyPoints;
  final List<CustomerAddress> addresses;
  final List<dynamic> paymentMethods;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.loyaltyPoints = 0,
    this.addresses = const [],
    this.paymentMethods = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      loyaltyPoints: json['loyalty_points'] ?? 0,
      addresses: (json['addresses'] as List?)
              ?.map((a) => CustomerAddress.fromJson(a))
              .toList() ??
          [],
      paymentMethods: json['payment_methods'] ?? [],
    );
  }

  bool get isBarista => role == 'barista';
  bool get isCustomer => role == 'customer';
}

class Category {
  final int id;
  final String name;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      products: (json['products'] as List?)
              ?.map((p) => Product.fromJson(p))
              .toList() ??
          [],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String? description;
  final String? category;
  final String? imageUrl;
  final bool isAvailable;
  final List<ProductVariation> variations;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.category,
    this.imageUrl,
    required this.isAvailable,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['image'] ?? json['image_url'],
      isAvailable: json['available'] ?? json['is_available'] ?? true,
      variations: (json['variations'] as List?)
              ?.map((v) => ProductVariation.fromJson(v))
              .toList() ??
          [],
    );
  }
}

class ProductVariation {
  final int id;
  final String type;
  final String price;

  ProductVariation({
    required this.id,
    required this.type,
    required this.price,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'],
      type: json['type'],
      price: json['price'],
    );
  }

  double get priceDouble => double.tryParse(price) ?? 0.0;
}

class Modifier {
  final int id;
  final String name;
  final String price;

  Modifier({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  double get priceDouble => double.tryParse(price) ?? 0.0;
}

class Barangay {
  final int id;
  final String name;

  Barangay({required this.id, required this.name});

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CustomerAddress {
  final int id;
  final String? label;
  final String addressText;
  final String? barangay;
  final bool isDefault;

  CustomerAddress({
    required this.id,
    this.label,
    required this.addressText,
    this.barangay,
    this.isDefault = false,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'],
      label: json['label'],
      addressText: json['address_text'],
      barangay: json['barangay'],
      isDefault: json['is_default'] ?? false,
    );
  }
}
