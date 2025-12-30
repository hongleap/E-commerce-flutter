
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StyleHub'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(Icons.flash_on, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSortOptions(context);
            },
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
          ),
          IconButton(
            onPressed: () {
               // Notifications
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                productProvider.search(value);
              },
            ),
          ),

          // Categories
          if (productProvider.categories.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: productProvider.categories.length + 1,
                itemBuilder: (context, index) {
                   if (index == 0) {
                     return _buildCategoryChip(
                       context, 
                       Category(id: -1, name: 'All', image: ''), 
                       productProvider.selectedCategory == null,
                       () => productProvider.filterByCategory(null)
                     );
                   }
                   final category = productProvider.categories[index - 1];
                   return _buildCategoryChip(
                     context, 
                     category, 
                     productProvider.selectedCategory?.id == category.id,
                     () => productProvider.filterByCategory(category)
                   );
                },
              ),
            ),
          
          const SizedBox(height: 8),

          // Product Grid
          Expanded(
            child: productProvider.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : productProvider.error != null
                ? Center(child: Text('Error: ${productProvider.error}'))
                : productProvider.products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: productProvider.products[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, Category category, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(category.name),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge!.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sort By', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Price: Low to High'),
                selected: provider.currentSort == SortType.priceLowHigh,
                onTap: () {
                  provider.sort(SortType.priceLowHigh);
                  Navigator.pop(context);
                },
              ),
               ListTile(
                leading: const Icon(Icons.money_off),
                title: const Text('Price: High to Low'),
                selected: provider.currentSort == SortType.priceHighLow,
                onTap: () {
                  provider.sort(SortType.priceHighLow);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Name: A-Z'),
                selected: provider.currentSort == SortType.nameAZ,
                onTap: () {
                  provider.sort(SortType.nameAZ);
                  Navigator.pop(context);
                },
              ),
               ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('Clear Sort'),
                selected: provider.currentSort == SortType.none,
                onTap: () {
                  provider.sort(SortType.none);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
