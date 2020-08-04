@MiddleMile @InterHub @MovementVisualization
Feature: Movement Visualization

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Movement From Origin Hub (uid:c99f6c9e-e9a2-445a-887f-619dc85f10e1)
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "origin" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  Scenario: Clear Filter From Origin Hub (uid:7e5cfe26-c8a2-4194-964b-c322553b6d57)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "origin" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    And Operator clears the filters in Movement Visualization Page

  Scenario: View Movement From Destination Hub (uid:a00fd00c-879e-43bd-9264-d2b15facfffc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "destination" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  Scenario: Clear Filter From Destination Hub (uid:fb3deb23-8d95-4f06-b664-93178c292c5e)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "destination" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    And Operator clears the filters in Movement Visualization Page

  Scenario: View and Edit Movement From Origin Hub (uid:97e0094c-0399-4cb1-bd3a-fc7dcdb270d8)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "origin" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right
    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
    And Operator edits the selected Movement Schedule
    And Operator close the View Schedule Modal on Movement Visualization Page
    And Operator verifies the relation of hub is right
    Then Operator verifies that the newly added relation is existed
    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
    Then Operator deletes the newly added relation from Movement Visualization Page

  Scenario: View and Edit Movement From Destination Hub (uid:c4f3eb6e-9a68-475e-af30-c5dda669d6d3)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    When Operator selects the Hub Type of "destination" on Movement Visualization Page
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right
    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
    And Operator edits the selected Movement Schedule
    And Operator close the View Schedule Modal on Movement Visualization Page
    And Operator verifies the relation of hub is right
    Then Operator verifies that the newly added relation is existed
    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
    Then Operator deletes the newly added relation from Movement Visualization Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
