import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import '../build/ActivitiesServiceFactory.dart';

class ActivitiesProcess extends ProcessContainer {
  ActivitiesProcess() : super('activities', 'Party activities microservice') {
    factories.add(ActivitiesServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}
