@RouteCashInbound @selenium
Feature: Zones

  @LaunchBrowser @RouteCashInbound#01 @RouteCashInbound#02
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  @ArchiveRoute @RouteCashInbound#01
  Scenario: Operator create, update and delete COD on Route Cash Inbound page (uid:2ca1458d-ecfe-44b2-a7b0-f86d4930d7fd)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | { "type":"Normal", "cod_goods":235, "from_postcode":"159363", "from_address1":"30 Jalan Kilang Barat", "from_address2":"Ninja Van HQ", "from_city":"SG", "from_state":"SG", "from_country":"SG", "to_postcode":"318993", "to_address1":"998 Toa Payoh North", "to_address2":"#01-10", "to_city":"SG", "to_state":"SG", "to_country":"SG", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1, "instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @RouteCashInbound." } |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id} } |
    And Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement." } |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "trackingId":"{{order_tracking_id}}", "type":"DD" } |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver deliver created parcel successfully
    Given Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator update the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is updated successfully
    When Operator delete the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is deleted successfully

  @ArchiveRoute @RouteCashInbound#02
  Scenario: Operator download and verify Zone CSV file on Route Cash Inbound page (uid:41707a8b-96dc-42ed-97e1-1fedd4daa649)
    Given Shipper create Order V2 Parcel using data below:
      | v2OrderRequest | { "type":"Normal", "cod_goods":235, "from_postcode":"159363", "from_address1":"30 Jalan Kilang Barat", "from_address2":"Ninja Van HQ", "from_city":"SG", "from_state":"SG", "from_country":"SG", "to_postcode":"318993", "to_address1":"998 Toa Payoh North", "to_address2":"#01-10", "to_city":"SG", "to_state":"SG", "to_country":"SG", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1, "instruction":"This order is created for testing purpose only. Ignore this order. Created at {{created_date}} by feature @RouteCashInbound." } |
    And Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "scan":"{{order_tracking_id}}", "type":"SORTING_HUB", "hubId":{hub-id} } |
    And Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id}, "date":"{{formatted_route_date}}", "comments":"This route is created for testing purpose only. Ignore this route. Created at {{created_date}} by feature @FailedDeliveryManagement." } |
    And Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "trackingId":"{{order_tracking_id}}", "type":"DD" } |
    And Driver collect all his routes
    And Driver try to find his pickup/delivery waypoint
    And Operator Van Inbound  parcel
    And Operator start the route
    And Driver deliver created parcel successfully
    Given Operator go to menu Fleet -> Route Cash Inbound
    When Operator create new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is created successfully
    When Operator download COD CSV file on Route Cash Inbound page
    Then Operator verify COD CSV file on Route Cash Inbound page is downloaded successfully
    When Operator delete the new COD on Route Cash Inbound page
    Then Operator verify the new COD on Route Cash Inbound page is deleted successfully

  @KillBrowser @RouteCashInbound#01 @RouteCashInbound#02
  Scenario: Kill Browser
