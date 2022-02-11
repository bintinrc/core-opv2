@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroupsV1.5
Feature: Create Route Groups V1.5

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario: Operator Add Transaction to Route Group on Create Route Group V1.5 (uid:f78a6a4f-cac1-40a4-a405-5fcf375abce7)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    And Operator adds following transactions to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}" on Create Route Group V1.5 page:
      | trackingId                                 |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    When Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    Then Operator verify route group on Route Groups Management page:
      | name                 | {KEY_CREATED_ROUTE_GROUP.name}      |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.* |
      | noTransactions       | 2                                   |
      | noRoutedTransactions | 0                                   |
      | noReservations       | 0                                   |
      | noRoutedReservations | 0                                   |

  @DeleteRouteGroups
  Scenario: Operator Add Reservation to Route Group on Create Route Group V1.5 (uid:ac76c33c-0e18-4a3f-957c-211444d4d708)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group V1.5 page
    And Operator add following filters on Reservation Filters section on Create Route Group V1.5 page:
      | reservationType | Normal |
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Reservation records on Create Route Group V1.5 page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |
    And Operator adds following reservations to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}":
      | id                           |
      | {KEY_CREATED_RESERVATION.id} |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    When Operator go to menu Routing -> 2. Route Group Management
    And Route Groups Management page is loaded
    Then Operator verify route group on Route Groups Management page:
      | name                 | {KEY_CREATED_ROUTE_GROUP.name}      |
      | createDateTime       | ^{gradle-current-date-yyyy-MM-dd}.* |
      | noTransactions       | 0                                   |
      | noRoutedTransactions | 0                                   |
      | noReservations       | 1                                   |
      | noRoutedReservations | 0                                   |

  Scenario: Operator Filter Master Shipper on Create Route Group V1.5 (uid:2d09a2eb-314f-436f-a8bb-7bcf77cfd553)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time  | Today                              |
      | Master Shipper | {shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Routed Transaction on Create Route Group V1.5 (uid:8b96252f-32bc-49e4-9768-ad802929f298)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Routed"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today |
      | Routed        | Show  |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction record on Create Route Group V1.5 page using data below:
      | id            | GET_FROM_CREATED_ORDER[1]                                  |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | PICKUP Transaction                                         |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Pending Pickup                                             |
      | startDateTime | {KEY_LIST_OF_CREATED_ORDER[1].pickupDate} 12:00:00         |
      | endDateTime   | {KEY_LIST_OF_CREATED_ORDER[1].pickupEndDate} 15:00:00      |

  Scenario: Operator Filter DP Order on Create Route Group V1.5 (uid:10fe0704-11ba-41b5-8ca2-00e695092078)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator refresh created order data
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper, DP Order"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today                 |
      | Shipper       | {filter-shipper-name} |
      | DP Order      | {dp-name}             |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction records on Create Route Group V1.5 page using data below:
      | trackingId                     | type                 | shipper                      | address                                  | status                 |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildToAddressString} | Arrived at Sorting Hub |

  @DeleteRouteGroups
  Scenario: Operator Filter Route Grouping on Create Route Group V1.5 (uid:3abb3461-9ffa-486d-b5e5-4949c87644fc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    When Operator adds following transactions to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}":
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} | PICKUP   |
    Then Operator verifies that success toast displayed:
      | top | Added successfully |
    When Operator refresh page
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Route Grouping"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Route Grouping | {KEY_CREATED_ROUTE_GROUP.name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator click Load Selection on Create Route Group V1.5 page
    Then Operator verifies Transaction records on Create Route Group V1.5 page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  Scenario: Download CSV of Route Group Information on Create Route Group V1.5 (uid:4a37fbbe-4069-4327-b4fe-46af568e7026)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 Parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1.1. Create Route Groups V1.5
    And Operator wait until 'Create Route Group V1.5' page is loaded
    And Operator removes all General Filters except following on Create Route Group V1.5 page: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group V1.5 page:
      | Creation Time | current hour          |
      | Shipper       | {filter-shipper-name} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group V1.5 page
    And Operator add following filters on Transactions Filters section on Create Route Group V1.5 page:
      | orderType | Normal,Return |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Group V1.5 page
    And Operator add following filters on Reservation Filters section on Create Route Group V1.5 page:
      | reservationType   | Normal  |
      | reservationStatus | Pending |
    And Operator click Load Selection on Create Route Group V1.5 page
    And Operator sort Transactions/Reservations table by Tracking ID on Create Route Group V1.5 page
    And Operator save records from Transactions/Reservations table on Create Route Group V1.5 page
    And Operator download CSV file on Create Route Group V1.5 page
    Then Operator verify Transactions/Reservations CSV file on Create Route Group V1.5 page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
