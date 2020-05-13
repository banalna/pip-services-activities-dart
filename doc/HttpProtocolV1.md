# HTTP REST Protocol (version 1) <br/> Party Activities Microservice

Party activities microservice implements a HTTP compatible API, that can be accessed on configured port.
All input and output data is serialized in JSON format. Errors are returned in [standard format]().

* [ReferenceV1 class](#class1)
* [PartyActivityV1 class](#class2)
* [POST /activities/get_party_activities](#operation1)
* [POST /activities/log_party_activity](#operation2)
* [POST /activities/batch_party_activities](#operation3)
* [POST /activities/delete_party_activities](#operation3)

## Data types

### <a name="class1"></a> ReferenceV1 class

Represents a reference to a particular item specified by id, type and name. 

**Properties:**
- id: string - unique item id
- type: string - item type
- name: string - item name

### <a name="class2"></a> PartyActivityV1 class

Represents a record of a party activity performed in the past. 
Each activity record is related to:
- Party who performed the activity
- Object related to the activity. For instance, object that was create or deleted by the party
- Parent of the related objects. If related object is a part of a bigger hierarchy it helps to collect change history across all child objects
- 3rd party related to the activity. For instance, if 3rd party offered or was offered to share work on specific object

**Properties:**
- id: string - unique record id
- time: Date - date and time when activity took place (default: current time)
- type: string - activity type: 'signup', 'signin', 'created', etc.
- party: ReferenceV1 - reference to the party who performed the activity
- ref_item: ReferenceV1 - reference to an item related to this activity
- ref_parties: ReferenceV1[] - array of the item parent references to enable hierarchical search
- ref_party: ReferenceV1 - reference to a 3rd party related to this activity
- details: Object - additional details related to this activity, like % of completion or new status

### <a name="class3"></a> DataPage<PartyActivityV1> class

Represents a paged result with subset of requested PartyActivityV1 objects

**Properties:**
- data: PartyActivityV1[] - array of retrieved PartyActivity page
- count: int - total number of objects in retrieved resultset

## Operations

### <a name="operation1"></a> Method: 'POST', route '/activities/get\_party\_activities'

Retrieves a list of party activities by specified criteria

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- filter: FilterParams
  - id: string - (optional) unique section id
  - search: string - (optional) search by id substring
  - type: string - (optional) type of activities
  - include_types: string[] - (optional) array of activities types to include into results
  - exclude_types: string[] - (optional) array of activities types to exclude from results
  - party_id: string - (optional) unique id of party who performed the activity
  - ref_id: string - (optional) unique id of related object
  - parent_id: string - (optional) unique if of parent of related object
  - ref\_party\_id: string - (optional) unique id of 3rd party
  - from_time: Date - (optional) start of the time range
  - to_time: Date - (optional) end of the time range
- paging: PagingParams
  - skip: int - (optional) start of page (default: 0). Operation returns paged result
  - take: int - (optional) page length (max: 100). Operation returns paged result

**Response body:**
DataPage<PartyActivityV1> object or error

### <a name="operation2"></a> Method: 'POST', route '/activities/log\_party\_activity'

Log a single party activity

**Request body:**
- correlation_id: string - (optional) unique id that identifies distributed transaction
- activity: PartyActivityV1 - object to be logged

**Response body:**
Logged PartyActivityV1 object or error

### <a name="operation3"></a> Method: 'POST', route '/activities/batch\_party\_activities'

Log multiple party activities

**Request body:**
- correlation_id: string - (optional) unique id that identifies distributed transaction
- activities: PartyActivityV1[] - Array of PartyActivity objects to be logged

**Response body:**
error or null for success

### <a name="operation4"></a> Method: 'POST', route '/activities/delete\_party\_activities'

Deletes party activities that satisfy specified criteria.
This operation is used to clean up the history if party or related objects are removed.

**Request body:** 
- correlation_id: string - (optional) unique id that identifies distributed transaction
- filter: FilterParams
  - id: string - (optional) unique section id
  - search: string - (optional) search by id substring
  - type: string - (optional) type of activities
  - include_types: string[] - (optional) array of activities types to include into results
  - exclude_types: string[] - (optional) array of activities types to exclude from results
  - party_id: string - (optional) unique id of party who performed the activity
  - ref_id: string - (optional) unique id of related object
  - parent_id: string - (optional) unique if of parent of related object
  - ref\_party\_id: string - (optional) unique id of 3rd party
  - from_time: Date - (optional) start of the time range
  - to_time: Date - (optional) end of the time range

**Response body:**
error or null for success
