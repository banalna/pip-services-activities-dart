import 'package:test/test.dart';
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

class ActivitiesPersistenceFixture {
  IActivitiesPersistence _persistence;

  ActivitiesPersistenceFixture(IActivitiesPersistence persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void testLogPartyActivities() async {
    // Log activity
    var activity1 = await _persistence.create(null, ACTIVITY);
    expect(activity1, isNotNull);

    // Check activity
    var page = await _persistence.getPageByFilter(
        null, FilterParams.fromValue({'id': activity1.id}), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 1);

    var activity = page.data[0];
    expect(activity.time, isNotNull);
    expect(ACTIVITY.type, activity.type);
    expect(ACTIVITY.party.id, activity.party.id);
    expect(ACTIVITY.party.name, activity.party.name);
    expect(ACTIVITY.ref_item.id, activity.ref_item.id);
    expect(ACTIVITY.ref_item.name, activity.ref_item.name);
  }

  void testGetPartyActivities() async {
    // Log activity
    var activity1 = await _persistence.create(null, ACTIVITY);
    expect(activity1, isNotNull);

    // Filter by party_id
    var page = await _persistence.getPageByFilter(
        null, FilterParams.fromValue({'party_id': '1'}), PagingParams());
    expect(page.data.length, 1);
    var activity = page.data[0];
    expect(activity.time, isNotNull);
    expect(ACTIVITY.type, activity.type);
    expect(ACTIVITY.party.id, activity.party.id);
    expect(ACTIVITY.party.name, activity.party.name);
  }
}
