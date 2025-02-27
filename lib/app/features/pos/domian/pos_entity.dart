class PosEntity {
  String id;
  String name;
  String picture;
  String status;
  String auxiliary;
  String deliveryPrice;
  String address;
  String shortAddress;
  String lat;
  String lon;
  String userName;
  String profilePicture;
  bool isDelivering;
  int wilayaId;
  int communeId;

  PosEntity(
      {this.id,
      this.name,
      this.picture,
      this.status,
      this.address,
      this.shortAddress,
      this.auxiliary,
      this.deliveryPrice,
      this.lat,
      this.lon,
      this.communeId,
      this.wilayaId,
      this.isDelivering,
      this.userName,
      this.profilePicture});

  factory PosEntity.fromJson(Map<String, dynamic> json) {
    return PosEntity(
      id: json['id'].toString(),
      name: json['name'],
      picture: json['picture'],
      // status: json['status'],
      address: json['short_address'] +
          ', ' +
          json['commune']['fr'] +
          ', ' +
          json['wilaya']['fr'],
      shortAddress: json['short_address'],
      // lat: json['lat'],
      auxiliary: json['auxiliary'],
      deliveryPrice: json['delivery_price'],
      // lon: json['lon'],
      // wilayaId: int.parse(json['wilaya_id'].toString()),
      // communeId: int.parse(json['commune_id'].toString()),
      // userName: json['user_name'],
      // profilePicture: json['profile_picture'],
    );
  }
}
