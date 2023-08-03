@OperatorV2 @Sort @Hubs
Feature: Sort App User Scope

  @LaunchBrowser @SortAppUserScope
  Scenario: Unable Create Sort User without Scope SORT_CREATE_SORT_APP_USER
    Given Operator login with client id = "{sort-without-scope-client-id}" and client secret = "{sort-without-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with detailsV2:
      | firstName              | {first-name}               |
      | lastName               | {last-name}                |
      | contact                | {contact}                  |
      | username               | {username}                 |
      | password               | {password}                 |
      | employmentType         | {employment-type}          |
      | primaryHub             | {primary-hub}              |
      | warehouseTeamFormation | {warehouse-team-formation} |
      | position               | {position}                 |
      | comments               | {comments}                 |
    Then Make sure "{permission-error-title}" notification pop up with "{error-without-create-scope}"

  @LaunchBrowser @SortAppUserScope
  Scenario: Unable Edit Sort User without Scope SORT_EDIT_SORT_APP_USER
    Given Operator login with client id = "{sort-without-scope-client-id}" and client secret = "{sort-without-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator refresh page
    And Operator Load all the Sort App User
    When Operator search sort app user by "User ID" with "SortAutoForEdit"
    When Operator edit the top searched user with data below:
      | firstName              | {edit-first-name}               |
      | lastName               | {edit-last-name}                |
      | contact                | {edit-contact}                  |
      | warehouseTeamFormation | {edit-warehouse-team-formation} |
      | position               | {edit-position}                 |
    Then Make sure "{permission-error-title}" notification pop up with "{error-without-edit-scope}"

  @LaunchBrowser @SortAppUserScope
  Scenario: Sort App Unable Edit Sort User with Scope SORT_CREATE_SORT_APP_USER
    Given Operator login with client id = "{sort-create-scope-client-id}" and client secret = "{sort-create-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator refresh page
    And Operator Load all the Sort App User
    When Operator search sort app user by "User ID" with "SortAutoForEdit"
    When Operator edit the top searched user with data below:
      | firstName              | {edit-first-name}               |
      | lastName               | {edit-last-name}                |
      | contact                | {edit-contact}                  |
      | warehouseTeamFormation | {edit-warehouse-team-formation} |
      | position               | {edit-position}                 |
    Then Make sure "{permission-error-title}" notification pop up with "{error-without-edit-scope}"

  @LaunchBrowser @SortAppUserScope
  Scenario: Sort App Unable Create Sort User with Scope SORT_EDIT_SORT_APP_USER
    Given Operator login with client id = "{sort-edit-scope-client-id}" and client secret = "{sort-edit-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    When Operator create new Sort App User with detailsV2:
      | firstName              | {first-name}               |
      | lastName               | {last-name}                |
      | contact                | {contact}                  |
      | username               | {username}                 |
      | password               | {password}                 |
      | employmentType         | {employment-type}          |
      | primaryHub             | {primary-hub}              |
      | warehouseTeamFormation | {warehouse-team-formation} |
      | position               | {position}                 |
      | comments               | {comments}                 |
    Then Make sure "{permission-error-title}" notification pop up with "{error-without-create-scope}"

  Scenario: Sort App Able Create Sort User with Scope SORT_CREATE_SORT_APP_USER
    Given Operator login with client id = "{sort-create-scope-client-id}" and client secret = "{sort-create-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
      | firstName              | {first-name}               |
      | lastName               | {last-name}                |
      | contact                | {contact}                  |
      | username               | {username}                 |
      | password               | {password}                 |
      | employmentType         | {employment-type}          |
      | primaryHub             | {primary-hub}              |
      | warehouseTeamFormation | {warehouse-team-formation} |
      | position               | {position}                 |
      | comments               | {comments}                 |
    Then Make sure "{create-sucess-title}" notification pop up with "Username"

  @LaunchBrowser @SortAppUserScope
  Scenario: Sort App Able Edit Sort User with Scope SORT_EDIT_SORT_APP_USER
    Given Operator login with client id = "{sort-edit-scope-client-id}" and client secret = "{sort-edit-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator refresh page
    And Operator Load all the Sort App User
    When Operator search sort app user by "User ID" with "SortAutoForEdit"
    When Operator edit the top searched user with data below:
      | firstName              | {edit-first-name}               |
      | lastName               | {edit-last-name}                |
      | contact                | {edit-contact}                  |
      | warehouseTeamFormation | {edit-warehouse-team-formation} |
      | position               | {edit-position}                 |
    Then Make sure "{edit-sucess-title}" notification pop up with "Username"

  @LaunchBrowser @SortAppUserScope @TAG
  Scenario: Sort App Unable View Sort User without Scope SORT_VIEW_SORT_APP_USER
    Given Operator login with client id = "{sort-without-view-scope-client-id}" and client secret = "{sort-without-view-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator refresh page
    And Operator Click Load Users
    Then Make sure "{permission-error-title}" notification pop up with "{error-without-view-scope}"

  @LaunchBrowser @SortAppUserScope
  Scenario: Sort App Able View Sort User with Scope SORT_VIEW_SORT_APP_USER
    Given Operator login with client id = "{sort-with-view-scope-client-id}" and client secret = "{sort-with-view-scope-secret-id}"
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Sort App User Management
    And Operator refresh page
    And Operator Load all the Sort App User
    When Operator search sort app user by "User ID" with "SortAutoForEdit"

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
