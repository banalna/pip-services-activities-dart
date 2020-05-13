import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/PartyActivityV1.dart';
import './ActivitiesMemoryPersistence.dart';

class ActivitiesFilePersistence extends ActivitiesMemoryPersistence {
  JsonFilePersister<PartyActivityV1> persister;

  ActivitiesFilePersistence([String path]) : super() {
    persister = JsonFilePersister<PartyActivityV1>(path);
    loader = persister;
    saver = persister;
  }
  @override
  void configure(ConfigParams config) {
    super.configure(config);
    persister.configure(config);
  }
}
