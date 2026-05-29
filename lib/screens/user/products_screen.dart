import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class ProductsScreen extends StatelessWidget {
  final String category; // 'lacteo' o 'no-lacteo'
  const ProductsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final String title = category == 'lacteo' ? 'Productos Lacteos' : 'Productos No Lacteos';

    return Scaffold(
      appBar: CustomHeader(title: title),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: userProvider.getProductsByCategory(category),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final products = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    final prod = products[i];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(child: Image.network(prod.imageUrl, fit: BoxFit.contain)),
                            Text(prod.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                            Text('\$${prod.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF005CBB))),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF005CBB)),
                              onPressed: () {
                                cartProvider.addProduct(prod);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregado al carrito'), duration: Duration(seconds: 1)));
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }
}