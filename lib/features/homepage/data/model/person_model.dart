import 'dart:convert';

import 'package:chat_app/features/homepage/domain/entity/person_entity.dart';

PersonalDetailModel personalDetailModelFromJson(String str) =>
    PersonalDetailModel.fromJson(json.decode(str));

String personalDetailModelToJson(PersonalDetailModel? data) =>
    json.encode(data?.toJson());

class PersonalDetailModel extends PersonalDetailEntity {
  PersonalDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    number = json['number']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    return data;
  }
}
