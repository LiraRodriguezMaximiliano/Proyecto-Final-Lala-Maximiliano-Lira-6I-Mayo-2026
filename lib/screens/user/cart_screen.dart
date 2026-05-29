import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: const CustomHeader(title: 'Carrito'),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Icon(Icons.shopping_cart, size: 50, color: Color(0xFF005CBB)),
          const Text('Carrito', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final item = cart.items.values.toList()[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: ListTile(
                    leading: Image.network(item.product.imageUrl, width: 50),
                    title: Text(item.product.name),
                    subtitle: Text('Cantidad: ${item.quantity} - \$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => cart.removeItem(item.product.id),
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            color: const Color(0xFF005CBB),
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: \$${cart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: cart.items.isEmpty ? null : () async {
                      bool ok = await userProv.checkout(userId: auth.currentUser!.uid, cartItems: cart.items.values.toList(), total: cart.totalAmount);
                      if (ok) {
                        cart.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido procesado con éxito')));
                      }
                    },
                    child: const Text('Proceder al pago', style: TextStyle(color: Color(0xFF005CBB))),
                  )
                ],
              ),
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }
}