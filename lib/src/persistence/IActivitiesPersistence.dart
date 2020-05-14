import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../data/version1/PartyActivityV1.dart';

abstract class IActivitiesPersistence {
  Future<DataPage<PartyActivityV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging);

  Future<PartyActivityV1> create(String correlationId, PartyActivityV1 item);

  Future deleteByFilter(String correlationId, dynamic filter);
}
