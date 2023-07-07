@OperatorV2 @Core @Routing @RoutingJob4 @CreateRouteGroups @TransactionFiltersPart4 @CRG7
Feature: Create Route Groups - Transaction Filters

  Background:
    Given Launch browser
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Marketplace International
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
      | generateTo     | RANDOM           |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type              | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
      | Marketplace International | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace International","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": false,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Marketplace
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | hiptest-uid                              |
      | Market Place | Pending Pickup | DELIVERY Transaction | {"service_type": "Marketplace","service_level": "Standard","from": {"name": "binti v4.1","phone_number": "+65189189","email": "binti@test.co","address": {"address1": "Orchard Road central","address2": "","country": "SG","postcode": "511200","latitude": 1.3248209,"longitude": 103.6983167}},"to": {"name": "George Ezra","phone_number": "+65189178","email": "ezra@g.ent","address": {"address1": "999 Toa Payoh North","address2": "","country": "SG","postcode": "318993"}},"parcel_job": {"experimental_from_international": false,"experimental_to_international": false,"is_pickup_required": true,"pickup_date": "{{next-1-day-yyyy-MM-dd}}","pickup_service_type": "Scheduled","pickup_service_level": "Standard","pickup_timeslot": {"start_time": "09:00","end_time": "12:00","timezone": "Asia/Singapore"},"pickup_address_id": "add08","pickup_instruction": "Please be careful with the v-day flowers.","delivery_start_date": "{{next-1-day-yyyy-MM-dd}}","delivery_timeslot": {"start_time": "09:00","end_time": "22:00","timezone": "Asia/Singapore"},"delivery_instruction": "Please be careful with the v-day flowers.","dimensions": {"weight": 100}},"marketplace": {"seller_id": "seller-ABCnew01","seller_company_name": "ABC Shop"}} | uid:3f17fe40-7fb8-44f5-ae5e-86639de78feb |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Document
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | Shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                     |
      | Document     | Pending Pickup | DELIVERY Transaction | { "service_type":"Document", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - Ninja Pack
    Given Operator go to menu Utilities -> QRCode Printing
    And API Operator generate 2 Ninja Pack Tracking Id
    And API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 1                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
    Examples:
      | service_type | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                                                                                                 |
      | Ninja Pack   | Pending Pickup | DELIVERY Transaction | { "requested_tracking_number":"{KEY_NINJA_PACK_TRACKING_LIST[1].trackingId}","service_type":"Ninja Pack","service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - International
    Given Operator go to menu Utilities -> QRCode Printing
    And API Shipper set Shipper V4 using data below:
      | shipperV4ClientId     | {shipper-v4-marketplace-client-id}     |
      | shipperV4ClientSecret | {shipper-v4-marketplace-client-secret} |
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder  | 2                |
      | v4OrderRequest | <v4OrderRequest> |
      | addressType    | global           |
      | generateTo     | RANDOM           |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | service_type  | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                        |
      | International | Pending Pickup | DELIVERY Transaction | { "service_type":"International", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}, "international":{"portation":"import"}} |

  Scenario Outline: Operator Filter Order by Service Type on Create Route Groups Page - Transaction Filters - <Note>
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 2                |
      | generateFromAndTo | RANDOM           |
      | v4OrderRequest    | <v4OrderRequest> |
    When Operator go to menu Routing -> 1. Create Route Groups
    Then Create Route Groups page is loaded
    And Operator set General Filters on Create Route Groups page:
      | creationTimeFrom | {gradle-next-0-day-yyyy-MM-dd} |
      | creationTimeTo   | {gradle-next-1-day-yyyy-MM-dd} |
      | Shipper          | {filter-shipper-name}          |
    And Operator choose "Include Transactions" on Transaction Filters section on Create Route Groups page
    And Operator add following filters on Transactions Filters section on Create Route Groups page:
      | orderServiceType | <service_type> |
    And Operator click Load Selection on Create Route Groups page
    Then Operator verifies Transaction records on Create Route Groups page using data below:
      | trackingId                                | type   | shipper                                 | address                                                  | status   |
      | {KEY_LIST_OF_CREATED_ORDER[1].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[1].fromName} | {KEY_LIST_OF_CREATED_ORDER[1].buildShortToAddressString} | <status> |
      | {KEY_LIST_OF_CREATED_ORDER[2].trackingId} | <type> | {KEY_LIST_OF_CREATED_ORDER[2].fromName} | {KEY_LIST_OF_CREATED_ORDER[2].buildShortToAddressString} | <status> |
    Examples:
      | Note   | service_type    | status         | type                 | v4OrderRequest                                                                                                                                                                                                                                                                                                                   |
      | Parcel | Parcel Delivery | Pending Pickup | DELIVERY Transaction | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
      | Return | Return          | Pending Pickup | DELIVERY Transaction | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}}  |
