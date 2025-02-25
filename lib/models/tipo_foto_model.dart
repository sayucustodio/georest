class TipoFotoModel {
  final String uuid;
  final String name;
  final String description;

  TipoFotoModel({required this.uuid, required this.name, required this.description});

  // Convertir de JSON a Modelo
  factory TipoFotoModel.fromJson(Map<String, dynamic> json) {
    return TipoFotoModel(
      uuid: json["uuid"],
      name: json["name"],
      description: json["description"],
    );
  }

  // Convertir de Modelo a Mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      "uuid": uuid,
      "name": name,
      "description": description,
    };
  }
}
