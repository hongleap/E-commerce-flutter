
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = '';
  Color _selectedColor = Colors.transparent;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) _selectedSize = widget.product.sizes.first;
    if (widget.product.colors.isNotEmpty) _selectedColor = widget.product.colors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // assuming image background
           style: IconButton.styleFrom(backgroundColor: Colors.black26),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              final isFav = productProvider.isFavorite(widget.product);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: Colors.red,
                style: IconButton.styleFrom(backgroundColor: Colors.white24),
                onPressed: () {
                  productProvider.toggleFavorite(widget.product);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image
            Hero(
              tag: widget.product.id,
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        ' ${widget.product.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' (120 reviews)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Size
                  Text(
                    'Size',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: widget.product.sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedSize = size);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Color
                  Text(
                    'Color',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: widget.product.colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedColor = color);
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                          radius: 18,
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                   const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
               Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(widget.product, _selectedSize, _selectedColor);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Buy Logic
                     final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addItem(widget.product, _selectedSize, _selectedColor);
                    // Navigate to cart/checkout
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to Checkout...')),
                    );
                  },
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
