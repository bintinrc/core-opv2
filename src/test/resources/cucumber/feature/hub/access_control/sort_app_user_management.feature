@OperatorV2 @MiddleMile @Hub @AccessControl @SortAppUserManagement
Feature: Sort App User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteSortAppUser @opv2
  Scenario: Success Create Sort User with One Primary Hub (uid:d2bdb5ea-9a31-46e1-821f-1091b390fa22)
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario: Success Create Sort User with Additional Hub(s) (uid:16be9389-f200-4ee9-b505-1d825562beef)
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | additionalHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | {hub-name-2}  | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  Scenario: Cannot Create Duplicate Hub User (uid:bc5a1f23-0b6e-4fb8-948e-0dbc3638ad91)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    Given DB Operator gets the newest existed username for Sort App
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username   | password | employmentType | employmentStartDate | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | DUPLICATED | password | FULL_TIME      | TODAY               | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be a duplication error toast shown

  Scenario Outline: Cannot Create Hub User with Invalid Request - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with negative scenarios using details:
      | firstName   | lastName   | contact        | username   | password   | employmentType   | employmentStartDate   | primaryHub   | warehouseTeamFormation | position   | comments                                                             |
      | <firstName> | Automation | qa@ninjavan.co | <username> | <password> | <employmentType> | <employmentStartDate> | <primaryHub> | Middle Mile Team       | <position> | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    Then Operator verifies that there will be UI error of empty field of "<errorMessage>" shown
    Examples:
      | scenarioName                   | errorMessage                      | firstName | username | password | employmentType | employmentStartDate | primaryHub | position | hiptest-uid                              | dataset_name                   |
      | First Name Is Empty            | Please fill First Name            |           | RANDOM   | password | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:5a27de9e-2b27-4cc4-acf8-7bb0ad447d3a | First Name Is Empty            |
      | Username Is Empty              | Please fill Username              | QA        |          | password | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:4d5498ae-fa34-465b-a208-11f5e792b4d0 | Username Is Empty              |
      | Password Is Empty              | Please fill Password              | QA        | RANDOM   |          | FULL_TIME      | TODAY               | {hub-name} | QAE      | uid:2b08e18f-5e17-4ac2-9664-4cb668061317 | Password Is Empty              |
      | Employment Type Is Empty       | Please fill Employment Type       | QA        | RANDOM   | password |                | TODAY               | {hub-name} | QAE      | uid:da92ea5e-2f5f-40cc-bfe9-b2193de713ae | Employment Type Is Empty       |
      | Employment Start Date Is Empty | Please fill Employment Start Date | QA        | RANDOM   | password | FULL_TIME      |                     | {hub-name} | QAE      | uid:13e5cc0a-3314-4b06-b9ba-6b58a31b7a7f | Employment Start Date Is Empty |
      | Hub Is Empty                   | Please fill Hub                   | QA        | RANDOM   | password | FULL_TIME      | TODAY               |            | QAE      | uid:be36c43c-cae1-43d0-be1e-e9c6d3e6d857 | Hub Is Empty                   |
      | Position is Empty              | Please fill Position              | QA        | RANDOM   | password | FULL_TIME      | TODAY               | {hub-name} |          | uid:e8671051-6e5d-430a-85f3-2fe9540d9aa1 | Position is Empty              |

  Scenario: Search Sort User (uid:b20f29ed-adbe-45ee-a4f6-97caf3059b5a)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator refresh page
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario Outline: Search User by Filter - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator fills the "<filterName>" filter and select the value based on created Sort App User
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    Examples:
      | scenarioName        | filterName            | hiptest-uid                              | dataset_name         |
      | Hub Id              | hub                   | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Hub Id               |
      | Employee Type       | employment type       | uid:c6646b40-c0e9-415e-b181-4ad9d944bcfa | Employee Type        |
      | Employee Start Date | employment start date | uid:07f8f825-d44c-4db1-a0ff-1fa780516a31 | Employee Start Date  |
      | Employee Status     | status                | uid:8800b427-a6b1-4df6-9636-eaf91e8564bf | Employee Status      |
      | Multiple Filter     | multiple              | uid:52b08dcf-ccf9-4757-b8dd-04137140f0c7 | Multiple Filter      |

  @DeleteSortAppUser
  Scenario Outline: Update Personal Detail - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | primaryHub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <primaryHub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    Examples:
      | scenarioName            | firstName  | lastName   | contact                       | password   | employmentType | employmentStatus | primaryHub | warehouseTeamFormation | position | comments                                                             | hiptest-uid                              | dataset_name            |
      | Normal Flow             | Automation | QA         | tristania.siagian@ninjavan.co | Ninjitsu89 | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:887ea61e-b5ef-43bd-ba2d-2dfdc4a01315 | Normal Flow             |
      | Last Name is Empty      | QA         |            | qa@ninjavan.co                | password   | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:81a11c2d-df0e-4c99-b1fb-20230e63085e | Last Name is Empty      |
      | Contact Detail is Empty | QA         | Automation |                               | password   | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:506bf7bc-290c-4780-856d-285a47e9a93d | Contact Detail is Empty |
      | Password is Empty       | QA         | Automation | qa@ninjavan.co                |            | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:4b7bf906-b57a-4425-be91-7b05fb20d933 | Password is Empty       |

  @DeleteSortAppUser
  Scenario Outline: Update Employee Detail - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | primaryHub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <primaryHub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    Examples:
      | scenarioName                      | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub | warehouseTeamFormation | position    | comments                                                             | hiptest-uid                              | dataset_name                      |
      | Normal Flow                       | QA        | Automation | qa@ninjavan.co | password | PART_TIME      | ACTIVE           | JKB        | Middle Mile Team       | QA Engineer | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:273c4bbb-3142-4449-aa7c-cb55a0370591 | Normal Flow                       |
      | Warehouse Team Formation is Empty | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} |                        | QA Engineer | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. | uid:fc842279-b840-40fd-a9e4-ffc376b3758a | Warehouse Team Formation is Empty |

  @DeleteSortAppUser
  Scenario: Update Activity of the Sort App User (uid:a0b02d55-7b33-4cd6-94c2-8b8badabe0bb)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub | warehouseTeamFormation | position    | comments                                                          |
      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario Outline: Update Additional Information - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName   | lastName   | contact   | password   | employmentType   | employmentStatus   | primaryHub   | warehouseTeamFormation   | position   | comments   |
      | <firstName> | <lastName> | <contact> | <password> | <employmentType> | <employmentStatus> | <primaryHub> | <warehouseTeamFormation> | <position> | <comments> |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    Examples:
      | scenarioName     | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub | warehouseTeamFormation | position    | comments                                                          | hiptest-uid                              | dataset_name     |
      | Normal Flow      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. | uid:b3c19d40-2e19-48d9-adf7-aa8fc6cd77ac | Normal Flow      |
      | Comment is Empty | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer |                                                                   | uid:a62ed47c-4fc9-4aa7-9c55-d5f2e9cba179 | Comment is Empty |

  @DeleteSortAppUser
  Scenario: Update User's Primary Hub (uid:56c59a36-c5b7-4702-a053-b3c374e5f381)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub   | warehouseTeamFormation | position    | comments                                                          |
      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name-2} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario: Update User Adding Additional Hubs (uid:b4313976-407b-4f1c-bbad-81c4706c9178)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub | additionalHub | warehouseTeamFormation | position    | comments                                                          |
      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | {hub-name-2}  | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario: Update User Deleting Additional Hubs (uid:0bd5fa62-56a0-4280-acde-9d7175e8fb90)
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | additionalHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | {hub-name-2}  | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with details:
      | firstName | lastName   | contact        | password | employmentType | employmentStatus | primaryHub | warehouseTeamFormation | position    | comments                                                          |
      | QA        | Automation | qa@ninjavan.co | password | FULL_TIME      | ACTIVE           | {hub-name} | Middle Mile Team       | QA Engineer | This is edited by automation at {gradle-current-date-yyyy-MM-dd}. |
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown

  @DeleteSortAppUser
  Scenario Outline: Update Detail Negative Scenario - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with details:
      | firstName | lastName   | contact        | username | password | employmentType | primaryHub | warehouseTeamFormation | position | comments                                                             |
      | QA        | Automation | qa@ninjavan.co | RANDOM   | password | FULL_TIME      | {hub-name} | Middle Mile Team       | QAE      | This is generated by automation at {gradle-current-date-yyyy-MM-dd}. |
    And Operator Load all the Sort App User
    Then Operator verifies that the newly created Sort App User will be shown
    And Operator edits the existed Sort App User with negative scenario using details:
      | firstName   | position   |
      | <firstName> | <position> |
    Then Operator verifies that there will be UI error of empty field of "<errorMessage>" shown
    Examples:
      | scenarioName        | firstName | position | errorMessage           | hiptest-uid                              | dataset_name        |
      | First Name is Empty |           | QAE      | Please fill First Name | uid:432e9b4a-9523-48ec-b149-74b63f476f64 | First Name is Empty |
      | Position is Empty   | QA        |          | Please fill Position   | uid:c256cbfd-468b-42aa-b26c-26f62c5860fc | Position is Empty   |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
