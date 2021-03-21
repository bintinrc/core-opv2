@OperatorV2 @MiddleMile @Hub @InterHub @MovementVisualization
Feature: Movement Visualization

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: View Movement From Origin Hub (uid:406b41e8-b599-4eed-a378-baa2de2f6c05)
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}" for Hub Type "origin"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  Scenario: Clear Filter From Origin Hub (uid:c327214e-1eff-4218-9d41-664bfa355af6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-origin-hub-name}" for Hub Type "origin"
    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
    And Operator clears the filters in Movement Visualization Page

  Scenario: View Movement From Destination Hub (uid:d52f1a47-8b9e-49be-96e5-74265f83cfe2)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}" for Hub Type "destination"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    When Operator clicks the first result on the list shown on Movement Visualization Page
    Then Operator verifies the relation of hub is right

  Scenario: Clear Filter From Destination Hub (uid:cbc6906d-46a7-4f9e-8c31-11d557e6dfcc)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Inter-Hub -> Movement Visualization
    And Operator selects the Hub by name "{hub-relation-destination-hub-name}" for Hub Type "destination"
    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
    And Operator clicks the selected Hub
    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
    And Operator clears the filters in Movement Visualization Page

#  Scenario: View and Edit Movement From Origin Hub (uid:f411d599-8293-4bed-ac03-b2761bb327aa)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Movement Visualization
#    And Operator selects the Hub by name "{hub-relation-origin-hub-name}" for Hub Type "destination"
#    And API Operator gets all relations for "origin" Hub id "{hub-relation-origin-hub-id}"
#    And Operator clicks the selected Hub
#    Then Operator verifies the list of "origin" shown on Movement Visualization Page is the same to the endpoint fired
#    When Operator clicks the first result on the list shown on Movement Visualization Page
#    Then Operator verifies the relation of hub is right
#    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
#    And Operator edits the selected Movement Schedule
#    And Operator close the View Schedule Modal on Movement Visualization Page
#    And Operator verifies the relation of hub is right
#    Then Operator verifies that the newly added relation is existed
#    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
#    Then Operator deletes the newly added relation from Movement Visualization Page
#
#  Scenario: View and Edit Movement From Destination Hub (uid:86b54059-ad21-440e-869e-63f0a875e000)
#    Given Operator go to menu Shipper Support -> Blocked Dates
#    Given Operator go to menu Inter-Hub -> Movement Visualization
#    And Operator selects the Hub by name "{hub-relation-destination-hub-name}" for Hub Type "destination"
#    And API Operator gets all relations for "destination" Hub id "{hub-relation-destination-hub-id}"
#    And Operator clicks the selected Hub
#    Then Operator verifies the list of "destination" shown on Movement Visualization Page is the same to the endpoint fired
#    When Operator clicks the first result on the list shown on Movement Visualization Page
#    Then Operator verifies the relation of hub is right
#    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
#    And Operator edits the selected Movement Schedule
#    And Operator close the View Schedule Modal on Movement Visualization Page
#    And Operator verifies the relation of hub is right
#    Then Operator verifies that the newly added relation is existed
#    When Operator clicks Edit Schedule Button on the Movement Schedule Modal
#    Then Operator deletes the newly added relation from Movement Visualization Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
