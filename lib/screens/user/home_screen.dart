import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';
import 'products_screen.dart';
import 'recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Imagen todo el ancho de la pantalla (URL web)
                  Image.network(
                    'https://raw.githubusercontent.com/LiraRodriguezMaximiliano/imagenes-para-flutter-6I-11-02-26/refs/heads/main/Chayanne.jpg?q=80&w=1200',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 15),
                  
                  // Card Oferta Especial (Bordes Rojos)
                  StreamBuilder(
                    stream: userProvider.getLatestOffer(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) return const SizedBox();
                      final offer = snapshot.data!;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_offer, color: Colors.red, size: 30),
                                  SizedBox(width: 10),
                                  Text('Oferta especial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Image.network(offer.imageUrl, height: 120, fit: BoxFit.contain),
                              Text(offer.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('\$${offer.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF005CBB), fontSize: 16)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  // Card Bienvenido (Bordes Azules)
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFF005CBB), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text('Bienvenido a Lala', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF005CBB))),
                          const SizedBox(height: 10),
                          const Text('Explora nuestros productos lacteos y no lacteos de la mas alta calidad', textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB)),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsScreen(category: 'lacteo'))),
                                  child: const Text('Ver Productos', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF005CBB))),
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecipesScreen())),
                                  child: const Text('Ver Recetas', style: TextStyle(color: Color(0xFF005CBB))),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
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