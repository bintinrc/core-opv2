@Sort @Routing @E2EPDwsInboundPart2
Feature: Parcel Sweeper Live

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - XS - e2e (uid:060618cd-0f04-4643-bc42-bca5cab957af)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "L","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":1000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 1      |
      | size   | XSMALL |
      | length | 5      |
      | width  | 6      |
      | height | 7      |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - S - e2e (uid:080536a0-4df2-4ec5-835d-046217f297f7)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "L","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":3000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 3     |
      | size   | SMALL |
      | length | 5     |
      | width  | 6     |
      | height | 7     |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - M - e2e (uid:0bf0204d-8b86-4753-8959-6e70011356ce)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "L","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":10000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 10     |
      | size   | MEDIUM |
      | length | 5      |
      | width  | 6      |
      | height | 7      |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - L - e2e (uid:619538e8-ade4-4a91-b834-ec9b5ece1e1c)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "S","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":15000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 15    |
      | size   | LARGE |
      | length | 5     |
      | width  | 6     |
      | height | 7     |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - XL - e2e (uid:339f6db3-747d-45c7-a031-3225d8d2f350)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "S","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":30000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 30         |
      | size   | EXTRALARGE |
      | length | 5          |
      | width  | 6          |
      | height | 7          |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Parcel Autosizing on Weight - DWS Inbound - XXL - e2e (uid:d9b2181e-eb52-435c-a687-351bf3ce91c5)
    When API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_start_time":"{gradle-next-1-day-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-next-1-day-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    Given API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions": {"size": "S","weight": 4,"length": "5","width": "6","height": "7"},"is_pickup_required":true,"pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"09:00","end_time":"22:00"}},"to":{"name":"Sort Automation Customer","email":"sort.automation.customer@ninjavan.co","phone_number":"+6598980004","address":{"address1":"{address1}","address2":"","postcode":{postcode},"country":"SG","latitude":{latitude},"longitude":{longitude}}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id-2} } |
    And API Operator add reservation pick-up to the route
    And API Operator start the route
    And API Driver set credentials "{ninja-driver-username-2}" and "{ninja-driver-password-2}"
    And API Driver collect all his routes
    And API Driver get Reservation Job
    And API Driver success reservation by scanning created parcel using submit pod v5
    When API Operator refresh created order data
    And API Operator global inbounds the order belongs to specific Hub Inbound User:
      | jsonRequest | {"barcodes":["{KEY_CREATED_ORDER_TRACKING_ID}"],"weight":{"value":310000},"dimensions":{"l":null,"w":null,"h":null},"hub_id":{hub-id-3}} |
    Then API Operator verify order info after Global Inbound
    When Operator switch to edit order page using direct URL
    Then Operator verify order status is "Transit" on Edit Order page
    And Operator verify order granular status is "Arrived at Sorting Hub" on Edit Order page
    And Operator verify Delivery details on Edit order page using data below:
      | status | PENDING |
    And API Operator get order details
    Then Operator verifies dimensions information on Edit Order page:
      | weight | 31         |
      | size   | EXTRALARGE |
      | length | 5          |
      | width  | 6          |
      | height | 7          |
    And Operator verify order event on Edit order page using data below:
      | name    | HUB INBOUND SCAN |
      | hubName | {hub-name-3}     |
    And API Operator new add parcel to the route using data below:
      | addParcelToRouteRequest | DELIVERY |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    And API Operator get order details
    And Operator refresh page
    Then API Operator verify order info after delivery "DELIVERY_SUCCESS"
    And Operator verify order status is "Completed" on Edit Order page
    And Operator verify order granular status is "Completed" on Edit Order page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op