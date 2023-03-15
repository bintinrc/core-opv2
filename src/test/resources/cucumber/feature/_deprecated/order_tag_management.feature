@Deprecated
Feature: Order Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Tagged Orders on the Order Tag Management Page - Arrived at Sorting Hub, No Route Id (uid:0117a8b6-ddca-44c3-90ec-a741f0f7f157)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> Order Tag Management
    And Operator opens 'View Tagged Orders' tab on Order Tag Management page:
    Then Operator verifies that 'Load Selection' button is disabled on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | orderTags      | {order-tag-name}       |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator verifies tagged order params on Order Tag Management page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | 1                               |
      | granularStatus       | Arrived at Sorting Hub          |

  Scenario: View Tagged Orders on the Order Tag Management Page - Pending Pickup, No Route Id, No Attempt, No Inbound Days (uid:890edc5f-46a4-4fde-990b-fa89bc0e94db)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    When Operator go to menu Order -> Order Tag Management
    And Operator opens 'View Tagged Orders' tab on Order Tag Management page:
    Then Operator verifies that 'Load Selection' button is disabled on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | orderTags      | {order-tag-name} |
      | granularStatus | Pending Pickup   |
    Then Operator verifies tagged order params on Order Tag Management page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID} |
      | tags                 | {order-tag-name}                |
      | driver               | No Driver                       |
      | route                | No Route                        |
      | lastAttempt          | No Attempt                      |
      | daysFromFirstInbound | Not Inbounded                   |
      | granularStatus       | Pending Pickup                  |

  @DeleteOrArchiveRoute
  Scenario: View Tagged Orders on the Order Tag Management Page - Delivery Attempted, Pending Reschedule (uid:3ea40471-cd24-4809-8b7d-c8e7605d4847)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator set tags of the new created route to [{route-tag-id}]
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
    When Operator go to menu Order -> Order Tag Management
    And Operator opens 'View Tagged Orders' tab on Order Tag Management page:
    Then Operator verifies that 'Load Selection' button is disabled on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | orderTags      | {order-tag-name}   |
      | granularStatus | Pending Reschedule |
    Then Operator verifies tagged order params on Order Tag Management page:
      | trackingId           | {KEY_CREATED_ORDER_TRACKING_ID}     |
      | tags                 | {order-tag-name}                    |
      | driver               | {ninja-driver-name}                 |
      | route                | {KEY_CREATED_ROUTE_ID}              |
      | lastAttempt          | ^{gradle-current-date-yyyy-MM-dd}.* |
      | daysFromFirstInbound | 1                                   |
      | granularStatus       | Pending Reschedule                  |

  @KillBrowser
  Scenario: Kill Browser
    Given no-op