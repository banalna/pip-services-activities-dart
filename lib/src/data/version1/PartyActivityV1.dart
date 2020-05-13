import 'package:pip_services3_commons/pip_services3_commons.dart';
import './ReferenceV1.dart';

class PartyActivityV1 implements IStringIdentifiable {
  @override
  /* Identification */
  String id;
  String org_id;

  /* Identification fields */
  DateTime time;
  String type;
  ReferenceV1 party;

  /* References objects (notes, goals, etc.) */
  ReferenceV1 ref_item;
  List<ReferenceV1> ref_parents;
  ReferenceV1 ref_party;

  /* Other details like % of progress or new status */
  StringValueMap details;


  PartyActivityV1(
      {String id,
      String org_id,
      DateTime time,
      String type,
      ReferenceV1 party,
      ReferenceV1 ref_item,
      List<ReferenceV1> ref_parents,
      ReferenceV1 ref_party,
      StringValueMap details})
      : id = id,
        org_id = org_id,
        time = time,
        type = type,
        party = party,
        ref_item = ref_item,
        ref_parents = ref_parents,
        ref_party = ref_party,
        details = details;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    org_id = json['org_id'];
    time = DateTime.tryParse(json['time']);
    type = json['type'];
    party = ReferenceV1.fromJsonRef(json['party']);
    ref_item = ReferenceV1.fromJsonRef(json['ref_item']);
    var items = json['ref_parents'];
    ref_parents = List<ReferenceV1>.from(items.map((itemsJson) => ReferenceV1.fromJsonRef(itemsJson)));
    ref_party = ReferenceV1.fromJsonRef(json['ref_party']);
    details = StringValueMap.fromJson(json['details']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'org_id': org_id,
      'time': time.toIso8601String(),
      'type': type,
      'party': party,
      'ref_item': ref_item,
      'ref_parents': ref_parents,
      'ref_party': ref_party,
      'details': details
    };
  }   

  factory PartyActivityV1.fromJsonActivity(Map<String, dynamic> json) {
    var items = json['ref_parents'];
    return PartyActivityV1(id: json['id'], org_id: json['org_id'], time: DateTime.tryParse(json['time']),
                           type: json['type'], party: ReferenceV1.fromJsonRef(json['party']), ref_item: ReferenceV1.fromJsonRef(json['ref_item']),
                           ref_parents: List<ReferenceV1>.from(items.map((itemsJson) => ReferenceV1.fromJsonRef(itemsJson))),
                           ref_party: ReferenceV1.fromJsonRef(json['ref_party']), details: StringValueMap.fromJson(json['details']));
  }
}