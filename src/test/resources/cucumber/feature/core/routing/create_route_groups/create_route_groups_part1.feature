@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @CreateRouteGroupsPart1 @CRG1
Feature: Create Route Groups

  https://studio.cucumber.io/projects/208144/test-plan/folders/1593801

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario: Operator Add Transaction to Route Group on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214754
    Given API Order - Shipper create multiple V4 orders using data below:
      | shipperClientId     | {shipper-v4-paj-client-id}                                                                                                                                                                                                                                                                                                       |
      | shipperClientSecret | {shipper-v4-paj-client-secret}                                                                                                                                                                                                                                                                                                   |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    And Operator adds following transactions to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}" on Create Route Groups page:
      | trackingId                            |
      | {KEY_LIST_OF_CREATED_TRACKING_IDS[1]} |
    Then Operator verifies that success react notification displayed:
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
  Scenario: Operator Add Reservation to Route Group on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/7160757
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Operator create V2 reservation using data below:
      | reservationRequest | { "pickup_service_level":"Standard", "legacy_shipper_id":{shipper-v4-legacy-id}, "pickup_approx_volume":"Less than 10 parcels", "pickup_start_time":"{gradle-current-date-yyyy-MM-dd}T15:00:00{gradle-timezone-XXX}", "pickup_end_time":"{gradle-current-date-yyyy-MM-dd}T18:00:00{gradle-timezone-XXX}" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
    And Operator choose "Include Reservations" on Reservation Filters section on Create Route Groups page
    And Operator add following filters on Reservation Filters section on Create Route Groups page:
      | reservationType | Normal |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Reservation records on Create Route Groups page using data below:
      | id                           | type        | shipper                    | address                                                     | status  | startDateTime                                       | endDateTime                                          |
      | {KEY_CREATED_RESERVATION.id} | Reservation | {KEY_CREATED_ADDRESS.name} | {KEY_CREATED_ADDRESS.to1LineShortAddressWithSpaceDelimiter} | PENDING | {KEY_CREATED_RESERVATION.getLocalizedReadyDatetime} | {KEY_CREATED_RESERVATION.getLocalizedLatestDatetime} |
    And Operator adds following reservations to new Route Group "ARG-{gradle-current-date-yyyyMMddHHmmsss}" on Create Route Groups page:
      | id                           |
      | {KEY_CREATED_RESERVATION.id} |
    Then Operator verifies that success react notification displayed:
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

  Scenario: Operator Filter Master Shipper on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/6905698
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    And API Shipper create V4 order using data below:
      | v4OrderRequest | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime  | today                              |
      | masterShipper | {shipper-v4-marketplace-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  @DeleteOrArchiveRoute
  Scenario: Operator Filter Routed Transaction on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214756
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    And API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"PP" } |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today |
      | routed       | Show  |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator choose "Hide Reservations" on Reservation Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction record on Create Route Groups page using data below:
      | id            | GET_FROM_CREATED_ORDER[1]                                  |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | PICKUP Transaction                                         |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Pending Pickup                                             |
      | startDateTime | {KEY_LIST_OF_CREATED_ORDER[1].pickupDate} 12:00:00         |
      | endDateTime   | {KEY_LIST_OF_CREATED_ORDER[1].pickupEndDate} 15:00:00      |

  Scenario: Operator Filter DP Order on Create Route Groups
    # https://studio.cucumber.io/projects/208144/test-plan/folders/1593801/scenarios/5214760
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                        |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions": {"weight": 1}, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "type":"SORTING_HUB", "hubId":{hub-id} } |
    And API Operator assign delivery waypoint of an order to DP Include Today with ID = "{dpms-id}"
    And API Operator refresh created order data
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTime | today                 |
      | shipper      | {filter-shipper-name} |
      | dpOrder      | {dp-name}             |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                     | type                 | shipper                      | address                                  | status                 |
      | {KEY_CREATED_ORDER.trackingId} | DELIVERY Transaction | {KEY_CREATED_ORDER.fromName} | {KEY_CREATED_ORDER.buildToAddressString} | Arrived at Sorting Hub |
