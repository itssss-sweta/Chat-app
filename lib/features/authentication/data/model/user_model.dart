import 'dart:convert';
import 'package:chat_app/features/authentication/domain/entity/user_entity.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data?.toJson());

class UserModel extends UserEntity {
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    number = json['number']?.toString();
    photo = json['photo']?.toString();
    about = json['about']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    data['photo'] = photo;
    data['about'] = about;
    return data;
  }
}
