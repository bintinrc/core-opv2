@OperatorV2 @Core @Routing @RouteLogs @RouteLogsPart2
Feature: Route Logs

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @ArchiveRouteCommonV2
  Scenario: Operator Add Tag to a Single Route on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_LIST_OF_CREATED_ROUTES[1].id}" Route ID on Route Logs page
    And Operator adds tag "{route-tag-name}" to created route
    Then Operator verifies that success react notification displayed:
      | top    | 1 route(s) tagged                                                     |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} tagged with {route-tag-name} |
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | tags | {route-tag-name}                   |

  @ArchiveRouteCommonV2
  Scenario: Operator Delete a Single Route on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator deletes created route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Route(s) Deleted                       |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
    And Operator verify routes are deleted successfully:
      | {KEY_LIST_OF_CREATED_ROUTES[1].id} |

  @ArchiveRouteCommonV2 @CloseNewWindows @wip
  Scenario: Operator Redirected to Edit Route Page from Route Logs - Load Waypoints of Selected Route(s) only
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator click 'Edit Route' and then click 'Load Waypoints of Selected Routes Only'
    Then Operator is redirected to this page "sg/edit-routes?cluster=true&ids={KEY_LIST_OF_CREATED_ROUTES[1].id}&unrouted=false"

  @ArchiveRouteCommonV2
  Scenario: Operator Filters Route by Route Id on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "{KEY_CREATED_ROUTE_ID}" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {date: 0 days next, yyyy-MM-dd}    |
      | id             | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | status         | PENDING                            |
      | driverName     | {ninja-driver-name}                |
      | hub            | {hub-name}                         |
      | zone           | {zone-name}                        |
      | driverTypeName | {default-driver-type-name}         |

  @ArchiveRouteCommonV2
  Scenario: Operator Remove Tag of a Single Route on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id},{route-tag-id-2}]
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator removes tag "{route-tag-name-2}" from created route
    Then Operator verify route details on Route Logs page using data below:
      | id   | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | tags | {route-tag-name}                   |

  @ArchiveRouteCommonV2 @happy-path @HighPriority
  Scenario: Operator Address Verify Route on Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id-2}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator verifies address of "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top                | Address verification successful for selected route |
      | waitUntilInvisible | true                                               |

  @DeleteOrArchiveRoute
  Scenario Outline: Operator Filters Multiple Routes by Comma Separated Route Ids on Route Logs Page - <Note>
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id-2}, "hubId":{hub-id-2}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    When Operator go to menu Routing -> Route Logs
    And Operator filters route by "<Search>" Route ID on Route Logs page
    Then Operator verify route details on Route Logs page using data below:
      | date           | {date: 0 days next, yyyy-MM-dd}    |
      | id             | {KEY_LIST_OF_CREATED_ROUTES[1].id} |
      | status         | PENDING                            |
      | driverName     | {ninja-driver-name}                |
      | hub            | {hub-name}                         |
      | zone           | {zone-name}                        |
      | driverTypeName | {default-driver-type-name}         |
    And Operator verify route details on Route Logs page using data below:
      | date           | {date: 0 days next, yyyy-MM-dd}   |
      | id             | {KEY_LIST_OF_CREATED_ROUTE_ID[2]} |
      | status         | PENDING                           |
      | driverName     | {ninja-driver-name}               |
      | hub            | {hub-name-2}                      |
      | zone           | {zone-name-2}                     |
      | driverTypeName | {default-driver-type-name}        |
    Examples:
      | Note          | Search                                                                 |
      | With Space    | {KEY_LIST_OF_CREATED_ROUTES[1].id}, {KEY_LIST_OF_CREATED_ROUTES[2].id} |
      | With No Space | {KEY_LIST_OF_CREATED_ROUTES[1].id},{KEY_LIST_OF_CREATED_ROUTES[2].id}  |

  @DeleteOrArchiveRoute
  Scenario: Operator Optimise Single Route from Route Logs Page
    Given API Core - Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                                   |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                               |
      | numberOfOrder       | 2                                                                                                                                                                                                                                                                                                                                            |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                                       |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{date: 1 days next, yyyy-MM-dd}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{date: 1 days next, yyyy-MM-dd}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Core - Operator get multiple order details for tracking ids:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Sort - Operator global inbound multiple parcel for "{hub-id}" hub id with data below:
      | KEY_LIST_OF_CREATED_TRACKING_IDS[1] |
      | KEY_LIST_OF_CREATED_TRACKING_IDS[2] |
    And API Core - Operator add multiple parcels to route "{KEY_LIST_OF_CREATED_ROUTES[1].id}" with type "DELIVERY" using data below:
      | {KEY_LIST_OF_CREATED_ORDERS[1].id} |
      | {KEY_LIST_OF_CREATED_ORDERS[2].id} |
    When Operator go to menu Routing -> Route Logs
    And Operator set filter using data below and click 'Load Selection'
      | routeDateFrom | YESTERDAY  |
      | routeDateTo   | TODAY      |
      | hubName       | {hub-name} |
    And Operator opens Optimize Selected Route dialog for "{KEY_LIST_OF_CREATED_ROUTES[1].id}" route on Route Logs page
    Then Optimize Selected Route dialog contains message on Route Logs page:
      | This route originally contained: 2 waypoint(s)                             |
      | Route optimise did not drop any waypoint(s)!                               |
      | Are you sure you want to proceed to optimise this route to 2 waypoints(s)? |
    When Operator clicks Optimize Route button in Optimize Selected Route dialog on Route Logs page
    Then Operator verifies that success react notification displayed:
      | top    | 1 Route Optimised                        |
      | bottom | Route {KEY_LIST_OF_CREATED_ROUTES[1].id} |
