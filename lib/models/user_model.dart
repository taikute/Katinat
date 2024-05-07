// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String phoneNumber;
  final String password;
  final String name;
  String? email;
  String? avataUrl;

  UserModel({
    required this.phoneNumber,
    required this.password,
    required this.name,
    this.email,
    this.avataUrl,
  });

  factory UserModel.fromSnapshot(DataSnapshot snapshot) {
    final map = snapshot.value as Map;
    return UserModel(
      name: map['name'],
      phoneNumber: snapshot.key!,
      password: map['password'],
      avataUrl: map['avata_url'],
      email: map['email'],
    );
  }
}
