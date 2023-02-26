@OperatorV2 @Route @NewFeatures @StationRoute
Feature: Add To Existing Routes on Station Route

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteDriver @DeleteCoverage @DeleteShipment @DeleteOrArchiveRoute
  Scenario: Operator Success Assign Unrouted Order To Existing Route on Station Route
    And API Operator create new shipment with type "AIR_HAUL" from hub id = {hub-id} to hub id = {hub-id-2}
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard","to": {"name": "QA-SO-Test-To","phone_number": "+6522453201","email": "recipientV4@nvqa.co","address": {"address1": "998 Toa Payoh North {gradle-current-date-yyyyMMddHHmmsss}","address2": "home {gradle-current-date-yyyyMMddHHmmsss}","country": "SG","postcode": "159363"}},"parcel_job":{ "cash_on_delivery": 50,"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","dimensions": {"size": "S" }, "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Sort - Operator global inbound
      | trackingId           | {KEY_CREATED_ORDER.trackingId} |
      | globalInboundRequest | {"hubId":{hub-id}}             |
    And API Sort - Operator adds order to shipment:
      | shipmentId | {KEY_CREATED_SHIPMENT_ID}                                                                                   |
      | request    | {"order_country":"sg","tracking_id":"{KEY_CREATED_ORDER.trackingId}","hub_id":{hub-id},"action_type":"ADD"} |
    Given API Operator does the "hub-inbound" scan for the shipment at transit hub = {hub-id-2}
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    Given API Operator create new Driver using data below:
      | driverCreateRequest | {"driver":{"firstName":"{{RANDOM_FIRST_NAME}}","lastName":"","licenseNumber":"D{{TIMESTAMP}}","driverType":"Middle-Mile-Driver","availability":false,"contacts":[{"active":true,"type":"Mobile Phone","details":"{default-phone-number}"}],"username":"D{{TIMESTAMP}}","comments":"This driver is created by \"Automation Test\" for testing purpose.","employmentStartDate":"{gradle-next-0-day-yyyy-MM-dd}","hubId":{hub-id-2},"hub":"{hub-name-2}","employmentType":"Full-time / Contract","licenseType":"Class 5","licenseExpiryDate":"{gradle-next-3-day-yyyy-MM-dd}","password":"{default-driver-password}","employmentEndDate":"{gradle-next-3-day-yyyy-MM-dd}"}} |
    And API Operator create new coverage:
      | hubId            | {hub-id-2}                                          |
      | area             | {KEY_CREATED_ORDER.toAddress1}                      |
      | areaVariations   | AreaVariation {gradle-current-date-yyyyMMddHHmmsss} |
      | keywords         | {KEY_CREATED_ORDER.toAddress2}                      |
      | primaryDriverId  | {KEY_LIST_OF_CREATED_DRIVERS[1].id}                 |
      | fallbackDriverId | {KEY_LIST_OF_CREATED_DRIVERS[2].id}                 |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{KEY_LIST_OF_CREATED_DRIVERS[1].id}, "comments":"Created by TA {gradle-current-date-yyyyMMddHHmmsss}"} |
    When Operator go to this URL "https://operatorv2-qa.ninjavan.co/#/sg/station-route"
    And Operator select filters on Station Route page:
      | hub                        | {hub-name-2}                   |
      | shipmentType               | AIR_HAUL                       |
      | shipmentDateFrom           | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentDateTo             | {gradle-next-1-day-yyyy-MM-dd} |
      | shipmentCompletionTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | shipmentCompletionTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator click Assign drivers button on Station Route page
    Then Operator verify statistics on Station Route page
    And Operator verify banner is displayed on Station Route page
    And Operator verify parcel is displayed on Station Route page:
      | trackingId | {KEY_CREATED_ORDER.trackingId}                                                   |
      | address    | {KEY_CREATED_ORDER.buildToAddressString}                                         |
      | parcelSize | Small                                                                            |
      | driverId   | {KEY_LIST_OF_CREATED_DRIVERS[1].id} - {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} |
    And Operator verify area match "{KEY_CREATED_ORDER.toAddress1}" is displayed in row 1 on Station Route page
    And Operator verify keyword match "{KEY_CREATED_ORDER.toAddress2}" is displayed in row 1 on Station Route page
    When Operator click Check assignment button on Station Route page
    Then Operator verify driver records on Select route creation method screen on Station Route page:
      | driverName                                 | parcelCount |
      | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} | 1           |
    When Operator select Add to existing routes on Station Route page
    And Operator click Next button on Station Route page
    Then Operator verify table records on Add to existing routes screen on Station Route page:
      | driverName                                 | routeId                           |
      | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    When Operator click Next button on Station Route page
    Then Operator verifies that success react notification displayed:
      | top | 1 parcels added to 1 routes |
    And Operator verify table records on Created routes detail screen on Station Route page:
      | driverName                                 | parcelCount | routeId                           | routeDate                        | zone        | hub          | comment                                             |
      | {KEY_LIST_OF_CREATED_DRIVERS[1].firstName} | 1           | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} | {gradle-current-date-yyyy-MM-dd} | {zone-name} | {hub-name-2} | Created by TA {gradle-current-date-yyyyMMddHHmmsss} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name    | ADD TO ROUTE                      |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
    And API Operator get order details
    And Operator save the last DELIVERY transaction of the created order as "KEY_TRANSACTION_AFTER"
    Then DB Operator verifies transactions record:
      | orderId    | {KEY_CREATED_ORDER_ID}             |
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | type       | DD                                 |
    And DB Operator verifies route_waypoint record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
    And DB Core - verify waypoints record:
      | id      | {KEY_TRANSACTION_AFTER.waypointId} |
      | status  | Routed                             |
      | routeId | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | seqNo   | not null                           |
    And DB Route - verify waypoints record:
      | legacyId | {KEY_TRANSACTION_AFTER.waypointId} |
      | seqNo    | not null                           |
      | routeId  | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |
      | status   | Routed                             |
    And DB Core - verify route_monitoring_data record:
      | waypointId | {KEY_TRANSACTION_AFTER.waypointId} |
      | routeId    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op