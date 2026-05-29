import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_footer.dart';
import 'admin_crud_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  Widget _buildCard(BuildContext context, String title, IconData icon, String type) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminCrudScreen(collectionType: type))),
      child: Card(
        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFF005CBB), width: 1.5), borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xFF005CBB),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: const Color(0xFF005CBB),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('¡Hola administrador!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Selecciona una opcion para gestionar', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                _buildCard(context, 'Productos', Icons.shopping_bag, 'products'),
                _buildCard(context, 'Recetas', Icons.restaurant_menu, 'recipes'),
                _buildCard(context, 'Reseñas', Icons.rate_review, 'reviews'),
                _buildCard(context, 'Usuarios', Icons.people, 'users'),
                _buildCard(context, 'Pedidos', Icons.delivery_dining, 'orders'),
              ],
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }
}