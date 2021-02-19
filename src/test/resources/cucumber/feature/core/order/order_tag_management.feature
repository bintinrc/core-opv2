@OperatorV2 @Core @Order @OrderTagManagement
Feature: Order Tag Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add Tags to Order (uid:370389c7-d387-4f1d-9af8-57380c4c3d0d)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page
    And Operator tags order with:
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |

  Scenario: Remove Tags from Order (uid:1ea8fbc7-d934-4433-9cc2-3034f6d9ae2a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id}   |
      | {order-tag-id-2} |
      | {order-tag-id-3} |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page
    And Operator removes order tags on Order Tag Management page:
      | {order-tag-name}   |
      | {order-tag-name-2} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name-3} |

  Scenario: Update Tags from Order (uid:7d001759-5de3-42aa-9622-dd72913aae5a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id} |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page
    And Operator tags order with:
      | {order-tag-name-2} |
      | {order-tag-name-3} |
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify the tags shown on Edit Order page
      | {order-tag-name}   |
      | {order-tag-name-2} |
      | {order-tag-name-3} |

  Scenario: Clear All Tags from Order (uid:abb24ee5-c2b1-4b8a-afa2-8b7fbee392b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Shipper tags "KEY_CREATED_ORDER_ID" parcel with following tags:
      | {order-tag-id}   |
      | {order-tag-id-2} |
      | {order-tag-id-3} |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    And Operator searches and selects orders created on Order Tag Management page
    And Operator clear all order tags on Order Tag Management page
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verifies no tags shown on Edit Order page

  Scenario Outline: Search Orders on Order Tag Management Page by Order Type Filter - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | orderType | <orderType> |
    Then Operator searches and selects orders created on Order Tag Management page
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:5a9eb763-3f2e-406a-a920-2fde0f189ace | Normal    | false            |
      | Return | uid:c2cb8cdc-f354-4afc-a5c8-63cc99a7955e | Return    | true             |

  Scenario: Search Orders on the Order Tag Management Page by RTS Filter - Hide RTS Orders (uid:375d4322-b8ba-4cd3-a211-ce59402fc803)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created orders:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> Order Tag Management
    Then Operator verifies selected value of RTS filter is "Hide" on Order Tag Management page
    When Operator clicks 'Clear All Selection' button on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | rts | Hide |
    Then Operator verifies orders are not displayed on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |

  Scenario: Search Orders on the Order Tag Management Page by RTS Filter - Show RTS Orders (uid:b2d0b3b7-e915-49ed-94a1-0ac287889db5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Operator RTS created orders:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    When Operator go to menu Order -> Order Tag Management
    Then Operator verifies selected value of RTS filter is "Hide" on Order Tag Management page
    When Operator clicks 'Clear All Selection' button on Order Tag Management page
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | rts | Show |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Shipper Filter (uid:d4180b65-215f-48f0-9c42-7f7ac5a45b2c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName | {shipper-v4-legacy-id}-{shipper-v4-name} |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Master Shipper Filter (uid:ae438b3a-376d-46bf-811a-1ccfcd8ef6b0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create multiple V4 orders using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | masterShipperName | {shipper-v4-marketplace-name} |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by Status & Granular Status Filter (uid:3ff15dde-21af-4e3c-89f1-6b57534e4e73)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> Order Tag Management
    And Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | status         | Transit                |
      | granularStatus | Arrived at Sorting Hub |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: Search Orders on the Order Tag Management Page by CSV File (uid:45a9e1a9-2112-4a5d-b753-83dd279c2f43)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound multiple parcels using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    When Operator go to menu Order -> Order Tag Management
    And Operator find orders by uploading CSV on Order Tag Management page:
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
    Then Operator searches and selects orders created on Order Tag Management page

  Scenario: View Tagged Orders - Arrived at Sorting Hub, No Route Id (uid:0117a8b6-ddca-44c3-90ec-a741f0f7f157)
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

  Scenario: View Tagged Orders - Pending Pickup, No Route Id, No Attempt, No Inbound Days (uid:890edc5f-46a4-4fde-990b-fa89bc0e94db)
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
  Scenario: View Tagged Orders - Delivery Attempted, Pending Reschedule (uid:3ea40471-cd24-4809-8b7d-c8e7605d4847)
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