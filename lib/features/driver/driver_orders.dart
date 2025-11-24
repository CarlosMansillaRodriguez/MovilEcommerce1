import 'package:flutter/material.dart';

class DriverOrders extends StatelessWidget {
  const DriverOrders({super.key});

  final List<Map<String, String>> pedidos = const [
    {
      "numero": "001",
      "cliente": "Juan Pérez",
      "direccion": "Av. Libertador 123",
      "estado": "Pendiente"
    },
    {
      "numero": "002",
      "cliente": "María López",
      "direccion": "Calle Sucre 456",
      "estado": "En camino"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis pedidos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.local_shipping),
              title: Text("Pedido #${pedido['numero']}"),
              subtitle: Text(
                  "Cliente: ${pedido['cliente']}\nDirección: ${pedido['direccion']}"),
              trailing: Text(
                pedido['estado'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
