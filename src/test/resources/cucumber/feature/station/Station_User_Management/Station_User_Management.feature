@StationManagement @StationUserManagement
Feature: Station User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario Outline: Add User to Station with Invalid Email
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator clicks on the add user button
    When Operator input email "Test@ninjavan.com" to Email Address field
    Then Operator verifies confirm user button is disabled
    When Operator input email "Testninjavan.co" to Email Address field
    Then Operator verifies confirm user button is disabled
    When Operator input email "Test@gmail.com" to Email Address field
    Then Operator verifies confirm user button is disabled

    Examples:
      | HubName      | HubID      |
      | {hub-name-6} | {hub-id-6} |

  Scenario Outline: Add User that Already Added to the Station
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    And Operator adds the user "{operator-email}" to the hub
    Then operator verifies the error message displayed on adding same user again to Hub:"<HubName>"

    Examples:
      | HubName      | HubID      |
      | {hub-name-6} | {hub-id-6} |

  @Happypath @HighPriority
  Scenario Outline: Remove User from Station
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName1>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName1>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID>"
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    Then Operator verifies the success message is displayed on removing user to Hub : "{operator-email}"
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName2>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName3>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    And DB Operator verifies the Station User "{operator-email}" record is deleted in the station_admins table "<HubID>"
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies All Orders Page is displayed

    Examples:
      | HubName1     | HubID      | HubName2     | HubName3     |
      | {hub-name-6} | {hub-id-6} | {hub-name-8} | {hub-name-9} |

  @Happypath @HighPriority
  Scenario Outline: Add User to Station
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    And DB Operator verifies the Station User "{operator-email}" record is available in the station_admins table "<HubID>"
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID>"

    Examples:
      | HubName      | HubID      |
      | {hub-name-6} | {hub-id-6} |

  Scenario Outline: Add User to Multiple Station
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName1>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName2>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName2>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    And Operator go to menu Station Management Tool -> Station User Management
    Then Operator searches by "Station Name": "<HubName3>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName3>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName1>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID1>"

    Examples:
      | HubName1     | HubID1     | HubName2     | HubName3     |
      | {hub-name-6} | {hub-id-6} | {hub-name-8} | {hub-name-9} |

  Scenario: Search Station by Region (uid:eadc7116-5a5b-4d9f-b628-587288aec8c6)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    And Operator verifies "Overview of Stations" title is displayed
    Then Operator searches by "Region": "JKB"
    And Operator verifies table is filtered "region" based on input in "JKB"

  @HighPriority
  Scenario Outline: Search Station by Station Name (uid:734b60e8-d052-41db-a225-3875f35f6486)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    And Operator verifies "Overview of Stations" title is displayed
    Then Operator searches by "Station Name": "<HubName>"
    And Operator verifies table is filtered "hubName" based on input in "{hub-name-6}"

    Examples:
      | HubName      |
      | {hub-name-6} |

  @HighPriority
  Scenario Outline: Search Station by Station ID (uid:dc65295e-6465-45d1-ab38-35f554b6be06)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    And Operator verifies "Overview of Stations" title is displayed
    Then Operator searches by "Station ID": "<HubID>"
    And Operator verifies table is filtered "hubId" based on input in "<HubID>"

    Examples:
      | HubID      |
      | {hub-id-6} |


  Scenario Outline: Search User by Email Address (uid:bdf4ac68-0417-43e1-8904-a42b451eb79c)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    When Operator verifies "Overview of Stations" title is displayed
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName>"
    And operator verifies the newly added user "{operator-email}" is available in the list

    Examples:
      | HubName      |
      | {hub-name-6} |

  Scenario Outline: Search Station by Number of User
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> Station User Management
    When Operator verifies "Overview of Stations" title is displayed
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    And operator verifies the newly added user "{operator-email}" is available in the list
    Then Operator searches by No of users with filter value "1"
    Then Operator searches by "Station Name": "<HubName>" without refresh
    And Operator verifies table is filtered "count" based on input in "1"

    Examples:
      | HubName      |
      | {hub-name-6} |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    When Operator click logout button