import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_activities_dart/pip_services_activities_dart.dart';
import './ActivitiesPersistenceFixture.dart';

void main() {
  group('ActivitiesMemoryPersistence', () {
    ActivitiesMemoryPersistence persistence;
    ActivitiesPersistenceFixture fixture;

    setUp(() async {
      persistence = ActivitiesMemoryPersistence();
      persistence.configure(ConfigParams());

      fixture = ActivitiesPersistenceFixture(persistence);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Log Party Activities', () async {
      await fixture.testLogPartyActivities();
    });

    test('Get Party Activities', () async {
      await fixture.testGetPartyActivities();
    });
  });
}
