import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: const CustomHeader(title: 'Mi Perfil'),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user?.profilePic.isNotEmpty == true ? NetworkImage(user!.profilePic) : null,
                    child: user?.profilePic.isEmpty == true ? const Icon(Icons.person, size: 50) : null,
                  ),
                  const SizedBox(height: 10),
                  Text(user?.name ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Correo: ${user?.email ?? ""}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Text('Teléfono: ${user?.phone ?? ""}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        Text('Dirección: ${user?.address ?? ""}', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB), minimumSize: const Size(double.infinity, 50)),
                    onPressed: () {}, // Lógica para activar edición
                    child: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
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