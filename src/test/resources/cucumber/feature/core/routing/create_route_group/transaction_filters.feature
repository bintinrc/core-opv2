@OperatorV2 @Core @Routing @CreateRouteGroups
Feature: Create Route Groups

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

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op