import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomHeader(title: product.name, showLeading: false),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Hero(
                      tag: product.id,
                      child: Image.network(product.imageUrl, height: 280, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      if (product.isOffer)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                          child: const Text('OFERTA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Categoría: ${product.category == 'lacteo' ? 'Lácteo' : 'No Lácteo'}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 15),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF005CBB))),
                  const SizedBox(height: 20),
                  const Text('Descripción del Producto:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Disfruta de la calidad Lala seleccionada bajo los más altos estándares para acompañar tu día a día con frescura y nutrición excepcional.', style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB), minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    label: const Text('Agregar al Carrito', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      cartProvider.addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito con éxito'), duration: Duration(seconds: 1)));
                    },
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
