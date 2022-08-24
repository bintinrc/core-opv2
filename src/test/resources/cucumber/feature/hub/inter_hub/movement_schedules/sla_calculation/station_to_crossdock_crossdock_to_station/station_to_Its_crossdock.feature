@MiddleMile @Hub @InterHub @MovementSchedules @SlaCalculation @StationToCrossdock @StationToItsCrossdock
Feature: Station to it's Crossdock

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to its Crossdock - Station Movement Found and there is available schedule (uid:6fcd7f9e-1876-4445-b840-d6baeece5575)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Land Haul                           |
      | departureTime  | 20:15                              |
      | duration       | 1                                  |
      | endTime        | 16:30                              |
      | daysOfWeek     | all                                |
    And Operator select "Relations" tab on Movement Management page
    Then Operator verify 'All' 'Pending' and 'Complete' tabs are displayed on 'Relations' tab
    And Operator verify "Pending" tab is selected on 'Relations' tab
    And Operator verify all Crossdock Hub in Pending tab have "Unfilled" value
    And Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab
    When Operator select "Complete" tab on Movement Management page
    And Operator verify all Crossdock Hub of all listed Stations already defined
    And Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | originHub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator put created parcel to shipment
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
#      | sla         | {{next-2-days-yyyy-MM-dd}} 12:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(OpV2)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

  @DeleteShipment @CloseNewWindows @DeletePaths @SoftDeleteCrossdockDetailsViaDb
  Scenario: Station to its Crossdock - Station Movement Found but there is no available schedule (uid:be4d5366-99e4-432d-879f-7647efbf7d6b)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator create new shipment with type "LAND_HAUL" from hub id = {hub-station-id} to hub id = {hub-relation-destination-hub-id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station        | {hub-station-name}                  |
      | crossdockHub   | {hub-relation-destination-hub-name} |
      | stationId      | {hub-station-id}                    |
      | crossdockHubId | {hub-relation-destination-hub-id}   |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator put created parcel to shipment
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {hub-station-name} to hub id = {hub-relation-destination-hub-name}
    And Operator close the shipment which has been created
    And API Operator does the "van-inbound" scan for the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {hub-station-name}                  |
      | destHubName | {hub-relation-destination-hub-name} |
      | status      | Transit                             |
      | sla         | -                                   |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA) |
      | result | Transit                    |
      | hub    | {hub-station-name}         |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION                                                                                                                            |
      | status   | FAILED                                                                                                                                     |
      | comments | No path found between {hub-station-name} (sg) and {hub-relation-destination-hub-name} (sg). Please ask your manager to check the schedule. |

  @DeleteHubsViaAPI @DeleteHubsViaDb @DeleteShipment @CloseNewWindows @DeletePaths
  Scenario: Station to its Crossdock - Station Movement not found (uid:034368e1-26d9-43fc-9aec-6a8f6cb8f3eb)
    Given Operator go to menu Utilities -> QRCode Printing
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When API Operator create new shipment with type "LAND_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    And Operator refresh page
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And DB Operator gets Hub ID by Hub Name of created parcel
    And API Operator put created parcel to shipment
    Given Operator go to menu Inter-Hub -> Add To Shipment
    When Operator add to shipment in hub {KEY_LIST_OF_CREATED_HUBS[1].name} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].name}
    And Operator close the shipment which has been created
    And API Operator does the "van-inbound" scan for the shipment
    And Operator go to menu Inter-Hub -> Shipment Management
#    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page:
      | id          | {KEY_CREATED_SHIPMENT_ID}          |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | status      | Transit                            |
      | sla         | -                                  |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page:
      | source | SHIPMENT_VAN_INBOUND(MMDA)         |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page:
      | source   | SLA_CALCULATION                                                                                                                                           |
      | status   | FAILED                                                                                                                                                    |
      | comments | No path found between {KEY_LIST_OF_CREATED_HUBS[1].name} (sg) and {KEY_LIST_OF_CREATED_HUBS[2].name} (sg). Please ask your manager to check the schedule. |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op