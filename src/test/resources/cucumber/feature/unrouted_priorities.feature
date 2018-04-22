@OperatorV2 @UnroutedPriorities
Feature: Unrouted Priorities

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator V2
    Given op login into Operator V2 with username "{operator-portal-uid}" and password "{operator-portal-pwd}"

  Scenario: Order with delivery date is today should be listed on page Unrouted Priorities (uid:a0dc5a79-a32f-49b2-88e2-2c6cddcbf6ba)
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":0 } |
    Given API Operator get order details
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | {current-date-yyyy-MM-dd} |
    Then Operator verify order with delivery date is today should be listed on page Unrouted Priorities

  Scenario: Order with delivery date is next day should not be listed on page Unrouted Priorities (uid:08207375-a006-4b7b-8797-2142d5c47d83)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given API Operator get order details
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | {current-date-yyyy-MM-dd} |
    Then Operator verify order with delivery date is next day should not be listed on page Unrouted Priorities

  Scenario: Order with delivery date is next day should be listed on next 2 day route date on page Unrouted Priorities (uid:e5bf257b-1bf3-4ce8-8319-e48394aec56f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create Order V2 Parcel using data below:
      | generateFromAndTo | RANDOM |
      | v2OrderRequest    | { "type":"Normal", "delivery_date":"{{cur_date}}", "pickup_date":"{{cur_date}}", "pickup_reach_by":"{{cur_date}} 15:00:00", "delivery_reach_by":"{{cur_date}} 17:00:00", "weekend":true, "pickup_timewindow_id":1, "delivery_timewindow_id":2, "max_delivery_days":1 } |
    Given API Operator get order details
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | {next-2-date-yyyy-MM-dd} |
    Then Operator verify order with delivery date is next day should be listed on next 2 days route date on page Unrouted Priorities

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
