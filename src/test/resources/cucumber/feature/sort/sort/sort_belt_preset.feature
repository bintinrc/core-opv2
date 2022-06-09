@Sort @SortBeltPreset
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
    When Operator click "Create new" preset menu on Sort Belt Preset page
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
    When Operator click "Create new" preset menu on Sort Belt Preset page
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
      | noValue       | noValue     |


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

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946639
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Add Filter - Included Shipper
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1                |
      | fields        | Shipper                   |
      | values        | Include:{shipper-v4-name} |

    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper       | {shipper-v4-name}     |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946649
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Add Filter - Excluded Shipper
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator fill the criteria with following data
      | description   | criteria 1                |
      | fields        | Shipper                   |
      | values        | Exclude:{shipper-v4-name} |

    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper       | {shipper-v4-name}     |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016680
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Create Preset from a Copy
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create a copy" preset menu on Sort Belt Preset page
    And Operator select "{base-preset-name}" as the preset base on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | Order Tag      | ABC     |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016684
  Scenario: Sort Belt Preset - Create Preset from a Copy - Cancel Creation
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create a copy" preset menu on Sort Belt Preset page
    And Operator select "{base-preset-name}" as the preset base on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM  |
      | description   | RANDOM  |
    And Operator click Cancel in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify no sort belt preset is created

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016589
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Edit Preset
    Given API Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column  | name                                     |
      | value   | {KEY_CREATED_SORT_BELT_PRESET_NAME}      |
    And Operator verify sort belt preset search result
    Then Operator select the preset from Sort Belt Preset page
    And Operator click edit on Sort Belt Preset Detail page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM      |
      | description   | RANDOM      |
    And Operator fill the criteria with following data
      | description   | criteria 1                |
      | fields        | Shipper                   |
      | values        | Exclude:{shipper-v4-name} |
    And Operator click Proceed in the Create Preset UI
    When DB Operator check saved sort belt preset by name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper       | {shipper-v4-name}     |


#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016633
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Edit Preset - Cancel Edit
    Given API Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column  | name                                     |
      | value   | {KEY_CREATED_SORT_BELT_PRESET_NAME}      |
    And Operator verify sort belt preset search result
    Then Operator select the preset from Sort Belt Preset page
    And Operator click edit on Sort Belt Preset Detail page
    And Operator verify Create Preset UI
    And Operator take note the old preset name
    When Operator fill name and description into Create Preset UI
      | name          | RANDOM      |
      | description   | RANDOM      |
    And Operator fill the criteria with following data
      | description   | criteria 1                |
      | fields        | Shipper                   |
      | values        | Exclude:{shipper-v4-name} |
    And Operator click Cancel in the Create Preset UI
    When DB Operator check not updated sort belt preset by name
    And Operator verify sort belt preset is not updated

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016639
  @CleanCreatedSortBeltPreset
  Scenario: Sort Belt Preset - Edit Preset on Preset Error Page
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
    When Operator click on Edit button at the Check Sort Belt Preset detail page
    Then Operator verify Create Preset UI


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op