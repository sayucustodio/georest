import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_1/models/tipo_foto_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class TipoFotoService {
  final String url = "https://op91uffl19.execute-api.us-east-1.amazonaws.com/dev/photo-types";
final String apiKey = dotenv.env['API_KEY'] ?? "";

  Future<List<TipoFotoModel>> fetchPhotoTypes() async {
    print('esta es la apikey');
    print(apiKey);
    try {
      final response = await http.get(Uri.parse(url),headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey, 
        },);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<TipoFotoModel> tiposFotos = (data['data'] as List)
            .map((photo) => TipoFotoModel.fromJson(photo))
            .toList();
            print('estas son los tipos de fotitos');
            print(tiposFotos);
        return tiposFotos;
      } else {
        throw Exception("Error al descargar: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
