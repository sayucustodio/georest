import 'dart:convert';

class RestaurantModel {
  int? id;
  String name;
  String? ruc;
  String latitude;
  String longitude;
  String? comment;
  String? uuid;
  String? createdAt;
  String? updatedAt;
  List<int>? photos;
  bool isSynced; // false = local, true = sincronizado

  RestaurantModel({
    this.id,
    required this.name,
    this.ruc,
    required this.latitude,
    required this.longitude,
    this.comment,
    this.uuid,
    this.createdAt,
    this.updatedAt,
    this.photos,
    this.isSynced = false,
  });

  /*
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "ruc": ruc,
      "latitude": latitude,
      "longitude": longitude,
      "isSynced": isSynced ? 1 : 0, // Convertimos bool a int
      "comment": comment,
    };
  }*/
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ruc": ruc,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "comment": comment,
    };
  }

  Map<String, dynamic> toJsonResponse() {
    return {
      "name": name,
      "ruc": ruc,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "comment": comment,
      "uuid": uuid,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "photos": photos,
    };
  }

  /// 🔹 Convertir desde JSON (de la API o SQLite)
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json["id"],
      name: json["name"],
      ruc: json["ruc"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      uuid: json["uuid"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      isSynced: json["isSynced"] == 1, // Convertimos int a bool
      comment: json["comment"],
    );
  }

  /// 🔹 Convertir de Modelo a Mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
       "id": id,
    "name": name,
    "ruc": ruc ?? "",  // Evita null
    "latitude": latitude,
    "longitude": longitude,
    "isSynced": isSynced ? 1 : 0, 
    "comment": comment ?? "", // Evita null
    "uuid": uuid ?? "",  // Evita null
    "createdAt": createdAt ?? "", // Evita null
    "updatedAt": updatedAt ?? "", // Evita null
    //"photos": photos != null ? jsonEncode(photos) : "[]", 
    };
  }

  /// 🔹 Convertir desde Map (desde SQLite)
  factory RestaurantModel.fromMap(Map<String, dynamic> map) =>
      RestaurantModel.fromJson(map);
}
