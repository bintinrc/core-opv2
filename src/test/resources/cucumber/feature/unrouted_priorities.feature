@OperatorV2Disabled @OperatorV2Part1Disabled @UnroutedPriorities @Saas
Feature: Unrouted Priorities

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Order with delivery date is today should be listed on page Unrouted Priorities (uid:a0dc5a79-a32f-49b2-88e2-2c6cddcbf6ba)
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Sameday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | GET_FROM_ORDER_DELIVERY_END_TIME_TRANSACTION |
    Then Operator verify order with delivery date is today should be listed on page Unrouted Priorities

  Scenario: Order with delivery date is next day should not be listed on page Unrouted Priorities (uid:08207375-a006-4b7b-8797-2142d5c47d83)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | {gradle-current-date-yyyy-MM-dd} |
    Then Operator verify order with delivery date is next day should not be listed on page Unrouted Priorities

  Scenario: Order with delivery date is next day should be listed on next 2 day route date on page Unrouted Priorities (uid:e5bf257b-1bf3-4ce8-8319-e48394aec56f)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Nextday", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given Operator go to menu Analytics -> Unrouted Priorities
    When Operator select filter and click Load Selection on page Unrouted Priorities using data below:
      | routeDate | GET_FROM_ORDER_DELIVERY_END_TIME_TRANSACTION |
    Then Operator verify order with delivery date is next day should be listed on next 2 days route date on page Unrouted Priorities

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
