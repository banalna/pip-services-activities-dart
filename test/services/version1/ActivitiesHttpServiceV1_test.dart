import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_activities/pip_services_activities.dart';

final ACTIVITY = PartyActivityV1(
    id: null,
    type: 'test',
    time: DateTime.now(),
    party: ReferenceV1(id: '1', type: 'party', name: 'Test User'),
    ref_item: ReferenceV1(id: '2', type: 'party', name: 'Admin User'),
    ref_parents: [],
    ref_party: null,
    details: null);

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('ActivitiesHttpServiceV1', () {
    ActivitiesMemoryPersistence persistence;
    ActivitiesController controller;
    ActivitiesHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      persistence = ActivitiesMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = ActivitiesController();
      controller.configure(ConfigParams());

      service = ActivitiesHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor('pip-services-activities', 'persistence', 'memory',
            'default', '1.0'),
        persistence,
        Descriptor('pip-services-activities', 'controller', 'default',
            'default', '1.0'),
        controller,
        Descriptor(
            'pip-services-activities', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await persistence.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
      await persistence.close(null);
    });

    test('Batch Party Activities', () async {
      // Log an activity batch
      var resp = await rest.post(url + '/v1/activities/batch_party_activities',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'activities': [ACTIVITY, ACTIVITY, ACTIVITY]
          }));

      // Get activities
      resp = await rest.post(url + '/v1/activities/get_party_activities',
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'filter': FilterParams(), 'paging': PagingParams()}));
      var page =
          DataPage<PartyActivityV1>.fromJson(json.decode(resp.body), (item) {
        var activity = PartyActivityV1();
        activity.fromJson(item);
        return activity;
      });
      expect(page, isNotNull);
      expect(page.data.length, 3);

      var activity1 = page.data[0];
      expect(activity1.type, ACTIVITY.type);
      expect(activity1.time, isNotNull);
      expect(activity1.party.name, ACTIVITY.party.name);
    });
  });
}
