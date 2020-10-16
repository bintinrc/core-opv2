@MiddleMile @Hub @InterHub @MovementSchedules @CrossdockToItsStation
Feature: Crossdock to it's Station

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @SoftDeleteHubViaDb @DeleteShipment @CloseNewWindows
  Scenario: Crossdock to its Station - Station Movement Found and there is available schedule (uid:4be9aa9e-813f-4c02-8d92-5af401b4a6f4)
    Given Operator go to menu Shipper Support -> Blocked Dates
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | CROSSDOCK |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    When API Operator creates new Hub using data below:
      | name         | GENERATED |
      | displayName  | GENERATED |
      | facilityType | STATION   |
      | region       | JKB       |
      | city         | GENERATED |
      | country      | GENERATED |
      | latitude     | GENERATED |
      | longitude    | GENERATED |
    And API Operator reloads hubs cache
    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
    When Operator go to menu Inter-Hub -> Movement Schedules
    And Movement Management page is loaded
    And Operator adds new relation on Movement Management page using data below:
      | station      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    And Operator adds new Station Movement Schedule on Movement Management page using data below:
      | crossdockHub   | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub      | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | destinationHub | {KEY_LIST_OF_CREATED_HUBS[2].name} |
      | movementType   | Air Haul                           |
      | departureTime  | 20:15                              |
      | duration       | 1                                  |
      | endTime        | 16:30                              |
    And Operator select "Relations" tab on Movement Management page
    Then Operator verify 'All' 'Pending' and 'Completed' tabs are displayed on 'Relations' tab
    And Operator verify "Pending" tab is selected on 'Relations' tab
    And Operator verify all Crossdock Hub in Pending tab have "Unfilled" value
    And Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab
    When Operator select "Completed" tab on Movement Management page
    And Operator verify all Crossdock Hub of all listed Stations already defined
    And Operator verify there is 'Edit Relation' link in Relations table on 'Relations' tab
    When Operator select "Stations" tab on Movement Management page
    And Operator load schedules on Movement Management page using data below:
      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
      | originHub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    When Operator go to menu Inter-Hub -> Shipment Inbound Scanning
    When Operator inbound scanning Shipment Into Van in hub {KEY_LIST_OF_CREATED_HUBS[1].name} on Shipment Inbound Scanning page
    Given Operator go to menu Inter-Hub -> Shipment Management
    And Operator refresh page
    And Operator search shipments by given Ids on Shipment Management page:
      | {KEY_CREATED_SHIPMENT_ID} |
    Then Operator verify parameters of shipment on Shipment Management page using data below:
      | id          | {KEY_CREATED_SHIPMENT_ID}           |
      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name}  |
      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name}  |
      | status      | Transit                             |
      | sla         | {{next-2-days-yyyy-MM-dd}} 12:45:00 |
    And Operator open the shipment detail for the created shipment on Shipment Management Page
    Then Operator verify shipment event on Shipment Details page using data below:
      | source | SHIPMENT_VAN_INBOUND               |
      | result | Transit                            |
      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
    Then Operator verify movement event on Shipment Details page using data below:
      | source | SLA_CALCULATION |
      | status | SUCCESS         |

#  @SoftDeleteHubViaDb @DeleteShipment @CloseNewWindows
#  Scenario: Crossdock to its Station - Station Movement Found but there is no available schedule (uid:459a5ba5-3ffd-4fe4-ae77-250e77e4c1b0)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    When API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | region       | JKB       |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    When API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | STATION   |
#      | region       | JKB       |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator reloads hubs cache
#    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    When Operator go to menu Inter-Hub -> Movement Schedules
#    And Movement Management page is loaded
#    And Operator adds new relation on Movement Management page using data below:
#      | station      | {KEY_LIST_OF_CREATED_HUBS[2].name} |
#      | crossdockHub | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#    And API Operator does the "van-inbound" scan for the shipment
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of shipment on Shipment Management page using data below:
#      | id          | {KEY_CREATED_SHIPMENT_ID}          |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
#      | status      | Transit                            |
#      | sla         | -                                  |
#    And Operator open the shipment detail for the created shipment on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page using data below:
#      | source | SHIPMENT_VAN_INBOUND               |
#      | result | Transit                            |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#    Then Operator verify movement event on Shipment Details page using data below:
#      | source   | SLA_CALCULATION                                                                                                      |
#      | status   | FAILED                                                                                                               |
#      | comments | found no path from origin {KEY_LIST_OF_CREATED_HUBS[1].id} (sg) to destination {KEY_LIST_OF_CREATED_HUBS[2].id} (sg) |
#
#  @SoftDeleteHubViaDb @DeleteShipment @CloseNewWindows
#  Scenario: Crossdock to its Station - Station Movement not found (uid:9aa9d622-d1e1-41d0-9ab0-c7b960051f91)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    When API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | CROSSDOCK |
#      | region       | JKB       |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    When API Operator creates new Hub using data below:
#      | name         | GENERATED |
#      | displayName  | GENERATED |
#      | facilityType | STATION   |
#      | region       | JKB       |
#      | city         | GENERATED |
#      | country      | GENERATED |
#      | latitude     | GENERATED |
#      | longitude    | GENERATED |
#    And API Operator reloads hubs cache
#    When API Operator create new shipment with type "AIR_HAUL" from hub id = {KEY_LIST_OF_CREATED_HUBS[1].id} to hub id = {KEY_LIST_OF_CREATED_HUBS[2].id}
#    And Operator refresh page
#    And API Operator does the "van-inbound" scan for the shipment
#    Given Operator go to menu Inter-Hub -> Shipment Management
#    And Operator search shipments by given Ids on Shipment Management page:
#      | {KEY_CREATED_SHIPMENT_ID} |
#    Then Operator verify parameters of shipment on Shipment Management page using data below:
#      | id          | {KEY_CREATED_SHIPMENT_ID}          |
#      | origHubName | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#      | destHubName | {KEY_LIST_OF_CREATED_HUBS[2].name} |
#      | status      | Transit                            |
#      | sla         | -                                  |
#    And Operator open the shipment detail for the created shipment on Shipment Management Page
#    Then Operator verify shipment event on Shipment Details page using data below:
#      | source | SHIPMENT_VAN_INBOUND               |
#      | result | Transit                            |
#      | hub    | {KEY_LIST_OF_CREATED_HUBS[1].name} |
#    Then Operator verify movement event on Shipment Details page using data below:
#      | source   | SLA_CALCULATION                                                                                                      |
#      | status   | FAILED                                                                                                               |
#      | comments | found no path from origin {KEY_LIST_OF_CREATED_HUBS[1].id} (sg) to destination {KEY_LIST_OF_CREATED_HUBS[2].id} (sg) |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
