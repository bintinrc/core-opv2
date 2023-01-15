@OperatorV2 @MiddleMile @Hub @InterHub @MiddleMileHomepage @ViewHomepage
Feature: Middle Mile Homepage - View Middle Mile Homepage

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Middle Mile Homepage without select any Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened

  Scenario: View Middle Mile Homepage with select Crossdock Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-crossdock-1-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  Scenario: View Middle Mile Homepage with select Warehouse Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-station-1-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  Scenario: View Middle Mile Homepage with select Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-airport-1-code} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  Scenario: View Middle Mile Homepage with selected disabled Crossdock Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-disabled-crossdock-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  Scenario: View Middle Mile Homepage with selected disabled Warehouse Hub
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-disabled-station-name} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  Scenario: View Middle Mile Homepage with selected disabled Airport
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Middle Mile Homepage
    Then Operator verifies Middle Mile Homepage is opened
    When Operator clicks "Set My Hub" button on Middle Mile Homepage
    And Operator selects hub from hubs dropdown list on Middle Mile Homepage
      | myHub | {local-disabled-airport-code} |
    When Operator clicks "Confirm" button on Middle Mile Homepage
    Then Operator verifies Shipments In My Hub section is shown on Middle Mile Homepage

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op