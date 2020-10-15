@MiddleMile @AccessControl @HubAppUserManagement @Shipment
Feature: Hub App User Management

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario: Success Create Hub User (uid:3c0e3793-b641-4037-97c5-cc2ff3dc4e79)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown

  @KillBrowser @LaunchBrowser
  Scenario: Cannot Create Duplicate Hub User (uid:48fc37e3-0697-4b08-a3ae-03a1a8ddf6c1)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    Given DB Operator gets the newest existed username for Hub App
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username   | password | employmentType | employmentStartDate | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | DUPLICATED | password | FULL_TIME      | TODAY               | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be a duplication error toast shown

  @KillBrowser @LaunchBrowser
  Scenario Outline: Cannot Create Hub User with Invalid Request - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with negative scenarios using details:
      | firstName   | lastName   | contact        | username   | password   | employmentType   | employmentStartDate   | hub   | warehouseTeamFormation | position   | comments                                                             |
      | <firstName> | Automation | qa@ninjavan.co | <username> | <password> | <employmentType> | <employmentStartDate> | <hub> | Middle Mile Team       | <position> | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be UI error of empty field of "<errorMessage>" shown
    Examples:
      | scenarioName                   | errorMessage                      | firstName | username | password | employmentType | employmentStartDate | hub        | position | hiptest-uid                              |
      | First Name Is Empty            | Please fill First Name            |           | RANDOM   | password | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:8c5eda00-087f-4874-90bb-702a22ca74a2 |
      | Username Is Empty              | Please fill Username              | QA        |          | password | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:fa3272b6-62f1-4906-bd09-919964fce126 |
      | Password Is Empty              | Please fill Password              | QA        | RANDOM   |          | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:d4b01276-580a-46e2-9f35-2cd5f3375104 |
      | Employment Type Is Empty       | Please fill Employment Type       | QA        | RANDOM   | password |                | TODAY               | {hub-name} | QAE      | uid:726a53bc-8120-4d20-bdaa-229f6bbd28d2 |
      | Employment Start Date Is Empty | Please fill Employment Start Date | QA        | RANDOM   | password | FULL_TIME      |                     | {hub-name} | QAE      | uid:4aa8e4aa-f5a6-47bf-8c22-a02dbaf6d805 |
      | Hub Is Empty                   | Please fill Hub                   | QA        | RANDOM   | password | FULL_TIME      | TODAY               |            | QAE      | uid:74985da8-5c38-43e9-a846-aee0f674e491 |
      | Position is Empty              | Please fill Position              | QA        | RANDOM   | password | FULL_TIME      | TODAY               | {hub-name} |          | uid:e36d0d59-1aec-4021-a2e5-72e42654e147 |

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario: Search Hub User (uid:7c736e00-9fda-4f55-a21d-093809eb8e8f)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario Outline: Search Hub User by Filter - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator fills the "<filterName>" filter and select the value based on created Hub App User
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    Examples:
      | scenarioName                                        | filterName            | hiptest-uid                              |
      | Search Hub App User by Hub Filter                   | hub                   | uid:7802965b-9f4a-43a1-a693-83dcb173e9e5 |
      | Search Hub App User by Employment Type Filter       | employment type       | uid:d5c87142-d15d-4f43-bd0e-1d8a5d1606e8 |
      | Search Hub App User by Employment Start Date Filter | employment start date | uid:79b7d18d-ad24-4c40-b38c-9027625b7400 |
      | Search Hub App User by Status Filter                | status                | uid:4b9e9ce5-941f-4ce0-8c45-951394c14e6d |
      | Search Hub App User by Multiple Filter              | multiple              | uid:91997ca6-351d-4dc8-84a2-ce1565fc4709 |

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario Outline: Update Personal Detail - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    And Operator edits the existed Hub App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | hub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <hub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    Examples:
      | scenarioName                                                             | firstName  | lastName   | contact                       | password   | employmentType | employmentStatus | hub        | warehouseTeamFormation | position | comments                                                             | hiptest-uid                              |
      | Update Personal Detail - Normal Flow                                     | Automation | QA         | tristania.siagian@ninjavan.co | Ninjitsu89 | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:e5d7973c-dc21-464b-a106-266b2014aed8 |
      | Update Personal Details - Last Name is Empty (Non-Negative Scenario)     | QA         |            | qa@ninjavan.co                | password   | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:06fe828f-d119-4a89-a9be-f9f6ed0aacf6 |
      | Update Personal Detail - Contact Detail is Empty (Non-Negative Scenario) | QA         | Automation |                               | password   | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:05406423-e5fe-45ed-a692-676f7abd7165 |
      | Update Personal Details - Password is Empty (Non-Negative Scenario)      | QA         | Automation | qa@ninjavan.co                |            | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:95ebb466-6bf7-4778-8187-85fa6f7d9824 |

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario Outline: Update Employee Detail - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    And Operator edits the existed Hub App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | hub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <hub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    Examples:
      | scenarioName                                                                        | firstName | lastName   | contact        | password | employmentType | employmentStatus | hub        | warehouseTeamFormation | position    | comments                                                             | hiptest-uid                              |
      | Update Employee Details  - Normal Flow                                              | QA        | Automation | qa@ninjavan.co | password | PART_TIME      | ACTIVE           | JKB        | Middle Mile Team       | QA Engineer | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:40c7f189-53c8-4c17-97b7-97c6821beb1b |
      | Update Employee Details - Warehouse Team Formation is Empty (Non-Negative Scenario) | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} |                        | QA Engineer | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:56787dc0-c5f9-4581-b494-a755f59fc8be |

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario: Update Activity of the Hub App User (uid:1ad221e9-6baa-4d1a-ae56-c074472961a3)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    And Operator edits the existed Hub App User with details:
      | firstName | lastName   | contact        | password | employmentType | employmentStatus | hub        | warehouseTeamFormation | position    | comments                                                          |
      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario Outline: Update Additional Information - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    And Operator edits the existed Hub App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | hub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <hub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    Examples:
      | scenarioName                                                         | firstName | lastName   | contact        | password | employmentType | employmentStatus | hub        | warehouseTeamFormation | position    | comments                                                          | hiptest-uid                              |
      | Update Additional Details  - Normal Flow                             | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. | uid:9281378b-1268-4a66-8ccc-17dc8e404c1b |
      | Update Additional Details - Comment is Empty (Non-Negative Scenario) | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer |                                                                   | uid:1424372b-9323-413e-a0ab-13be21f57100 |

  @DeleteHubAppUser @KillBrowser @LaunchBrowser
  Scenario Outline: Update Detail Negative Scenario - <scenarioName> (<hiptest-uid>)
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Hub App User Management
    When Operator create new Hub App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | hub        | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Hub App User
    Then Operator verifies that the newly created Hub App User will be shown
    And Operator edits the existed Hub App User with negative scenario using details:
      | firstName   | position   |
      | <firstName> | <position> |
    Then Operator verifies that there will be UI error of empty field of "<errorMessage>" shown
    Examples:
      | scenarioName                                  | firstName | position | errorMessage           | hiptest-uid                              |
      | Update Personal Details - First Name is Empty |           | QAE      | Please fill First Name | uid:45a0b4b3-89a0-4ecb-a26c-4cf713cafc6c |
      | Update Employee Details - Position is Empty   | QA        |          | Please fill Position   | uid:4397b019-568e-4601-81df-336d1c1294df |
