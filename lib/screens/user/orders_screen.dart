import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/custom_footer.dart';
import '../../widgets/custom_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: const CustomHeader(title: 'Mis Pedidos'),
      endDrawer: const CustomDrawer(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text('Mis Pedidos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder(
              stream: userProv.getUserOrders(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final orders = snapshot.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    final ord = orders[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${ord.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Estado: ${ord.status}', style: TextStyle(color: ord.status == 'entregado' ? Colors.green : Colors.orange)),
                            Text('Fecha: ${ord.date}'),
                            const SizedBox(height: 5),
                            ...ord.items.map((item) => Text('• ${item.productName} (x${item.quantity})')),
                            const Divider(),
                            Text('Total: \$${ord.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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