import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services_activities_dart/src/persistence/IActivitiesPersistence.dart';
import '../../pip_services_activities_dart.dart';
import '../data/version1/PartyActivityV1.dart';
import './IActivitiesPersistence.dart';

class ActivitiesMemoryPersistence
    extends IdentifiableMemoryPersistence<PartyActivityV1, String>
    implements IActivitiesPersistence {
  ActivitiesMemoryPersistence() : super() {
    maxPageSize = 1000;
  }

  bool matchString(String value, String search) {
    if (value == null && search == null) {
      return true;
    }
    if (value == null || search == null) {
      return false;
    }
    return value.toLowerCase().contains(search);    
  }

  bool matchSearch(PartyActivityV1 item, String search) {
    search = search.toLowerCase();
    if (matchString(item.type, search)) {
      return true;
    }
    if (item.party != null && matchString(item.party.name, search)) {
      return true;
    }
    if (item.ref_item != null && matchString(item.ref_item.name, search)) {
      return true;
    }    
    if (item.ref_party != null && matchString(item.ref_party.name, search)) {
      return true;
    }
    return false;    
  }

  bool equalIds(ReferenceV1 reference, String id) {
    return (reference != null) ? reference.id == id : false;
  }

  bool includeId(List<ReferenceV1> references, String id) {
    if (references == null) return false;
      for (var i = 0; i < references.length; i++) {
        var ref = references[i];
        if (ref != null && ref.id == id) return true;
      }
    return false;
  }  

  Function composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var search = filter.getAsNullableString('search');
    var id = filter.getAsNullableString('id') ?? filter.getAsNullableString('activity_id');
    var orgId = filter.getAsNullableString('org_id');
    var type = filter.getAsNullableString('type');
    var includeTypes = filter.getAsObject('include_types');
    var excludeTypes = filter.getAsObject('exclude_types');
    var partyId = filter.getAsNullableString('party_id');
    var refParentId = filter.getAsNullableString('ref_parent_id');
    var refPartyId = filter.getAsNullableString('ref_party_id');
    var refItemId = filter.getAsNullableString('ref_item_id');
    var fromTime = filter.getAsNullableDateTime('from_time');
    var toTime = filter.getAsNullableDateTime('to_time');

    // Convert string parameters to arrays
    if (includeTypes != null && includeTypes is! List) {
      includeTypes = ('' + includeTypes).split(',');
    }
    if (excludeTypes != null && excludeTypes is! List) {
      excludeTypes = ('' + excludeTypes).split(',');
    }    

    return (item) {
      if (search != null && !matchSearch(item, search)) {
        return false;
      }
      if (id != null && item.id != id) {
        return false;
      }
      if (orgId != null && item.orgId != orgId) {
        return false;
      }
      if (type != null && item.type != type) {
        return false;
      }

      if (includeTypes != null && includeTypes.contains(item.id)) {
        return false;
      }                
      if (excludeTypes != null && excludeTypes.contains(item.id)) {
        return false;
      }

      if (refParentId != null && !includeId(item.ref_parents, refParentId)) {
        return false;
      }
      if (refItemId != null && !includeId(item.ref_parents, refItemId)) {
        return false;
      }

      if (partyId != null && !equalIds(item.party, partyId)) {
        return false;
      }

      if (refPartyId != null && !equalIds(item.ref_party, refPartyId)) {
        return false;
      }
      if (refItemId != null && !equalIds(item.ref_item, refItemId)) {
        return false;
      }
            
      if (fromTime != null && item.time >= fromTime) {
        return false;
      }
      if (toTime != null && item.time < toTime) {
        return false;
      }           

      return true; 
    };
  }

  @override
  Future<DataPage<PartyActivityV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<PartyActivityV1> create(String correlationId, PartyActivityV1 item) {
    item.ref_parents = item.ref_parents ?? <ReferenceV1>[];
    if (item.ref_item != null) {
      item.ref_parents.add(item.ref_item);
    }
    return super.create(correlationId, item);
  }

  @override
  Future deleteByFilter(String correlationId, dynamic filter){
    return super.deleteByFilter(correlationId, composeFilter(filter));
  }    
}
