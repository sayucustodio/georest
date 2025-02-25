import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prueba_1/db/database.dart';
import 'package:prueba_1/models/restaurant_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:prueba_1/services/restaurante_service.dart';
import 'package:prueba_1/views/widget/show_snackbar_awesome.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class FormularioRestaurante extends StatefulWidget {
  final String latitud;
  final String longitud;

  FormularioRestaurante({required this.latitud, required this.longitud});

  @override
  _FormularioRestauranteState createState() => _FormularioRestauranteState();
}

class _FormularioRestauranteState extends State<FormularioRestaurante>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> photoTypes = [];
  Map<String, File?> capturedPhotos = {};

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _rucController = TextEditingController();
  TextEditingController _comentarioController = TextEditingController();
  File? _foto;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPhotoTypes();
  }

  Future<void> _loadPhotoTypes() async {
    List<Map<String, dynamic>> data = await DatabaseHelper().getPhotoTypes();
    setState(() {
      photoTypes = data;
      // Inicializar cada tipo de foto con null (sin foto tomada)
      for (var photo in photoTypes) {
        capturedPhotos[photo["uuid"]] = null;
      }
    });
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto(String uuid) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        capturedPhotos[uuid] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurantes")),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [Tab(text: "Datos"), Tab(text: "Fotos")],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child:  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Registro de Restaurante",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 16),
    TextFormField(
      controller: _nombreController,
      decoration: InputDecoration(
        labelText: "Nombre",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.restaurant),
      ),
      validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
    ),
    SizedBox(height: 12),
    TextFormField(
      controller: _rucController,
      decoration: InputDecoration(
        labelText: "RUC",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.business),
      ),
    ),
    SizedBox(height: 12),
    Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ubicación",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(child: Text("Latitud: ${widget.latitud}")),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blueAccent),
                SizedBox(width: 8),
                Expanded(child: Text("Longitud: ${widget.longitud}")),
              ],
            ),
          ],
        ),
      ),
    ),
    SizedBox(height: 12),
    TextFormField(
      controller: _comentarioController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Comentario",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.comment),
      ),
    ),
  ],
),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    photoTypes.isEmpty
                        ? Center(
                          child: CircularProgressIndicator(),
                        ) // Loader mientras carga
                        : Expanded(
                          // 🔥 Esto le da tamaño definido al ListView
                          child: ListView.builder(
                            itemCount: photoTypes.length,
                            itemBuilder: (context, index) {
                              String uuid = photoTypes[index]["uuid"];
                              String name = photoTypes[index]["name"];
                              String description =
                                  photoTypes[index]["description"];

                              return Card(
                                margin: EdgeInsets.all(10),
                                color: const Color.fromARGB(194, 3, 124, 172),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                      Text(
                                        description,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      capturedPhotos[uuid] == null
                                          ? Container(
                                            height: 150,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Text("No hay foto tomada"),
                                            ),
                                          )
                                          : Image.file(
                                            capturedPhotos[uuid]!,
                                            height: 150,
                                          ),
                                      SizedBox(height: 10),
                                      ElevatedButton.icon(
          onPressed: () => _takePhoto(uuid),
          icon: Icon(Icons.save, color: Colors.white),
          label: Text("Tomar foto"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 2, 89, 170),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
                                      
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Botones en la parte inferior
      bottomNavigationBar: BottomAppBar(
  shape: CircularNotchedRectangle(),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              capturedPhotos.clear();
            });
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel, color: Colors.red),
          label: Text("Cancelar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            side: BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: saveRegistro,
          icon: Icon(Icons.save, color: Colors.white),
          label: Text("Guardar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
      ],
    ),
  ),
),
    );
  }

  void saveRegistro() async {
    int resultado = 0;
    if (_formKey.currentState!.validate()) {
      RestaurantModel nuevoRestaurante = RestaurantModel(
        name: _nombreController.text,
        ruc: _rucController.text.isNotEmpty ? _rucController.text : null,
        latitude: widget.latitud,
        longitude: widget.longitud,
        comment:
            _comentarioController.text.isNotEmpty
                ? _comentarioController.text
                : null,
        isSynced: false, // No sincronizado con la API aún
      );
      try {
        await DatabaseHelper().insertRestaurant(nuevoRestaurante);
        // Verificar si hay internet para sincronizar en segundo plano
        if (await tieneConexionInternet()) {
          resultado = await sincronizarConAPI(nuevoRestaurante);
        }
        if (resultado == 1) {
          Navigator.pop(context,true);
          showSnackBarAwesome(
            context,
            'EXITO',
            'Restaurante sincronizado con éxito.',
            ContentType.success,
          );
        } else {
          Navigator.pop(context,true);
          showSnackBarAwesome(
            context,
            'ERROR',
            'No hay conexion a internet. Cuando se reconecte se sincronizará con la API',
            ContentType.failure,
          );
        }
      } catch (e) {
        Navigator.pop(context,true);
        showSnackBarAwesome(
          context,
          'ERROR',
          'No hay conexion a internet. Cuando se reconecte se sincronizará con la API',
          ContentType.failure,
        );
      }
    }
  }

  Future<bool> tieneConexionInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  Future<int> sincronizarConAPI(RestaurantModel nuevoRestaurante) async {
    try {
      print("Sincronizando datos con la API...");
      final response = await RestauranteService().registerRestaurant(
        nuevoRestaurante,
      );
      print("mensajito de resouesa");
      print(response.mensaje);
      if (response.mensaje == "Restaurante creado correctamente") {
        try {
          nuevoRestaurante.isSynced = true;
          await DatabaseHelper().updateRestaurant(response.data);
        } catch (dbError) {
          print("no se actualizo el sync en la bd local.$dbError");
          Navigator.pop(context,true);
          showSnackBarAwesome(
            context,
            'ERROR',
            'No hay conexion a internet. Cuando se reconecte se sincronizará con la API. $dbError',
            ContentType.failure,
          );
        }
      }
      return 1;
    } catch (e) {
      print("Error al sincronizar con la API: $e");
      return 0;
    }
  }
}
