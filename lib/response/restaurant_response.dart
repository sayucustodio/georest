import 'package:prueba_1/models/restaurant_model.dart';

class RestaurantResponseModel {
  final RestaurantModel data;
  final String mensaje;

  RestaurantResponseModel({
    required this.data,
    required this.mensaje,
  });

  factory RestaurantResponseModel.fromJson(Map<String, dynamic> json) {
    return RestaurantResponseModel(
      data: RestaurantModel.fromJson(json['data']),
      mensaje: json['mensaje'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.toJsonResponse(),
      "mensaje": mensaje,
    };
  }
}
