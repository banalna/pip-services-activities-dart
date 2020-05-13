import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_activities_dart/pip_services_activities_dart.dart';

final ACTIVITY = PartyActivityV1(
    id: null,
    type: 'test',
    time: DateTime.now(),
    party: ReferenceV1(
        id: '1',
        type: 'party',
        name: 'Test User'
    ),
    ref_item: ReferenceV1(
        id: '2',
        type: 'party',
        name: 'Admin User'
    ),
    ref_parents: [],
    ref_party: null,
    details: null
);

void main() {
  group('ActivitiesController', () {
    ActivitiesMemoryPersistence persistence;
    ActivitiesController controller;

    setUp(() async {
      persistence = ActivitiesMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = ActivitiesController();
      controller.configure(ConfigParams());

      var references = References.fromTuples([
        Descriptor('pip-services-activities', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor('pip-services-activities', 'controller', 'default', 'default', '1.0'),
        controller
      ]);

      controller.setReferences(references);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Batch Party Activities', () async {
      PartyActivityV1 activity1;

      // Create the first activity
      var activity = await controller.logPartyActivity(null, ACTIVITY);
      expect(activity, isNotNull);
      expect(ACTIVITY.type, activity.type);
      expect(ACTIVITY.party.id, activity.party.id);
      expect(ACTIVITY.ref_item.name, activity.ref_item.name);
      expect(activity.time, isNotNull);

      // Log an activity batch
      var activities = await controller.batchPartyActivities(null, [ACTIVITY, ACTIVITY]);

      // Get all activities
      var page =
          await controller.getPartyActivities(null, FilterParams(), PagingParams());
      expect(page, isNotNull);
      expect(page.data.length, 3);
      activity1 = page.data[0];
      expect(activity1, isNotNull);
      expect(ACTIVITY.type, activity1.type);
      expect(ACTIVITY.party.id, activity1.party.id);
      expect(ACTIVITY.ref_item.name, activity1.ref_item.name);
      expect(activity1.time, isNotNull);
    });
  });
}