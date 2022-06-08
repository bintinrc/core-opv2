@Sort @SortBeltPreset @CWF
Feature: Sort Belt Preset

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"


#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6944465
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - UI Check
    Given API Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1,"shipper_ids":[{shipper-v4-id}]}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column  | name                                     |
      | value   | {KEY_CREATED_SORT_BELT_PRESET_NAME}      |
    And Operator verify sort belt preset search result
    Then Operator search sort belt preset by
      | column  | description                              |
      | value   | {KEY_CREATED_SORT_BELT_PRESET_NAME}      |
    And Operator verify sort belt preset search result
    When Operator click Create a new preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | AUTOMATION PRESET       |
      | description   | AUTOMATION DESCRIPTION  |
    And Operator add new criteria to Create Preset UI
    And Operator remove criteria to Create Preset UI
    And Operator clear name and description in Create Preset UI
    And Operator click Proceed in the Create Preset UI
    Then Operator verify the new preset is failed to be submitted
      | header  | Incomplete Form Submission          |
      | message | Please fill in all required fields  |


#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946748
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Create Preset
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click Create a new preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1  |
      | fields        | Order Tag   |
      | values        | ABC         |

    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page


#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016503
  Scenario: Sort Belt Preset - Create Preset - Cancel Creation
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click Create a new preset menu on Sort Belt Preset page
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
    When Operator click Create a new preset menu on Sort Belt Preset page
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
    When Operator click Create a new preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1       |
      | fields        | Order Tag,RTS   |
      | values        | ABC,Yes         |
    And Operator add new criteria to Create Preset UI
    And Operator fill the criteria with following data
      | description   | criteria 2                |
      | fields        | Service Level,Order Tag   |
      | values        | STANDARD,ABC              |
    And Operator click Proceed in the Create Preset UI
    And Operator verify preset has error on Check Sort Belt Preset detail page
      | fields        | Tags        |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op