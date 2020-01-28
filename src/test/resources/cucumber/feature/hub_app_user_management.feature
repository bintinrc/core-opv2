@HubAppUserManagement @Shipment @MiddleMile @ForceNotHeadless
Feature: Hub App User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteHubAppUser
  Scenario: Create Hub User (uid:092570b2-3381-4202-80ec-c4d0c98b5d48)
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | JKB | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown

  Scenario: Create Hub User - Duplicated username (uid:53650108-32ff-4775-98a7-1097b5713075)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    Given DB Operator gets the newest existed username for Hub App
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username   | password | employmentType | employmentStartDate | hub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | DUPLICATED | password | FULL_TIME      | TODAY               | JKB | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be a duplication error toast shown

  Scenario Outline: Create Hub User - Invalid Request - <scenarioName>
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with negative scenarios using details:
      | firstName   | lastName   | contact        | username   | password   | employmentType   | employmentStartDate   | hub   | warehouseTeamFormation | position   | comments                                                             |
      | <firstName> | Automation | qa@ninjavan.co | <username> | <password> | <employmentType> | <employmentStartDate> | <hub> | Middle Mile Team       | <position> | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be UI error of empty field of "<errorMessage>" shown
      Examples:
        | scenarioName                   | errorMessage                      | firstName  | username    | password | employmentType | employmentStartDate | hub | position | hiptest-uid                              |
        | First Name Is Empty            | Please fill First Name            |            | RANDOM      | password | FULL_TIME      | TODAY               | JKB | QAE      | uid:57dad002-b329-4924-a4e7-aa72b12b2bde |
        | Username Is Empty              | Please fill Username              | QA         |             | password | FULL_TIME      | TODAY               | JKB | QAE      | uid:503d1caf-5d89-426b-bcee-1eaf47ca5550 |
        | Password Is Empty              | Please fill Password              | QA         | RANDOM      |          | FULL_TIME      | TODAY               | JKB | QAE      | uid:af7fcfae-fdc1-420d-aea1-a0c17b16bdfb |
        | Employment Type Is Empty       | Please fill Employment Type       | QA         | RANDOM      | password |                | TODAY               | JKB | QAE      | uid:4e743af2-95b3-4a34-9a39-98e3204ea751 |
        | Employment Start Date Is Empty | Please fill Employment Start Date | QA         | RANDOM      | password | FULL_TIME      |                     | JKB | QAE      | uid:fff33da7-b469-4132-ab1b-ba1abe540ca5 |
        | Hub Is Empty                   | Please fill Hub                   | QA         | RANDOM      | password | FULL_TIME      | TODAY               |     | QAE      | uid:8affd32c-0069-4ae3-8d68-34ae0494fe67 |
        | Position is Empty              | Please fill Position              | QA         | RANDOM      | password | FULL_TIME      | TODAY               | JKB |          | uid:94f1afb8-234f-49de-b025-93743973a97c |

  @DeleteHubAppUser
  Scenario: Search Hub User - Show All (uid:e3b18380-3889-4a25-bb3e-2d8de57e1b61)
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | employmentStartDate | hub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | TODAY               | JKB | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
