import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Recetas'),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Icon(Icons.restaurant, color: Color(0xFF005CBB), size: 50), // Icono Gorro/Chef equivalente
          const Text('Recetas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text('Deliciosas recetas con productos Lala', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder(
              stream: Provider.of<UserProvider>(context, listen: false).getRecipes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final recipes = snapshot.data!;
                return ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, i) {
                    final rec = recipes[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: ListTile(
                        title: Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Ingredientes: ${rec.ingredients.join(", ")}\nTiempo: ${rec.time}'),
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