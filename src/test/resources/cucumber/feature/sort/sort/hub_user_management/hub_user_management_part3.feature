@Sort @Sort @HubUserManagementPart3
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-user-client-id}" and client secret = "{sort-hub-user-client-secret}"

  Scenario: Hub User Management - Add Staff for Hub User  - Empty Input
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    When Operator input "" user email
    Then Make sure add button is disabled

  Scenario: Hub User Management - Add Staff Hub User - User already has 3 hubs assigned
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    When Operator input "{add-hub-user-with-max-hub-name}" user email
    Then Operator verifies that error react notification displayed in Hub User Management Page:
      | top    | Failed to add user                        |
      | bottom | User should be mapped with 3 Hubs maximum |

  Scenario: Hub User Management - Remove Staff Hub User - Remove Staff
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click remove button for "{remove-hub-user-id}" on Hub User Management Page
    When Operator click on remove button on remove user modal
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully removed {remove-hub-user-name} |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Removed                |
      | username | {remove-hub-user-name} |

  Scenario: Hub User Management - Bulk Assigns  Hub User -  Duplicate User within the csv with Mixed Capslock - User not yet Assigned to Hub
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-2}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_duplicate_user_with_mixed_capslock.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 1 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-2}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Added           |
      | username | {hub-user-name} |
    Then Operator remove all "hub_user_management_duplicate_user_with_mixed_capslock.csv" added user

  Scenario: Hub User Management - Bulk Assigns  Hub User -  Duplicate User within the csv with Mixed Capslock - User Already Assigned to Hub
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_duplicate_user_with_mixed_capslock2.csv" CSV file
    Then Operator verifies the error details in modal:
      | modalTitle | We've detected some error in the file                                  |
      | modalBody  | 1 emails cannot be added. Please correct the file and upload it again. |

  Scenario: Hub User Management - Add Staff Hub User with mixed capslock - User Already Assigned to Hubs
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    When Operator input "{hub-user-mixed-capslock}" user email
    Then Operator verifies that error react notification displayed in Hub User Management Page:
      | top | Failed to add user                  |
      | bot | User is already assigned to the hub |

  Scenario: Hub User Management - Remove Staff Hub User - Admin / Manager
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator search "{station-hub-name-2}" hub name
    When Operator click edit button "{station-hub-id-2}" on Hub User Management Page
    When Operator search "{hub-user-admin-name}" username with "{hub-user-admin-role}" role
    Then Operator verifies delete hub user button is not exist

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op