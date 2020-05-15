import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../src/data/version1/PartyActivityV1.dart';

abstract class IActivitiesController {
  /// Gets a page of party activities retrieved by a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items
  /// - [paging]            (optional) paging parameters
  /// Return Future that receives a data page
  /// Throws error.
  Future<DataPage<PartyActivityV1>> getPartyActivities(
      String correlationId, FilterParams filter, PagingParams paging);

  /// Logs party activity.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [activity]              an activity to be logged.
  /// Return         (optional) Future that receives logged activity or error.
  Future<PartyActivityV1> logPartyActivity(
      String correlationId, PartyActivityV1 activity);

  /// Logs batch of party activities.
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [activities]              a list of activities to be logged.
  /// Return         (optional) Future that receives logged activities or error.
  Future<List<PartyActivityV1>> batchPartyActivities(
      String correlationId, List<PartyActivityV1> activities);

  /// Deletes party activities that match to a given filter.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [filter]            (optional) a filter function to filter items.
  /// Return                Future that receives null for success.
  /// Throws error
  Future deletePartyActivities(String correlationId, dynamic filter);
}
