
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final String cartKey;
  final CartItem cartItem;

  const CartItemTile({
    super.key,
    required this.cartKey,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(cartKey);
      },
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cartItem.product.imageUrl),
              backgroundColor: Colors.transparent,
            ),
            title: Text(cartItem.product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: \$${cartItem.totalPrice.toStringAsFixed(2)}'),
                Text('Size: ${cartItem.size} | Color: ${_getColorName(cartItem.color)}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).removeSingleItem(cartKey);
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                     Provider.of<CartProvider>(context, listen: false).addItem(cartItem.product, cartItem.size, cartItem.color);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.grey) return 'Grey';
    if (color == Colors.redAccent) return 'Red';
    if (color == Colors.blueAccent) return 'Blue';
    // Add more as needed
    return 'Custom';
  }
}
