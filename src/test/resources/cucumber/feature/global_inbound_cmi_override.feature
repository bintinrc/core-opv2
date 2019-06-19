@OperatorV2 @OperatorV2Part1 @GlobalInboundCmiOverride
Feature: Global Inbound CMI Override

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Operator Global Inbound CMI Override an order with different Priority Level (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu New Features -> Global Inbound CMI Override
    Given API Shipper create V4 order using data below:
      | generateFromAndTo | RANDOM |
      | v4OrderRequest    | { "service_type":"Parcel", "service_level":"Standard", "parcel_job":{ "is_pickup_required":false, "pickup_date":"{{next-1-day-yyyy-MM-dd}}", "pickup_timeslot":{ "start_time":"12:00", "end_time":"15:00"}, "delivery_start_date":"{{next-1-day-yyyy-MM-dd}}", "delivery_timeslot":{ "start_time":"09:00", "end_time":"22:00"}}} |
    Given API Operator update priority level of an order to = "<priorityLevel>"
    When Operator global inbounds parcel using data below:
      | hubName    | {hub-name}             |
      | trackingId | GET_FROM_CREATED_ORDER |
    Then API Operator verify order info after Global Inbound
    Then Operator verifies priority level info is correct using data below:
      | priorityLevel           | <priorityLevel>           |
      | priorityLevelColorAsHex | <priorityLevelColorAsHex> |
    Examples:
      | Note         | hiptest-uid                              | priorityLevel | priorityLevelColorAsHex |
      | Level 0      | uid:24a430c9-a7d9-489c-8a0f-bd412ad14151 | 0             | #e8e8e8                 |
      | Level 1      | uid:811ceb47-d042-4abf-961c-ebe2f3da1603 | 1             | #ffff00                 |
      | Level 2 - 90 | uid:d8129d0a-aaf1-43be-850c-fe180606d753 | 42            | #ffa500                 |
      | Level > 90   | uid:6bff6c9b-9664-45ec-89a8-ab3defa547bb | 91            | #ff0000                 |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
