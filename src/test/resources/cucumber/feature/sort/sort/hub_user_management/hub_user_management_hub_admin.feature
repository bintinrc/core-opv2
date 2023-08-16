@Sort @Sort @HubUserManagementHubAdmin
Feature: Hub User Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with client id = "{sort-hub-user-client-id}" and client secret = "{sort-hub-user-client-secret}"

  Scenario:Station Admin Specific Edit User button
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{hub-user-email}" hub user email
    When Hub User assigned hub to user with following hub:
      | hub1 | {selected-hub-1} |
      | hub2 | {selected-hub-2} |
      | hub3 | {selected-hub-3} |
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully updated {hub-user-email} |
    When Hub User admin click edit user button
    When Hub User search "{hub-user-email}" hub user email
    Then Make sure user assigned to correct hub
      | hub1 | {selected-hub-1} |
      | hub2 | {selected-hub-2} |
      | hub3 | {selected-hub-3} |

  Scenario:Hub User Management (Station Admin Flow)  - Add Staff Hub User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator search "{station-hub-name-1}" hub name
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    When Operator click add user button on Hub User Management Page
    Then Operator verifies "add" user modal for Station Admin flow is shown
    When Operator input "{add-hub-user-email}" user email
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully added {add-hub-user-email} |
    When Operator refresh page
    When Operator search "{station-hub-name-1}" hub name
    When Operator click edit button "{station-hub-id-1}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Added               |
      | username | {add-hub-user-name} |

  Scenario: Station Admin Specific Edit User button on Hub User Management Landing Page - Edit User - Remove Staff
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{add-hub-user-email}" hub user email
    When Operator click on remove user button on user modal
    Then Operator verifies "remove" user modal for Station Admin flow is shown
    When Operator click on remove button on remove user modal
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully removed {add-hub-user-email} |

  Scenario:Hub User Management (Station Admin Flow)  - Edit Staff Hub User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator search "{selected-hub-1}" hub name
    When Operator click edit button "{selected-hub-id-1}" on Hub User Management Page
    When Operator click edit view user "{hub-user-edit-id}" navigation button on Hub User Management Page
    Then Operator verifies "edit" user modal for Station Admin flow is shown
    When Hub User assigned hub to user with following hub:
      | hub1 | {selected-hub-1} |
      | hub2 | {selected-hub-2} |
      | hub3 | {selected-hub-3} |
    Then Operator verifies that success react notification displayed in Hub User Management Page:
      | top | Successfully updated {hub-user-edit-name} |
    When Operator refresh page
    When Operator search "{selected-hub-1}" hub name
    When Operator click edit button "{selected-hub-id-1}" on Hub User Management Page
    Then Operator verify hub user parameter:
      | check    | Added                |
      | username | {hub-user-edit-name} |

  Scenario:Station Admin Specific Edit User button on Hub User Management Landing Page - User is registered in Hub User Database
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{hub-user-email}" hub user email
    Then Operator verifies "edit" user modal for Station Admin flow is shown

  Scenario:Station Admin Specific Edit User button on Hub User Management Landing Page - User is registered in AAA Database - Not Registered in Hub User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{user-not-in-hub-user-database-email}" hub user email
    Then Operator verifies Add a new user? modal is shown
    When Operator clicks on the add user button
    Then Operator verifies "add" user modal for Station Admin flow is shown

  Scenario:Station Admin Specific Edit User button on Hub User Management Landing Page - User is not registered in AAA Database - Not Registered in Hub User
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{invalid-user-email}" hub user email
    Then Operator verifies that error react notification displayed in Hub User Management Page:
      | top    | User not found                                   |
      | bottom | Please try again with correct email or username. |

  Scenario: Station Admin Specific Edit User button on Hub User Management Landing Page - Edit User - Not Able to Remove Admin Role
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Hub User admin click edit user button
    When Hub User search "{hub-user-admin-email}" hub user email
    Then Operator verifies "edit" user modal for Station Admin flow is shown
    Then Operator verify remove hub user remove button is not exist

  Scenario:Hub User Management - Edit Hub User  - Should not be Able to Remove Station Admin
    When Operator refresh page
    When Operator go to menu Sort -> Hub User Management
    When Operator search "{station-hub-name-2}" hub name
    When Operator click edit button "{station-hub-id-2}" on Hub User Management Page
    When Operator search "{hub-user-admin-name}" username with "{hub-user-admin-role}" role
    When Operator click edit view user "{hub-user-admin-id}" navigation button on Hub User Management Page
    Then Operator verifies "edit" user modal for Station Admin flow is shown
    Then Operator verify remove hub user remove button is not exist

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op