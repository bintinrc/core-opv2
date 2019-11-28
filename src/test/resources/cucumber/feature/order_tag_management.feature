@OperatorV2 @OperatorV2Part2 @OrderTagManagement @ShouldAlwaysRun
Feature: Order Tag Management

  @LaunchBrowser
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Add Tags to Order (uid:91100421-447c-4e9b-8ac0-b4614dff8ddd)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    And DB Operator verify order_events record for the created order:
      | type | 48 |

  Scenario: Remove Tags from Order (uid:17d845d9-5acf-45d7-bba8-4ecd55d295c1)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator remove order tags:
      | OPV2AUTO1   |
      | OPV2AUTO2   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO3   |
    And DB Operator verify order_events record for the created order:
      | type | 48 |

  Scenario: Update Tags from Order (uid:7a99d8b5-6b5b-4b3f-bce0-e32017a328f9)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO1   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1   |
    Given Operator go to menu Order -> Order Tag Management
    When Operator selects filter and clicks Load Selection on Add Tags to Order page using data below:
      | shipperName     | {shipper-v4-legacy-id}-{shipper-v4-name} |
      | status          | Pending                                  |
      | granular status | Pending Pickup                           |
    And Operator searches and selects orders created on Add Tags to Order page
    And Operator tags order with:
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    Then Operator verify the tags shown on Edit Order page
      | OPV2AUTO1   |
      | OPV2AUTO2   |
      | OPV2AUTO3   |
    And DB Operator verify order_events record for the created order:
      | type | 48 |

  @KillBrowser
  Scenario: Kill Browser
    Given no-op
