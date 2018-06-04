@OperatorV2 @DriverTypeManagement
Feature: Driver Type Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator should be able to download CSV file on Driver Type Management page (uid:24c3e041-cf3a-4182-93a1-4b35320ab144)
    Given Operator go to menu Fleet -> Driver Type Management
    When Operator get all Driver Type params on Driver Type Management page
    When Operator click on Download CSV File button on Driver Type Management page
    Then Downloaded CSV file contains correct Driver Types data

  @DeleteDriverType
  Scenario: Operator should be able to create a new Driver Type on Driver Type Management page (uid:1aff8024-0653-4a8d-8e3b-a662913bd5ee)
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
  Scenario: Operator should be able to update a Driver Type on Driver Type Management page (uid:9638882f-eed5-4303-a422-2ee998e4cab9)
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
  Scenario: Operator should be able to delete a Driver Type on Driver Type Management page (uid:2288beb7-e076-41ea-a5bb-51d07956beb0)
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
      | deliveryType: Normal Delivery         | uid:ddc38972-2cd5-4ead-9f1b-e871c1060fee | deliveryType    | Normal Delivery      |
      | deliveryType: C2C + Return Pick Up    | uid:eb311074-6ee1-4e3b-b243-b17afb2b9c30 | deliveryType    | C2C + Return Pick Up |
      | deliveryType: Reservation Pick Up     | uid:f22d171c-4f0c-43e9-989a-b8586a68fe39 | deliveryType    | Reservation Pick Up  |
      | priorityLevel: Priority               | uid:f622fc14-bfd5-4e34-bce1-5d25c0df6ab5 | priorityLevel   | Priority             |
      | priorityLevel: Non-Priority           | uid:6b2d25f1-b065-4931-902c-02ba3471a98b | priorityLevel   | Non-Priority         |
      | reservationSize: Less Than 3 Parcels  | uid:a95b5461-c876-42eb-9162-72b6a5093826 | reservationSize | Less Than 3 Parcels  |
      | reservationSize: Less Than 10 Parcels | uid:9d7fc7d8-2fdd-4fb7-bf13-e9a8c51bfdb2 | reservationSize | Less Than 10 Parcels |
      | reservationSize: Trolley Required     | uid:1418577e-f5dc-4990-889b-4b68cb3ebce2 | reservationSize | Trolley Required     |
      | reservationSize: Half Van Load        | uid:c915829c-7957-42da-ae1c-8b82dce313e5 | reservationSize | Half Van Load        |
      | reservationSize: Full Van Load        | uid:b4db25d5-d4d8-4eb8-94dd-781f5f48e49c | reservationSize | Full Van Load        |
      | reservationSize: Larger Than Van Load | uid:94e2bbf9-4a80-45e2-9f98-c4245c0a94b8 | reservationSize | Larger Than Van Load |
      | parcelSize: Small                     | uid:edba8c29-1ae6-4c4f-a0cc-0d57080ab402 | parcelSize      | Small                |
      | parcelSize: Medium                    | uid:17259475-2e26-4456-a2c5-4edb4b8cb1cf | parcelSize      | Medium               |
      | parcelSize: Large                     | uid:d44dad43-2e46-4554-8862-b346428e0413 | parcelSize      | Large                |
      | parcelSize: Extra Large               | uid:782cd9d5-08bb-4a3b-85a8-c7b643f8e487 | parcelSize      | Extra Large          |
      | timeslot: 9AM To 6PM                  | uid:cd65b713-c0dd-49ea-b2b0-3ab9295380a8 | timeslot        | 9AM To 6PM           |
      | timeslot: 9AM To 10PM                 | uid:64e40eaa-a676-4049-bc1c-c1e7ea206f59 | timeslot        | 9AM To 10PM          |
      | timeslot: 9AM To 12PM                 | uid:ac66a89d-d30a-440b-bced-b9ff388a00d5 | timeslot        | 9AM To 12PM          |
      | timeslot: 12PM To 3PM                 | uid:4aa95dfa-37d1-4206-b867-fe6d512d2d78 | timeslot        | 12PM To 3PM          |
      | timeslot: 3PM To 6PM                  | uid:0c3a580d-ce1d-4592-b836-145780ac9828 | timeslot        | 3PM To 6PM           |
      | timeslot: 6PM To 10PM                 | uid:6b7caf52-9b9d-4464-8eb0-a9f12f543805 | timeslot        | 6PM To 10PM          |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
