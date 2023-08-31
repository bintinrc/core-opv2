@StationManagement @StationHome @PriorityParcelsOnVehicle
Feature: Priority Parcels On Vehicle for Delivery

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ForceSuccessOrder @Happypath @ArchiveRoute @HighPriority
  Scenario Outline: View Priority Parcel on Vehicle for Delivery (uid:bd22c933-b02b-4302-b086-9336148dc9a8)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has increased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID |
      | Timeslot    |
      | Driver Name |
      | Route ID    |
      | Address     |
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     | Route ID               |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ROUTE_ID} |
    And Operator verifies that Edit Order page is opened on clicking tracking id
    And Operator verifies that Route Manifest page is opened on clicking route id

    Examples:
      | HubName      | HubId      | TileName                                 | ModalName                   |
      | {hub-name-5} | {hub-id-5} | Priority parcels on vehicle for delivery | Priority Parcels on Vehicle |

  @ForceSuccessOrder @Happypath @ArchiveRoute @MediumPriority
  Scenario Outline: Priority Parcel on Vehicle for Delivery Number is Decreased (uid:01b34681-796b-432a-af31-33fb8c2cf930)
    Given Operator loads Operator portal home page
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags multiple parcels as per the below tag
      | orderTag | 5570 |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":"{hub-id-Global}" } |
    And API Operator sweep parcel in the hub
      | hubId | <HubId>                         |
      | scan  | {KEY_CREATED_ORDER_TRACKING_ID} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":<HubId>, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator wait until order granular status changes to "On Vehicle for Delivery"
    And Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "On Vehicle for Delivery" on Edit Order page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator get the count from the tile: "<TileName>"
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator searches for the orders in modal pop-up by applying the following filters:
      | Tracking ID                     | Route ID               |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ROUTE_ID} |
    And Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    And Operator click Order Settings -> Manually Complete Order on Edit Order page
    And Operator confirm manually complete order on Edit Order page
    And Operator verify the order completed successfully on Edit Order page
    Then Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName>" and proceed
    And Operator verifies that the count in tile: "<TileName>" has decreased by 1
    And Operator opens modal pop-up: "<ModalName>" through hamburger button for the tile: "<TileName>"
    And Operator verifies that a table is displayed with following columns:
      | Tracking ID |
      | Timeslot    |
      | Driver Name |
      | Route ID    |
      | Address     |
    And Operator expects no results when searching for the orders by applying the following filters:
      | Tracking ID                     | Route ID               |
      | {KEY_CREATED_ORDER_TRACKING_ID} | {KEY_CREATED_ROUTE_ID} |

    Examples:
      | HubName      | HubId      | TileName                                 | ModalName                   |
      | {hub-name-5} | {hub-id-5} | Priority parcels on vehicle for delivery | Priority Parcels on Vehicle |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op