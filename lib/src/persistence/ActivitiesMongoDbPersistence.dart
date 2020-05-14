import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';

import '../data/version1/PartyActivityV1.dart';
import '../data/version1/ReferenceV1.dart';
import './IActivitiesPersistence.dart';

class ActivitiesMongoDbPersistence
    extends IdentifiableMongoDbPersistence<PartyActivityV1, String>
    implements IActivitiesPersistence {
  ActivitiesMongoDbPersistence() : super('party_activities') {
    maxPageSize = 1000;
    super.ensureIndex({ 'time': -1 });
  }

  dynamic composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var search = filter.getAsNullableString('search');
    if (search != null) {
      var searchRegex = RegExp(r'^' + search, caseSensitive: false);
      var searchCriteria = [];
      searchCriteria.add({ 'type': { r'$regex': searchRegex.pattern } });
      searchCriteria.add({ 'party.name': { r'$regex': searchRegex.pattern } });
      searchCriteria.add({ 'ref_item.name': { r'$regex': searchRegex.pattern } });
      searchCriteria.add({ 'ref_party.name': { r'$regex': searchRegex.pattern } });
      criteria.add({ r'$or': searchCriteria });
    }    

    var id = filter.getAsNullableString('id') ?? filter.getAsNullableString('activity_id');
    if (id != null) {
      criteria.add({'_id': id});
    }

    var orgId = filter.getAsNullableString('org_id');
    if (orgId != null) {
      criteria.add({'org_id': orgId});
    }

    var type = filter.getAsNullableString('type');
    if (type != null) {
      criteria.add({'type': type});
    }

    // Decode include types
    var includeTypes = filter.getAsObject('include_types');
    if (includeTypes != null) {
      if (includeTypes is! List) {
        includeTypes = ('' + includeTypes).split(',');
      }
      criteria.add({ 'type': { r'$in': includeTypes } });
    }

    // Decode exclude types
    var excludeTypes = filter.getAsObject('exclude_types');
    if (excludeTypes != null) {
      if (excludeTypes is! List) {
        excludeTypes = ('' + excludeTypes).split(',');
      }
      criteria.add({ 'type': { r'$nin': excludeTypes } });
    }

    var partyId = filter.getAsNullableString('party_id');
    if (partyId != null) {
      criteria.add({'party.id': partyId});
    }        

    var refItemId = filter.getAsNullableString('ref_item_id');
    if (refItemId != null) {
      criteria.add({'ref_item.id': refItemId});
    }

    var refParentId = filter.getAsNullableString('ref_parent_id');
    if (refParentId != null) {
      criteria.add({'ref_parent.id': refParentId});
    }

    var refPartyId = filter.getAsNullableString('ref_party_id');
    if (refPartyId != null) {
      criteria.add({'ref_party.id': refPartyId});
    }

    var toTime = filter.getAsNullableDateTime('to_time');
    if (toTime  != null) {
      criteria.add({'time': { r'$lt': toTime  }});
    }

    var fromTime = filter.getAsNullableDateTime('from_time');
    if (fromTime != null) {
      criteria.add({'time': { r'$gte': fromTime }});
    }          

    return criteria.isNotEmpty ? {r'$and': criteria} : null;
  }

  @override
  Future<DataPage<PartyActivityV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<PartyActivityV1> create(String correlationId, PartyActivityV1 item) async {
    item.ref_parents = item.ref_parents ?? <ReferenceV1>[];
    if (item.ref_item != null) {
      item.ref_parents.add(item.ref_item);
    }
    return super.create(correlationId, item);
  }

  @override
  Future deleteByFilter(String correlationId, dynamic filter) async {
    return super.deleteByFilter(correlationId, composeFilter(filter));
  }    
}
