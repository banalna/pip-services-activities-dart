# Examples for Party Activities Microservice

This is a party activity logging microservice from Pip.Services library. 
It logs important party activities like signups, signins, 
creation, changes or deletion of data items and so on.

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
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
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = ActivitiesHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
// Create a new activity
final ACTIVITY = PartyActivityV1({
        type: 'signup',
        party: {
            id: '123',
            name: 'Test User'
        }
});

    // Create the activity
    try {
      var activity = await client.logPartyActivity('123', ACTIVITY);
      // Do something with the returned activity...
    } catch(err) {
      // Error handling...     
    }
```

```dart
// Get the list of activities for 'My Samples' product
var now = Date();
try {
var page = await client.getPartyActivities(
    null,
    {
        party_id: '123',
        from_time: Date(now.getTime() - 24 * 3600 * 1000),
        to_time: now
    },
    {
        total: true,
        skip: 0,
        take: 10
    });
    // Do something with page...

    } catch(err) { // Error handling}
```   

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-users/pip-services-activities-dart/tree/master/test).
