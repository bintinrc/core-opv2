@OperatorV2 @OperatorV2Part1 @DpTagging @DP
Feature: DP Tagging

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: DP Tagging - Invalid CSV (uid:975339a9-7c0b-4ec8-b815-3c2aa9c87bc5)
    Given Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator uploads invalid DP Tagging CSV
    Then Operator verify invalid DP Tagging CSV is not uploaded successfully

  Scenario: DP Tagging - Tag Single Order to DP (uid:6ff4e22e-fb5b-41cd-adf4-c650fc773a40)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator tags single order to DP with DPMS ID = "{opv2-dp-dpms-id}"
    Then API Operator verify order info after Operator assign delivery waypoint of an order to DP

  Scenario: DP Tagging - Tag Single Return Order to DP (uid:6c443877-7e89-4548-a3c1-14183c6fa16b)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator tags single order to DP with DPMS ID = "{opv2-dp-dpms-id}"
    Then API Operator verify order info after Operator assign delivery waypoint of an order to DP

  Scenario: DP Tagging - Tag Multiple Orders to DP (uid:ada9a598-22ad-42d5-8260-541b6c5e35bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
      Then Operator wait for DP tagging page to load
      When Operator tags multiple orders to DP with DPMS ID = "{opv2-dp-dpms-id}"
      Then API Operator verify multiple orders info after Operator assign delivery waypoint of the orders to the same DP

  Scenario: DP Tagging - Unassign Single Normal Order from DP (uid:9df35d69-140a-42c2-82b2-a0881ce4d8b3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Normal", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator tags single order to DP with DPMS ID = "{opv2-dp-dpms-id}"
    And Operator untags created orders from DP with DPMS ID = "{opv2-dp-dpms-id}" on DP Tagging page
    Then Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |

  Scenario: DP Tagging - Unassign Single Return Order from DP (uid:1e3f4652-47d4-47fc-bcd7-c2bd0530fc93)
    Given Operator go to menu Shipper Support -> Blocked Dates
    And API Shipper create V4 order using data below:
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                     |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                 |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                          |
      | v4OrderRequest      | { "service_type":"Return", "service_level":"Standard", "parcel_job":{ "is_pickup_required":true, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    When Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator tags single order to DP with DPMS ID = "{opv2-dp-dpms-id}"
    And Operator untags created orders from DP with DPMS ID = "{opv2-dp-dpms-id}" on DP Tagging page
    Then Operator go to menu Order -> All Orders
    And Operator open page of the created order from All Orders page
    And Operator verify order event on Edit order page using data below:
      | name | UNASSIGNED FROM DP |

  Scenario: DP Tagging - Unassign Multiple Orders from DP (uid:c8013813-5a4e-4a6f-8bca-03f60d992f92)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create multiple V4 orders using data below:
      | numberOfOrder       | 3                                                                                                                                                                                                                                                                                                                                |
      | shipperClientId     | {opv2-dp-shipper-client-id}                                                                                                                                                                                                                                                                                                      |
      | shipperClientSecret | {opv2-dp-shipper-client-secret}                                                                                                                                                                                                                                                                                                  |
      | generateFromAndTo   | RANDOM                                                                                                                                                                                                                                                                                                                           |
      | v4OrderRequest      | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator tags multiple orders to DP with DPMS ID = "{opv2-dp-dpms-id}"
    And Operator untags created orders from DP with DPMS ID = "{opv2-dp-dpms-id}" on DP Tagging page
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

  Scenario: DP Tagging - Download DP tagging sample
    Given Operator go to menu Distribution Points -> DP Tagging
    Then Operator wait for DP tagging page to load
    When Operator click on Download Button for Sample CSV File of DP tagging
    Then sample CSV file on DP Tagging page is downloaded successfully

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op