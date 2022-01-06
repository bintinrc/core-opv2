@OperatorV2 @Core @Routing @RoutingJob2 @CreateRouteGroups
Feature: Create Route Groups - Transaction Filters

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteOrArchiveRoute
  Scenario: Operator Filter RTS on Create Route Group - Transaction Filters (uid:f712664e-dbb9-4fbe-b041-d4d6c305ff48)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Operator create new route using data below:
      | createRouteRequest | { "zoneId":{zone-id}, "hubId":{hub-id}, "vehicleId":{vehicle-id}, "driverId":{ninja-driver-id} } |
    Given API Operator add parcel to the route using data below:
      | addParcelToRouteRequest | { "type":"DD" } |
    Given API Operator RTS created order:
      | rtsRequest | {"reason":"Return to sender: Nobody at address","timewindow_id":1,"date":"{gradle-next-1-day-yyyy-MM-dd}"} |
    Given Operator go to menu Routing -> 1. Create Route Groups
    Given Operator wait until 'Create Route Group' page is loaded
    Given Operator removes all General Filters except following: "Creation Time"
    Given Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    Given Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | RTS | Show |
    Given Operator choose "Hide Reservations" on Reservation Filters section on Create Route Group page
    Given Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | id            | GET_FROM_CREATED_ORDER[1]                                  |
      | orderId       | {KEY_LIST_OF_CREATED_ORDER[1].id}                          |
      | trackingId    | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type          | PICKUP Transaction                                         |
      | shipper       | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address       | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status        | Arrived at Sorting Hub                                     |
      | startDateTime | {KEY_LIST_OF_CREATED_ORDER[1].pickupDate} 12:00:00         |
      | endDateTime   | {KEY_LIST_OF_CREATED_ORDER[1].pickupEndDate} 15:00:00      |

  Scenario: Operator Filter Order Type on Create Route Group - Transaction Filters (uid:30fc5e7c-b85f-4401-8d92-dcc63c07a03a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator Global Inbound parcel using data below:
      | globalInboundRequest | { "hubId":{hub-id} } |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderType | Normal,Return |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status                 |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Arrived at Sorting Hub |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup         |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - <Note> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | Note   | service_type    | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                   | hiptest-uid                              |
      | Parcel | Parcel Delivery | Pending Pickup | DELIVERY Transaction | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:547bc7e9-1432-4d1f-8ea8-553086758134 |
      | Return | Return          | Pending Pickup | DELIVERY Transaction | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}}  | uid:fc3a7a68-feb0-4540-9599-5b957ed37047 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Marketplace (uid:d7067f43-f02c-4dde-ba64-1aea558fed8c)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | hiptest-uid                              |
      | Marketplace  | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} | uid:3f17fe40-7fb8-44f5-ae5e-86639de78feb |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - International (uid:30d34cc1-76db-4833-b434-0f06294cb5a3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
      | generateTo     | RANDOM           |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type  | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                        |
      | International | Pending Pickup | DELIVERY Transaction | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Marketplace International (uid:f8929f70-3e18-4be8-b490-20dd32b97e68)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
      | generateTo     | RANDOM           |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type              | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | Marketplace International | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace International","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": false,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Ninja Pack (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator generate 2 Ninja Pack Tracking Id
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 1                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                 | hiptest-uid                              |
      | Ninja Pack   | Pending Pickup | DELIVERY Transaction | { "requested_tracking_number":"{KEY_NINJA_PACK_TRACKING_LIST[1].trackingId}","service_type":"Ninja Pack","service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:b2314731-a6d8-42e1-9f22-4b93dfbd88e9 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Document (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                     | hiptest-uid                              |
      | Document     | Pending Pickup | DELIVERY Transaction | { "service_type":"Document", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} | uid:7cc4e8fa-9506-4f91-b2f2-07fbe1820b97 |

  Scenario: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Marketplace Sort (uid:e49e7cbc-d702-43cf-bc49-05201f83b8e1)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-sort-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-sort-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
      | v4OrderRequest    | { "service_type":"Marketplace Sort","requested_tracking_number":"RBS{{6-random-digits}}","sort":{"to_3pl":"ROADBULL"},"marketplace":{"seller_id": "seller-ABC01","seller_company_name":"ABC Shop"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Master Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time  | Today                                   |
      | Master Shipper | {shipper-v4-marketplace-sort-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | Marketplace Sort |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Corporate (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType | hiptest-uid                              |
      | Corporate   | uid:e9550294-1f8b-4e43-a7ec-234239ab9d67 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Corporate Return (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType      | hiptest-uid                              |
      | Corporate Return | uid:26f1fb1c-23d5-4126-8285-c325f0e7b838 |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Corporate Document (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                                                                                                                                                                                                                                                                                                                                                                                                              |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                         |
      | v4OrderRequest    | { "service_type":"<serviceType>","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | <serviceType> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |
    Examples:
      | serviceType        | hiptest-uid                              |
      | Corporate Document | uid:8670e666-5a26-4450-aa4f-e00acd7472d5 |

  Scenario: Operator Filter Order by Service Type on Create Route Group Page - Transaction Filters - Corporate AWB (uid:599a191b-43b6-45ca-896e-c91e159d8f4f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator generate 2 Corporate AWB Tracking Id
    And API Shipper set Shipper V4 using data below:
      | legacyId | {shipper-v4-corporate-legacy-id} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[1].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
      | v4OrderRequest    | {"service_type":"Corporate AWB","requested_tracking_number":"{KEY_CORPORATE_AWB_TRACKING_LIST[2].trackingId}","corporate":{"branch_id":"{shipper-v4-corporate-subshipper-branch-id}"},"service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                                       |
      | Shipper       | {shipper-v4-corporate-subshipper-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    And Operator add following filters on Transactions Filters section on Create Route Group page:
      | orderServiceType | Corporate Manual AWB |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction records on Create Route Group page using data below:
      | trackingId                                | type                 | shipper                                 | address                                                    | status         |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | PICKUP Transaction   | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} | Pending Pickup |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | DELIVERY Transaction | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString}   | Pending Pickup |

  Scenario Outline: Operator Filter Granular Order Status on Create Route Group - Transaction Filters - <granularStatus> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                  |
      | v4OrderRequest    | { "service_type":"<serviceType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | <granularStatus>                  |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | granularOrderStatus | <granularStatus> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | <granularStatus>                                           |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | <granularStatus>                                         |
    Examples:
      | granularStatus                       | serviceType | hiptest-uid                              |
      | Arrived at Distribution Point        | Parcel      | uid:c30061fd-799c-4768-9d02-27600891f50d |
      | Arrived at Origin Hub                | Parcel      | uid:fb3817dd-c7c2-4ae9-ac27-78ae10a5dc99 |
      | Arrived at Sorting Hub               | Parcel      | uid:0fc6e89d-eeaf-4bca-b5b4-ea548affdeec |
      | Cross Border Transit                 | Parcel      | uid:b798a0b0-8d01-497d-853f-3cdf98733ab3 |
      | En-route to Sorting Hub              | Parcel      | uid:da90d5f4-0ee5-4cb3-bb2d-93e0d42b2b32 |
      | On Hold                              | Parcel      | uid:994c030d-acfc-4c0d-9cb8-c01f1533c4e2 |
      | On Vehicle for Delivery              | Parcel      | uid:bbf34aa3-1bca-4d5f-84c8-f2bae09c0365 |
      | Pending Pickup                       | Parcel      | uid:0528a079-eb73-4c63-a8d3-3c177772e569 |
      | Pending Pickup at Distribution Point | Parcel      | uid:f35f330a-96bb-4ca3-9ecc-99dbbe8f9b68 |
      | Pending Reschedule                   | Parcel      | uid:3b85490c-e3f4-453d-8ced-b2e65857bd4f |
      | Pickup fail                          | Return      | uid:c82bb52e-088d-43ef-81ee-cb8ab7d4ad99 |
      | Staging                              | Parcel      | uid:2ed012c6-d7a2-46e7-9ce9-256efe6d1c41 |
      | Transferred to 3PL                   | Parcel      | uid:e3b28ae3-5cc2-4a69-b5da-0c8a5f3c3a56 |
      | Van en-route to pickup               | Parcel      | uid:e5c5048d-2823-4521-a054-4b81033c1d72 |

  Scenario Outline: Operator Filter Parcel Size on Create Route Group - Transaction Filters - <parcelSize> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"dimensions":{"size":"<size>","volume":1.0,"weight":4.0},"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | parcelSize | <parcelSize> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
    Examples:
      | parcelSize  | size | hiptest-uid                              |
      | Bulky (XXL) | XXL  | uid:9a233818-0771-4c81-bbe4-0588cf30f7bc |
      | Extra Large | XL   | uid:2df4a63c-59d9-4885-805f-ec8d3c054c92 |
      | Large       | L    | uid:5cfd610b-b390-453c-8a62-ee4ae8856bc4 |
      | Medium      | M    | uid:f9a63c13-9da9-479c-9c7e-d089e64b9601 |
      | Small       | S    | uid:20988608-803f-4479-b50d-d928c4feefc8 |
      | Extra Small | XS   | uid:10a6796a-66e3-4801-a1d2-78684e848054 |

  Scenario Outline: Operator Filter Transaction Timeslot on Create Route Group - Transaction Filters - <timeslots> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | {"service_type":"Parcel","service_level":"Standard","parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}","pickup_timeslot":{"start_time":"12:00","end_time":"15:00"},"delivery_start_date":"{{next-1-day-yyyy-MM-dd}}","delivery_timeslot":{"start_time":"<startTime>","end_time":"<endTime>"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | timeslots | <timeslots> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
    Examples:
      | timeslots | startTime | endTime | hiptest-uid                              |
      | 12-3pm    | 12:00     | 15:00   | uid:ebdfe3a8-108d-437d-80d8-4833ddf6ca70 |
      | 3-6pm     | 15:00     | 18:00   | uid:9de49540-44bb-4764-a560-fd4379ae001e |
      | 6-10pm    | 18:00     | 22:00   | uid:f5ec2f7e-18c4-47dd-96ed-e85ae16997a1 |
      | 9-12pm    | 09:00     | 12:00   | uid:b34c1af0-64b0-4747-81fb-9b784b167741 |
      | Anytime   | 09:00     | 21:00   | uid:5a23b593-47cb-4867-bd09-0eb8c6d9ed91 |
      | Day       | 09:00     | 18:00   | uid:a408168d-f299-4366-a703-3e179b996d63 |
      | Night     | 18:00     | 22:00   | uid:90816330-9865-4f8c-9e22-5530c56e9668 |

  Scenario: Operator Filter Transaction Status on Create Route Group - Transaction Status = Cancelled - Transaction Filters (uid:b39eed67-342c-4738-a779-42437223eb82)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator cancel created order
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | transactionStatus | Cancelled |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |

  Scenario: Operator Filter Transaction Status on Create Route Group - Transaction Status = Fail - Transaction Filters (uid:30d2add1-35fd-4152-91cd-89696fa31a75)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | granularStatus | Pending Reschedule                |
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update order granular status:
      | orderId        | {KEY_LIST_OF_CREATED_ORDER_ID[2]} |
      | granularStatus | Pickup fail                       |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | transactionStatus | Fail |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Reschedule                                       |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[2].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[2].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[2].buildShortFromAddressString} |
      | status     | Pickup fail                                                |

  Scenario: Operator Filter Transaction Status on Create Route Group - Transaction Status = Success - Transaction Filters (uid:a9b5e800-f2fc-4f6d-9d05-45bc7931ca76)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator force succeed created order
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | transactionStatus | Success |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Completed                                                  |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Completed                                                |

  Scenario: Operator Filter Transaction Status on Create Route Group - Transaction Status = Pending - Transaction Filters (uid:4a5cc769-9638-471a-be6c-6a1b6eb5fdca)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | transactionStatus | Pending |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Transaction Status on Create Route Group - Transaction Status = Staging - Transaction Filters (uid:9a76e1ec-aec6-4c2f-a2a7-b76a6ba0f474)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","is_staged":true,"parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | transactionStatus | Staging |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Staging                                                    |
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Staging                                                  |

  Scenario Outline: Operator Filter PP/DD Leg Transaction on Create Route Group - Transaction Filters - <ppDdLeg> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard","parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | ppDdLeg | <ppDdLeg> |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} |
      | type       | <type> Transaction                        |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}   |
      | address    | <address>                                 |
      | status     | Pending Pickup                            |
    Examples:
      | ppDdLeg | type     | address                                                    | hiptest-uid                              |
      | PP      | PICKUP   | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} | uid:9aa3eb6d-560a-4c00-b625-c91a4377a2f9 |
      | DD      | DELIVERY | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString}   | uid:a11f812d-673d-4215-991b-db42b3e7daa1 |

  Scenario: Operator Filter Order Weight on Create Route Group - Transaction Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                                                                    |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "dimensions":{ "size":"S", "volume":1.0, "weight":4.0 }, "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | weight | == 4.0 |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Order Priority Level on Create Route Group - Transaction Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator update priority level of an order:
      | orderId       | {KEY_LIST_OF_CREATED_ORDER_ID[1]} |
      | priorityLevel | 58                                |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | priorityLevel | == 58 |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Order Zone on Create Route Group - Transaction Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | ZONE{zone-name-3}                                                                                                                                                                                                                                                                                                               |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | zone | {zone-full-name-3} |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  Scenario: Operator Filter Order DNR Group on Create Route Group - Transaction Filters
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Routing -> 1. Create Route Groups
    And Operator wait until 'Create Route Group' page is loaded
    And Operator removes all General Filters except following: "Creation Time, Shipper"
    And Operator add following filters on General Filters section on Create Route Group page:
      | Creation Time | Today                  |
      | Shipper       | {shipper-v4-legacy-id} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Group page
    Given Operator add following filters on Transactions Filters section on Create Route Group page:
      | dnrGroup | Normal |
    And Operator click Load Selection on Create Route Group page
    Then Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                  |
      | type       | PICKUP Transaction                                         |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                    |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortFromAddressString} |
      | status     | Pending Pickup                                             |
    And Operator verifies Transaction record on Create Route Group page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER[1].trackingId}                |
      | type       | DELIVERY Transaction                                     |
      | shipper    | {KEY_LIST_OF_CREATED_ORDER[1].fromName}                  |
      | address    | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} |
      | status     | Pending Pickup                                           |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op