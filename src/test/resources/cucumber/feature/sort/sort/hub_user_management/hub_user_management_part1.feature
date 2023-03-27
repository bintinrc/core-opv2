@Sort @Sort @HubUserManagementPart1
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-user-client-id}" and client secret = "{sort-hub-user-client-secret}"

  Scenario: Hub User Management - Manager to switch between hubs in station users page - Managers Assigned to More than 1 Hubs
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click select hub on Hub User Management Page
      | hubName | {station-hub-name-2} |
    Then Operator verifies redirect to correct "{station-hub-name-2} " Hub User Management Page

  Scenario: Hub User Management - Bulk Assigns Hub User  - 1 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_1_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 1 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify bulk hub "hub_user_management_add_1_user.csv" user is added
    Then Operator remove all "hub_user_management_add_1_user.csv" added user

  Scenario: Hub User Management - Bulk Assigns Hub User  - 2 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_2_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 2 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify bulk hub "hub_user_management_add_2_user.csv" user is added
    Then Operator remove all "hub_user_management_add_2_user.csv" added user

  Scenario: Hub User Management Bulk Assigns Hub User - Empty CSV
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_empty_user.csv" CSV file
    Then Make sure it show error "hub_user_management_add_empty_user.csv" contains no email

  Scenario: Hub User Management Bulk Assigns Hub User - Empty with Spaces CSV
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_empty_with_space_user.csv" CSV file
    Then Make sure it show error "hub_user_management_add_empty_with_space_user.csv" contains no email

  Scenario: Hub User Management Bulk Assigns  Hub User - Partially Error CSV Valid and Invalid Email
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_invalid_and_valid_user.csv" CSV file
    Then Operator verify success notification "Successfully added 1 user(s)"
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  Scenario: Hub User Management - Bulk Assigns Hub User -  User already assigned to Maximum (3)Hubs
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_max_3_hub_user.csv" CSV file
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op