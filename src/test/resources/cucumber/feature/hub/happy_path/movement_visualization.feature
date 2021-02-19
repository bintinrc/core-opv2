@OperatorV2 @Hub @HappyPath @MovementVisualization
Feature: Movement Visualization

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Movement From Origin Hub (uid:e32738f0-5a66-4b98-87e6-cc9d88be60e0)
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}" for Hub Type "origin"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  Scenario: View Movement From Destination Hub (uid:05345ed7-390d-4bc0-a91b-a16046d1a2b6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}" for Hub Type "destination"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op