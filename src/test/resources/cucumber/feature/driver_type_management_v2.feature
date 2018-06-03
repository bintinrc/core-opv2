@OperatorV2 @DriverTypeManagementV2
Feature: Driver Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to download CSV file on Driver Type Management page
    Given Operator go to menu Fleet -> Driver Type Management
    When Operator get all Driver Type params on Driver Type Management page
    When Operator click on Download CSV File button on Driver Type Management page
    Then Downloaded CSV file contains correct Driver Types data

  @DeleteDriverType
  Scenario: Operator should be able to create a new Driver Type on Driver Type Management page
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
  Scenario: Operator should be able to update a Driver Type on Driver Type Management page
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
  Scenario: Operator should be able to delete a Driver Type on Driver Type Management page
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Fleet -> Driver Type Management
    Given Operator create new Driver Type with the following attributes:
      | driverTypeName | GENERATED |
    Given Operator get new Driver Type params on Driver Type Management page
    When Operator delete new Driver Type on on Driver Type Management page
    Then Operator verify new Driver Type is deleted successfully

  @DeleteDriverType
  Scenario Outline: Operator should be able to filter by '<value>' on Driver Type Management page
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
      | param           | value                |
      | deliveryType    | Normal Delivery      |
      | deliveryType    | C2C + Return Pick Up |
      | deliveryType    | Reservation Pick Up  |
      | priorityLevel   | Priority             |
      | priorityLevel   | Non-Priority         |
      | reservationSize | Less Than 3 Parcels  |
      | reservationSize | Less Than 10 Parcels |
      | reservationSize | Trolley Required     |
      | reservationSize | Half Van Load        |
      | reservationSize | Full Van Load        |
      | reservationSize | Larger Than Van Load |
      | parcelSize      | Small                |
      | parcelSize      | Medium               |
      | parcelSize      | Large                |
      | parcelSize      | Extra Large          |
      | timeslot        | 9AM To 6PM           |
      | timeslot        | 9AM To 10PM          |
      | timeslot        | 9AM To 12PM          |
      | timeslot        | 12PM To 3PM          |
      | timeslot        | 3PM To 6PM           |
      | timeslot        | 6PM To 10PM          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
