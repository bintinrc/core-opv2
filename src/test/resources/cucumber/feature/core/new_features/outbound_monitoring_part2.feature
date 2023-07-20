@OperatorV2 @Core @NewFeatures @OutboundMonitoring @OutboundMonitoringPart2 @NewFeatures1
Feature: Outbound Monitoring

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Filters Single Route on Outbound Monitoring Page by Pull Out button
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_CREATED_ROUTE_ID} |
    Then Operator verifies 1 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{gradle-current-date-yyyy-MM-dd}" date shown on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Searches Order of Multiple Routes on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 4                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[1]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[2]} | { "type":"DD" }         |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcels to the route using data below:
      | orderId                           | addParcelToRouteRequest |
      | {KEY_LIST_OF_CREATED_ORDER_ID[3]} | { "type":"DD" }         |
      | {KEY_LIST_OF_CREATED_ORDER_ID[4]} | { "type":"DD" }         |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{gradle-current-date-yyyy-MM-dd}" date shown on Outbound Breakroute V2 page
    When Operator filter orders table on Outbound Breakroute V2 page:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | lastScannedHub | {hub-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | routeDate | {gradle-current-date-yyyy-MM-dd} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverId | {ninja-driver-id} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverName | {ninja-driver-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverType | {default-driver-type-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | address | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | lastScanType | inbound_scan |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | orderDeliveryType | STANDARD |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[4].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Able to Show Pending State and Non-Pending State Delivery Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus         | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Completed              | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Show Pending State and Non-Pending State Pickup Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver pickup the created parcel successfully
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies orders table is empty on Outbound Breakroute V2 page

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When API Operator get order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL

    And DB Operator verifies route_monitoring_data is hard-deleted
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE    |
      | routeId | KEY_CREATED_ROUTE_ID |

  #   TODO DISABLED
  #scenario is disabled because causing db inconsistent data
#  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V2 Page - Route is Soft Deleted (uid:48deac7d-dde2-4e28-a637-3a08b1ae1a47)
#    Given Operator go to menu Utilities -> QRCode Printing
#    Given API Shipper create V4 order using data below:
#      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
#      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
#    And API Operator get order details
#    Given API Operator create new route using data below:
#      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
#    Given API Operator add parcel to the route using data below:
#      | addParcelToRouteRequest | { "type":"DD" } |
#    When Operator go to menu New Features -> Outbound Load Monitoring
#    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
#    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
#      | zoneName | {zone-name} |
#      | hubName  | {hub-name}  |
#    And Operator clicks Pull Out button for routes on Outbound Monitoring Page:
#      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
#    And DB Operator soft delete route "KEY_CREATED_ROUTE_ID"
#    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
#      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
#      | routeId                           | trackingId                                 |
#      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
#    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
#    Then Operator verifies that success react notification displayed:
#      | top                | Tracking IDs Pulled Out   |
#      | bottom             | 1 Tracking IDs pulled out |
#      | waitUntilInvisible | true                      |
#    And Operator verifies orders table is empty on Outbound Breakroute V2 page
#    When API Operator get order details
#    Then DB Operator verify Delivery waypoint of the created order using data below:
#      | status | PENDING |
#    And DB Operator verifies transaction route id is null
#    And DB Operator verifies waypoint status is "PENDING"
#    And DB Operator verifies waypoints.route_id & seq_no is NULL
#
#    And DB Operator verifies route_monitoring_data is hard-deleted
#    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
#    Then Operator verify order event on Edit order page using data below:
#      | name    | PULL OUT OF ROUTE    |
#      | routeId | KEY_CREATED_ROUTE_ID |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Shows Multiple Same Tracking IDs of Different Routes on Outbound Breakrout V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver failed the delivery of the created parcel using data below:
      | failureReasonFindMode  | findAdvance |
      | failureReasonCodeId    | 6           |
      | failureReasonIndexMode | FIRST       |
    And API Operator reschedule failed delivery order
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    And Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus          | lastScannedHub | routeId                           | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Shows a Route that has Multiple Tracking IDs on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_CREATED_ROUTE_ID} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus          | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | On Vehicle for Delivery | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Pull Out Multiple Delivery Orders from Multiple Routes on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 2 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[2]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[2]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Unable to Pull Out Non-Pending State Delivery Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoints of created orders
    And API Operator Van Inbound multiple parcels
    And API Operator start the route
    And API Driver successfully deliver created parcels with numbers: 1
    And API Driver failed the delivery of parcels with numbers: 2
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[1]}] is not in pending state] |
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus     | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | Completed          | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Pending Reschedule | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @DeleteOrArchiveRoute
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page - Pending State & Non-Pending State Delivery
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When API Driver set credentials "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver collect all his routes
    And API Driver get pickup/delivery waypoint of the created order
    And API Operator Van Inbound parcel
    And API Operator start the route
    And API Driver deliver the created parcel successfully
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{gradle-current-date-yyyy-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                           | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDER_ID[2]}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top                | Tracking IDs Pulled Out   |
      | bottom             | 1 Tracking IDs pulled out |
      | waitUntilInvisible | true                      |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                                 | granularStatus | lastScannedHub | routeId                | routeDate                                 | driverId          | driverName          | driverType                 | address                                             | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | Completed      | {hub-name}     | {KEY_CREATED_ROUTE_ID} | {gradle-current-date-yyyy-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDER[2].buildToAddressString} | inbound_scan | STANDARD          |
    When API Operator get "{KEY_LIST_OF_CREATED_ORDER_ID[1]}" order details
    Then DB Operator verify Delivery waypoint of the created order using data below:
      | status | PENDING |
    And DB Operator verifies transaction route id is null
    And DB Operator verifies waypoint status is "PENDING"
    And DB Operator verifies waypoints.route_id & seq_no is NULL
    And DB Operator verifies route_monitoring_data is hard-deleted:
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | PULL OUT OF ROUTE                 |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
