@Sort @SortBeltPresetPart1
Feature: Sort Belt Preset

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946639
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Add Filter - Included Shipper
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator fill the criteria with following data
      | description | criteria 1                |
      | fields      | Shipper                   |
      | values      | Include:{shipper-v4-name} |
    And Operator click Proceed in the Create Preset UI
    When DB Sort - Operator check saved sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper     | {shipper-v4-name}                               |
      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6946649
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Add Filter - Excluded Shipper
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator fill the criteria with following data
      | description | criteria 1                |
      | fields      | Shipper                   |
      | values      | Exclude:{shipper-v4-name} |
    And Operator click Proceed in the Create Preset UI
    When DB Sort - Operator check saved sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper     | {shipper-v4-name}                               |
      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |
#
#    When DB Operator check saved sort belt preset by name
#    And Operator verify preset created correctly on Sort Belt Preset detail page
#      | shipper       | {shipper-v4-name}     |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016680
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Create Preset from a Copy
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create a copy" preset menu on Sort Belt Preset page
    And Operator select "{base-preset-name}" as the preset base on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator click Proceed in the Create Preset UI
    When DB Sort - Operator check saved sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | Order Tag   | ABC                                             |
      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |
#    When DB Operator check saved sort belt preset by name
#    And Operator verify preset created correctly on Sort Belt Preset detail page
#      | Order Tag | ABC |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016684

  Scenario: Sort Belt Preset - Create Preset from a Copy - Cancel Creation
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create a copy" preset menu on Sort Belt Preset page
    And Operator select "{base-preset-name}" as the preset base on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator click Cancel in the Create Preset UI
    When Operator search sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name and make sure its "not exist"
#    And Operator verify no sort belt preset is created
#      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
#      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
#      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016589
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Edit Preset
    Given API Sort - Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column | name                                     |
      | value  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name} |
    And Operator verify sort belt preset search result
      | presetName  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
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
    When DB Sort - Operator check saved sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | shipper     | {shipper-v4-name}                               |
      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016633
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Edit Preset - Cancel Edit
    Given API Sort - Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    When DB Sort - Operator check saved sort belt preset by "{KEY_SORT_CREATED_SORT_BELT_PRESET.name}" name
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column | name                                     |
      | value  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name} |
    And Operator verify sort belt preset search result
      | presetName  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
    Then Operator select the preset from Sort Belt Preset page
    And Operator click edit on Sort Belt Preset Detail page
    And Operator verify Create Preset UI
    And Operator take note the old preset name
      | oldPresetName | {KEY_SORT_CREATED_SORT_BELT_PRESET.name} |
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator fill the criteria with following data
      | description | criteria 1                |
      | fields      | Shipper                   |
      | values      | Exclude:{shipper-v4-name} |
    And Operator click Cancel in the Create Preset UI
    And Operator verify sort belt preset is not updated
      | savedPreset | {KEY_UPDATED_SORT_BELT_PRESET_NAME}      |
      | oldName     | {KEY_SORT_CREATED_SORT_BELT_PRESET.name} |

#  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/7016639
  Scenario: Sort Belt Preset - Edit Preset on Preset Error Page
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator fill the criteria with following data
      | description | criteria 1 |
      | fields      | Order Tag  |
      | values      | OPV2AUTO1  |
    And Operator add new criteria to Create Preset UI
    And Operator fill the criteria with following data
      | description   | criteria 2  |
      | fields      | Order Tag  |
      | values      | OPV2AUTO1  |
    And Operator click Proceed in the Create Preset UI
    And Operator verify preset has error on Check Sort Belt Preset detail page
      | fields        | Tags        |
    When Operator click on Edit button at the Check Sort Belt Preset detail page
    Then Operator verify Create Preset UI

    #  https://studio.cucumber.io/projects/208191/test-plan/folders/2172562/scenarios/6944465
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - UI Check
    Given API Sort - Operator create sort belt preset with following data
      | jsonPayload | {"description":"all fields","name":"all fields","rules":[{"seq":1,"description":"desc","filter":{"zones":[{zone-id}],"dest_hub_ids":[{hub-id}],"granular_statuses":["Van en-route to pickup","Arrived at Sorting Hub"],"tags":["AAA"],"rts":true,"service_levels":["EXPRESS","NEXTDAY"],"txn_end_in_days":1,"shipper_ids":[{shipper-v4-id}]}},{"seq":2,"description":"","filter":{"tags":["AAA"]}}]} |
    When DB Sort - Operator check saved sort belt preset by "{KEY_SORT_CREATED_SORT_BELT_PRESET.name}" name
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    Then Operator search sort belt preset by
      | column | name                                     |
      | value  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name} |
    And Operator verify sort belt preset search result
      | presetName  | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
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
  @CleanCreatedSortBeltPresetV2
  Scenario: Sort Belt Preset - Create Preset
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Sort -> Sort Belt Preset
    And Operator wait until sort belt preset page loaded
    When Operator click "Create new" preset menu on Sort Belt Preset page
    And Operator verify Create Preset UI
    When Operator fill name and description into Create Preset UI
      | name        | RANDOM |
      | description | RANDOM |
    And Operator fill the criteria with following data
      | description   | criteria 1  |
      | fields        | Order Tag   |
      | values        | OPV2AUTO1         |
    And Operator click Proceed in the Create Preset UI
    When DB Sort - Operator check saved sort belt preset by "{KEY_CREATED_SORT_BELT_PRESET_NAME}" name
    And Operator verify preset created correctly on Sort Belt Preset detail page
      | name        | {KEY_SORT_CREATED_SORT_BELT_PRESET.name}        |
      | description | {KEY_SORT_CREATED_SORT_BELT_PRESET.description} |
      | rulesString | {KEY_SORT_CREATED_SORT_BELT_PRESET.rulesString} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op