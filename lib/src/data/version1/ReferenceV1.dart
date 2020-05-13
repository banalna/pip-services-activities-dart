import 'package:pip_services3_commons/pip_services3_commons.dart';

class ReferenceV1 implements IStringIdentifiable {
  @override
  String id;
  String type;
  String name;

  ReferenceV1(
      {String id,
      String type,
      String name})
      : id = id,
        type = type,
        name = name;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];    
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'name': name      
    };
  }

  factory ReferenceV1.fromJsonRef(Map<String, dynamic> json) {    
    return json != null ? ReferenceV1(id: json['id'], type: json['type'], name: json['name']) : null;
  } 
}