@Sort @SortBeltPresetPart1
Feature: Sort Belt Preset

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016503
  Scenario: Sort Belt Preset - Create Preset - Cancel Creation
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1  |
      | fields        | Order Tag   |
      | values        | ABC         |
    And Operator click Cancel in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify no sort belt preset is created

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016533
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Create Preset - Duplicate Rules
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1  |
      | fields        | Order Tag   |
      | values        | ABC         |
    And Operator add new criteria to Create Preset UI
    And Operator fill the criteria with following data
      | description   | criteria 2  |
      | fields        | Order Tag   |
      | values        | ABC         |
    And Operator click Proceed in the Create Preset UI
    And Operator verify preset has error on Check Sort Belt Preset detail page
      | fields        | Tags        |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016572
  Scenario: Sort Belt Preset - Create Preset - Duplicate Rules in Different Order
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Create Preset - Duplicate Rules
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1       |
      | fields        | Order Tag        |
      | values        | ABS.ABC          |
    And Operator add new criteria to Create Preset UI
    And Operator fill the criteria with following data
      | description   | criteria 2        |
      | fields        | Order Tag         |
      | values        | ABC.ABS           |
    And Operator click Proceed in the Create Preset UI
    And Operator verify preset has error on Check Sort Belt Preset detail page
      | fields        | Tags        |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946574
  @CleanCreatedSortBeltPreset
  Scenario Outline: Sort Belt Preset - Add Filter - <dataset_name> (<hiptest-uid>)
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1          |
      | fields        | <filterName>        |
      | values        | <filterValue>       |
    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      |  <filterKey>    | <filterValue>    |
    Examples:
      | scenarioName          | filterName          | filterKey         | filterValue        | hiptest-uid                              | dataset_name         |
      | DP                    | DP IDs              | dpName            | {dp-name}          | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | DP                   |
      | Zones                 | Zones               | zones             | {filter-zone-name} | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Zones                |
      | Destination Hub       | Destination Hub     | destinationHub    | {hub-name}         | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Destination Hub      |
      | Granular Status       | Granular Status     | granularStatus    | Pending Pickup     | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Granular Status      |
      | Order Tag             | Order Tag           | orderTag          | ABC                | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Order Tag            |
      | RTS                   | RTS                 | rts               | Yes                | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | RTS                  |
      | Service Level         | Service Level       | serviceLevel      | Standard           | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Service Level        |
      | Transaction End Date  | Transaction End Day | txnEnd            | < 1 Day            | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Transaction End Date |
      | Master Shipper        | Master Shipper      | masterShipper     | {master-shipper}   | uid:b2492424-7156-4ef2-aa23-b28035ed0f31 | Master Shipper       |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op