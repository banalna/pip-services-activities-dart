import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/PartyActivityV1Schema.dart';
import '../../src/logic/IActivitiesController.dart';
import '../../src/data/version1/PartyActivityV1.dart';

class ActivitiesCommandSet extends CommandSet {
  IActivitiesController _controller;

  ActivitiesCommandSet(IActivitiesController controller) : super() {
    _controller = controller;

    addCommand(_makeGetPartyActivitiesCommand());
    addCommand(_makeLogPartyActivityCommand());
    addCommand(_makeBatchPartyActivitiesCommand());
    addCommand(_makeDeletePartyActivitiesCommand());
  }

  ICommand _makeGetPartyActivitiesCommand() {
    return Command(
        'get_party_activities',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return _controller.getPartyActivities(correlationId, filter, paging);
    });
  }

  ICommand _makeLogPartyActivityCommand() {
    return Command('log_party_activity',
        ObjectSchema(true).withRequiredProperty('activity', PartyActivityV1Schema()),
        (String correlationId, Parameters args) {      
      var activity = PartyActivityV1.fromJsonActivity(args.get('activity'));
      activity.time = DateTimeConverter.toNullableDateTime(activity.time);
      return _controller.logPartyActivity(correlationId, activity);
    });
  }

  ICommand _makeBatchPartyActivitiesCommand() {
    return Command('batch_party_activities',
        ObjectSchema(true).withRequiredProperty('activities', ArraySchema(PartyActivityV1Schema())),
        (String correlationId, Parameters args) {
      
      var activities = List<PartyActivityV1>.from(args.get('activities').map((itemsJson) => PartyActivityV1.fromJsonActivity(itemsJson)));
      activities.forEach((activity) => activity.time = DateTimeConverter.toNullableDateTime(activity.time));
      return _controller.batchPartyActivities(correlationId, activities);
    });
  }

  ICommand _makeDeletePartyActivitiesCommand() {
    return Command('delete_party_activities',
        ObjectSchema(true).withRequiredProperty('filter', FilterParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      return _controller.deletePartyActivities(correlationId, filter);
    });
  }
}
