import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _auth.currentUser != null;

  // Monitorear el estado de la autenticación al iniciar la app
  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      await fetchUserData(firebaseUser.uid);
    }
  }

  // Obtener los datos del usuario desde Firestore
  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      }
    } catch (e) {
      print("Error al obtener datos de usuario: $e");
    }
  }

  // Iniciar Sesión
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fetchUserData(credential.user!.uid);
      _setLoading(false);
      return null; // Sin errores
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message;
    }
  }

  // Crear Cuenta (Registro de Usuario Normal)
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    _setLoading(true);
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Instancia del nuevo usuario (isAdmin siempre false por defecto en registro abierto)
      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        address: address,
        profilePic: '', // Vacío inicialmente para cargar por URL después
        isAdmin: false,
      );

      // Guardar en Firestore
      await _db.collection('users').doc(credential.user!.uid).set(newUser.toMap());
      _currentUser = newUser;
      
      _setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message;
    }
  }

  // Actualizar perfil del usuario actual
  Future<bool> updateProfile({required String name, required String phone, required String address, required String profilePic}) async {
    if (_currentUser == null) return false;
    try {
      await _db.collection('users').doc(_currentUser!.uid).update({
        'name': name,
        'phone': phone,
        'address': address,
        'profilePic': profilePic,
      });
      
      _currentUser = UserModel(
        uid: _currentUser!.uid,
        name: name,
        email: _currentUser!.email,
        phone: phone,
        address: address,
        profilePic: profilePic,
        isAdmin: _currentUser!.isAdmin,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print("Error al actualizar perfil: $e");
      return false;
    }
  }

  // Cerrar Sesión
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}