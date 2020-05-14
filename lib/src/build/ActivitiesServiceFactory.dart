import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../persistence/ActivitiesMemoryPersistence.dart';
import '../persistence/ActivitiesFilePersistence.dart';
import '../persistence/ActivitiesMongoDbPersistence.dart';
import '../logic/ActivitiesController.dart';
import '../services/version1/ActivitiesHttpServiceV1.dart';

class ActivitiesServiceFactory extends Factory {
  static final MemoryPersistenceDescriptor = Descriptor(
      'pip-services-activities', 'persistence', 'memory', '*', '1.0');
  static final FilePersistenceDescriptor =
      Descriptor('pip-services-activities', 'persistence', 'file', '*', '1.0');
  static final MongoDbPersistenceDescriptor = Descriptor(
      'pip-services-activities', 'persistence', 'mongodb', '*', '1.0');
  static final ControllerDescriptor = Descriptor(
      'pip-services-activities', 'controller', 'default', '*', '1.0');
  static final HttpServiceDescriptor =
      Descriptor('pip-services-activities', 'service', 'http', '*', '1.0');

  ActivitiesServiceFactory() : super() {
    registerAsType(ActivitiesServiceFactory.MemoryPersistenceDescriptor,
        ActivitiesMemoryPersistence);
    registerAsType(ActivitiesServiceFactory.FilePersistenceDescriptor,
        ActivitiesFilePersistence);
    registerAsType(ActivitiesServiceFactory.MongoDbPersistenceDescriptor,
        ActivitiesMongoDbPersistence);
    registerAsType(
        ActivitiesServiceFactory.ControllerDescriptor, ActivitiesController);
    registerAsType(ActivitiesServiceFactory.HttpServiceDescriptor,
        ActivitiesHttpServiceV1);
  }
}
