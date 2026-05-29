import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String? error = await auth.login(_emailController.text.trim(), _passwordController.text.trim());
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('LALA', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Color(0xFF005CBB), letterSpacing: 3)),
                  const SizedBox(height: 30),
                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Correo Electrónico')),
                  TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
                  const SizedBox(height: 30),
                  auth.isLoading 
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005CBB), minimumSize: const Size(double.infinity, 50)),
                        onPressed: _submit, 
                        child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white))
                      ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('¿No tienes cuenta? Regístrate aquí', style: TextStyle(color: Color(0xFF005CBB))),
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