@OperatorV2 @Fleet @OperatorV2Part1 @DriverTypeManagement @Saas
Feature: Driver Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Download CSV File of Driver Type (uid:76f6ba04-4f9c-46f7-b450-8b73f67a7b7b)
    Given Operator go to menu Fleet -> Driver Type Management
    When Operator get all Driver Type params on Driver Type Management page
    When Operator click on Download CSV File button on Driver Type Management page
    Then Downloaded CSV file contains correct Driver Types data

  @DeleteDriverType
  Scenario: Create New Driver Type (uid:eaa1b45c-725f-4ec3-9383-99fa808f887a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Driver Type Management
    Given Operator create new Driver Type with the following attributes:
      | driverTypeName  | GENERATED           |
      | deliveryType    | Normal Delivery     |
      | priorityLevel   | Priority            |
      | reservationSize | Less Than 3 Parcels |
      | parcelSize      | Small               |
      | timeslot        | 9AM To 6PM          |
    And Operator get new Driver Type params on Driver Type Management page
    Then Operator verify new Driver Type params

  @DeleteDriverType
  Scenario: Update Driver Type (uid:d47cf8da-5c64-4771-ad90-0ceed2f4bac0)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Driver Type Management
    Given Operator create new Driver Type with the following attributes:
      | driverTypeName  | GENERATED           |
      | deliveryType    | Normal Delivery     |
      | priorityLevel   | Priority            |
      | reservationSize | Less Than 3 Parcels |
      | parcelSize      | Small               |
      | timeslot        | 9AM To 6PM          |
    Given Operator get new Driver Type params on Driver Type Management page
    When Operator edit new Driver Type with the following attributes:
      | driverTypeName  | GENERATED            |
      | deliveryType    | C2C + Return Pick Up |
      | priorityLevel   | Non-Priority         |
      | reservationSize | Less Than 10 Parcels |
      | parcelSize      | Medium               |
      | timeslot        | 9AM To 10PM          |
    Then Operator verify new Driver Type params

  @DeleteDriverType
  Scenario: Delete Driver Type That Is Not Being Used by Driver (uid:693eafa6-09c6-4a38-9a84-043c5afed854)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Driver Type Management
    Given Operator create new Driver Type with the following attributes:
      | driverTypeName | GENERATED |
    Given Operator get new Driver Type params on Driver Type Management page
    When Operator delete new Driver Type on on Driver Type Management page
    Then Operator verify new Driver Type is deleted successfully

  @DeleteDriverType
  Scenario Outline: Operator should be able to filter by '<value>' on Driver Type Management page (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Driver Type Management
    Given Operator create new Driver Type with the following attributes:
      | driverTypeName | GENERATED |
      | <param>        | <value>   |
    And Operator get new Driver Type params on Driver Type Management page
    When Operator configure filter on Driver Type Management page with the following attributes:
      | <param> | <value> |
    Then Operator verify filter results on Driver Type Management page
    Examples:
      | Note                                  | hiptest-uid                              | param           | value                |
      | deliveryType: Normal Delivery         | uid:f9b37dac-8d1f-41f7-be76-8d25444dda91 | deliveryType    | Normal Delivery      |
      | deliveryType: C2C + Return Pick Up    | uid:ec607fad-a709-4662-b3c1-428fc245a774 | deliveryType    | C2C + Return Pick Up |
      | deliveryType: Reservation Pick Up     | uid:c49805f4-f82f-4738-83a5-2f5d3b483e17 | deliveryType    | Reservation Pick Up  |
      | priorityLevel: Priority               | uid:f91f40e6-354f-49ff-a3b0-e552a17d6b6c | priorityLevel   | Priority             |
      | priorityLevel: Non-Priority           | uid:f39ec62a-d5c1-45a3-80ac-d4c9c7dcca5c | priorityLevel   | Non-Priority         |
      | reservationSize: Less Than 3 Parcels  | uid:e7ee4097-6b56-408f-acfb-ace79cba492a | reservationSize | Less Than 3 Parcels  |
      | reservationSize: Less Than 10 Parcels | uid:a68160bf-d8d6-4ea6-af89-b76aab131124 | reservationSize | Less Than 10 Parcels |
      | reservationSize: Trolley Required     | uid:1dda72e6-9ca0-4c57-87c7-8d493512a3dc | reservationSize | Trolley Required     |
      | reservationSize: Half Van Load        | uid:910dcf45-5361-43eb-9e09-9e57e8b5aca2 | reservationSize | Half Van Load        |
      | reservationSize: Full Van Load        | uid:1c8f4fcd-be2b-4da1-9a8e-3b671b301cb1 | reservationSize | Full Van Load        |
      | reservationSize: Larger Than Van Load | uid:eb53b254-a2df-4513-a877-1b80267161dc | reservationSize | Larger Than Van Load |
      | parcelSize: Small                     | uid:590e63b3-7b7c-4abd-b66a-4c9ff7ec0b86 | parcelSize      | Small                |
      | parcelSize: Medium                    | uid:6bb0673d-8c66-4efa-98f0-cac222adb250 | parcelSize      | Medium               |
      | parcelSize: Large                     | uid:089b4ea6-3cfb-43e4-8fbd-13d853cfacf5 | parcelSize      | Large                |
      | parcelSize: Extra Large               | uid:c060d91d-2551-4ac8-9512-0f70794b1d59 | parcelSize      | Extra Large          |
      | timeslot: 9AM To 6PM                  | uid:2c827a3b-4ef4-4a28-8ac7-31302269eb17 | timeslot        | 9AM To 6PM           |
      | timeslot: 9AM To 10PM                 | uid:791bc6fd-e689-4bbd-807c-31936acf7f55 | timeslot        | 9AM To 10PM          |
      | timeslot: 9AM To 12PM                 | uid:7bf849c2-86be-48db-93ec-ef8bfba824e5 | timeslot        | 9AM To 12PM          |
      | timeslot: 12PM To 3PM                 | uid:2b0d5790-9d3f-492f-955f-cee9b22f9879 | timeslot        | 12PM To 3PM          |
      | timeslot: 3PM To 6PM                  | uid:08e3f316-04a9-4aae-b55f-94eb86aa719f | timeslot        | 3PM To 6PM           |
      | timeslot: 6PM To 10PM                 | uid:5ceba73a-806b-4115-824f-01345fec3ed9 | timeslot        | 6PM To 10PM          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
