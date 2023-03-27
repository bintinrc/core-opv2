@Sort @Utilities @BulkAddressVerificationPart1
Feature: Bulk Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Bulk AV RTS orders - RTS zone exist
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG_RTS            |
      | longitude | FROM_CONFIG_RTS            |
    And Operator verifies waypoints are assigned to "RTS" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV RTS orders - RTS zone doesn't exist
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG                |
      | longitude | FROM_CONFIG                |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV RTS orders - Zone is NULL
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG_OOZ            |
      | longitude | FROM_CONFIG_OOZ            |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV Non RTS orders - RTS zone exist
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG_RTS            |
      | longitude | FROM_CONFIG_RTS            |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV Non RTS orders - RTS zone doesn't exist
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG                |
      | longitude | FROM_CONFIG                |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV Non RTS orders - Zone is NULL
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 5                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator get order details
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_ORDER_DETAILS |
      | latitude  | FROM_CONFIG_OOZ            |
      | longitude | FROM_CONFIG_OOZ            |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully

  Scenario: Bulk AV Reservation - RTS zone doesn't exist
    Given API Operator create multiple shipper addresses V2 using data below:
      | numberOfAddresses | 5               |
      | shipperId         | {shipper-v4-id} |
      | generateAddress   | RANDOM          |
    And API Operator create multiple V2 reservations based on number of created addresses using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Utilities -> Bulk Address Verification
    And Operator refresh page v1
    And Operator upload bulk address CSV using data below:
      | waypoint  | FROM_CREATED_RESERVATION_DETAILS |
      | latitude  | FROM_CONFIG                      |
      | longitude | FROM_CONFIG                      |
    And Operator verifies waypoints are assigned to "STANDARD" rack sector upon bulk address verification
    Then Operator update successfully matched waypoints upon bulk address verification
    Then Operator verify Jaro Scores are created successfully
    Then DB Operator verify Jaro Scores:
      | waypointId                                      | archived | score | sourceId |
      | {KEY_LIST_OF_CREATED_JARO_SCORES[1].waypointId} | 1        | 1     | 4        |
      | {KEY_LIST_OF_CREATED_JARO_SCORES[2].waypointId} | 1        | 1     | 4        |
    And DB Operator verifies waypoints record:
      | id        | {KEY_LIST_OF_CREATED_JARO_SCORES[1].waypointId} |
      | latitude  | {KEY_LIST_OF_CREATED_JARO_SCORES[1].latitude}   |
      | longitude | {KEY_LIST_OF_CREATED_JARO_SCORES[1].longitude}  |
    And DB Operator verifies waypoints record:
      | id        | {KEY_LIST_OF_CREATED_JARO_SCORES[2].waypointId} |
      | latitude  | {KEY_LIST_OF_CREATED_JARO_SCORES[2].latitude}   |
      | longitude | {KEY_LIST_OF_CREATED_JARO_SCORES[2].longitude}  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op