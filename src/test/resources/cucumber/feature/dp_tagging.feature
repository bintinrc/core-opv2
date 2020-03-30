@OperatorV2 @OperatorV2Part1 @DpTagging
Feature: DP Tagging

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator verify invalid DP Tagging CSV is not uploaded successfully (uid:754b9a0d-67c0-4012-bb7a-ec786e24bed3)
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator uploads invalid DP Tagging CSV
    Then Operator verify invalid DP Tagging CSV is not uploaded successfully

  Scenario Outline: Operator tagged single order to DP (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
    Then API Operator verify order info after Operator assign delivery waypoint of an order to DP
    Examples:
      | Note   | hiptest-uid                              | orderType | isPickupRequired |
      | Normal | uid:c798aa53-3cab-4d3b-80e8-23849cfda6c5 | Normal    | false            |
      | Return | uid:c9fcc03b-99cc-41ee-91d0-ae2e46e74774 | Return    | true             |

  Scenario: Operator tagged multiple order to DP (uid:d3342895-66f9-4e9e-bfb7-7bc369d94b55)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags multiple orders to DP with DPMS ID = "{dpms-id}"
    Then API Operator verify multiple orders info after Operator assign delivery waypoint of the orders to the same DP

  Scenario Outline: Operator untag single order from DP
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                                             |
      | v4OrderRequest    | { "service_type":"<orderType>", "service_level":"Standard", "parcel_job":{ "is_pickup_required":<isPickupRequired>, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Distribution Points -> DP Tagging
    When Operator tags single order to DP with DPMS ID = "{dpms-id}"
    And Operator untags created orders from DP with DPMS ID = "{dpms-id}" on DP Tagging page
    Then Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    Examples:
      | Note   | hiptest-uid | orderType | isPickupRequired |
      | Normal | uid:        | Normal    | false            |
      | Return | uid:        | Return    | true             |

  Scenario: Operator untag multiple order from DP
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder     | 3                                                                                                                                                                                                                                                                                                                                |
      | generateFromAndTo | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    When Operator tags multiple orders to DP with DPMS ID = "{dpms-id}"
    And Operator untags created orders from DP with DPMS ID = "{dpms-id}" on DP Tagging page
    Then Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[1]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[1]}          |
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    Then Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[2]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[2]}          |
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |
    Then Operator go to menu Order -> All Orders
    And Operator open page of an order from All Orders page using data below:
      | trackingId | {KEY_LIST_OF_CREATED_ORDER_TRACKING_ID[3]} |
      | orderId    | {KEY_LIST_OF_CREATED_ORDER_ID[3]}          |
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op