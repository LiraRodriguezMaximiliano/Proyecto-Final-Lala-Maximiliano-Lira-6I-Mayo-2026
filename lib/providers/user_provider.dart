import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/recipe_model.dart';
import '../models/review_model.dart';
import '../models/order_model.dart';
import 'cart_provider.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream de Productos por categoría
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Stream de la última Oferta agregada a la Base de Datos
  Stream<ProductModel?> getLatestOffer() {
    return _db
        .collection('products')
        .where('isOffer', isEqualTo: true)
        // Se asume que en Firebase tienes un campo id o puedes ordenarlo. 
        // Si no hay timestamps, tomamos el primero de los que estén marcados como oferta.
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return ProductModel.fromMap(snapshot.docs.last.data(), snapshot.docs.last.id);
          }
          return null;
        });
  }

  // Stream de Recetas
  Stream<List<RecipeModel>> getRecipes() {
    return _db.collection('recipes').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => RecipeModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Stream de Reseñas
  Stream<List<ReviewModel>> getReviews() {
    return _db.collection('reviews').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // Stream de Pedidos del Usuario Autenticado
  Stream<List<OrderModel>> getUserOrders(String userUid) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Convertir el carrito local en un pedido formal en Firebase
  Future<bool> checkout({
    required String userId,
    required List<CartItem> cartItems,
    required double total,
  }) async {
    try {
      List<Map<String, dynamic>> itemsMap = cartItems.map((item) {
        return {
          'productName': item.product.name,
          'quantity': item.quantity,
          'price': item.product.price,
        };
      }).toList();

      DateTime now = DateTime.now();
      String formattedDate = "${now.day}/${now.month}/${now.year}";

      await _db.collection('orders').add({
        'userId': userId,
        'status': 'procesando',
        'date': formattedDate,
        'total': total,
        'items': itemsMap,
      });

      return true;
    } catch (e) {
      print("Error al procesar el pago: $e");
      return false;
    }
  }
}