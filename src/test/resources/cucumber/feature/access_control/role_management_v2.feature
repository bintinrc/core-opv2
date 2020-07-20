@OperatorV2 @AccessControl @OperatorV2Part1 @RoleManagementV2 @Saas
Feature: Role Management V2

  @LaunchBrowser @ShouldAlwaysRun
  Scenario: Login to Operator Portal V2
    Given Operator login with username = "{operator-portal-uid}" and password = "{operator-portal-pwd}"

  Scenario: Operator adds new role in role management V2 page (uid:3e917e7c-728d-4a1b-9f1d-7852266c3533)
    Given Operator go to menu Access Control -> Role Management V2
    When Operator creates new role on Role Management v2 page
    Then Operator verifies the role on Role Management V2 page

  Scenario: Operator delete role in role management V2 page  (uid:608c9487-f66a-49b5-838f-07cbb414d13c)
    Given Operator go to menu Access Control -> Role Management V2
    When Operator creates new role on Role Management v2 page
    Then Operator verifies the role on Role Management V2 page
    When Operator deletes the role on Role Management V2 page
    Then Operator verifies the role is deleted on Role Management V2 page

  Scenario: Operator edits role in role management V2 page (uid:edc399ff-62df-49ba-befd-34737080db0a)
    Given Operator go to menu Access Control -> Role Management V2
    When Operator creates new role on Role Management v2 page
    Then Operator verifies the role on Role Management V2 page
    When Operator edits the role on Role Management V2 page
    Then Operator verifies the role is edited on Role Management V2 Page

  @KillBrowser @ShouldAlwaysRun
  Scenario: Kill Browser
    Given no-op
