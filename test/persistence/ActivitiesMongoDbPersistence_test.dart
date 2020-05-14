import 'dart:io';
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'package:pip_services_activities/pip_services_activities.dart';
import './ActivitiesPersistenceFixture.dart';

void main() {
  group('ActivitiesMongoDbPersistence', () {
    ActivitiesMongoDbPersistence persistence;
    ActivitiesPersistenceFixture fixture;

    setUp(() async {
      var mongoUri = Platform.environment['MONGO_SERVICE_URI'];
      var mongoHost = Platform.environment['MONGO_SERVICE_HOST'] ?? 'localhost';
      var mongoPort = Platform.environment['MONGO_SERVICE_PORT'] ?? '27017';
      var mongoDatabase = Platform.environment['MONGO_SERVICE_DB'] ?? 'test';
      var mongoCollection =
          Platform.environment['MONGO_COLLECTION'] ?? 'activities';
      // Exit if mongo connection is not set
      if (mongoUri == '' && mongoHost == '') return;

      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        mongoUri,
        'connection.host',
        mongoHost,
        'connection.port',
        mongoPort,
        'connection.database',
        mongoDatabase,
        'collection',
        mongoCollection
      ]);

      persistence = ActivitiesMongoDbPersistence();
      persistence.configure(dbConfig);

      fixture = ActivitiesPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
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
