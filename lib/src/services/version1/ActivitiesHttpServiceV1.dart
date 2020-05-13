import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

class ActivitiesHttpServiceV1 extends CommandableHttpService {
  ActivitiesHttpServiceV1() : super('v1/activities') {
    dependencyResolver.put(
        'controller', Descriptor('pip-services-activities', 'controller', '*', '*', '1.0'));
  }
}
