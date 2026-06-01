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

  void _showPaymentDialog(BuildContext context, CartProvider cart, UserProvider userProv, String userId) {
  String paymentMethod = 'Efectivo';
  final cardCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Método de Pago', style: TextStyle(color: Color(0xFF005CBB))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text('Efectivo'),
                value: 'Efectivo',
                groupValue: paymentMethod,
                onChanged: (val) => setDialogState(() => paymentMethod = val.toString()),
              ),
              RadioListTile(
                title: const Text('Tarjeta de Crédito/Débito'),
                value: 'Tarjeta',
                groupValue: paymentMethod,
                onChanged: (val) => setDialogState(() => paymentMethod = val.toString()),
              ),
              if (paymentMethod == 'Tarjeta') ...[
                const SizedBox(height: 10),
                TextField(controller: cardCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Número de Tarjeta', hintText: '1234 5678 9123 4567')),
                Row(
                  children: [
                    Expanded(child: TextField(controller: expCtrl, decoration: const InputDecoration(labelText: 'Vencimiento', hintText: 'MM/AA'))),
                    const SizedBox(width: 15),
                    Expanded(child: TextField(controller: cvvCtrl, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'CVV'))),
                  ],
                )
              ]
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB)),
            onPressed: () async {
              if (paymentMethod == 'Tarjeta' && (cardCtrl.text.isEmpty || expCtrl.text.isEmpty || cvvCtrl.text.isEmpty)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor llena los datos de la tarjeta')));
                return;
              }
              
              bool ok = await userProv.checkout(
                userId: userId, 
                cartItems: cart.items.values.toList(), 
                total: cart.totalAmount
              );
              
              Navigator.pop(context);
              if (ok) {
                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Pedido confirmado con éxito!')));
              }
            },
            child: const Text('Confirmar Pedido', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    ),
  );
}

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
                        _showPaymentDialog(context, cart, userProv, auth.currentUser!.uid);
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
