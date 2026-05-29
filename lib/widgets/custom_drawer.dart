import 'package:flutter/material.dart';
import 'package:lala/providers/auth_provider.dart';
import 'package:provider/provider.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF005CBB)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: (authProvider.currentUser?.profilePic ?? '').isNotEmpty
                ? NetworkImage(authProvider.currentUser!.profilePic)
                : null,
              child: (authProvider.currentUser?.profilePic ?? '').isEmpty
                ? const Icon(Icons.person, size: 40, color: Color(0xFF005CBB))
                : null,
            ),
            accountName: Text(authProvider.currentUser?.name ?? 'Usuario Lala'),
            accountEmail: Text(authProvider.currentUser?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xFF005CBB)),
            title: const Text('Inicio'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.opacity, color: Color(0xFF005CBB)),
            title: const Text('Productos Lácteos'),
            onTap: () => Navigator.pushNamed(context, '/lacteos'),
          ),
          ListTile(
            leading: const Icon(Icons.eco, color: Color(0xFF005CBB)),
            title: const Text('Productos No Lácteos'),
            onTap: () => Navigator.pushNamed(context, '/no_lacteos'),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu, color: Color(0xFF005CBB)),
            title: const Text('Recetas'),
            onTap: () => Navigator.pushNamed(context, '/recipes'),
          ),
          ListTile(
            leading: const Icon(Icons.rate_review, color: Color(0xFF005CBB)),
            title: const Text('Reseñas'),
            onTap: () => Navigator.pushNamed(context, '/reviews'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xFF005CBB)),
            title: const Text('Mi Carrito'),
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Color(0xFF005CBB)),
            title: const Text('Mi Perfil'),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long, color: Color(0xFF005CBB)),
            title: const Text('Mis Pedidos'),
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          const Divider(),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}