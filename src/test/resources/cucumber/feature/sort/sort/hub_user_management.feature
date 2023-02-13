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
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_1_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 1 user(s) |
    When Operator refresh page
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Added               |
      | username | {add-hub-user-name} |

  Scenario: Hub User Management - Bulk Assigns Hub User  - 2 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_2_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 2 user(s) |

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

  Scenario: Hub User Management- Bulk Assign Hub User - 20 User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator bulk upload hub user using a "hub_user_management_add_20_user.csv" CSV file
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added 20 user(s) |

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

