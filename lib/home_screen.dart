import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prueba_1/database.dart';
import 'package:prueba_1/db/database.dart';
import 'package:prueba_1/mapa_restaurantes.dart';
import 'package:prueba_1/models/tipo_foto_model.dart';
import 'package:prueba_1/services/tipo_foto_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalRestaurants = 0;
  int pendingSync = 0;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final restaurants = await db.getRestaurants();
    final pending = restaurants.where((r) => r['isSynced'] == 0).length;

    setState(() {
      totalRestaurants = restaurants.length;
      pendingSync = pending;
    });
  }

  Future<void> _downloadPhotoTypes() async {
    TipoFotoService tipoFotoService = TipoFotoService();

    try {
      List<TipoFotoModel> photoTypes = await tipoFotoService.fetchPhotoTypes();

      // Guardar en SQLite
      await DatabaseHelper().insertPhotoTypes(photoTypes);

      setState(() {}); // Refrescar UI
      await verificarDatos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tipos de foto descargados con éxito")),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> verificarDatos() async {
    List<Map<String, dynamic>> photoTypes =
        await DatabaseHelper().getPhotoTypes();
    print("📸 Tipos de Fotos en la Base de Datos:");
    for (var photo in photoTypes) {
      print(
        "UUID: ${photo['uuid']}, Nombre: ${photo['name']}, Descripción: ${photo['description']}",
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total de Restaurantes: $totalRestaurants"),
                Text("Pendientes de Sincronización: $pendingSync"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _downloadPhotoTypes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, // Color celeste
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Espaciado
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Bordes redondeados
                    ),
                    elevation: 5, 
                  ),
                  child: Text(
                    "Descargar Tipos de Foto",
                    style: TextStyle(
                      color: Colors.white, // Texto en blanco
                      fontSize: 16, // Tamaño de fuente
                      fontWeight:
                          FontWeight.bold, // Negrita para mejor visibilidad
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: MapaRestaurantes()), // Aquí se muestra el mapa
          /*Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(-12.0464, -77.0428), // Ubicación por defecto
                zoom: 12,
              ),
              myLocationEnabled: true,
              markers: {}, // Se agregarán los marcadores dinámicamente
            ),
          ),*/
        ],
      ),
    );
  }
}
