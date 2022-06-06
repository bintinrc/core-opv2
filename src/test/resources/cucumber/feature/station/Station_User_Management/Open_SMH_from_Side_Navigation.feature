@StationManagement @StationUserManagement
Feature: Open SMH from Side Navigation

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    And DB Operator updates the station_admins table deleted_at to current timestamp: "" for the user "{operator-email}"


  Scenario Outline: User has 1 Hub Open SMH (uid:f10dc44f-8a84-46d4-a552-072565ba0779)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName>"
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID>"
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator go to menu Station Management Tool -> Station Management Homepage
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID>"

    Examples:
      | HubName      | HubID      |
      | {hub-name-6} | {hub-id-6} |


  Scenario Outline: User has No hub Open SMH (uid:0138f406-40b1-49b8-8557-3bbbeb175f5c)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    Then Operator verifies the success message is displayed on removing user to Hub : "{operator-email}"
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName2>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName3>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies All Orders Page is displayed
    And Operator go to menu Station Management Tool -> Station Management Homepage
    Then Operator verifies that the text:"<ModalText>" is displayed on the hub modal selection
    And Operator selects the hub as "<HubName1>" and proceed
    And Operator verifies that the hub has changed to:"<HubName1>" in header dropdown
    And Operator verifies that the url path parameter changes to hub-id:"<HubID1>"

    Examples:
      | HubName1     | HubID1     | HubName2     | HubName3     | ModalText                          |
      | {hub-name-6} | {hub-id-6} | {hub-name-8} | {hub-name-9} | Welcome to Station Management Tool |


  Scenario Outline: User has Multiple Hubs Open SMH
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName1>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName2>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName2>"
    And operator verifies the newly added user "{operator-email}" is available in the list
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName1>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID1>"
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator go to menu Station Management Tool -> Station Management Homepage
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName1>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID1>"

    Examples:
      | HubName1     | HubID1     | HubName2     |
      | {hub-name-6} | {hub-id-6} | {hub-name-8} |

  Scenario Outline: User has Disabled Hub Open SMH (uid:342cd60f-a96e-4399-a7e6-31a16118af70)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName1>"
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName2>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName3>"
    And Operator clicks on the view Users button
    And Operator removes the user "{operator-email}" from the hub
    And DB Operator verifies the Station User "{operator-email}" record is deleted in the station_admins table "<HubID>"
    And DB Operator updates the station_admins table deleted_at to current timestamp: "<TimeStamp>" for the user "{operator-email}"
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies All Orders Page is displayed
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator selects the hub as "<HubName2>" and proceed
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName2>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID2>"

    Examples:
      | HubName1     | HubID1     | HubName2     | HubID2     | HubName3     | TimeStamp                                 |
      | {hub-name-6} | {hub-id-6} | {hub-name-8} | {hub-id-8} | {hub-name-9} | {gradle-current-date-yyyy-MM-dd} 00:00:00 |

  Scenario Outline: User has Hub changes Operating Country and Open SMH (uid:778b0c97-9978-415d-9acd-491c4faa335e)
    Given Operator loads Operator portal home page
    And Operator go to menu Station Management Tool -> User Management
    Then Operator searches by "Station Name": "<HubName1>"
    And Operator clicks on the view Users button
    And Operator adds the user "{operator-email}" to the hub
    Then Operator verifies the success message is displayed on adding user to Hub : "<HubName1>"
    When Operator click logout button
    And Operator login Operator portal with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName1>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID1>"
    And Operator go to menu Station Management Tool -> Station COD Report
    And Operator changes the country to "<Country>"
    And Operator verify operating country is "<Country>"
    When Operator go to menu Station Management Tool -> Station Management Homepage
    And Operator refresh page v1
    And Operator selects the hub as "<HubName2>" and proceed
    Then Operator verifies user is redirected to the Station Management Homepage of hub "<HubName2>" that has been mapped to user
    And Operator verifies that the url path parameter changes to hub-id:"<HubID2>"

    Examples:
      | HubName1     | HubID1     | Country  | HubName2     | HubID2     |
      | {hub-name-6} | {hub-id-6} | Thailand | {hub-name-1} | {hub-id-1} |


  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    When Operator click logout button