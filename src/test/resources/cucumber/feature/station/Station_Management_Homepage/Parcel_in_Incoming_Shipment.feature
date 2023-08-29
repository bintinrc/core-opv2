@StationManagement @IncomingShipment
Feature: Parcel in Incoming Shipment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @Happypath @ArchiveRoute @HighPriority
  Scenario Outline: View Parcel in Incoming Shipment (uid:e03d4b5c-4253-4f35-9e8a-87d7c912dcc2)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<DestHubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
    And Operator get the count from one more tile: "<TileName2>"
    Given API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "<OrigHubId>" to hub id = "<DestHubId>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <OrigHubId>                     |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | <OrigHubId>               |
    And API Operator clears incoming shipment cache
    And Operator waits for 600 seconds
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<DestHubName>" and proceed
    And Operator verifies that the count in tile: "<TileName1>" has increased by 1
    And Operator verifies that the count in the second tile: "<TileName2>" has increased by 0
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName1>" is displayed with following columns:
      | Size           |
      | Total Count    |
      | Priority Count |
    And Operator verifies that the table:"<TableName2>" is displayed with following columns:
      | Zones          |
      | Total Count    |
      | Priority Count |
    And Operator verifies that the chart is displayed in incoming shipment modal
    When API Operator deletes movement schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" from "<OrigHubId>" to "<DestHubId>" with facility type "STATIONS"

    Examples:
      | OrigHubId   | OrigHubName   | DestHubId   | DestHubName   | Country | Comments  | TileName                     | TileName1 | TileName2 | ModalName                    | TableName1     | TableName2 |
      | {hub-id-10} | {hub-name-10} | {hub-id-11} | {hub-name-11} | sg      | GENERATED | Parcels in incoming shipment | Total     | Priority  | Parcels in Incoming Shipment | By Parcel Size | By Zone    |

  @Happypath @ArchiveRoute @HighPriority
  Scenario Outline: View Priority Parcel in Incoming Shipment (uid:17a93bac-e718-4f9b-8be7-b6d025f66434)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<DestHubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
    And Operator get the count from one more tile: "<TileName2>"
    Given API Operator create new "STATIONS" movement schedule with type "LAND_HAUL" from hub id = "<OrigHubId>" to hub id = "<DestHubId>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <OrigHubId>                     |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<OrigHubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator creates shipment using data below:
      | createShipmentRequest | {"shipment": {"shipment_type": "LAND_HAUL", "orig_hub_id": <OrigHubId>, "dest_hub_id": <DestHubId>, "comments": "<Comments>", "orig_hub_country": "<Country>", "dest_hub_country": "<Country>", "curr_hub_country": "<Country>", "status": "Pending", "end_date": null }}' |
    And API Operator adds parcels to shipment using following data:
      | country    | <Country>                       |
      | trackingId | {KEY_CREATED_ORDER_TRACKING_ID} |
      | actionType | ADD                             |
    And API Operator closes the shipment using created shipper id
    And API Operator performs van inbound by updating shipment status using data below:
      | scanValue  | {KEY_CREATED_SHIPMENT_ID} |
      | hubCountry | SG                        |
      | hubId      | <OrigHubId>               |
    And API Operator clears incoming shipment cache
    And Operator waits for 600 seconds
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<DestHubName>" and proceed
    And Operator verifies that the count in tile: "<TileName1>" has increased by 1
    And Operator verifies that the count in the second tile: "<TileName2>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that the table:"<TableName1>" is displayed with following columns:
      | Size           |
      | Total Count    |
      | Priority Count |
    And Operator verifies that the table:"<TableName2>" is displayed with following columns:
      | Zones          |
      | Total Count    |
      | Priority Count |
    And Operator verifies that the chart is displayed in incoming shipment modal
    When API Operator deletes movement schedule "{KEY_LIST_OF_CREATED_MOVEMENT_SCHEDULE_WITH_TRIP[1].id}" from "<OrigHubId>" to "<DestHubId>" with facility type "STATIONS"

    Examples:
      | OrigHubId   | OrigHubName   | DestHubId   | DestHubName   | Country | Comments  | TileName                     | TileName1 | TileName2 | ModalName                    | TableName1     | TableName2 |
      | {hub-id-10} | {hub-name-10} | {hub-id-11} | {hub-name-11} | sg      | GENERATED | Parcels in incoming shipment | Total     | Priority  | Parcels in Incoming Shipment | By Parcel Size | By Zone    |

  @ArchiveRoute
  Scenario Outline: No Chart if No Parcel in Incoming Shipment (uid:8c659f58-cc6f-4a2c-b580-6a4e9fee86a1)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<OrigHubName>" and proceed
    And Operator get the count from the tile: "<TileName1>"
    And Operator get the count from one more tile: "<TileName2>"
    And Operator verifies that the count in tile: "<TileName1>" has increased by 0
    And Operator verifies that the count in the second tile: "<TileName2>" has increased by 0
    Then Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that no results found text is displayed under the table: "<TableName1>"
    And Operator verifies that no results found text is displayed under the table: "<TableName2>"
    And Operator verifies that the chart is not displayed in incoming shipment modal

    Examples:
      | OrigHubName   | TileName                     | ModalName                    | TileName1 | TileName2 | TableName1     | TableName2 |
      | {hub-name-10} | Parcels in incoming shipment | Parcels in Incoming Shipment | Total     | Priority  | By Parcel Size | By Zone    |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op