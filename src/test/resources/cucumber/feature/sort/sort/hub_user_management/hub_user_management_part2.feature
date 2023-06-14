@Sort @Sort @HubUserManagementPart2
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-user-client-id}" and client secret = "{sort-hub-user-client-secret}"

  Scenario: Hub User Management -  manager to switch between hubs in station users page - Managers Assigned only 1 Hubs
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    Then Operator verifies redirect to correct "{station-hub-name-1}" Hub User Management Page

  Scenario: Hub User Management- Bulk Assign Hub User - 20 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_20_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 20 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify bulk hub "hub_user_management_add_20_user.csv" user is added
    Then Operator remove all "hub_user_management_add_20_user.csv" added user

  Scenario: Hub User Management - Bulk Assigns Hub User - More than 20 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_more_than_20_user.csv" CSV file
    Then Make sure it show error "hub_user_management_add_more_than_20_user.csv" exceeds the maximum size

  Scenario: Hub User Management - Bulk Assigns UI/UX  Hub User - User already assigned to The Hub
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_user_already_assigned_to_hub.csv" CSV file
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  Scenario: Hub User Management - Bulk Assigns  Hub User -  Duplicate User within the csv
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_duplicate_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 1 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify bulk hub "hub_user_management_duplicate_user.csv" user is added
    Then Operator remove all "hub_user_management_duplicate_user.csv" added user

  Scenario: Hub User Management - Add Staff Hub User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    When Operator input "{add-hub-user-email}" user email
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added {add-hub-user-email} |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Added               |
      | username | {add-hub-user-name} |

  Scenario: Hub User Management  Add Staff Hub User - User Not In AAA
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    When Operator input "{add-invalid-hub-user-name}" user email
    Then Operator verifies that error react notification displayed in Hub User Management Page:
      | top    | Failed to add user             |
      | bottom | User not found in our database |

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op