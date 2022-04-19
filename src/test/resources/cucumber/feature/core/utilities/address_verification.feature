@OperatorV2 @Core @Utilities @AddressVerification
Feature: Address Verification

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteRouteGroups
  Scenario Outline: Operator Fetch Addresses By Route Groups on Address Verification Page - <Note> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of <transactionType> Transaction waypoint of created order
    When Operator go to menu Utilities -> Address Verification
    And Address Verification page is loaded
    And Operator clicks on 'Verify Address' tab on Address Verification page
    And Operator fetch addresses by "{KEY_CREATED_ROUTE_GROUP.name}" route group on Address Verification page
    Then Operator verify fetched addresses are displayed on Address Verification page:
      | {KEY_CREATED_ORDER.<address>} |
    Examples:
      | Note                     | hiptest-uid                              | orderType | isPickupRequired | transactionType | address                                |
      | Normal Delivery Waypoint | uid:de43e1c6-8686-438b-bbb2-319f7aca6cbe | Parcel    | false            | Delivery        | buildShortToAddressWithCountryString   |
      | Return Pickup Waypoint   | uid:360840cc-2d74-4945-9bfb-03d291df5cf3 | Return    | true             | Pickup          | buildShortFromAddressWithCountryString |

  @DeleteRouteGroups
  Scenario: Operator Archive Address By Route Groups on Address Verification Page (uid:92b022ea-5a46-4380-83e9-f56f01d02c35)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Utilities -> Address Verification
    And Address Verification page is loaded
    And Operator clicks on 'Verify Address' tab on Address Verification page
    And Operator fetch addresses by "{KEY_CREATED_ROUTE_GROUP.name}" route group on Address Verification page
    Then Operator verify fetched addresses are displayed on Address Verification page:
      | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString} |
    When Operator archives 1 address on Address Verification page
    Then Operator verifies that "Success archive address" success notification is displayed
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived

  @DeleteRouteGroups
  Scenario: Operator Edit Waypoint Lat/Long By Route Groups on Address Verification Page (uid:fac2c989-56ed-43d0-b333-a56cff5b3f4a)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Utilities -> Address Verification
    And Address Verification page is loaded
    And Operator clicks on 'Verify Address' tab on Address Verification page
    And Operator fetch addresses by "{KEY_CREATED_ROUTE_GROUP.name}" route group on Address Verification page
    Then Operator verify fetched addresses are displayed on Address Verification page:
      | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString} |
    When Operator clicks on 'Edit' button for 1 address on Address Verification page
    And Operator fills address parameters in Edit Address modal on Address Verification page:
      | latitude  | GENERATED |
      | longitude | GENERATED |
    And Operator clicks 'Save' button in Edit Address modal on Address Verification page:
    Then Operator verifies that "Address event created" success notification is displayed
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |

  @DeleteRouteGroups
  Scenario: Operator Save Address on Address Verification Page (uid:0a7847d4-9c68-4954-95e8-baaad8d893d5)
    Given Operator go to menu Utilities -> QRCode Printing
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator create new Route Group:
      | name        | ARG-{gradle-current-date-yyyyMMddHHmmsss}                                                                    |
      | description | This Route Group is created by automation test from Operator V2. Created at {gradle-current-date-yyyy-MM-dd} |
    And API Operator add transactions to "{KEY_CREATED_ROUTE_GROUP.id}" Route Group:
      | trackingId                                 | type     |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | DELIVERY |
      | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} | PICKUP   |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Utilities -> Address Verification
    And Address Verification page is loaded
    And Operator clicks on 'Verify Address' tab on Address Verification page
    And Operator fetch addresses by "{KEY_CREATED_ROUTE_GROUP.name}" route group on Address Verification page
    Then Operator verify fetched addresses are displayed on Address Verification page:
      | {KEY_CREATED_ORDER.buildShortToAddressWithCountryString} |
    When Operator save 1 address on Address Verification page
    Then Operator verifies that "Address event created" success notification is displayed
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order are archived
    When Operator open Edit Order page for order ID "{KEY_LIST_OF_CREATED_ORDER_ID[1]}"
    Then Operator verify order event on Edit order page using data below:
      | name | VERIFY ADDRESS |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op