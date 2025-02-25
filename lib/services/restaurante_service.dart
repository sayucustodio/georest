import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_1/models/restaurant_model.dart'; // Asegúrate de importar tu modelo
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prueba_1/response/restaurant_response.dart';

class RestauranteService {
  
 final String url =
      "https://op91uffl19.execute-api.us-east-1.amazonaws.com/dev/restaurants";
  final String apiKey = dotenv.env['API_KEY'] ?? "";
   Future<RestaurantResponseModel> registerRestaurant(RestaurantModel restaurant) async {
   
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "x-api-key": apiKey,
        },
        body: jsonEncode(restaurant.toJson()), 
      );

      if (response.statusCode == 201) { // Código 201 cuando se ha creado
        final data = json.decode(response.body);
        print('resultado de api');
        print(data);
        return RestaurantResponseModel.fromJson(data);
      } else {
        throw Exception("Error al registrar: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
