@Sort @Addressing
Feature: Addressing

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  @DeleteAddress
  Scenario: Add Address SG
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_CREATED_ADDRESSING.postcode}   |
      | streetName | {KEY_CREATED_ADDRESSING.streetName} |
      | buildingNo | {KEY_CREATED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_CREATED_ADDRESSING.latitude}   |
      | longitude  | {KEY_CREATED_ADDRESSING.longitude}  |

  @DeleteAddress
  Scenario: Search Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_CREATED_ADDRESSING.postcode}   |
      | streetName | {KEY_CREATED_ADDRESSING.streetName} |
      | buildingNo | {KEY_CREATED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_CREATED_ADDRESSING.latitude}   |
      | longitude  | {KEY_CREATED_ADDRESSING.longitude}  |

  @DeleteAddress
  Scenario: Delete Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    When Operator delete address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | ^Success delete address.* |
      | waitUntilInvisible | true                      |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}" address on Addressing Page
    Then Operator verifies the address does not exist on Addressing Page

  @DeleteAddress
  Scenario: Edit Address
    Given Operator go to menu Utilities -> QRCode Printing
    Given Operator go to menu Addressing -> Addressing
    When Operator clicks on Add Address Button on Addressing Page
    And Operator creates new address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success create address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_CREATED_ADDRESSING.buildingNo}, {KEY_CREATED_ADDRESSING.buildingName}, {KEY_CREATED_ADDRESSING.streetName}" address on Addressing Page
    And Operator edits the address on Addressing Page
    Then Operator verifies that success react notification displayed:
      | top                | Success update address |
      | waitUntilInvisible | true                   |
    And Operator searches "{KEY_EDITED_ADDRESSING.buildingNo}, {KEY_EDITED_ADDRESSING.buildingName}, {KEY_EDITED_ADDRESSING.streetName}" address on Addressing Page
    Then Operator verifies address on Addressing Page:
      | postcode   | {KEY_EDITED_ADDRESSING.postcode}   |
      | streetName | {KEY_EDITED_ADDRESSING.streetName} |
      | buildingNo | {KEY_EDITED_ADDRESSING.buildingNo} |
      | latitude   | {KEY_EDITED_ADDRESSING.latitude}   |
      | longitude  | {KEY_EDITED_ADDRESSING.longitude}  |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op