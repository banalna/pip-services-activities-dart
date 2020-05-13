import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/PartyActivityV1.dart';
import '../../src/persistence/IActivitiesPersistence.dart';
import './IActivitiesController.dart';
import './ActivitiesCommandSet.dart';

class ActivitiesController
    implements IActivitiesController, IConfigurable, IReferenceable, ICommandable {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples(
        ['dependencies.persistence', 'pip-services-activities:persistence:*:*:1.0']
    );
  IActivitiesPersistence persistence;
  ActivitiesCommandSet commandSet;
  DependencyResolver dependencyResolver = DependencyResolver(ActivitiesController._defaultConfig);

  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
  }

  @override
  void setReferences(IReferences references) {
    dependencyResolver.setReferences(references);
    persistence = dependencyResolver.getOneRequired<IActivitiesPersistence>('persistence');
  }

  @override
  CommandSet getCommandSet() {
    commandSet ??= ActivitiesCommandSet(this);
    return commandSet;
  }

  @override
  Future<DataPage<PartyActivityV1>> getPartyActivities(
      String correlationId, FilterParams filter, PagingParams paging) {
    return persistence.getPageByFilter(correlationId, filter, paging);
  }

  @override
  Future<PartyActivityV1> logPartyActivity(String correlationId, PartyActivityV1 activity) {
    activity.time = DateTimeConverter.toNullableDateTime(activity.time);
    activity.time = activity.time ?? DateTime.now();
    return persistence.create(correlationId, activity);
  }

  @override
  Future<List<PartyActivityV1>> batchPartyActivities(String correlationId, List<PartyActivityV1> activities) async {
    activities.forEach((activity) => persistence.create(correlationId, activity));
    return activities;
  }

  @override
  Future deletePartyActivities(String correlationId, dynamic filter) {
    return persistence.deleteByFilter(correlationId, filter);
  }
}
