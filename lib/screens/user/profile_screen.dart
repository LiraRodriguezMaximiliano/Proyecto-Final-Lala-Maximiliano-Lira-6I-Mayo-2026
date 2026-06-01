import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showEditDialog(BuildContext context, dynamic user, AuthProvider auth) {
    final nameCtrl = TextEditingController(text: user?.name);
    final phoneCtrl = TextEditingController(text: user?.phone);
    final addressCtrl = TextEditingController(text: user?.address);
    final picCtrl = TextEditingController(text: user?.profilePic);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil', style: TextStyle(color: Color(0xFF005CBB))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
              TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
              TextField(controller: picCtrl, decoration: const InputDecoration(labelText: 'URL Foto de Perfil')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB)),
            onPressed: () async {
              bool success = await auth.updateProfile(
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                profilePic: picCtrl.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? 'Perfil actualizado' : 'Error al actualizar')),
              );
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
                    onPressed: () => _showEditDialog(context, user, auth),
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
