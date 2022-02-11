@OperatorV2 @Core @Addressing @UnverifiedAddressAssignment
Feature: Unverified Address Assignment

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddress
  Scenario: Operator Load Unverified Address Assignment (uid:07a27fb1-9e2e-4c0d-bc4f-eafb434145ba)
    Given API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | CREATED_ADDRESS                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Addressing -> Unverified Address Assignment
    And Operator clicks Load Selection on Unverified Address Assignment page
    Then Operator verifies address on Unverified Address Assignment page:
      | score   | 1.0                                              |
      | address | {KEY_CREATED_ORDER.buildCommaSeparatedToAddress} |

  @DeleteAddress
  Scenario: Operator Assign a Zone to an Unverified Address Successfully (uid:2bf09de6-73bb-42b5-b052-69be8aca67dc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Operator create new shipper address V2 using data below:
      | shipperId       | {shipper-v4-id} |
      | generateAddress | RANDOM          |
    And API Shipper create V4 order using data below:
      | generateFrom   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | generateTo     | CREATED_ADDRESS                                                                                                                                                                                                                                                                                                                 |
      | v4OrderRequest | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{"is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    And API Operator get order details
    And DB Operator unarchive Jaro Scores of Delivery Transaction waypoint of created order
    When Operator go to menu Addressing -> Unverified Address Assignment
    And Operator clicks Load Selection on Unverified Address Assignment page
    And Operator assign address "{KEY_CREATED_ORDER.buildCommaSeparatedToAddress}" to zone "{zone-name}" on Unverified Address Assignment page
    Then Operator verifies that success toast displayed:
      | top                | 1 Addresses Assigned |
      | waitUntilInvisible | true                 |
    When Operator open Edit Order page for order ID "{KEY_CREATED_ORDER_ID}"
    Then Operator verifies Zone is "{zone-short-name}" on Edit Order page
    When DB operator gets details for delivery transactions by order id
    And DB operator gets details for delivery waypoint
    Then Operator verifies waypoint details:
      | routingZoneId | {zone-id} |
    And DB Operator verify Jaro Scores of Delivery Transaction waypoint of created order:
      | archived |
      | 0        |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op