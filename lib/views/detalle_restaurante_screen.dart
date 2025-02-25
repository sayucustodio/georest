import 'package:flutter/material.dart';
import 'package:prueba_1/db/database.dart';

class DetallesRestauranteScreen extends StatelessWidget {
  final String id;

  const DetallesRestauranteScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<Map<String, dynamic>?> _fetchRestaurant() async {
    final dbHelper = DatabaseHelper();
    final restaurantes = await dbHelper.getRestaurants();

    try {
      return restaurantes.firstWhere((r) => r['uuid'] == id, orElse: () => {});
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        title: Text('Detalles del Restaurante'),
        backgroundColor: Colors.amberAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchRestaurant(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No se encontró el restaurante.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final detalle = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[900], // Azul oscuro
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        detalle['name'] ?? 'Sin Nombre',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: "Ubicación",
                      content: "Latitud: ${detalle['latitude'] ?? 'N/A'}\nLongitud: ${detalle['longitude'] ?? 'N/A'}",
                    ),
                    _buildInfoCard(
                      icon: Icons.business,
                      title: "RUC",
                      content: detalle['ruc'] ?? "Sin RUC",
                    ),
                    _buildInfoCard(
                      icon: Icons.sync,
                      title: "Estado de Sincronización",
                      content: detalle['isSynced'] == 1
                          ? "✅ Sincronizado con API"
                          : "❌ No sincronizado",
                      color: detalle['isSynced'] == 1 ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    Color color = Colors.black,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[900]),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          content,
          style: TextStyle(color: color, fontSize: 16),
        ),
      ),
    );
  }
}
