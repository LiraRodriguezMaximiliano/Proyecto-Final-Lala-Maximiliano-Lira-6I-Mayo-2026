import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
// Importación de Proveedores
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/admin_provider.dart';

// Importación de Vistas Base (Pantallas de Autenticación temporalmente mapeadas)
// Nota: Crearemos el código físico de estas pantallas en el siguiente bloque.
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/products_screen.dart';
import 'screens/user/recipes_screen.dart';
import 'screens/user/reviews_screen.dart';
import 'screens/user/cart_screen.dart';
import 'screens/user/profile_screen.dart';
import 'screens/user/orders_screen.dart';
import 'screens/admin/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Requiere los archivos google-services.json (Android) / GoogleService-Info.plist (iOS)
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Lala App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, // Fondo principal blanco solicitado
          primaryColor: const Color(0xFF005CBB), // Azul Claro/Medio
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFF005CBB),
          ),
        ),
        // Pantalla inicial: Evalúa si hay sesión activa
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/lacteos': (context) => const ProductsScreen(category: 'lacteo'),
          '/no_lacteos': (context) => const ProductsScreen(category: 'no-lacteo'),
          '/recipes': (context) => const RecipesScreen(),
          '/reviews': (context) => const ReviewsScreen(),
          '/cart': (context) => const CartScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/admin_dashboard': (context) => const AdminDashboardScreen(),
          // Las sub-rutas de pantallas se integrarán directamente al codificar cada sección.
        },
      ),
    );
  }
}

// Filtro de Seguridad para decidir si el usuario va al Dashboard de Admin o a la App de Clientes
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Si está cargando datos de Firebase, muestra un indicador circular de progreso
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF005CBB))),
      );
    }

    // Si está autenticado, valida el campo isAdmin de Firestore
    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      if (authProvider.currentUser!.isAdmin) {
        return const AdminDashboardScreen();
      } else {
        return const HomeScreen();
      }
    }

    // Si no está autenticado, lo envía directamente al Login
    return LoginScreen();
  }
}