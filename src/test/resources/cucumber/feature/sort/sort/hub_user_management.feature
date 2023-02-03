@Sort @Sort @HubUserManagement
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Hub User Management - Manager to switch between hubs in station users page - Managers Assigned to More than 1 Hubs
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click select hub on Hub User Management Page
      | hubName | {station-hub-name-2} |
    Then Operator verifies redirect to correct "{station-hub-name-2} " Hub User Management Page

  Scenario: Hub User Management - Bulk Assigns Hub User  - 1 User
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_1_user.csv" CSV file
    Then Operator verify success notification "Successfully added 1 user(s)"

  Scenario: Hub User Management - Bulk Assigns Hub User  - 2 User
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_2_user.csv" CSV file
    Then Operator verify success notification "Successfully added 2 user(s)"

  Scenario: Hub User Management Bulk Assigns Hub User - Empty CSV
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_empty_user.csv" CSV file
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  Scenario: Hub User Management Bulk Assigns  Hub User - Partially Error CSV Valid and Invalid Email
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_invalid_and_valid_user.csv" CSV file
    Then Operator verify success notification "Successfully added 1 user(s)"
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  Scenario: Hub User Management -  manager to switch between hubs in station users page - Managers Assigned only 1 Hubs
    When Operator click logout button
    When Operator back in the login page
    When Operator click login button
    When Operator login as "dyo123dyo@gmail.com" with password "Ninjitsu89"
    When Operator go to menu Sort -> Hub User Management
    Then Operator verifies redirect to correct "{station-hub-name-1} " Hub User Management Page
