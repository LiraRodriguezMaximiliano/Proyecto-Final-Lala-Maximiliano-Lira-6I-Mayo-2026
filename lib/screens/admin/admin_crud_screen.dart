import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../models/product_model.dart';
import '../../models/recipe_model.dart';
import '../../models/review_model.dart';
import '../../widgets/custom_footer.dart';

class AdminCrudScreen extends StatefulWidget {
  final String collectionType;
  const AdminCrudScreen({Key? key, required this.collectionType}) : super(key: key);

  @override
  State<AdminCrudScreen> createState() => _AdminCrudScreenState();
}

class _AdminCrudScreenState extends State<AdminCrudScreen> {
  // Controladores genéricos para los formularios
  final _field1Ctrl = TextEditingController(); // Nombre / Título / Usuario
  final _field2Ctrl = TextEditingController(); // Categoría / Tiempo / Mensaje
  final _field3Ctrl = TextEditingController(); // Precio / Ingredientes (separados por coma) / Estrellas
  final _field4Ctrl = TextEditingController(); // URL de Imagen (Solo para productos)
  bool _isOffer = false;

  // Limpiar controladores al cerrar
  void _clearControllers() {
    _field1Ctrl.clear();
    _field2Ctrl.clear();
    _field3Ctrl.clear();
    _field4Ctrl.clear();
    _isOffer = false;
  }

  // Cargar datos si se va a editar
  void _loadItemData(dynamic item) {
    if (widget.collectionType == 'products') {
      _field1Ctrl.text = item.name;
      _field2Ctrl.text = item.category;
      _field3Ctrl.text = item.price.toString();
      _field4Ctrl.text = item.imageUrl;
      _isOffer = item.isOffer;
    } else if (widget.collectionType == 'recipes') {
      _field1Ctrl.text = item.title;
      _field2Ctrl.text = item.time;
      _field3Ctrl.text = item.ingredients.join(', ');
    } else if (widget.collectionType == 'reviews') {
      _field1Ctrl.text = item.userName;
      _field2Ctrl.text = item.message;
      _field3Ctrl.text = item.stars.toString();
    }
  }

  // --- FORMULARIO DINÁMICO (BOTTOM SHEET) ---
  void _showFormSheet(BuildContext context, {dynamic item}) {
    final isEditing = item != null;
    if (isEditing) _loadItemData(item); else _clearControllers();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder( // Permite actualizar el checkbox de la oferta en tiempo real
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Evita que el teclado tape el input
                top: 20, left: 20, right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Editar Registro' : 'Agregar Nuevo Registro',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005CBB)),
                    ),
                    const SizedBox(height: 15),
                    
                    // Campos adaptativos según la colección
                    TextField(
                      controller: _field1Ctrl,
                      decoration: InputDecoration(
                        labelText: widget.collectionType == 'products' ? 'Nombre del Producto' 
                                  : widget.collectionType == 'recipes' ? 'Título de la Receta' : 'Nombre de Usuario'
                      ),
                    ),
                    TextField(
                      controller: _field2Ctrl,
                      decoration: InputDecoration(
                        labelText: widget.collectionType == 'products' ? 'Categoría (lacteo / no-lacteo)' 
                                  : widget.collectionType == 'recipes' ? 'Tiempo de preparación' : 'Mensaje de la Reseña'
                      ),
                    ),
                    TextField(
                      controller: _field3Ctrl,
                      decoration: InputDecoration(
                        labelText: widget.collectionType == 'products' ? 'Precio' 
                                  : widget.collectionType == 'recipes' ? 'Ingredientes (separados por comas)' : 'Estrellas (1-5)'
                      ),
                      keyboardType: widget.collectionType == 'recipes' ? TextInputType.text : TextInputType.number,
                    ),
                    if (widget.collectionType == 'products') ...[
                      TextField(
                        controller: _field4Ctrl,
                        decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                      ),
                      CheckboxListTile(
                        title: const Text("¿Es una oferta especial?"),
                        value: _isOffer,
                        activeColor: const Color(0xFF005CBB),
                        onChanged: (val) => setModalState(() => _isOffer = val ?? false),
                      )
                    ],
                    
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEditing ? Colors.blue : Colors.green,
                        minimumSize: const Size(double.infinity, 50)
                      ),
                      onPressed: () => _saveData(context, isEditing, item?.id),
                      child: Text(isEditing ? 'Actualizar' : 'Guardar', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showStatusDialog(BuildContext context, String orderId, String currentStatus) {
    String selectedStatus = currentStatus;
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Actualizar Estado del Pedido'),
          content: DropdownButton<String>(
            value: selectedStatus,
            isExpanded: true,
            items: ['procesando', 'en camino', 'entregado'].map((String val) {
              return DropdownMenuItem<String>(value: val, child: Text(val.toUpperCase()));
            }).toList(),
            onChanged: (val) => setDialogState(() => selectedStatus = val!),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                await adminProv.updateOrderStatus(orderId, selectedStatus);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Estado actualizado correctamente')));
              },
              child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  // --- GUARDAR / ACTUALIZAR EN FIREBASE ---
  void _saveData(BuildContext context, bool isEditing, String? docId) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    try {
      if (widget.collectionType == 'products') {
        final prod = ProductModel(
          id: docId ?? '',
          name: _field1Ctrl.text.trim(),
          category: _field2Ctrl.text.trim(),
          price: double.tryParse(_field3Ctrl.text) ?? 0.0,
          imageUrl: _field4Ctrl.text.trim(),
          isOffer: _isOffer,
        );
        if (isEditing) await adminProv.updateProduct(docId!, prod); else await adminProv.addProduct(prod);
      } 
      else if (widget.collectionType == 'recipes') {
        final rec = RecipeModel(
          id: docId ?? '',
          title: _field1Ctrl.text.trim(),
          time: _field2Ctrl.text.trim(),
          ingredients: _field3Ctrl.text.split(',').map((e) => e.trim()).toList(),
        );
        if (isEditing) await adminProv.updateRecipe(docId!, rec); else await adminProv.addRecipe(rec);
      } 
      else if (widget.collectionType == 'reviews') {
        final rev = ReviewModel(
          id: docId ?? '',
          userName: _field1Ctrl.text.trim(),
          message: _field2Ctrl.text.trim(),
          stars: int.tryParse(_field3Ctrl.text) ?? 5,
        );
        if (isEditing) await adminProv.updateReview(docId!, rev); else await adminProv.addReview(rev);
      }

      Navigator.pop(context); // Cerrar BottomSheet
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Operación realizada con éxito')));
      _clearControllers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  // --- DIÁLOGO DE CONFIRMACIÓN PARA ELIMINAR ---
  void _confirmDelete(BuildContext context, String id) {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar registro?'),
        content: const Text('Esta acción borrará permanentemente el elemento de Firebase Console.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (widget.collectionType == 'products') await adminProv.deleteProduct(id);
              if (widget.collectionType == 'recipes') await adminProv.deleteRecipe(id);
              if (widget.collectionType == 'reviews') await adminProv.deleteReview(id);
              if (widget.collectionType == 'users') await adminProv.deleteUser(id);
              if (widget.collectionType == 'orders') await adminProv.deleteOrder(id);
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro eliminado')));
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    final String translatedTitle = widget.collectionType == 'products' ? 'Productos'
                                 : widget.collectionType == 'recipes' ? 'Recetas'
                                 : widget.collectionType == 'reviews' ? 'Reseñas'
                                 : widget.collectionType == 'users' ? 'Usuarios' : 'Pedidos';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text('Gestión de $translatedTitle', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF005CBB),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          // Botón agregar: Visible solo para Productos, Recetas y Reseñas
          if (widget.collectionType != 'users' && widget.collectionType != 'orders')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: () => _showFormSheet(context),
                child: const Text('+ Agregar Nuevo', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: widget.collectionType == 'products' ? adminProv.getAllProducts()
                     : widget.collectionType == 'recipes' ? adminProv.getAllRecipes()
                     : widget.collectionType == 'reviews' ? adminProv.getAllReviews()
                     : widget.collectionType == 'users' ? adminProv.getAllUsers()
                     : adminProv.getAllOrders(),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFF005CBB)));
                final list = snapshot.data!;
                if (list.isEmpty) return const Center(child: Text('No hay registros en esta colección.'));

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final item = list[i];
                    String title = '';
                    String subtitle = '';

                    // Extracción de datos según el modelo mapeado
                    if (widget.collectionType == 'products') {
                      title = item.name;
                      subtitle = 'Categoría: ${item.category} • \$${item.price.toStringAsFixed(2)}';
                    } else if (widget.collectionType == 'recipes') {
                      title = item.title;
                      subtitle = 'Tiempo: ${item.time}';
                    } else if (widget.collectionType == 'reviews') {
                      title = item.userName;
                      subtitle = 'Estrellas: ${item.stars} • "${item.message}"';
                    } else if (widget.collectionType == 'users') {
                      title = item.name;
                      subtitle = 'Email: ${item.email}';
                    } else if (widget.collectionType == 'orders') {
                      title = 'Pedido ID: ${item.id.toString().substring(0, 6)}...';
                      subtitle = 'Fecha: ${item.date} • Estado: ${item.status.toUpperCase()}';
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFF005CBB), width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(subtitle),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Deshabilitar edición directa de estructura para usuarios/pedidos completos
                            if (widget.collectionType != 'users' && widget.collectionType != 'orders')
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showFormSheet(context, item: item),
                              ),
                            if (widget.collectionType == 'orders')
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showStatusDialog(context, item.id, item.status),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(context, widget.collectionType == 'users' ? item.uid : item.id),
                            ),
                          ],
                        ),
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
