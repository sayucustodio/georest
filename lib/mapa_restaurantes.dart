import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:prueba_1/db/database.dart';
import 'package:prueba_1/views/detalle_restaurante_screen.dart';
import 'package:prueba_1/views/form_restaurante.dart';

class MapaRestaurantes extends StatefulWidget {
  @override
  _MapaRestaurantesState createState() => _MapaRestaurantesState();
}

class _MapaRestaurantesState extends State<MapaRestaurantes> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el GPS está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('El GPS está desactivado.');
      return;
    }

    // Verificar y solicitar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Los permisos de ubicación fueron denegados.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Los permisos de ubicación están denegados permanentemente.');
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _cargarRestaurantes();
  }

  Future<void> _cargarRestaurantes() async {
    final dbHelper = DatabaseHelper();
    final restaurantes = await dbHelper.getRestaurants(); 

    Set<Marker> newMarkers = restaurantes.map((rest) {
      return Marker(
        markerId: MarkerId(rest['id'].toString()),
        position: LatLng(rest['latitude'], rest['longitude']),
        infoWindow: InfoWindow(title: rest['name']),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          rest['isSynced'] == 0 ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetallesRestauranteScreen(
                id: rest['uuid']
              ),
            ),
          );
        },
      );
    }).toSet();

    setState(() {
      _markers = newMarkers;
    });
  }
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _onMapTapped(LatLng position) async {
   bool? actualizado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FormularioRestaurante(
              latitud: position.latitude.toString(),
              longitud: position.longitude.toString(),
            ),
      ),
    );
    // Si la pantalla devolvió "true", recargar los restaurantes en el mapa
  if (actualizado == true) {
    _cargarRestaurantes();
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Restaurantes')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onTap: _onMapTapped,
            ),
    );
  }
}
