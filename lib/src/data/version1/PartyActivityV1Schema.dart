import 'package:pip_services3_commons/pip_services3_commons.dart';
import './ReferenceV1Schema.dart';

class PartyActivityV1Schema extends ObjectSchema {
  PartyActivityV1Schema() : super() {

    var referenceSchema = ReferenceV1Schema();

    withOptionalProperty('id', TypeCode.String);
    withOptionalProperty('org_id', TypeCode.String);
    withOptionalProperty('time', TypeCode.DateTime);
    withRequiredProperty('type', TypeCode.String);
    withRequiredProperty('party', referenceSchema);
    withOptionalProperty('ref_item', referenceSchema);
    withOptionalProperty('ref_parents', ArraySchema(referenceSchema));
    withOptionalProperty('ref_party', referenceSchema);
    withOptionalProperty('details', TypeCode.Map);
  }
}