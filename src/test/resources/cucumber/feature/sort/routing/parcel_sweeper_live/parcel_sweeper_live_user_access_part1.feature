@Sort @Routing @ParcelSweeperLive @ParcelSweeperLiveUserAccessPart1 @wipFeature
Feature: Parcel Sweeper Live User Access

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-no-hub-access-user-client-id}" and client secret = "{sort-hub-no-hub-access-user-client-secret}"

  @CloseNewWindows
  Scenario: User Not Found - Hub Feature Switch Inactive
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Then DB Operator verify "sort-hub-no-hub-access-user-client-id" is not a hub user
    When API Operator changes hub feature switch for station hub:
      | featureSwitchStatus | true               |
      | stationHubId        | {activated-hub-id} |
    Then DB Operator verify hub feature switch is "true" for "{activated-hub-id}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator selects hub on Parcel Sweeper Live page:
      | hubName    | {activated-hub-name} |
      | trackingId | CREATED              |
    Then Operator verify access denied modal on Parcel Sweeper Live page with the data below:
      | title   | Access declined                                                            |
      | message | Please select the correct station or contact station admin to gain access. |

  @CloseNewWindows @wipScenario
  Scenario: User Not Found - Hub Feature Switch Inactive
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Then DB Operator verify "sort-hub-no-hub-access-user-client-id" is not a hub user
    When API Operator changes hub feature switch for station hub:
      | featureSwitchStatus | false                 |
      | stationHubId        | {deactivated-hub-id}  |
    Then DB Operator verify hub feature switch is "false" for "{deactivated-hub-id}"
    Given Operator go to menu Routing -> Parcel Sweeper Live
    When Operator provides data on Parcel Sweeper Live page:
      | hubName    | {deactivated-hub-name} |
      | trackingId | CREATED                |
    Then Operator verify Route ID on Parcel Sweeper page using data below:
      | backgroundColor | {success-bg-inbound} |
    Then Operator verify Zone on Parcel Sweeper page using data below:
      | zoneName  | {hub-name}       |
      | textColor | {blue-hex-color} |
    And Operator verify Destination Hub on Parcel Sweeper By Hub page using data below:
      | hubName   | GLOBAL INBOUND        |
      | textColor | {dark-gray-hex-color} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op