@OperatorV2 @Core @NewFeatures @OutboundMonitoring @OutboundMonitoringPart2 @NewFeatures1
Feature: Outbound Monitoring

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Filters Single Route on Outbound Monitoring Page by Pull Out button
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[1].trackingId} |
      | status     | TRANSIT                                    |
    Then API Core -  Wait for following order state:
      | trackingId | {KEY_LIST_OF_CREATED_ORDERS[2].trackingId} |
      | status     | TRANSIT                                    |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    Then Operator verifies 1 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{date: 0 days next, YYYY-MM-dd}" date shown on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Searches Order of Multiple Routes on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 4                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[3] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[4] |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[3].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[4].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies "{date: 0 days next, YYYY-MM-dd}" date shown on Outbound Breakroute V2 page
    When Operator filter orders table on Outbound Breakroute V2 page:
      | trackingId | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | granularStatus | Arrived at Sorting Hub |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | lastScannedHub | {hub-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | routeDate | {date: 0 days next, YYYY-MM-dd} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverId | {ninja-driver-id} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverName | {ninja-driver-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | driverType | {default-driver-type-name} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | address | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | lastScanType | inbound_scan |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |
    When Operator clear filters of orders table on Outbound Breakroute V2 page
    And Operator filter orders table on Outbound Breakroute V2 page:
      | orderDeliveryType | STANDARD |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[3]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[3].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[4]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[4].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Able to Show Pending State and Non-Pending State Delivery Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                     |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                             |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_ORDERS[1].trackingId}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                      |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus         | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Completed              | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Arrived at Sorting Hub | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Unable to Show Pending State and Non-Pending State Pickup Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"PICKUP"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                               |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"PICKUP"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                               |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[1].waypointId}                       |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS"}] |
      | routes     | KEY_DRIVER_ROUTES                                                                |
      | jobType    | TRANSACTION                                                                      |
      | jobAction  | SUCCESS                                                                          |
      | jobMode    | PICK_UP                                                                          |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    Then Operator verifies 2 total selected Route IDs shown on Outbound Breakroute V2 page
    And Operator verifies orders table is empty on Outbound Breakroute V2 page

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Pull Out Delivery Order from a Route on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                            | trackingId                            |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top    | Tracking IDs Pulled Out   |
      | bottom | 1 Tracking IDs pulled out |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |
      | routeId  | null                                                       |
      | seqNo    | null                                                       |
      | status   | Pending                                                    |
    And DB Core - verify transactions record:
      | id      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].id} |
      | routeId | null                                               |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Shows Multiple Same Tracking IDs of Different Routes on Outbound Breakrout V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get order details for tracking order "KEY_LIST_OF_CREATED_TRACKING_IDS[1]"
    And API Sort - Operator global inbound
      | trackingId           | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | hubId                | {hub-id}                              |
      | globalInboundRequest | { "hubId":{hub-id} }                  |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | DELIVERY                                                                                             |
      | failureReasonId | 139                                                                                                  |
    And API Core - Operator reschedule order:
      | orderId           | {KEY_LIST_OF_CREATED_ORDERS[1].id}        |
      | rescheduleRequest | {"date":"{date: 0 days ago, yyyy-MM-dd}"} |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[2].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    And Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator verifies filter results on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus          | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Shows a Route that has Multiple Tracking IDs on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    Given API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Driver - Driver start route "{KEY_LIST_OF_CREATED_ROUTES[1].id}"
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus          | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | On Vehicle for Delivery | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Pull Out Multiple Delivery Orders from Multiple Routes on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                  |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                           |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    When Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                            | trackingId                            |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top    | Tracking IDs Pulled Out   |
      | bottom | 2 Tracking IDs pulled out |
    And Operator verifies orders table is empty on Outbound Breakroute V2 page
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[1].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[1].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Unable to Pull Out Non-Pending State Delivery Order on Outbound Breakroute V2 Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                        |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                 |
    And API Driver - Driver submit POD:
      | routeId         | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                   |
      | waypointId      | {KEY_LIST_OF_CREATED_ORDERS[2].transactions[2].waypointId}                                           |
      | routes          | KEY_DRIVER_ROUTES                                                                                    |
      | jobType         | TRANSACTION                                                                                          |
      | parcels         | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[2]}", "action":"FAIL","failure_reason_id":139}] |
      | jobAction       | FAIL                                                                                                 |
      | jobMode         | DELIVERY                                                                                             |
      | failureReasonId | 139                                                                                                  |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                            | trackingId                            |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDERS[1].id}] is not in pending state] |
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDERS[2].id}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus     | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Completed          | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} | Pending Reschedule | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[2].buildToAddressString} | inbound_scan | STANDARD          |

  @CloseNewWindows @ArchiveRouteCommonV2
  Scenario: Operator Partial Success To Pull Out Multiple Orders from Multiple Routes on Outbound Breakroute V2 Page - Pending State & Non-Pending State Delivery
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-client-id}                                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-client-secret}                                                                                                                                                                                                                                                                                                                   |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, YYYY-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, YYYY-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    # 1st Order/Route
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[1].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[1].id}, "type":"DELIVERY"} |
    And API Driver - Driver login with username "{ninja-driver-username}" and "{ninja-driver-password}"
    And API Driver - Driver read routes:
      | driverId        | {ninja-driver-id}                  |
      | expectedRouteId | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And API Driver - Driver van inbound:
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                                                                |
      | request | {"parcels":[{"inbound_type":"VAN_FROM_NINJAVAN","tracking_id":"{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}","waypoint_id":{KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}}]} |
    And API Core - Operator start the route with following data:
      | routeId  | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                                                                    |
      | driverId | {ninja-driver-id}                                                                                                                     |
      | request  | {"user_id":"5622157","user_name":"OPV2-CORE-DRIVER","user_grant_type":"PASSWORD","user_email":"opv2-core-driver.auto@hg.ninjavan.co"} |
    And API Driver - Driver submit POD:
      | routeId    | {KEY_LIST_OF_CREATED_ROUTES[1].id}                                                |
      | waypointId | {KEY_LIST_OF_CREATED_ORDERS[1].transactions[2].waypointId}                        |
      | parcels    | [{ "tracking_id": "{KEY_LIST_OF_CREATED_TRACKING_IDS[1]}", "action": "SUCCESS" }] |
      | routes     | KEY_DRIVER_ROUTES                                                                 |
    # 2nd Order/Route
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator add parcel to the route using data below:
      | orderId                 | {KEY_LIST_OF_CREATED_ORDERS[2].id}                                 |
      | addParcelToRouteRequest | {"route_id":{KEY_LIST_OF_CREATED_ROUTES[2].id}, "type":"DELIVERY"} |
    Given Operator go to menu New Features -> Outbound Load Monitoring
    Then Operator verifies Date is "{date: 0 days next, YYYY-MM-dd}" on Outbound Monitoring Page
    When Operator select filter and click Load Selection on Outbound Monitoring page using data below:
      | zoneName | {zone-name} |
      | hubName  | {hub-name}  |
    When Operator clicks Pull Out button for routes on Outbound Monitoring Page:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} |
    And Operator clicks Pull Out button for orders on Outbound Breakroute V2 page:
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    Then Operator verifies info in Confirm Pull Out modal on Outbound Breakroute V2 page:
      | routeId                            | trackingId                            |
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
      | {KEY_LIST_OF_CREATED_ROUTES[2].id} | {KEY_LIST_OF_CREATED_TRACKING_IDS[2]} |
    When Operator clicks Pull Out in Confirm Pull Out modal on Outbound Breakroute V2 page
    Then Operator verifies errors in Processing modal on Outbound Breakroute V2 page:
      | Get ProcessingException [Code:ORDER_COMPLETED_EXCEPTION][Message:Transaction for [OrderID:{KEY_LIST_OF_CREATED_ORDERS[1].id}] is not in pending state] |
    When Operator clicks Cancel in Processing modal on Outbound Breakroute V2 page
    Then Operator verifies that success react notification displayed:
      | top    | Tracking IDs Pulled Out   |
      | bottom | 1 Tracking IDs pulled out |
    And Operator verifies orders info on Outbound Breakroute V2 page:
      | trackingId                            | granularStatus | lastScannedHub | routeId                            | routeDate                                | driverId          | driverName          | driverType                 | address                                              | lastScanType | orderDeliveryType |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} | Completed      | {hub-name}     | {KEY_LIST_OF_CREATED_ROUTES[1].id} | {date: 0 days next, YYYY-MM-dd} 00:00:00 | {ninja-driver-id} | {ninja-driver-name} | {default-driver-type-name} | {KEY_LIST_OF_CREATED_ORDERS[1].buildToAddressString} | inbound_scan | STANDARD          |
    And API Core - save the last Delivery transaction of "{KEY_LIST_OF_CREATED_ORDERS[2].id}" order from "KEY_LIST_OF_CREATED_ORDERS" as "KEY_TRANSACTION"
    And DB Core - verify transactions record:
      | id      | {KEY_TRANSACTION.id} |
      | status  | Pending              |
      | routeId | null                 |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION.waypointId} |
      | status  | Pending                      |
      | routeId | null                         |
      | seqNo   | null                         |
    And DB Core - verify route_monitoring_data is hard-deleted:
      | {KEY_TRANSACTION.waypointId} |
    When Operator open Edit Order V2 page for order ID "{KEY_LIST_OF_CREATED_ORDERS[2].id}"
    Then Operator verify order event on Edit Order V2 page using data below:
      | name    | PULL OUT OF ROUTE                  |
      | routeId | {KEY_LIST_OF_CREATED_ROUTES[2].id} |