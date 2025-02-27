import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photo;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
  });

  @override
  List<Object> get props => [id, name, email, phone, photo];
}
