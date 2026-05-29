import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/recipe_model.dart';
import '../models/review_model.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- STREAMS GLOBALES PARA TABLAS DEL DASHBOARD ---

  Stream<List<ProductModel>> getAllProducts() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<RecipeModel>> getAllRecipes() {
    return _db.collection('recipes').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<ReviewModel>> getAllReviews() {
    return _db.collection('reviews').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<UserModel>> getAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _db.collection('orders').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // --- OPERACIONES CRUD: PRODUCTOS ---

  Future<void> addProduct(ProductModel product) async {
    await _db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    await _db.collection('products').doc(id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }

  // --- OPERACIONES CRUD: RECETAS ---

  Future<void> addRecipe(RecipeModel recipe) async {
    await _db.collection('recipes').add(recipe.toMap());
  }

  Future<void> updateRecipe(String id, RecipeModel recipe) async {
    await _db.collection('recipes').doc(id).update(recipe.toMap());
  }

  Future<void> deleteRecipe(String id) async {
    await _db.collection('recipes').doc(id).delete();
  }

  // --- OPERACIONES CRUD: RESEÑAS ---

  Future<void> addReview(ReviewModel review) async {
    await _db.collection('reviews').add(review.toMap());
  }

  Future<void> updateReview(String id, ReviewModel review) async {
    await _db.collection('reviews').doc(id).update(review.toMap());
  }

  Future<void> deleteReview(String id) async {
    await _db.collection('reviews').doc(id).delete();
  }

  // --- MÉTODOS DE EDICIÓN PARA USUARIOS Y PEDIDOS (Sin botón Agregar) ---

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection('users').doc(id).update(data);
  }

  Future<void> deleteUser(String id) async {
    await _db.collection('users').doc(id).delete();
  }

  Future<void> updateOrderStatus(String id, String newStatus) async {
    await _db.collection('orders').doc(id).update({'status': newStatus});
  }

  Future<void> deleteOrder(String id) async {
    await _db.collection('orders').doc(id).delete();
  }
}