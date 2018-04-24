@OperatorV2 @RoleManagement
Feature: Role Management

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator adds new role in role management page (uid:2e77cf93-2ca9-4e8c-bd1c-cd84ffbd3f1c)
    Given Operator go to menu Access Control -> Role Management
    When Operator creates new role on Role Management page
    Then Operator verifies the role on Role Management page
    When Operator deletes the role on Role Management page
    Then Operator verifies the role is deleted

  Scenario: Operator searches role in role management page (uid:6d571b40-6f44-4dbb-8000-40aadb750df5)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Role Management
    When Operator creates new role on Role Management page
    Then Operator verifies the role on Role Management page
    When Operator deletes the role on Role Management page
    Then Operator verifies the role is deleted

  Scenario: Operator deletes role in role management page (uid:dae6fc2f-c94e-4ee2-bbc1-e13606fa35d6)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Role Management
    When Operator creates new role on Role Management page
    Then Operator verifies the role on Role Management page
    When Operator deletes the role on Role Management page
    Then Operator verifies the role is deleted

  Scenario: Operator edits role in role management page (uid:9fb611e0-d6e5-4048-9b55-578581b0fe71)
    Given Operator go to menu Shipper Support -> Blocked Dates
    Given Operator go to menu Access Control -> Role Management
    When Operator creates new role on Role Management page
    Then Operator verifies the role on Role Management page
    When Operator edits the role on Role Management page
    Then Operator verifies the role is edited on Role Management Page
    When Operator deletes the role on Role Management page
    Then Operator verifies the edited role is deleted

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
