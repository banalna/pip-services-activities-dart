import 'package:pip_services3_commons/pip_services3_commons.dart';

class ReferenceV1Schema extends ObjectSchema {
  ReferenceV1Schema() : super() {
    withRequiredProperty('id', TypeCode.String);
    withRequiredProperty('type', TypeCode.String);
    withOptionalProperty('name', TypeCode.String);
  }
}
