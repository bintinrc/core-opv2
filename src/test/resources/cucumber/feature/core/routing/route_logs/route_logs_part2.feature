@OperatorV2 @Core @Routing @RouteLogs @RouteLogsPart2 @current
Feature: Route Logs

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute @wip
  Scenario: Operator Add Tag to a Single Route on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator adds tag "{route-tag-name}" to created route
    Then Operator verifies that success react notification displayed:
      | top    | 1 route(s) tagged                                         |
      | bottom | Route {KEY_CREATED_ROUTE_ID} tagged with {route-tag-name} |
#      | waitUntilInvisible | true                                                      |
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | tags | {route-tag-name}       |

  #TODO will uncomment verifies success react notification after the fix pushed to QA
  @DeleteOrArchiveRoute
  Scenario: Operator Delete a Single Route on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route on Route Logs page
#    Then Operator verifies that success react notification displayed:
#      | top                | 1 Route(s) Deleted |
    And Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |

  @DeleteOrArchiveRoute @CloseNewWindows
  Scenario: Operator Redirected to Edit Route Page from Route Logs - Load Waypoints of Selected Route(s) only
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator click 'Edit Route' and then click 'Load Waypoints of Selected Route(s) Only'
    Then Operator is redirected to this page "sg/edit-routes?cluster=true&ids={KEY_CREATED_ROUTE_ID}&unrouted=false"

  @DeleteOrArchiveRoute
  Scenario: Operator Filters Route by Route Id on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd} |
      | id             | {KEY_CREATED_ROUTE_ID}           |
      | status         | PENDING                          |
      | driverName     | {ninja-driver-name}              |
      | hub            | {hub-name}                       |
      | zone           | {zone-name}                      |
      | driverTypeName | {default-driver-type-name}       |

  @DeleteOrArchiveRoute
  Scenario: Operator Remove Tag of a Single Route on Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id},{route-tag-id-2}]
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator removes tag "{route-tag-name-2}" from created route
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_CREATED_ROUTE_ID} |
      | tags | {route-tag-name}       |

  @DeleteOrArchiveRoute @happy-path
  Scenario: Operator Address Verify Route on Route Logs Page
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator verifies address of "{KEY_CREATED_ROUTE_ID}" route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | Address verification successful for selected route |
      | waitUntilInvisible | true                                               |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filters Multiple Routes by Comma Separated Route Ids on Route Logs Page - <Note>
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-2}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "<Search>" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}  |
      | id             | {KEY_LIST_OF_CREATED_ROUTE_ID[1]} |
      | status         | PENDING                           |
      | driverName     | {ninja-driver-name}               |
      | hub            | {hub-name}                        |
      | zone           | {zone-name}                       |
      | driverTypeName | {default-driver-type-name}        |
    And Operator verify route details on Route Logs page using data below:
      | date           | {gradle-current-date-yyyy-MM-dd}  |
      | id             | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | status         | PENDING                           |
      | driverName     | {ninja-driver-name}               |
      | hub            | {hub-name-2}                      |
      | zone           | {zone-name-2}                     |
      | driverTypeName | {default-driver-type-name}        |
    Examples:
      | Note          | Search                                                               |
      | With Space    | {KEY_LIST_OF_CREATED_ROUTE_ID[1]}, {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | With No Space | {KEY_LIST_OF_CREATED_ROUTE_ID[1]},{KEY_LIST_OF_CREATED_ROUTE_ID[2]}  |

  @DeleteOrArchiveRoute
  Scenario: Operator Optimise Single Route from Route Logs Page
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator add multiple parcels to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Optimize Selected Route dialog for "{KEY_CREATED_ROUTE_ID}" route on Route Logs page
    Then Optimize Selected Route dialog contains message on Route Logs page:
      | This route originally contained: 2 waypoint(s)                             |
      | Route optimise did not drop any waypoint(s)!                               |
      | Are you sure you want to proceed to optimise this route to 2 waypoints(s)? |
    When Operator clicks Optimize Route button in Optimize Selected Route dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Route Optimised            |
      | bottom | Route {KEY_CREATED_ROUTE_ID} |
