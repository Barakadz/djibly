class AssetColor {
  int id;
  String name;
  String hex;



  AssetColor({this.id, this.name, this.hex});

  factory AssetColor.fromJson(Map<String, dynamic> json) {
    return AssetColor(
        id: json['id'],
        name: json['name'],
        hex: json['hex']);
  }
}
